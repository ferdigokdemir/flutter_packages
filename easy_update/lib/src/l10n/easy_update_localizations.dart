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
      'al': 'Përditësim i Aplikacionit',
      'ar': 'تحديث التطبيق',
      'bn': 'অ্যাপ আপডেট',
      'bs': 'Ažuriranje Aplikacije',
      'bg': 'Актуализация на Приложението',
      'ca': 'Actualització de l\'Aplicació',
      'zh': '应用更新',
      'hr': 'Ažuriranje Aplikacije',
      'cs': 'Aktualizace Aplikace',
      'da': 'App-opdatering',
      'nl': 'App-update',
      'en': 'App Update',
      'et': 'Rakenduse Värskendus',
      'fi': 'Sovelluspäivitys',
      'fa': 'بروزرسانی برنامه',
      'fr': 'Mise à Jour de l\'Application',
      'ka': 'აპლიკაციის განახლება',
      'de': 'App-Update',
      'el': 'Ενημέρωση Εφαρμογής',
      'he': 'עדכון אפליקציה',
      'hu': 'Alkalmazás Frissítés',
      'hi': 'ऐप अपडेट',
      'id': 'Pembaruan Aplikasi',
      'it': 'Aggiornamento App',
      'ja': 'アプリの更新',
      'ku': 'Nûvekirina Sepanê',
      'ko': '앱 업데이트',
      'km': 'ការអាប់ដេតកម្មវិធី',
      'lo': 'ອັບເດດແອັບ',
      'lv': 'Lietotnes Atjauninājums',
      'ms': 'Kemas Kini Aplikasi',
      'mn': 'Аппын Шинэчлэл',
      'no': 'App-oppdatering',
      'pl': 'Aktualizacja Aplikacji',
      'pt': 'Atualização do Aplicativo',
      'ro': 'Actualizare Aplicație',
      'ru': 'Обновление Приложения',
      'sk': 'Aktualizácia Aplikácie',
      'sl': 'Posodobitev Aplikacije',
      'es': 'Actualización de la Aplicación',
      'sw': 'Sasisho la Programu',
      'se': 'App-uppdatering',
      'ta': 'ஆப் புதுப்பிப்பு',
      'th': 'อัปเดตแอป',
      'tr': 'Uygulama Güncelleme',
      'uk': 'Оновлення Додатка',
      'vi': 'Cập Nhật Ứng Dụng',
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
          'Përditësoni aplikacionin për të marrë veçoritë dhe përmirësimet më të fundit.',
      'ar': 'حدّث التطبيق للحصول على أحدث الميزات والتحسينات.',
      'bn':
          'সর্বশেষ বৈশিষ্ট্য এবং উন্নতিগুলি পেতে অ্যাপটি আপডেট করুন।',
      'bs':
          'Ažurirajte aplikaciju da biste dobili najnovije funkcije i poboljšanja.',
      'bg':
          'Актуализирайте приложението, за да получите най-новите функции и подобрения.',
      'ca':
          'Actualitzeu l\'aplicació per obtenir les últimes funcions i millores.',
      'zh': '更新应用以获取最新的功能和改进。',
      'hr':
          'Ažurirajte aplikaciju kako biste dobili najnovije značajke i poboljšanja.',
      'cs':
          'Aktualizujte aplikaci a získejte nejnovější funkce a vylepšení.',
      'da':
          'Opdater appen for at få de nyeste funktioner og forbedringer.',
      'nl':
          'Werk de app bij om de nieuwste functies en verbeteringen te krijgen.',
      'en':
          'Update the app to get the latest features and improvements.',
      'et':
          'Värskendage rakendust, et saada uusimad funktsioonid ja täiustused.',
      'fi':
          'Päivitä sovellus saadaksesi uusimmat ominaisuudet ja parannukset.',
      'fa':
          'برنامه را به‌روزرسانی کنید تا جدیدترین ویژگی‌ها و بهبودها را دریافت کنید.',
      'fr':
          'Mettez à jour l\'application pour obtenir les dernières fonctionnalités et améliorations.',
      'ka':
          'განაახლეთ აპლიკაცია უახლესი ფუნქციებისა და გაუმჯობესებების მისაღებად.',
      'de':
          'Aktualisieren Sie die App, um die neuesten Funktionen und Verbesserungen zu erhalten.',
      'el':
          'Ενημερώστε την εφαρμογή για να αποκτήσετε τις πιο πρόσφατες λειτουργίες και βελτιώσεις.',
      'he': 'עדכנו את האפליקציה כדי לקבל את התכונות והשיפורים האחרונים.',
      'hu':
          'Frissítse az alkalmazást a legújabb funkciók és fejlesztések eléréséhez.',
      'hi':
          'नवीनतम सुविधाएँ और सुधार पाने के लिए ऐप को अपडेट करें।',
      'id':
          'Perbarui aplikasi untuk mendapatkan fitur dan peningkatan terbaru.',
      'it':
          'Aggiorna l\'app per ottenere le ultime funzionalità e i miglioramenti.',
      'ja': '最新の機能と改善点を入手するには、アプリを更新してください。',
      'ku':
          'Sepanê nûve bikin da ku taybetmendî û başkirinên herî dawî bistînin.',
      'ko': '최신 기능과 개선 사항을 받으려면 앱을 업데이트하세요.',
      'km':
          'អាប់ដេតកម្មវិធីដើម្បីទទួលបានមុខងារ និងភាពប្រសើរឡើងថ្មីៗ។',
      'lo': 'ອັບເດດແອັບເພື່ອຮັບຄຸນສົມບັດ ແລະ ການປັບປຸງຫຼ້າສຸດ.',
      'lv':
          'Atjauniniet lietotni, lai iegūtu jaunākās funkcijas un uzlabojumus.',
      'ms':
          'Kemas kini aplikasi untuk mendapatkan ciri dan penambahbaikan terkini.',
      'mn':
          'Хамгийн сүүлийн үеийн функц, сайжруулалтыг авахын тулд аппликейшнаа шинэчилнэ үү.',
      'no':
          'Oppdater appen for å få de nyeste funksjonene og forbedringene.',
      'pl':
          'Zaktualizuj aplikację, aby uzyskać najnowsze funkcje i ulepszenia.',
      'pt':
          'Atualize o aplicativo para obter os recursos e as melhorias mais recentes.',
      'ro':
          'Actualizați aplicația pentru a obține cele mai noi funcții și îmbunătățiri.',
      'ru':
          'Обновите приложение, чтобы получить новейшие функции и улучшения.',
      'sk':
          'Aktualizujte aplikáciu a získajte najnovšie funkcie a vylepšenia.',
      'sl':
          'Posodobite aplikacijo, da pridobite najnovejše funkcije in izboljšave.',
      'es':
          'Actualiza la aplicación para obtener las últimas funciones y mejoras.',
      'sw':
          'Sasisha programu ili kupata vipengele na maboresho ya hivi karibuni.',
      'se':
          'Uppdatera appen för att få de senaste funktionerna och förbättringarna.',
      'ta':
          'சமீபத்திய அம்சங்கள் மற்றும் மேம்பாடுகளைப் பெற பயன்பாட்டைப் புதுப்பிக்கவும்.',
      'th':
          'อัปเดตแอปเพื่อรับฟีเจอร์และการปรับปรุงล่าสุด',
      'tr':
          'En son özellikleri ve iyileştirmeleri almak için uygulamayı güncelleyin.',
      'uk':
          'Оновіть додаток, щоб отримати найновіші функції та покращення.',
      'vi':
          'Cập nhật ứng dụng để nhận các tính năng và cải tiến mới nhất.',
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
      'al': 'Më Kujto Më Vonë',
      'ar': 'ذكرني لاحقاً',
      'bn': 'পরে মনে করিয়ে দিন',
      'bs': 'Podsjeti Me Kasnije',
      'bg': 'Напомни Ми По-късно',
      'ca': 'Recorda-m\'ho Més Tard',
      'zh': '稍后提醒我',
      'hr': 'Podsjeti Me Kasnije',
      'cs': 'Připomenout Později',
      'da': 'Påmind Mig Senere',
      'nl': 'Herinner Me Later',
      'en': 'Remind Me Later',
      'et': 'Tuleta Hiljem Meelde',
      'fi': 'Muistuta Myöhemmin',
      'fa': 'بعداً یادآوری کن',
      'fr': 'Me Rappeler Plus Tard',
      'ka': 'შემახსენე მოგვიანებით',
      'de': 'Später Erinnern',
      'el': 'Υπενθύμισέ Μου Αργότερα',
      'he': 'הזכר לי מאוחר יותר',
      'hu': 'Emlékeztess Később',
      'hi': 'बाद में याद दिलाएं',
      'id': 'Ingatkan Saya Nanti',
      'it': 'Ricordamelo Più Tardi',
      'ja': '後で通知する',
      'ku': 'Paşê Bîne Bîra Min',
      'ko': '나중에 알림',
      'km': 'រំលឹកខ្ញុំពេលក្រោយ',
      'lo': 'ເຕືອນຂ້ອຍພາຍຫຼັງ',
      'lv': 'Atgādināt Vēlāk',
      'ms': 'Ingatkan Saya Nanti',
      'mn': 'Дараа Сануулах',
      'no': 'Påminn Meg Senere',
      'pl': 'Przypomnij Później',
      'pt': 'Lembrar Mais Tarde',
      'ro': 'Amintește-mi Mai Târziu',
      'ru': 'Напомнить Позже',
      'sk': 'Pripomenúť Neskôr',
      'sl': 'Opomni Me Kasneje',
      'es': 'Recordar Más Tarde',
      'sw': 'Nikumbushe Baadaye',
      'se': 'Påminn Mig Senare',
      'ta': 'பின்னர் நினைவூட்டு',
      'th': 'เตือนฉันภายหลัง',
      'tr': 'Daha Sonra Hatırlat',
      'uk': 'Нагадати Пізніше',
      'vi': 'Nhắc Tôi Sau',
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
    'bannerMessage': {
      'en': 'Update the app to discover new features!',
      'de': 'Aktualisiere die App, um neue Funktionen zu entdecken!',
      'es': '¡Actualiza la app para descubrir nuevas funciones!',
      'id': 'Perbarui aplikasi untuk menemukan fitur baru!',
      'it': 'Aggiorna l\'app per scoprire le nuove funzionalità!',
      'pt': 'Atualize o app para descobrir novos recursos!',
      'tr': 'Yeni özellikleri görmek için uygulamayı güncelle!',
    },
    'bannerForceMessage': {
      'en': 'This version is no longer supported.',
      'de': 'Diese Version wird nicht mehr unterstützt.',
      'es': 'Esta versión ya no es compatible.',
      'id': 'Versi ini tidak lagi didukung.',
      'it': 'Questa versione non è più supportata.',
      'pt': 'Esta versão não é mais suportada.',
      'tr': 'Bu sürüm artık desteklenmiyor.',
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

  /// İnce güncelleme banner'ı mesajı (opsiyonel güncelleme)
  String get bannerMessage => _get('bannerMessage');

  /// İnce güncelleme banner'ı mesajı (zorunlu güncelleme)
  String get bannerForceMessage => _get('bannerForceMessage');
}
