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

final ads = EasyAdsService(
  EasyAdsConfig(
    adsEnabled: true,
    interstitialAdUnitId: 'ca-app-pub-xxx/yyy',
    rewardedAdUnitId: 'ca-app-pub-xxx/zzz',
    appOpenAdUnitId: 'ca-app-pub-xxx/ttt',
  ),
);

await ads.initialize();
await ads.applyRequestConfiguration();
await ads.warmUp();

final res = await ads.showAd(AdType.interstitial);
if (res.isSuccess) {
  // shown + dismissed
}
```
