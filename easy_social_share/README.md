# Easy Social Share 🚀

Simple Flutter package for sharing content to Instagram as images via SharedFortuneBottomSheet. Copy text to clipboard or share your custom widget as Instagram-compatible image (1080x1080).

## ✨ Features

- 📋 **Copy to Clipboard**: Copy text to clipboard instantly
- 📷 **Share to Instagram**: Share widget as Instagram-compatible image (1080x1080)
- 📱 **Preview Dialog**: Preview content before sharing
- ✅ **Two-Step Process**: Simple copy or share with preview confirmation
- 🎨 **Custom Widget Support**: Share any Flutter widget as image

## 📦 Installation

Add to your `pubspec.yaml`:

```yaml
dependencies:
  easy_social_share:
    path: packages/easy_social_share
```

Then run:

```bash
flutter pub get
```

## 🚀 Quick Start

### 1. Initialize

```dart
import 'package:easy_social_share/easy_social_share.dart';

void main() {
  EasySocialShare.instance.initialize(
    EasySocialShareConfig(),
  );
  
  runApp(MyApp());
}
```

### 2. Use SharedFortuneBottomSheet

```dart
await SharedFortuneBottomSheet.show(
  context: context,
  text: 'Full text to copy & share',
  content: Container(
    width: 1080,
    height: 1080,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.brown, Colors.brown.shade800],
      ),
    ),
    child: Center(
      child: Text(
        'Your Content Here',
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    ),
  ),
  onCopySuccess: () => print('Copied!'),
  onShareSuccess: () => print('Shared!'),
);
```

## 🔮 Fortune Share Bottom Sheet (Fal Paylaşımı)

SharedFortuneBottomSheet is designed for sharing fortune/divination content:

### 📊 Akış (Flow)

1. **Bottom Sheet** - 2 seçenek sunulur:
   - 📋 **Açıklamayı Kopyala** - Verilen metin clipboard'a kopyalanır
   - 📱 **Sosyal Medya'da Paylaş** - Paylaşım önizlemesi diyaloğu açılır

2. **Preview Dialog** - İçeriği gösterir:
   - Dışardan verilen custom widget content
   - Kapatma ve Paylaş butonu

3. **Instagram'a Paylaş** - Content'i resim olarak Instagram'a gönderir:
   - Widget otomatik olarak resime dönüştürülür
   - Instagram uygun boyutlara (1080x1080) ölçeklendirilir

### Features
- 📋 **Copy to Clipboard**: Copy the text
- 📱 **Preview Dialog**: Shows custom widget content before sharing
- 📷 **Instagram Share**: Share as Instagram-compatible image (1080x1080)
- ✅ **Two-Step Process**: Copy or Share with preview confirmation
- 🎨 **Custom Content**: Any Flutter widget can be shared

### Parameters

```dart
SharedFortuneBottomSheet.show({
  required BuildContext context,
  required String text,                      // Text to copy & share
  required Widget content,                   // Custom widget to preview & share
  VoidCallback? onShareSuccess,              // Called after successful share
  VoidCallback? onCopySuccess,               // Called after successful copy
})
```

### ✅ Best Practices

- `content` Widget'ı Instagram uygun boyutlarda tasarla (1080x1080 tercih)
- Custom theme'ler ve layoutlar kullan
- Callback'ler ile başarı/hata işlemlerini yönet
- Metin ve widget'ı ayrı ayrı yönet

### ❌ Avoid

- Platform seçme UI'ı - Sadece Instagram destekleniyor
- Hard-coded platform kontrolleri
- Direkt share() çağırma - Preview Dialog aracılığıyla yap

## 🌍 How It Works

1. User sees a bottom sheet with 2 options
2. If "Copy" selected → Text goes to clipboard
3. If "Share" selected → Preview dialog opens
4. In preview → User confirms and shares to Instagram
5. Widget is captured as image and shared with system share dialog

## 📝 Example

See `example/` folder for complete working example.

## 📄 License

MIT License

## 🤝 Contributing

Contributions welcome! This package is designed for Falcı Nine app.

---

Made with ❤️ for sharing fortune readings
