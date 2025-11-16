import '../models/survey_submission.dart';

abstract class SurveyStorageStrategy {
  Future<void> saveSubmission(SurveySubmission submission);

  Future<List<SurveySubmission>> fetchSubmissions(String surveyId);

  Future<void> clearSubmissions(String surveyId);
}
