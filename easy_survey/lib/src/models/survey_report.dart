class SurveyReport {
  const SurveyReport({
    required this.surveyId,
    required this.totalResponses,
    required this.optionDistribution,
    required this.averageRatings,
  });

  final String surveyId;
  final int totalResponses;
  final Map<String, Map<String, int>> optionDistribution;
  final Map<String, double> averageRatings;
}
