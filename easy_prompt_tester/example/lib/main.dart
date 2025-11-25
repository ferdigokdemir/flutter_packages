import 'package:easy_prompt_tester/easy_prompt_tester.dart';
import 'package:flutter/material.dart';

void main() {
  // Initialize with OpenRouter (recommended - one key for all models)
  EasyPromptTester.init(
    config: EasyPromptTesterConfig(
      openRouterApiKey: 'your-openrouter-api-key',
      appName: 'Easy Prompt Tester Example',
    ),
  );

  // Or initialize with individual provider keys:
  // EasyPromptTester.init(
  //   config: EasyPromptTesterConfig(
  //     openAiApiKey: 'sk-xxx',
  //     anthropicApiKey: 'sk-ant-xxx',
  //     googleApiKey: 'xxx',
  //   ),
  // );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Easy Prompt Tester Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PromptTesterPage(),
    );
  }
}

class PromptTesterPage extends StatefulWidget {
  const PromptTesterPage({super.key});

  @override
  State<PromptTesterPage> createState() => _PromptTesterPageState();
}

class _PromptTesterPageState extends State<PromptTesterPage> {
  final _promptController = TextEditingController(
    text: 'What is Flutter? Explain in 2-3 sentences.',
  );
  final _systemPromptController = TextEditingController(
    text: 'You are a helpful assistant. Be concise.',
  );

  TestReport? _report;
  bool _isLoading = false;

  // Selected models for testing
  final List<AIModel> _selectedModels = [
    AIModel.gpt4oMini(),
    AIModel.claude3Haiku(),
    AIModel.geminiFlash(),
  ];

  Future<void> _runTest() async {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isLoading = true;
      _report = null;
    });

    try {
      final prompt = Prompt(
        systemPrompt: _systemPromptController.text.isNotEmpty
            ? _systemPromptController.text
            : null,
        userPrompt: _promptController.text,
      );

      final report = await EasyPromptTester.instance.testPrompt(
        prompt: prompt,
        models: _selectedModels,
      );

      setState(() {
        _report = report;
      });

      // Print summary to console
      debugPrint(report.summary);
    } catch (e) {
      debugPrint('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Easy Prompt Tester'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // System Prompt Input
            TextField(
              controller: _systemPromptController,
              decoration: const InputDecoration(
                labelText: 'System Prompt (optional)',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 16),

            // User Prompt Input
            TextField(
              controller: _promptController,
              decoration: const InputDecoration(
                labelText: 'User Prompt',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),

            // Models Info
            Text(
              'Testing with: ${_selectedModels.map((m) => m.displayName).join(", ")}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),

            // Test Button
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _runTest,
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.play_arrow),
              label: Text(_isLoading ? 'Testing...' : 'Run Test'),
            ),
            const SizedBox(height: 24),

            // Results
            if (_report != null) ...[
              // Summary Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Summary',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const Divider(),
                      _buildSummaryRow(
                        'Success Rate',
                        '${_report!.successRate.toStringAsFixed(0)}%',
                      ),
                      _buildSummaryRow(
                        'Avg Duration',
                        '${_report!.averageDuration.inMilliseconds}ms',
                      ),
                      _buildSummaryRow(
                        'Total Cost',
                        '\$${_report!.totalEstimatedCost.toStringAsFixed(6)}',
                      ),
                      if (_report!.fastestResult != null)
                        _buildSummaryRow(
                          'Fastest',
                          '${_report!.fastestResult!.model.displayName} (${_report!.fastestResult!.duration.inMilliseconds}ms)',
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Individual Results
              Text(
                'Results by Model',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              ..._report!.results.map((result) => _buildResultCard(result)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(TestResult result) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ExpansionTile(
        leading: Icon(
          result.isSuccess ? Icons.check_circle : Icons.error,
          color: result.isSuccess ? Colors.green : Colors.red,
        ),
        title: Text(result.model.displayName),
        subtitle: Text(
          result.isSuccess
              ? '${result.duration.inMilliseconds}ms • ${result.outputTokens ?? 0} tokens'
              : result.error ?? 'Unknown error',
        ),
        children: [
          if (result.isSuccess && result.response != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Response:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: SelectableText(result.response!),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Input tokens: ${result.inputTokens ?? "N/A"} • '
                    'Output tokens: ${result.outputTokens ?? "N/A"} • '
                    'Cost: \$${result.estimatedCost.toStringAsFixed(6)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }
}
