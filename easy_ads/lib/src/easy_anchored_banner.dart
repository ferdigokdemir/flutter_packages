import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:retry/retry.dart';
import 'easy_ads_singleton.dart';

class EasyAnchoredBanner extends StatefulWidget {
  const EasyAnchoredBanner({super.key});

  @override
  State<EasyAnchoredBanner> createState() => _EasyAnchoredBannerState();
}

class _EasyAnchoredBannerState extends State<EasyAnchoredBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAd();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  Future<void> _loadAd() async {
    final config = EasyAds.config;
    if (config == null || !config.adsEnabled) return;

    final int width = MediaQuery.of(context).size.width.truncate();
    final AnchoredAdaptiveBannerAdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(width);
    if (size == null) return;

    try {
      await retry(
        () async {
          final completer = Completer<void>();
          final ad = BannerAd(
            adUnitId: config.bannerAdUnitId,
            size: size,
            request: const AdRequest(),
            listener: BannerAdListener(
              onAdLoaded: (ad) {
                if (!mounted) {
                  ad.dispose();
                  completer.complete();
                  return;
                }
                setState(() {
                  _bannerAd = ad as BannerAd;
                  _isAdLoaded = true;
                });
                completer.complete();
              },
              onAdFailedToLoad: (ad, error) {
                ad.dispose();
                completer.completeError(error);
              },
            ),
          );
          ad.load();
          return await completer.future;
        },
        retryIf: (e) => true,
        maxAttempts: 3,
      );
    } catch (e) {
      // Reklam yüklenemedi, boş widget gösterilecek
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_bannerAd == null || !_isAdLoaded) {
      return const SizedBox.shrink();
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
