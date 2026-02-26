/// Easy Update Localizations
///
/// Desteklenen 47 dil:
/// AL, AR, BN, BS, BG, CA, ZH, HR, CS, DA, NL, EN, ET, FI, FA,
/// FR, KA, DE, EL, HE, HU, HI, ID, IT, JA, KU, KO, KM, LO, LV, MS, MN, NO,
/// PL, PT, RO, RU, SK, SL, ES, SW, SE, TA, TH, TR, UK, VI
///
/// Kullanım:
/// ```dart
/// final text = EasyUpdateLocalizations.of('tr').updateAvailable;
/// ```

class EasyUpdateLocalizations {
  final String locale;

  const EasyUpdateLocalizations._(this.locale);

  /// Locale'e göre localization instance döndür
  static EasyUpdateLocalizations of(String locale) {
    return EasyUpdateLocalizations._(locale.toLowerCase());
  }

  /// Desteklenen diller
  static const supportedLocales = [
    'al',
    'ar',
    'bn',
    'bs',
    'bg',
    'ca',
    'zh',
    'hr',
    'cs',
    'da',
    'nl',
    'en',
    'et',
    'fi',
    'fa',
    'fr',
    'ka',
    'de',
    'el',
    'he',
    'hu',
    'hi',
    'id',
    'it',
    'ja',
    'ku',
    'ko',
    'km',
    'lo',
    'lv',
    'ms',
    'mn',
    'no',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'es',
    'sw',
    'se',
    'ta',
    'th',
    'tr',
    'uk',
    'vi',
  ];

  /// Varsayılan dil
  static const defaultLocale = 'en';

  // ═══════════════════════════════════════════════════════════
  // TRANSLATIONS
  // ═══════════════════════════════════════════════════════════

