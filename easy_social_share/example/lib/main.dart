import 'package:flutter/material.dart';
import 'package:easy_social_share/easy_social_share.dart';

void main() {
  // Initialize EasySocialShare
  EasySocialShare.instance.initialize(
    EasySocialShareConfig(
      onError: (error) {
        debugPrint('❌ Error: ${error.message}');
      },
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Social Share Example',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const ExamplePage(),
    );
  }
}

class ExamplePage extends StatefulWidget {
  const ExamplePage({super.key});

  @override
  State<ExamplePage> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<ExamplePage> {
  bool _isLoading = false;
  String? _result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Social Share - Fortune Share'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'SharedFortuneBottomSheet',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue.shade900,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Copy text or share widget as Instagram image',
                      style: TextStyle(color: Colors.blue.shade700),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Action Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _showFortuneSheet,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.favorite),
              label: Text(_isLoading ? 'Loading...' : 'Show Fortune Sheet'),
            ),

            // Result
            if (_result != null) ...[
              const SizedBox(height: 24),
              Card(
                color: _result!.startsWith('✅')
                    ? Colors.green.shade50
                    : Colors.red.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    _result!,
                    style: TextStyle(
                      color: _result!.startsWith('✅')
                          ? Colors.green.shade900
                          : Colors.red.shade900,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Show SharedFortuneBottomSheet example
  Future<void> _showFortuneSheet() async {
    setState(() {
      _isLoading = true;
      _result = null;
    });

    try {
      _isLoading = true;

      final fortuneCardWidget = Container(
        width: double.maxFinite,
        height: double.maxFinite,
        decoration: const BoxDecoration(color: Colors.black),
        padding: const EdgeInsets.all(48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.spa, size: 80, color: Colors.white),
            const SizedBox(height: 32),
            const Text(
              'Your Fortune',
              style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 48),
            const Flexible(
              child: Text(
                'This is a sample fortune text that will be copied or shared on Instagram.',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Text(
                '🔮 Fortune Teller',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );

      // Show SharedFortuneBottomSheet
      await SharedFortuneBottomSheet.show(
        context: context,
        text:
            'This is a sample fortune text that will be copied or shared on Instagram.',
        content: fortuneCardWidget,
        onCopySuccess: () {
          setState(() {
            _result = '✅ Text copied to clipboard!';
          });
        },
        onShareSuccess: () {
          setState(() {
            _result = '✅ Shared to Instagram successfully!';
          });
        },
      );
    } catch (e) {
      setState(() {
        _result = '❌ Error: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }
}
