import 'package:flutter/material.dart';

import '../core/in_memory_survey_storage.dart';
import '../core/survey_storage_strategy.dart';
import '../models/models.dart';

typedef EasySurveyErrorListener = void Function(
    Object error, StackTrace stackTrace);

typedef EasySurveyPostSubmitCallback = void Function(
    SurveySubmission submission);

class EasySurveyConfig {
  EasySurveyConfig({
    required this.surveys,
    this.localeCode,
    SurveyStorageStrategy? storageStrategy,
    this.onError,
    this.onPostSubmit,
    Color? textColor,
  })  : storageStrategy = storageStrategy ?? InMemorySurveyStorage(),
        textColor = textColor ?? Colors.black;

  final List<SurveyDefinition> surveys;
  final String? localeCode;
  final SurveyStorageStrategy storageStrategy;
  final EasySurveyErrorListener? onError;
  final EasySurveyPostSubmitCallback? onPostSubmit;
  final Color textColor;
}
