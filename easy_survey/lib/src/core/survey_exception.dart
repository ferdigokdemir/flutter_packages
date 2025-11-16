import '../enums/survey_error_type_enum.dart';

class SurveyException implements Exception {
  SurveyException({required this.type, required this.message, this.details});

  final SurveyErrorTypeEnum type;
  final String message;
  final Map<String, dynamic>? details;

  @override
  String toString() =>
      'SurveyException(type: $type, message: $message, details: $details)';
}