  static const _translations = {
    'updateAvailable': {
      'al': 'Përditësim i Disponueshëm',
      'ar': 'يتوفر تحديث',
      'bn': 'আপডেট উপলব্ধ',
      'bs': 'Ažuriranje Dostupno',
      'bg': 'Налична е Актуализация',
      'ca': 'Actualització Disponible',
      'zh': '有可用更新',
      'hr': 'Ažuriranje Dostupno',
      'cs': 'Aktualizace Dostupná',
      'da': 'Opdatering Tilgængelig',
      'nl': 'Update Beschikbaar',
      'en': 'Update Available',
      'et': 'Värskendus Saadaval',
      'fi': 'Päivitys Saatavilla',
      'fa': 'بروزرسانی موجود است',
      'fr': 'Mise à Jour Disponible',
      'ka': 'განახლება ხელმისაწვდომია',
      'de': 'Update Verfügbar',
      'el': 'Διαθέσιμη Ενημέρωση',
      'he': 'עדכון זמין',
      'hu': 'Frissítés Elérhető',
      'hi': 'अपडेट उपलब्ध है',
      'id': 'Pembaruan Tersedia',
      'it': 'Aggiornamento Disponibile',
      'ja': 'アップデートが利用可能',
      'ku': 'Nûvekirin Peyda ye',
      'ko': '업데이트 사용 가능',
      'km': 'មានការអាប់ដេត',
      'lo': 'ມີອັບເດດ',
      'lv': 'Pieejams Atjauninājums',
      'ms': 'Kemas Kini Tersedia',
      'mn': 'Шинэчлэл Боломжтой',
      'no': 'Oppdatering Tilgjengelig',
      'pl': 'Dostępna Aktualizacja',
      'pt': 'Atualização Disponível',
      'ro': 'Actualizare Disponibilă',
      'ru': 'Доступно Обновление',
      'sk': 'Aktualizácia Dostupná',
      'sl': 'Posodobitev Na Voljo',
      'es': 'Actualización Disponible',
      'sw': 'Sasisho Linapatikana',
      'se': 'Uppdatering Tillgänglig',
      'ta': 'புதுப்பிப்பு கிடைக்கிறது',
      'th': 'มีอัปเดต',
      'tr': 'Güncelleme Mevcut',
      'uk': 'Доступне Оновлення',
      'vi': 'Có Bản Cập Nhật',
    },
    'updateRequired': {
      'al': 'Kërkohet Përditësim',
      'ar': 'التحديث مطلوب',
      'bn': 'আপডেট প্রয়োজন',
      'bs': 'Potrebno Ažuriranje',
      'bg': 'Изисква се Актуализация',
      'ca': 'Actualització Necessària',
      'zh': '需要更新',
      'hr': 'Potrebno Ažuriranje',
      'cs': 'Vyžadována Aktualizace',
      'da': 'Opdatering Påkrævet',
      'nl': 'Update Vereist',
      'en': 'Update Required',
      'et': 'Värskendus Nõutav',
      'fi': 'Päivitys Vaaditaan',
      'fa': 'بروزرسانی الزامی است',
      'fr': 'Mise à Jour Requise',
      'ka': 'საჭიროა განახლება',
      'de': 'Update Erforderlich',
      'el': 'Απαιτείται Ενημέρωση',
      'he': 'נדרש עדכון',
      'hu': 'Frissítés Szükséges',
      'hi': 'अपडेट आवश्यक है',
      'id': 'Pembaruan Diperlukan',
      'it': 'Aggiornamento Richiesto',
      'ja': 'アップデートが必要',
      'ku': 'Nûvekirin Pêwîst e',
      'ko': '업데이트 필요',
      'km': 'ត្រូវការអាប់ដេត',
      'lo': 'ຕ້ອງການອັບເດດ',
      'lv': 'Nepieciešams Atjauninājums',
      'ms': 'Kemas Kini Diperlukan',
      'mn': 'Шинэчлэл Шаардлагатай',
      'no': 'Oppdatering Kreves',
      'pl': 'Wymagana Aktualizacja',
      'pt': 'Atualização Necessária',
      'ro': 'Actualizare Necesară',
      'ru': 'Требуется Обновление',
      'sk': 'Vyžaduje sa Aktualizácia',
      'sl': 'Potrebna Posodobitev',
      'es': 'Actualización Requerida',
      'sw': 'Sasisho Linahitajika',
      'se': 'Uppdatering Krävs',
      'ta': 'புதுப்பிப்பு தேவை',
      'th': 'ต้องอัปเดต',
      'tr': 'Güncelleme Gerekli',
      'uk': 'Потрібне Оновлення',
      'vi': 'Cần Cập Nhật',
    },
    'updateMessage': {
      'al':
          'Një version i ri i aplikacionit është i disponueshëm. Ju lutemi përditësoni për të vazhduar.',
      'ar': 'يتوفر إصدار جديد من التطبيق. يرجى التحديث للمتابعة.',
      'bn': 'অ্যাপের একটি নতুন সংস্করণ উপলব্ধ। চালিয়ে যেতে আপডেট করুন।',
      'bs':
          'Nova verzija aplikacije je dostupna. Molimo ažurirajte da nastavite.',
      'bg':
          'Налична е нова версия на приложението. Моля, актуализирайте, за да продължите.',
      'ca':
          'Hi ha una nova versió de l\'aplicació disponible. Si us plau, actualitzeu per continuar.',
      'zh': '应用有新版本可用。请更新以继续使用。',
      'hr':
          'Nova verzija aplikacije je dostupna. Molimo ažurirajte za nastavak.',
      'cs':
          'Je k dispozici nová verze aplikace. Pro pokračování prosím aktualizujte.',
      'da':
          'En ny version af appen er tilgængelig. Opdater venligst for at fortsætte.',
      'nl':
          'Er is een nieuwe versie van de app beschikbaar. Update om door te gaan.',
      'en': 'A new version of the app is available. Please update to continue.',
      'et': 'Rakenduse uus versioon on saadaval. Jätkamiseks värskendage.',
      'fi': 'Sovelluksesta on saatavilla uusi versio. Päivitä jatkaaksesi.',
      'fa': 'نسخه جدید برنامه موجود است. لطفاً برای ادامه بروزرسانی کنید.',
      'fr':
          'Une nouvelle version de l\'application est disponible. Veuillez mettre à jour pour continuer.',
      'ka':
          'აპლიკაციის ახალი ვერსია ხელმისაწვდომია. გთხოვთ განაახლოთ გასაგრძელებლად.',
      'de':
          'Eine neue Version der App ist verfügbar. Bitte aktualisieren Sie, um fortzufahren.',
      'el':
          'Μια νέα έκδοση της εφαρμογής είναι διαθέσιμη. Παρακαλώ ενημερώστε για να συνεχίσετε.',
      'he': 'גרסה חדשה של האפליקציה זמינה. אנא עדכן כדי להמשיך.',
      'hu':
          'Az alkalmazás új verziója elérhető. Kérjük, frissítsen a folytatáshoz.',
      'hi': 'ऐप का नया संस्करण उपलब्ध है। कृपया जारी रखने के लिए अपडेट करें।',
      'id': 'Versi baru aplikasi tersedia. Silakan perbarui untuk melanjutkan.',
      'it':
          'Una nuova versione dell\'app è disponibile. Aggiorna per continuare.',
      'ja': 'アプリの新しいバージョンが利用可能です。続行するには更新してください。',
      'ku':
          'Guhertoya nû ya sepanê heye. Ji kerema xwe nûve bikin da ku bidomînin.',
      'ko': '앱의 새 버전을 사용할 수 있습니다. 계속하려면 업데이트하세요.',
      'km': 'កំណែថ្មីនៃកម្មវិធីមាន។ សូមអាប់ដេតដើម្បីបន្ត។',
      'lo': 'ມີເວີຊັນໃໝ່ຂອງແອັບ. ກະລຸນາອັບເດດເພື່ອສືບຕໍ່.',
      'lv':
          'Ir pieejama jauna lietotnes versija. Lūdzu, atjauniniet, lai turpinātu.',
      'ms': 'Versi baharu aplikasi tersedia. Sila kemas kini untuk meneruskan.',
      'mn':
          'Аппликейшны шинэ хувилбар боломжтой. Үргэлжлүүлэхийн тулд шинэчлэнэ үү.',
      'no':
          'En ny versjon av appen er tilgjengelig. Vennligst oppdater for å fortsette.',
      'pl':
          'Dostępna jest nowa wersja aplikacji. Zaktualizuj, aby kontynuować.',
      'pt':
          'Uma nova versão do aplicativo está disponível. Por favor, atualize para continuar.',
      'ro':
          'O nouă versiune a aplicației este disponibilă. Vă rugăm să actualizați pentru a continua.',
      'ru':
          'Доступна новая версия приложения. Пожалуйста, обновите, чтобы продолжить.',
      'sk':
          'K dispozícii je nová verzia aplikácie. Pre pokračovanie prosím aktualizujte.',
      'sl':
          'Na voljo je nova različica aplikacije. Za nadaljevanje prosimo posodobite.',
      'es':
          'Una nueva versión de la aplicación está disponible. Por favor, actualiza para continuar.',
      'sw':
          'Toleo jipya la programu linapatikana. Tafadhali sasisha ili kuendelea.',
      'se':
          'En ny version av appen är tillgänglig. Vänligen uppdatera för att fortsätta.',
      'ta': 'பயன்பாட்டின் புதிய பதிப்பு உள்ளது. தொடர புதுப்பிக்கவும்.',
      'th': 'แอปเวอร์ชันใหม่พร้อมใช้งาน กรุณาอัปเดตเพื่อดำเนินการต่อ',
      'tr':
          'Uygulamanın yeni bir sürümü mevcut. Devam etmek için lütfen güncelleyin.',
      'uk':
          'Доступна нова версія додатку. Будь ласка, оновіть, щоб продовжити.',
      'vi': 'Có phiên bản mới của ứng dụng. Vui lòng cập nhật để tiếp tục.',
    },
    'optionalUpdateMessage': {
      'al':
          'Një version i ri i aplikacionit është i disponueshëm. Rekomandojmë përditësimin për një përvojë më të mirë.',
      'ar': 'يتوفر إصدار جديد من التطبيق. نوصي بالتحديث للحصول على تجربة أفضل.',
      'bn':
          'অ্যাপের একটি নতুন সংস্করণ উপলব্ধ। ভালো অভিজ্ঞতার জন্য আপডেট করার পরামর্শ দিচ্ছি।',
      'bs':
          'Nova verzija aplikacije je dostupna. Preporučujemo ažuriranje za bolje iskustvo.',
      'bg':
          'Налична е нова версия на приложението. Препоръчваме актуализация за по-добро изживяване.',
      'ca':
          'Hi ha una nova versió de l\'aplicació disponible. Recomanem actualitzar per a una millor experiència.',
      'zh': '应用有新版本可用。建议更新以获得更好的体验。',
      'hr':
          'Nova verzija aplikacije je dostupna. Preporučujemo ažuriranje za bolje iskustvo.',
      'cs':
          'Je k dispozici nová verze aplikace. Pro lepší zážitek doporučujeme aktualizovat.',
      'da':
          'En ny version af appen er tilgængelig. Vi anbefaler at opdatere for en bedre oplevelse.',
      'nl':
          'Er is een nieuwe versie van de app beschikbaar. We raden aan te updaten voor een betere ervaring.',
      'en':
          'A new version of the app is available. We recommend updating for a better experience.',
      'et':
          'Rakenduse uus versioon on saadaval. Soovitame parema kogemuse saamiseks värskendada.',
      'fi':
          'Sovelluksesta on saatavilla uusi versio. Suosittelemme päivittämistä paremman kokemuksen saamiseksi.',
      'fa':
          'نسخه جدید برنامه موجود است. برای تجربه بهتر بروزرسانی را توصیه می‌کنیم.',
      'fr':
          'Une nouvelle version de l\'application est disponible. Nous recommandons de mettre à jour pour une meilleure expérience.',
      'ka':
          'აპლიკაციის ახალი ვერსია ხელმისაწვდომია. უკეთესი გამოცდილებისთვის გირჩევთ განაახლოთ.',
      'de':
          'Eine neue Version der App ist verfügbar. Wir empfehlen ein Update für ein besseres Erlebnis.',
      'el':
          'Μια νέα έκδοση της εφαρμογής είναι διαθέσιμη. Συνιστούμε την ενημέρωση για καλύτερη εμπειρία.',
      'he': 'גרסה חדשה של האפליקציה זמינה. אנו ממליצים לעדכן לחוויה טובה יותר.',
      'hu':
          'Az alkalmazás új verziója elérhető. A jobb élmény érdekében javasoljuk a frissítést.',
      'hi':
          'ऐप का नया संस्करण उपलब्ध है। बेहतर अनुभव के लिए अपडेट करने की अनुशंसा करते हैं।',
      'id':
          'Versi baru aplikasi tersedia. Kami sarankan memperbarui untuk pengalaman yang lebih baik.',
      'it':
          'Una nuova versione dell\'app è disponibile. Ti consigliamo di aggiornare per un\'esperienza migliore.',
      'ja': 'アプリの新しいバージョンが利用可能です。より良い体験のために更新をお勧めします。',
      'ku':
          'Guhertoya nû ya sepanê heye. Em pêşniyar dikin ku hûn nûve bikin ji bo ezmûnek çêtir.',
      'ko': '앱의 새 버전을 사용할 수 있습니다. 더 나은 경험을 위해 업데이트를 권장합니다.',
      'km':
          'កំណែថ្មីនៃកម្មវិធីមាន។ យើងណែនាំអោយអាប់ដេតសម្រាប់បទពិសោធន៍ល្អប្រសើរ។',
      'lo': 'ມີເວີຊັນໃໝ່ຂອງແອັບ. ພວກເຮົາແນະນຳໃຫ້ອັບເດດເພື່ອປະສົບການທີ່ດີຂຶ້ນ.',
      'lv':
          'Ir pieejama jauna lietotnes versija. Iesakām atjaunināt labākai pieredzei.',
      'ms':
          'Versi baharu aplikasi tersedia. Kami mengesyorkan kemas kini untuk pengalaman yang lebih baik.',
      'mn':
          'Аппликейшны шинэ хувилбар боломжтой. Илүү сайн туршлагын тулд шинэчлэхийг зөвлөж байна.',
      'no':
          'En ny versjon av appen er tilgjengelig. Vi anbefaler å oppdatere for en bedre opplevelse.',
      'pl':
          'Dostępna jest nowa wersja aplikacji. Zalecamy aktualizację dla lepszego doświadczenia.',
      'pt':
          'Uma nova versão do aplicativo está disponível. Recomendamos atualizar para uma melhor experiência.',
      'ro':
          'O nouă versiune a aplicației este disponibilă. Vă recomandăm să actualizați pentru o experiență mai bună.',
      'ru':
          'Доступна новая версия приложения. Рекомендуем обновить для лучшего опыта.',
      'sk':
          'K dispozícii je nová verzia aplikácie. Pre lepší zážitok odporúčame aktualizovať.',
      'sl':
          'Na voljo je nova različica aplikacije. Za boljšo izkušnjo priporočamo posodobitev.',
      'es':
          'Una nueva versión de la aplicación está disponible. Recomendamos actualizar para una mejor experiencia.',
      'sw':
          'Toleo jipya la programu linapatikana. Tunapendekeza kusasisha kwa uzoefu bora.',
      'se':
          'En ny version av appen är tillgänglig. Vi rekommenderar att uppdatera för en bättre upplevelse.',
      'ta':
          'பயன்பாட்டின் புதிய பதிப்பு உள்ளது. சிறந்த அனுபவத்திற்கு புதுப்பிக்க பரிந்துரைக்கிறோம்.',
      'th':
          'แอปเวอร์ชันใหม่พร้อมใช้งาน เราแนะนำให้อัปเดตเพื่อประสบการณ์ที่ดีขึ้น',
      'tr':
          'Uygulamanın yeni bir sürümü mevcut. Daha iyi bir deneyim için güncellemenizi öneririz.',
      'uk':
          'Доступна нова версія додатку. Рекомендуємо оновити для кращого досвіду.',
      'vi':
          'Có phiên bản mới của ứng dụng. Chúng tôi khuyên bạn nên cập nhật để có trải nghiệm tốt hơn.',
    },
    'updateButton': {
      'al': 'Përditëso',
      'ar': 'تحديث',
      'bn': 'আপডেট',
      'bs': 'Ažuriraj',
      'bg': 'Актуализирай',
      'ca': 'Actualitza',
      'zh': '更新',
      'hr': 'Ažuriraj',
      'cs': 'Aktualizovat',
      'da': 'Opdater',
      'nl': 'Updaten',
      'en': 'Update',
      'et': 'Värskenda',
      'fi': 'Päivitä',
      'fa': 'بروزرسانی',
      'fr': 'Mettre à jour',
      'ka': 'განახლება',
      'de': 'Aktualisieren',
      'el': 'Ενημέρωση',
      'he': 'עדכן',
      'hu': 'Frissítés',
      'hi': 'अपडेट',
      'id': 'Perbarui',
      'it': 'Aggiorna',
      'ja': '更新',
      'ku': 'Nûvekirin',
      'ko': '업데이트',
      'km': 'អាប់ដេត',
      'lo': 'ອັບເດດ',
      'lv': 'Atjaunināt',
      'ms': 'Kemas Kini',
      'mn': 'Шинэчлэх',
      'no': 'Oppdater',
      'pl': 'Aktualizuj',
      'pt': 'Atualizar',
      'ro': 'Actualizează',
      'ru': 'Обновить',
      'sk': 'Aktualizovať',
      'sl': 'Posodobi',
      'es': 'Actualizar',
      'sw': 'Sasisha',
      'se': 'Uppdatera',
      'ta': 'புதுப்பி',
      'th': 'อัปเดต',
      'tr': 'Güncelle',
      'uk': 'Оновити',
      'vi': 'Cập nhật',
    },
    'laterButton': {
      'al': 'Më vonë',
      'ar': 'لاحقاً',
      'bn': 'পরে',
      'bs': 'Kasnije',
      'bg': 'По-късно',
      'ca': 'Més tard',
      'zh': '稍后',
      'hr': 'Kasnije',
      'cs': 'Později',
      'da': 'Senere',
      'nl': 'Later',
      'en': 'Later',
      'et': 'Hiljem',
      'fi': 'Myöhemmin',
      'fa': 'بعداً',
      'fr': 'Plus tard',
      'ka': 'მოგვიანებით',
      'de': 'Später',
      'el': 'Αργότερα',
      'he': 'מאוחר יותר',
      'hu': 'Később',
      'hi': 'बाद में',
      'id': 'Nanti',
      'it': 'Dopo',
      'ja': '後で',
      'ku': 'Paşê',
      'ko': '나중에',
      'km': 'ពេលក្រោយ',
      'lo': 'ພາຍຫຼັງ',
      'lv': 'Vēlāk',
      'ms': 'Nanti',
      'mn': 'Дараа',
      'no': 'Senere',
      'pl': 'Później',
      'pt': 'Mais Tarde',
      'ro': 'Mai Târziu',
      'ru': 'Позже',
      'sk': 'Neskôr',
      'sl': 'Kasneje',
      'es': 'Más Tarde',
      'sw': 'Baadaye',
      'se': 'Senare',
      'ta': 'பின்னர்',
      'th': 'ภายหลัง',
      'tr': 'Daha Sonra',
      'uk': 'Пізніше',
      'vi': 'Để sau',
    },
    'skipButton': {
      'al': 'Kalo Këtë Version',
      'ar': 'تخطي هذا الإصدار',
      'bn': 'এই সংস্করণ এড়িয়ে যান',
      'bs': 'Preskoči Ovu Verziju',
      'bg': 'Пропусни Тази Версия',
      'ca': 'Omet Aquesta Versió',
      'zh': '跳过此版本',
      'hr': 'Preskoči Ovu Verziju',
      'cs': 'Přeskočit Tuto Verzi',
      'da': 'Spring Denne Version Over',
      'nl': 'Sla Deze Versie Over',
      'en': 'Skip This Version',
      'et': 'Jäta See Versioon Vahele',
      'fi': 'Ohita Tämä Versio',
      'fa': 'رد کردن این نسخه',
      'fr': 'Ignorer Cette Version',
      'ka': 'გამოტოვე ეს ვერსია',
      'de': 'Diese Version Überspringen',
      'el': 'Παράλειψη Αυτής της Έκδοσης',
      'he': 'דלג על גרסה זו',
      'hu': 'Verzió Kihagyása',
      'hi': 'इस संस्करण को छोड़ें',
      'id': 'Lewati Versi Ini',
      'it': 'Salta Questa Versione',
      'ja': 'このバージョンをスキップ',
      'ku': 'Vê Guhertoyê Derbas Bike',
      'ko': '이 버전 건너뛰기',
      'km': 'រំលងកំណែនេះ',
      'lo': 'ຂ້າມເວີຊັນນີ້',
      'lv': 'Izlaist Šo Versiju',
      'ms': 'Langkau Versi Ini',
      'mn': 'Энэ хувилбарыг алгасах',
      'no': 'Hopp Over Denne Versjonen',
      'pl': 'Pomiń Tę Wersję',
      'pt': 'Pular Esta Versão',
      'ro': 'Omite Această Versiune',
      'ru': 'Пропустить Эту Версию',
      'sk': 'Preskočiť Túto Verziu',
      'sl': 'Preskoči To Različico',
      'es': 'Omitir Esta Versión',
      'sw': 'Ruka Toleo Hili',
      'se': 'Hoppa Över Denna Version',
      'ta': 'இந்த பதிப்பை தவிர்',
      'th': 'ข้ามเวอร์ชันนี้',
      'tr': 'Bu Sürümü Atla',
      'uk': 'Пропустити Цю Версію',
      'vi': 'Bỏ Qua Phiên Bản Này',
    },
    'currentVersion': {
      'al': 'Versioni Aktual',
      'ar': 'الإصدار الحالي',
      'bn': 'বর্তমান সংস্করণ',
      'bs': 'Trenutna Verzija',
      'bg': 'Текуща Версия',
      'ca': 'Versió Actual',
      'zh': '当前版本',
      'hr': 'Trenutna Verzija',
      'cs': 'Aktuální Verze',
      'da': 'Nuværende Version',
      'nl': 'Huidige Versie',
      'en': 'Current Version',
      'et': 'Praegune Versioon',
      'fi': 'Nykyinen Versio',
      'fa': 'نسخه فعلی',
      'fr': 'Version Actuelle',
      'ka': 'მიმდინარე ვერსია',
      'de': 'Aktuelle Version',
      'el': 'Τρέχουσα Έκδοση',
      'he': 'גרסה נוכחית',
      'hu': 'Jelenlegi Verzió',
      'hi': 'वर्तमान संस्करण',
      'id': 'Versi Saat Ini',
      'it': 'Versione Attuale',
      'ja': '現在のバージョン',
      'ku': 'Guhertoya Niha',
      'ko': '현재 버전',
      'km': 'កំណែបច្ចុប្បន្ន',
      'lo': 'ເວີຊັນປັດຈຸບັນ',
      'lv': 'Pašreizējā Versija',
      'ms': 'Versi Semasa',
      'mn': 'Одоогийн Хувилбар',
      'no': 'Nåværende Versjon',
      'pl': 'Aktualna Wersja',
      'pt': 'Versão Atual',
      'ro': 'Versiunea Curentă',
      'ru': 'Текущая Версия',
      'sk': 'Aktuálna Verzia',
      'sl': 'Trenutna Različica',
      'es': 'Versión Actual',
      'sw': 'Toleo la Sasa',
      'se': 'Nuvarande Version',
      'ta': 'தற்போதைய பதிப்பு',
      'th': 'เวอร์ชันปัจจุบัน',
      'tr': 'Mevcut Sürüm',
      'uk': 'Поточна Версія',
      'vi': 'Phiên Bản Hiện Tại',
    },
    'newVersion': {
      'al': 'Version i Ri',
      'ar': 'إصدار جديد',
      'bn': 'নতুন সংস্করণ',
      'bs': 'Nova Verzija',
      'bg': 'Нова Версия',
      'ca': 'Versió Nova',
      'zh': '新版本',
      'hr': 'Nova Verzija',
      'cs': 'Nová Verze',
      'da': 'Ny Version',
      'nl': 'Nieuwe Versie',
      'en': 'New Version',
      'et': 'Uus Versioon',
      'fi': 'Uusi Versio',
      'fa': 'نسخه جدید',
      'fr': 'Nouvelle Version',
      'ka': 'ახალი ვერსია',
      'de': 'Neue Version',
      'el': 'Νέα Έκδοση',
      'he': 'גרסה חדשה',
      'hu': 'Új Verzió',
      'hi': 'नया संस्करण',
      'id': 'Versi Baru',
      'it': 'Nuova Versione',
      'ja': '新しいバージョン',
      'ku': 'Guhertoya Nû',
      'ko': '새 버전',
      'km': 'កំណែថ្មី',
      'lo': 'ເວີຊັນໃໝ່',
      'lv': 'Jaunā Versija',
      'ms': 'Versi Baharu',
      'mn': 'Шинэ Хувилбар',
      'no': 'Ny Versjon',
      'pl': 'Nowa Wersja',
      'pt': 'Nova Versão',
      'ro': 'Versiune Nouă',
      'ru': 'Новая Версия',
      'sk': 'Nová Verzia',
      'sl': 'Nova Različica',
      'es': 'Nueva Versión',
      'sw': 'Toleo Jipya',
      'se': 'Ny Version',
      'ta': 'புதிய பதிப்பு',
      'th': 'เวอร์ชันใหม่',
      'tr': 'Yeni Sürüm',
      'uk': 'Нова Версія',
      'vi': 'Phiên Bản Mới',
    },
  };

  /// Çeviri al - bulunamazsa İngilizce döner
  String _get(String key) {
    final map = _translations[key];
    if (map == null) return key;

    return map[locale] ?? map[defaultLocale] ?? key;
  }

  // ═══════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════

  /// "Güncelleme Mevcut"
  String get updateAvailable => _get('updateAvailable');

  /// "Güncelleme Gerekli"
  String get updateRequired => _get('updateRequired');

  /// Zorunlu güncelleme mesajı
  String get updateMessage => _get('updateMessage');

  /// Opsiyonel güncelleme mesajı
  String get optionalUpdateMessage => _get('optionalUpdateMessage');

  /// "Güncelle" butonu
  String get updateButton => _get('updateButton');

  /// "Daha Sonra" butonu
  String get laterButton => _get('laterButton');

  /// "Bu Sürümü Atla" butonu
  String get skipButton => _get('skipButton');

  /// "Mevcut Sürüm"
  String get currentVersion => _get('currentVersion');

  /// "Yeni Sürüm"
  String get newVersion => _get('newVersion');
}
