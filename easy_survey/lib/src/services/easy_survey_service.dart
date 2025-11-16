import 'package:flutter/material.dart';

import '../config/easy_survey_config.dart';
import '../core/survey_exception.dart';
import '../enums/survey_error_type_enum.dart';
import '../enums/survey_question_type_enum.dart';
import '../models/models.dart';

class EasySurveyService {
  EasySurveyService._();

  static final EasySurveyService instance = EasySurveyService._();

  EasySurveyConfig? _config;

  bool get isInitialized => _config != null;

  Color get textColor {
    _ensureInitialized();
    return _config!.textColor;
  }

  Future<void> init(EasySurveyConfig config) async {
    _config = config;
  }

  SurveyDefinition getSurvey(String surveyId) {
    _ensureInitialized();
    final survey = _config!.surveys.firstWhere(
      (definition) => definition.id == surveyId,
      orElse: () => throw SurveyException(
        type: SurveyErrorTypeEnum.surveyNotFound,
        message: 'Survey with id $surveyId not found',
      ),
    );

    if (!survey.isActive) {
      throw SurveyException(
        type: SurveyErrorTypeEnum.validation,
        message: 'Survey with id $surveyId is not active',
      );
    }

    return survey;
  }

  Future<SurveySubmission> submit({
    required String surveyId,
    required List<SurveyAnswer> answers,
  }) async {
    _ensureInitialized();
    final survey = getSurvey(surveyId);

    try {
      _validateAnswers(survey, answers);
      final submission = SurveySubmission(surveyId: surveyId, answers: answers);

      await _config!.storageStrategy.saveSubmission(submission);
      _config!.onPostSubmit?.call(submission);
      return submission;
    } on SurveyException {
      rethrow;
    } catch (error, stackTrace) {
      _notifyError(error, stackTrace);
      throw SurveyException(
        type: SurveyErrorTypeEnum.unknown,
        message: 'Failed to submit survey response',
        details: <String, dynamic>{'cause': error.toString()},
      );
    }
  }

  Future<SurveyReport> getReport(String surveyId) async {
    _ensureInitialized();
    final survey = getSurvey(surveyId);
    final submissions = await _config!.storageStrategy.fetchSubmissions(
      surveyId,
    );

    final Map<String, Map<String, int>> optionDistribution =
        <String, Map<String, int>>{};
    final Map<String, List<double>> ratingValues = <String, List<double>>{};

    for (final question in survey.questions) {
      if (question.isChoiceQuestion) {
        optionDistribution[question.id] = <String, int>{};
      } else if (question.type == SurveyQuestionTypeEnum.rating) {
        ratingValues[question.id] = <double>[];
      }
    }

    for (final submission in submissions) {
      for (final answer in submission.answers) {
        final question = survey.questions.firstWhere(
          (item) => item.id == answer.questionId,
          orElse: () => throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message: 'Answer references unknown question ${answer.questionId}',
          ),
        );

        if (question.isChoiceQuestion) {
          final Map<String, int> distribution =
              optionDistribution[question.id]!;
          if (question.isMultipleChoice) {
            final List<String> selectedOptions = List<String>.from(
              answer.value as Iterable,
            );
            for (final optionId in selectedOptions) {
              distribution.update(
                optionId,
                (count) => count + 1,
                ifAbsent: () => 1,
              );
            }
          } else {
            final String optionId = answer.value as String;
            distribution.update(
              optionId,
              (count) => count + 1,
              ifAbsent: () => 1,
            );
          }
        } else if (question.type == SurveyQuestionTypeEnum.rating) {
          final double rating = (answer.value as num).toDouble();
          ratingValues[question.id]!.add(rating);
        }
      }
    }

    final Map<String, double> averageRatings = <String, double>{};
    ratingValues.forEach((questionId, ratings) {
      if (ratings.isNotEmpty) {
        final double total = ratings.reduce((a, b) => a + b);
        averageRatings[questionId] = total / ratings.length;
      }
    });

    return SurveyReport(
      surveyId: surveyId,
      totalResponses: submissions.length,
      optionDistribution: optionDistribution,
      averageRatings: averageRatings,
    );
  }

  Future<void> clearResponses(String surveyId) async {
    _ensureInitialized();
    await _config!.storageStrategy.clearSubmissions(surveyId);
  }

  void _validateAnswers(SurveyDefinition survey, List<SurveyAnswer> answers) {
    final Map<String, SurveyQuestion> questionIndex = <String, SurveyQuestion>{
      for (final question in survey.questions) question.id: question,
    };

    for (final question in survey.questions) {
      SurveyAnswer? answer;
      for (final candidate in answers) {
        if (candidate.questionId == question.id) {
          answer = candidate;
          break;
        }
      }

      if (answer == null) {
        if (question.isRequired) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message: 'Required question ${question.id} is missing an answer',
          );
        }
        continue;
      }

      _validateAnswerValue(question, answer.value);
    }

    for (final answer in answers) {
      if (!questionIndex.containsKey(answer.questionId)) {
        throw SurveyException(
          type: SurveyErrorTypeEnum.validation,
          message: 'Answer provided for unknown question ${answer.questionId}',
        );
      }
    }
  }

  void _validateAnswerValue(SurveyQuestion question, dynamic value) {
    switch (question.type) {
      case SurveyQuestionTypeEnum.multipleChoice:
        if (value is! Iterable) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message:
                'Multiple choice answer for ${question.id} must be an iterable',
          );
        }
        final List<String> selections = List<String>.from(value);
        if (question.isRequired && selections.isEmpty) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message: 'Question ${question.id} requires at least one selection',
          );
        }
        if (question.minSelection != null &&
            selections.length < question.minSelection!) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message:
                'Question ${question.id} requires at least ${question.minSelection} selections',
          );
        }
        if (question.maxSelection != null &&
            selections.length > question.maxSelection!) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message:
                'Question ${question.id} allows at most ${question.maxSelection} selections',
          );
        }
        final Set<String> optionIds =
            question.options.map((option) => option.id).toSet();
        for (final selection in selections) {
          if (!optionIds.contains(selection)) {
            throw SurveyException(
              type: SurveyErrorTypeEnum.validation,
              message:
                  'Selection $selection is not valid for question ${question.id}',
            );
          }
        }
        break;
      case SurveyQuestionTypeEnum.singleChoice:
        if (value is! String) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message: 'Single choice answer for ${question.id} must be a string',
          );
        }
        final Set<String> optionIds =
            question.options.map((option) => option.id).toSet();
        if (!optionIds.contains(value)) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message:
                'Selection $value is not valid for question ${question.id}',
          );
        }
        break;
      case SurveyQuestionTypeEnum.textInput:
        if (value == null || (value is String && value.trim().isEmpty)) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message: 'Text input for question ${question.id} cannot be empty',
          );
        }
        break;
      case SurveyQuestionTypeEnum.rating:
        if (value is! num) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message: 'Rating answer for ${question.id} must be numeric',
          );
        }
        final double rating = value.toDouble();
        if (rating < question.ratingMin || rating > question.ratingMax) {
          throw SurveyException(
            type: SurveyErrorTypeEnum.validation,
            message:
                'Rating for question ${question.id} must be between ${question.ratingMin} and ${question.ratingMax}',
          );
        }
        break;
    }
  }

  void _ensureInitialized() {
    if (!isInitialized) {
      throw SurveyException(
        type: SurveyErrorTypeEnum.notInitialized,
        message: 'EasySurveyService is not initialized',
      );
    }
  }

  void _notifyError(Object error, StackTrace stackTrace) {
    _config?.onError?.call(error, stackTrace);
  }
}
