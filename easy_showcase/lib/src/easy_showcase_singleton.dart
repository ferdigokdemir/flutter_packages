import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:super_tooltip/super_tooltip.dart';
import 'models.dart';

class EasyShowcase {
  static EasyShowcase? _instance;
  static ShowcaseTheme? _globalTheme;
  static bool _debugMode = false;
  static String _currentVersion = "1.0.0";
  static Function(ShowcaseAnalytics)? _analyticsCallback;

  static EasyShowcase get instance {
    if (_instance == null) {
      throw Exception(
          "EasyShowcase must be initialized before use. Call EasyShowcase.initialize() in main.dart");
    }
    return _instance!;
  }

  static Future<void> initialize({
    ShowcaseTheme? theme,
    bool debugMode = false,
    String version = "1.0.0",
    Function(ShowcaseAnalytics)? analyticsCallback,
  }) async {
    _instance = EasyShowcase._();
    _globalTheme = theme ?? const ShowcaseTheme();
    _debugMode = debugMode;
    _currentVersion = version;
    _analyticsCallback = analyticsCallback;
    await _instance!._init();
  }

  EasyShowcase._();

  final Map<String, SuperTooltipController> _controllers = {};
  final Map<String, ShowcaseConfig> _configs = {};
  final Map<String, Timer> _autoDismissTimers = {};
  List<String> _currentSequence = [];
  bool _isSequenceActive = false;

  Future<void> _init() async {
    // Initialize showcase system
  }

  // Theme Management
  static void setGlobalTheme(ShowcaseTheme theme) {
    _globalTheme = theme;
  }

  static ShowcaseTheme get globalTheme => _globalTheme ?? const ShowcaseTheme();

  // Debug Mode
  static void setDebugMode(bool enabled) {
    _debugMode = enabled;
  }

  static bool get debugMode => _debugMode;

  // Analytics
  static void setAnalyticsCallback(Function(ShowcaseAnalytics) callback) {
    _analyticsCallback = callback;
  }

  void _trackAnalytics(String eventName, Map<String, dynamic> parameters) {
    if (_analyticsCallback != null) {
      _analyticsCallback!(ShowcaseAnalytics(
        eventName: eventName,
        parameters: parameters,
        timestamp: DateTime.now(),
      ));
    }
  }

  // Controller Management
  SuperTooltipController getController(String key) {
    if (!_controllers.containsKey(key)) {
      _controllers[key] = SuperTooltipController();
    }
    return _controllers[key]!;
  }

  ShowcaseConfig getConfig(String key) {
    if (!_configs.containsKey(key)) {
      _configs[key] = ShowcaseConfig(
        key: key,
        controller: getController(key),
      );
    }
    return _configs[key]!;
  }

  void setConfig(String key, ShowcaseConfig config) {
    _configs[key] = config;
  }

  // Basic Show/Hide Methods
  Future<void> show({required List<String> keys}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      for (var key in keys) {
        final config = getConfig(key);

        // Check condition
        if (config.condition != null && !config.condition!()) {
          continue;
        }

        if (!await isShown(key: key)) {
          await _showShowcase(key, config);
          await prefs.setBool('has_seen_showcase_$key', true);
          _trackAnalytics('showcase_shown', {'key': key});
          return;
        }
      }
    });
  }

  Future<void> _showShowcase(String key, ShowcaseConfig config) async {
    // Play sound (placeholder for future implementation)
    if (config.playSound && _debugMode) {
      debugPrint('EasyShowcase: Sound would play here');
    }

    // Vibrate (placeholder for future implementation)
    if (config.vibrate && _debugMode) {
      debugPrint('EasyShowcase: Vibration would happen here');
    }

    // Show tooltip
    config.controller.showTooltip();

    // Auto dismiss
    if (config.autoDismiss != null) {
      _autoDismissTimers[key] = Timer(config.autoDismiss!, () {
        hide(key);
      });
    }
  }

  Future<void> hide(String key) async {
    final config = getConfig(key);
    config.controller.hideTooltip();
    _autoDismissTimers[key]?.cancel();
    _autoDismissTimers.remove(key);
    _trackAnalytics('showcase_hidden', {'key': key});
  }

  Future<void> hideAll() async {
    for (var key in _controllers.keys) {
      await hide(key);
    }
  }

  // Sequence Management
  Future<void> showSequence(ShowcaseSequence sequence) async {
    if (_isSequenceActive) return;

    _isSequenceActive = true;
    _currentSequence = List.from(sequence.keys);

    for (int i = 0; i < sequence.keys.length; i++) {
      if (!_isSequenceActive) break;

      final key = sequence.keys[i];

      sequence.onStep?.call();
      await showSingle(key);

      if (i < sequence.keys.length - 1) {
        await Future.delayed(sequence.delayBetween);
      }
    }

    _isSequenceActive = false;
    sequence.onComplete?.call();
    _trackAnalytics('showcase_sequence_completed', {
      'keys': sequence.keys,
      'count': sequence.keys.length,
    });
  }

  void stopSequence() {
    _isSequenceActive = false;
    _currentSequence.clear();
  }

  // Reset Methods
  Future<void> reset({required List<String> keys}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in keys) {
      await prefs.remove('has_seen_showcase_$key');
      _configs.remove(key);
    }
  }

  Future<void> resetAll() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var key in _controllers.keys) {
      await prefs.remove('has_seen_showcase_$key');
    }
    _configs.clear();
  }

  // Status Methods
  Future<bool> isShown({required String key}) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('has_seen_showcase_$key') ?? false;
  }

  bool isSequenceActive() => _isSequenceActive;

  // Convenience Methods
  Future<void> showSingle(String key) async {
    await show(keys: [key]);
  }

  Future<void> resetSingle(String key) async {
    await reset(keys: [key]);
  }

  // Analytics Methods
  Future<void> showWithAnalytics({
    required String key,
    required String eventName,
    Map<String, dynamic> parameters = const {},
  }) async {
    _trackAnalytics(eventName, parameters);
    await showSingle(key);
  }

  // Debug Methods
  Future<void> showAllForTesting() async {
    if (!_debugMode) return;

    for (var key in _controllers.keys) {
      await showSingle(key);
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  // Persistence and Migration
  Future<void> migrateFromVersion(String fromVersion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final migrationKey =
        'showcase_migration_${fromVersion}_to_$_currentVersion';

    if (!(prefs.getBool(migrationKey) ?? false)) {
      // Perform migration logic here
      await prefs.setBool(migrationKey, true);
      _trackAnalytics('showcase_migration', {
        'from_version': fromVersion,
        'to_version': _currentVersion,
      });
    }
  }

  // Cleanup Methods
  void disposeController(String key) {
    _controllers[key]?.dispose();
    _controllers.remove(key);
    _configs.remove(key);
    _autoDismissTimers[key]?.cancel();
    _autoDismissTimers.remove(key);
  }

  void disposeAll() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    for (var timer in _autoDismissTimers.values) {
      timer.cancel();
    }
    _controllers.clear();
    _configs.clear();
    _autoDismissTimers.clear();
  }
}
