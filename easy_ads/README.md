# easy_ads

Basit, yapılandırılabilir Google Mobile Ads yardımcı paketi.

## Kurulum

`packages/easy_ads` yerel paketi olarak kullanılmak üzere tasarlandı. `pubspec.yaml` içinde path ile ekleyin:

```yaml
dependencies:
  easy_ads:
    path: packages/easy_ads
```

## Kullanım

```dart
import 'package:easy_ads/easy_ads.dart';

// Singleton kullanımı (önerilen)
await EasyAds.configure(EasyAdsConfig(
  adsEnabled: true,
  interstitialAdUnitId: 'ca-app-pub-xxx/yyy',
  rewardedAdUnitId: 'ca-app-pub-xxx/zzz',
  rewardedInterstitialAdUnitId: 'ca-app-pub-xxx/rrr',
  appOpenAdUnitId: 'ca-app-pub-xxx/ttt',
  bannerAdUnitId: 'ca-app-pub-xxx/bbb',
));

await EasyAds.applyRequestConfiguration();

EasyAds.showAd(AdType.interstitial, onResult: (response) {
  if (response.isSuccess) {
    // reklam gösterildi ve kapatıldı
  }
});

// Veya direkt service kullanımı
final ads = EasyAdsService(EasyAdsConfig(
  adsEnabled: true,
  interstitialAdUnitId: 'ca-app-pub-xxx/yyy',
  rewardedAdUnitId: 'ca-app-pub-xxx/zzz',
  rewardedInterstitialAdUnitId: 'ca-app-pub-xxx/rrr',
  appOpenAdUnitId: 'ca-app-pub-xxx/ttt',
  bannerAdUnitId: 'ca-app-pub-xxx/bbb',
));

await ads.initialize();
await ads.applyRequestConfiguration();

ads.showAd(AdType.interstitial, onResult: (response) {
  if (response.isSuccess) {
    // reklam gösterildi ve kapatıldı
  }
});
```
