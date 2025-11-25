/// Configuration for EasyPromptTester
class EasyPromptTesterConfig {
  /// OpenRouter API key (if provided, will be used for all requests)
  final String? openRouterApiKey;

  /// OpenAI API key (used only if openRouterApiKey is not provided)
  final String? openAiApiKey;

  /// Anthropic API key (used only if openRouterApiKey is not provided)
  final String? anthropicApiKey;

  /// Google API key (used only if openRouterApiKey is not provided)
  final String? googleApiKey;

  /// Default timeout for API requests
  final Duration timeout;

  /// Whether to run tests in parallel
  final bool runInParallel;

  /// App name for OpenRouter (optional, for rankings)
  final String? appName;

  /// Site URL for OpenRouter (optional, for rankings)
  final String? siteUrl;

  /// Creates a configuration
  const EasyPromptTesterConfig({
    this.openRouterApiKey,
    this.openAiApiKey,
    this.anthropicApiKey,
    this.googleApiKey,
    this.timeout = const Duration(seconds: 60),
    this.runInParallel = true,
    this.appName,
    this.siteUrl,
  });

  /// Whether OpenRouter is configured and should be used
  bool get useOpenRouter =>
      openRouterApiKey != null && openRouterApiKey!.isNotEmpty;

  /// Whether OpenAI is configured (direct API)
  bool get hasOpenAiKey => openAiApiKey != null && openAiApiKey!.isNotEmpty;

  /// Whether Anthropic is configured (direct API)
  bool get hasAnthropicKey =>
      anthropicApiKey != null && anthropicApiKey!.isNotEmpty;

  /// Whether Google is configured (direct API)
  bool get hasGoogleKey => googleApiKey != null && googleApiKey!.isNotEmpty;

  /// Creates a copy with updated values
  EasyPromptTesterConfig copyWith({
    String? openRouterApiKey,
    String? openAiApiKey,
    String? anthropicApiKey,
    String? googleApiKey,
    Duration? timeout,
    bool? runInParallel,
    String? appName,
    String? siteUrl,
  }) =>
      EasyPromptTesterConfig(
        openRouterApiKey: openRouterApiKey ?? this.openRouterApiKey,
        openAiApiKey: openAiApiKey ?? this.openAiApiKey,
        anthropicApiKey: anthropicApiKey ?? this.anthropicApiKey,
        googleApiKey: googleApiKey ?? this.googleApiKey,
        timeout: timeout ?? this.timeout,
        runInParallel: runInParallel ?? this.runInParallel,
        appName: appName ?? this.appName,
        siteUrl: siteUrl ?? this.siteUrl,
      );
}
