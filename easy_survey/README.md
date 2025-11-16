# easy_survey

Config tabanlı anketleri göstermeye ve yanıt toplamaya odaklı Flutter paketi. `EasySurveyService` singleton üzerinden konfigürasyon sağlanır, `EasySurveyWidget` ile anket render edilir.

## Başlangıç

```dart
import 'package:easy_survey/easy_survey.dart';

Future<void> bootstrapSurveys() async {
  final config = EasySurveyConfig(
    surveys: <SurveyDefinition>[
      SurveyDefinition(
        id: 'onboarding',
        title: 'Onboarding Anketi',
        description: 'Seni daha yakından tanımamıza yardım et',
        questions: <SurveyQuestion>[
          SurveyQuestion(
            id: 'preferred-feature',
            title: 'Uygulamada en sevdiğin özellik hangisi?',
            type: SurveyQuestionTypeEnum.singleChoice,
            options: <SurveyOption>[
              SurveyOption(id: 'fortunes', label: 'Günlük fal'),
              SurveyOption(id: 'notifications', label: 'Bildirimler'),
              SurveyOption(id: 'community', label: 'Topluluk'),
            ],
          ),
          SurveyQuestion(
            id: 'improvements',
            title: 'Neleri geliştirebiliriz?',
            type: SurveyQuestionTypeEnum.textInput,
            placeholder: 'Görüşlerini yaz',
            isRequired: false,
          ),
          SurveyQuestion(
            id: 'satisfaction',
            title: 'Genel memnuniyet puanın?',
            type: SurveyQuestionTypeEnum.rating,
            ratingMin: 1,
            ratingMax: 5,
            ratingStep: 1,
          ),
        ],
      ),
    ],
  );

  await EasySurveyService.instance.init(config);
}
```

Widget tarafı:

```dart
class OnboardingSurvey extends StatelessWidget {
  const OnboardingSurvey({super.key});

  @override
  Widget build(BuildContext context) {
    return EasySurveyWidget(
      surveyId: 'onboarding',
      onSubmitSuccess: (submission) {
        debugPrint('Yanıtlanan anket: \\${submission.surveyId}');
      },
    );
  }
}
```

## Raporlama

```dart
final report = await EasySurveyService.instance.getReport('onboarding');
print(report.totalResponses);
print(report.optionDistribution['preferred-feature']);
print(report.averageRatings['satisfaction']);
```

## Hata yönetimi

- Konfigürasyon yapılmadan servis kullanılırsa `SurveyException` fırlatılır.
- `EasySurveyWidget` validasyon hatalarında `ErrorDialog` gösterir.
- `EasySurveyConfig.onError` ile yakalanan hatalara global tepki verebilirsiniz.
