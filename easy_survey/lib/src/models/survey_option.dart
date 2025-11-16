class SurveyOption {
  const SurveyOption({
    required this.id,
    required this.label,
    this.value,
    this.isDefault = false,
  });

  final String id;
  final String label;
  final dynamic value;
  final bool isDefault;
}
