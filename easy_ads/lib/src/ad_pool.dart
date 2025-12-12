import 'dart:async';
import 'dart:collection';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'models.dart';

/// Generic ad pool for managing pre-loaded ads
class AdPool<T> {
  AdPool({
    required this.type,
    required this.maxSize,
    required this.loadAd,
  });

  final AdType type;
  final int maxSize;
  final Future<T?> Function() loadAd;

  final Queue<T> _pool = Queue<T>();
  bool _isRefilling = false;

  /// Current size of the pool
  int get size => _pool.length;

  /// Check if pool is empty
  bool get isEmpty => _pool.isEmpty;

  /// Check if pool is full
  bool get isFull => _pool.length >= maxSize;

  /// Get an ad from the pool
  /// Returns null if pool is empty
  T? getAd() {
    if (_pool.isEmpty) return null;
    final ad = _pool.removeFirst();

    // Auto-refill: trigger refill in background if not already refilling
    if (!_isRefilling && !isFull) {
      _refillOne();
    }

    return ad;
  }

  /// Fill the pool up to maxSize
  Future<void> refill() async {
    if (_isRefilling) return;

    _isRefilling = true;
    try {
      while (_pool.length < maxSize) {
        final ad = await loadAd();
        if (ad != null) {
          _pool.add(ad);
        } else {
          // Stop refilling if we can't load more ads
          break;
        }
      }
    } finally {
      _isRefilling = false;
    }
  }

  /// Refill one ad to the pool
  Future<void> _refillOne() async {
    if (_isRefilling) return;

    _isRefilling = true;
    try {
      if (_pool.length < maxSize) {
        final ad = await loadAd();
        if (ad != null) {
          _pool.add(ad);
        }
      }
    } finally {
      _isRefilling = false;
    }
  }

  /// Dispose all ads in the pool
  void dispose() {
    for (final ad in _pool) {
      if (ad is InterstitialAd) {
        ad.dispose();
      } else if (ad is RewardedAd) {
        ad.dispose();
      } else if (ad is RewardedInterstitialAd) {
        ad.dispose();
      } else if (ad is AppOpenAd) {
        ad.dispose();
      }
    }
    _pool.clear();
  }
}
