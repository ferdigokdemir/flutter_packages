import 'package:flutter/material.dart';

import '../core/survey_exception.dart';
import '../enums/survey_question_type_enum.dart';
import '../models/models.dart';
import '../services/easy_survey_service.dart';
import '../dialogs/error_dialog.dart';

class EasySurveyWidget extends StatefulWidget {
  const EasySurveyWidget({
    super.key,
    required this.surveyId,
    this.onSubmitSuccess,
    this.submitButtonLabel = 'Gönder',
  });

  final String surveyId;
  final void Function(SurveySubmission submission)? onSubmitSuccess;
  final String submitButtonLabel;

  @override
  State<EasySurveyWidget> createState() => _EasySurveyWidgetState();
}

class _EasySurveyWidgetState extends State<EasySurveyWidget> {
  SurveyDefinition? _survey;
  final Map<String, TextEditingController> _textControllers =
      <String, TextEditingController>{};
  final Map<String, Set<String>> _multipleSelections = <String, Set<String>>{};
  final Map<String, String?> _singleSelections = <String, String?>{};
  final Map<String, double?> _ratings = <String, double?>{};
  final Set<String> _ratingTouched = <String>{};

  bool _isLoading = true;
  bool _isSubmitting = false;

  Color get _textColor => EasySurveyService.instance.textColor;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadSurvey());
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  Future<void> _loadSurvey() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final survey = EasySurveyService.instance.getSurvey(widget.surveyId);
      setState(() {
        _survey = survey;
        _clearState();
        _initializeState(survey);
        _isLoading = false;
      });
    } on SurveyException catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      await _showErrorDialog(error.message);
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      await _showErrorDialog('Beklenmeyen bir hata oluştu.');
    }
  }

  void _initializeState(SurveyDefinition survey) {
    for (final question in survey.questions) {
      switch (question.type) {
        case SurveyQuestionTypeEnum.multipleChoice:
          final defaults = question.options
              .where((option) => option.isDefault)
              .map((option) => option.id)
              .toSet();
          _multipleSelections[question.id] = defaults;
          break;
        case SurveyQuestionTypeEnum.singleChoice:
          String? defaultOptionId;
          for (final option in question.options) {
            if (option.isDefault) {
              defaultOptionId = option.id;
              break;
            }
          }
          _singleSelections[question.id] = defaultOptionId;
          break;
        case SurveyQuestionTypeEnum.textInput:
          _textControllers[question.id] = TextEditingController();
          break;
        case SurveyQuestionTypeEnum.rating:
          _ratings[question.id] =
              question.isRequired ? question.ratingMin : null;
          break;
      }
    }
  }

  void _clearState() {
    _disposeControllers();
    _textControllers.clear();
    _multipleSelections.clear();
    _singleSelections.clear();
    _ratings.clear();
    _ratingTouched.clear();
  }

  void _disposeControllers() {
    for (final controller in _textControllers.values) {
      controller.dispose();
    }
  }

  Future<void> _onSubmit() async {
    if (_survey == null) {
      await _showErrorDialog('Anket bulunamadı.');
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    final answers = _collectAnswers();

    try {
      final submission = await EasySurveyService.instance.submit(
        surveyId: _survey!.id,
        answers: answers,
      );
      widget.onSubmitSuccess?.call(submission);
      _resetSelections();
    } on SurveyException catch (error) {
      await _showErrorDialog(error.message);
    } catch (error) {
      await _showErrorDialog('Beklenmeyen bir hata oluştu.');
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  List<SurveyAnswer> _collectAnswers() {
    final List<SurveyAnswer> answers = <SurveyAnswer>[];

    if (_survey == null) {
      return answers;
    }

    for (final question in _survey!.questions) {
      switch (question.type) {
        case SurveyQuestionTypeEnum.multipleChoice:
          final selections = _multipleSelections[question.id] ?? <String>{};
          if (selections.isNotEmpty || question.isRequired) {
            answers.add(
              SurveyAnswer(
                questionId: question.id,
                value: selections.toList(growable: false),
              ),
            );
          }
          break;
        case SurveyQuestionTypeEnum.singleChoice:
          final selection = _singleSelections[question.id];
          if (selection != null || question.isRequired) {
            answers.add(
              SurveyAnswer(questionId: question.id, value: selection),
            );
          }
          break;
        case SurveyQuestionTypeEnum.textInput:
          final controller = _textControllers[question.id];
          final text = controller?.text.trim() ?? '';
          if (text.isNotEmpty || question.isRequired) {
            answers.add(SurveyAnswer(questionId: question.id, value: text));
          }
          break;
        case SurveyQuestionTypeEnum.rating:
          final rating = _ratings[question.id];
          final bool hasValue =
              rating != null || _ratingTouched.contains(question.id);
          if (hasValue || question.isRequired) {
            answers.add(
              SurveyAnswer(
                questionId: question.id,
                value: (rating ?? question.ratingMin),
              ),
            );
          }
          break;
      }
    }

    return answers;
  }

  void _resetSelections() {
    if (_survey == null) {
      return;
    }

    setState(() {
      _clearState();
      _initializeState(_survey!);
    });
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => ErrorDialog(title: 'Hata', message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_survey == null) {
      return const SizedBox.shrink();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const SizedBox(height: 4),
          for (final question in _survey!.questions) ...<Widget>[
            _buildQuestionCard(question),
            const SizedBox(height: 16),
          ],
          ElevatedButton(
            onPressed: _isSubmitting ? null : _onSubmit,
            child: _isSubmitting
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(widget.submitButtonLabel),
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(SurveyQuestion question) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              question.title,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: _textColor,
                  ),
            ),
            if (question.description != null) ...<Widget>[
              const SizedBox(height: 8),
              Text(
                question.description!,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: _textColor),
              ),
            ],
            const SizedBox(height: 12),
            _buildQuestionBody(question),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionBody(SurveyQuestion question) {
    switch (question.type) {
      case SurveyQuestionTypeEnum.multipleChoice:
        return _buildMultipleChoice(question);
      case SurveyQuestionTypeEnum.singleChoice:
        return _buildSingleChoice(question);
      case SurveyQuestionTypeEnum.textInput:
        return _buildTextInput(question);
      case SurveyQuestionTypeEnum.rating:
        return _buildRating(question);
    }
  }

  Widget _buildMultipleChoice(SurveyQuestion question) {
    final selections = _multipleSelections.putIfAbsent(
      question.id,
      () => <String>{},
    );
    return Column(
      children: question.options.map((option) {
        final isSelected = selections.contains(option.id);
        return CheckboxListTile(
          value: isSelected,
          onChanged: (value) {
            setState(() {
              if (value ?? false) {
                selections.add(option.id);
              } else {
                selections.remove(option.id);
              }
            });
          },
          title: Text(
            option.label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: _textColor),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSingleChoice(SurveyQuestion question) {
    _singleSelections.putIfAbsent(question.id, () => null);
    final String? selectedValue = _singleSelections[question.id];
    return Column(
      children: question.options.map((option) {
        final bool isSelected = selectedValue == option.id;
        return ListTile(
          leading: Radio<String>(
            value: option.id,
            groupValue: selectedValue,
            onChanged: (value) {
              setState(() {
                _singleSelections[question.id] = value;
              });
            },
          ),
          title: Text(
            option.label,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: _textColor),
          ),
          onTap: () {
            setState(() {
              _singleSelections[question.id] = option.id;
            });
          },
          selected: isSelected,
        );
      }).toList(),
    );
  }

  Widget _buildTextInput(SurveyQuestion question) {
    final controller = _textControllers[question.id]!;
    return TextFormField(
      controller: controller,
      maxLines: null,
      decoration: const InputDecoration(
        filled: true,
        fillColor: Colors.grey,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        floatingLabelAlignment: FloatingLabelAlignment.center,
        labelStyle: TextStyle(color: Colors.white),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildRating(SurveyQuestion question) {
    final double currentValue = _ratings[question.id] ?? question.ratingMin;
    final double totalRange = question.ratingMax - question.ratingMin;
    final int? divisions = question.ratingStep > 0
        ? (totalRange / question.ratingStep).round()
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Slider(
          value: currentValue,
          min: question.ratingMin,
          max: question.ratingMax,
          divisions: divisions,
          label: currentValue.toStringAsFixed(1),
          onChanged: (value) {
            setState(() {
              _ratings[question.id] = value;
              _ratingTouched.add(question.id);
            });
          },
        ),
        Text(
          currentValue.toStringAsFixed(1),
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(color: _textColor),
        ),
      ],
    );
  }
}
