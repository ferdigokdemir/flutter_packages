import 'survey_answer.dart';

class SurveySubmission {
  SurveySubmission({
    required this.surveyId,
    required this.answers,
    DateTime? submittedAt,
  }) : submittedAt = submittedAt ?? DateTime.now();

  final String surveyId;
  final List<SurveyAnswer> answers;
  final DateTime submittedAt;
}
