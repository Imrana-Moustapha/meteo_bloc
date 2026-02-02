// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get weatherNiger => 'طقس النيجر';

  @override
  String get weatherTitle => 'الطقس الحالي';

  @override
  String get temperature => 'درجة الحرارة';

  @override
  String get description => 'سماء صافية';

  @override
  String get humidity => 'الرطوبة';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get themeLabel => 'المظهر';

  @override
  String get themeLight => 'فاتح';

  @override
  String get themeLightDesc => 'ألوان فاتحة';

  @override
  String get themeDark => 'داكن';

  @override
  String get themeDarkDesc => 'ألوان داكنة';

  @override
  String get themeSystem => 'النظام';

  @override
  String get themeSystemDesc => 'متابعة إعدادات النظام';

  @override
  String get languageLabel => 'اللغة';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get exitTitle => 'خروج من التطبيق';

  @override
  String get exitSubtitle => 'إغلاق التطبيق';

  @override
  String get exitConfirmMessage => 'هل أنت متأكد أنك تريد الخروج من التطبيق؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get searchHint => 'البحث عن مدينة...';

  @override
  String get favoritesTitle => 'المفضلات';

  @override
  String get aboutTooltip => 'حول';

  @override
  String get refreshTooltip => 'تحديث';

  @override
  String get loadingMessage => 'جارٍ تحميل حالة الطقس...';

  @override
  String get returnDefaultTooltip => 'العودة إلى المدينة الافتراضية';

  @override
  String get windSpeed => 'الرياح';

  @override
  String get feelsLike => 'درجة الحرارة المحسوسة';

  @override
  String get forecastTitle => 'التوقعات';

  @override
  String get today => 'اليوم';

  @override
  String get tomorrow => 'غداً';

  @override
  String get view => 'عرض';

  @override
  String lastUpdate(String time) {
    return 'آخر تحديث: $time';
  }

  @override
  String get addToFavorites => 'إضافة إلى المفضلات';

  @override
  String addedToFavorites(String city) {
    return 'تم إضافة $city إلى المفضلات';
  }

  @override
  String alreadyInFavorites(String city) {
    return '$city موجود بالفعل في المفضلات';
  }
}
