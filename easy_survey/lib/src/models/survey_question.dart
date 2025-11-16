import '../enums/survey_question_type_enum.dart';
import 'survey_option.dart';

class SurveyQuestion {
  const SurveyQuestion({
    required this.id,
    required this.title,
    required this.type,
    this.description,
    this.options = const <SurveyOption>[],
    this.isRequired = true,
    this.minSelection,
    this.maxSelection,
    this.ratingMin = 1,
    this.ratingMax = 5,
    this.ratingStep = 1,
    this.placeholder,
  });

  final String id;
  final String title;
  final SurveyQuestionTypeEnum type;
  final String? description;
  final List<SurveyOption> options;
  final bool isRequired;
  final int? minSelection;
  final int? maxSelection;
  final double ratingMin;
  final double ratingMax;
  final double ratingStep;
  final String? placeholder;

  bool get isChoiceQuestion =>
      type == SurveyQuestionTypeEnum.multipleChoice ||
      type == SurveyQuestionTypeEnum.singleChoice;

  bool get isMultipleChoice => type == SurveyQuestionTypeEnum.multipleChoice;
}
