import 'survey_question.dart';

class SurveyDefinition {
  const SurveyDefinition({
    required this.id,
    required this.questions,
    this.isActive = true,
    this.metadata = const <String, dynamic>{},
  });

  final String id;
  final List<SurveyQuestion> questions;
  final bool isActive;
  final Map<String, dynamic> metadata;
}
