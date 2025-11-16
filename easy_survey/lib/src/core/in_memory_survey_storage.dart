import 'survey_storage_strategy.dart';
import '../models/survey_submission.dart';

class InMemorySurveyStorage implements SurveyStorageStrategy {
  final Map<String, List<SurveySubmission>> _storage =
      <String, List<SurveySubmission>>{};

  @override
  Future<void> saveSubmission(SurveySubmission submission) async {
    final submissions = _storage.putIfAbsent(
      submission.surveyId,
      () => <SurveySubmission>[],
    );
    submissions.add(submission);
  }

  @override
  Future<List<SurveySubmission>> fetchSubmissions(String surveyId) async {
    return List<SurveySubmission>.unmodifiable(
      _storage[surveyId] ?? <SurveySubmission>[],
    );
  }

  @override
  Future<void> clearSubmissions(String surveyId) async {
    _storage.remove(surveyId);
  }
}
