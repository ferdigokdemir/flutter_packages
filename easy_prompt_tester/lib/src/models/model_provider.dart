/// Enum representing different AI model providers
enum ModelProvider {
  /// OpenAI (GPT models)
  openAI('OpenAI'),

  /// Anthropic (Claude models)
  anthropic('Anthropic'),

  /// Google (Gemini models)
  google('Google'),

  /// OpenRouter (proxy for multiple providers)
  openRouter('OpenRouter');

  const ModelProvider(this.displayName);

  /// Human-readable name of the provider
  final String displayName;
}
