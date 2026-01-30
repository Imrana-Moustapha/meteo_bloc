import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meteo/presentation/cubit/local_cubit/loacal_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleCubit extends Cubit<LocaleState> {
  static const String _localeKey = 'app_locale';
  StreamSubscription? _prefsSubscription;

  LocaleCubit() : super(LocaleState.initial()) {
    _loadLocale();
  }

  @override
  Future<void> close() {
    _prefsSubscription?.cancel();
    return super.close();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale = prefs.getString(_localeKey) ?? 'fr';
    
    _prefsSubscription = _watchLocaleChanges(prefs);
    
    emit(LocaleState(languageCode: savedLocale));
  }

  StreamSubscription _watchLocaleChanges(SharedPreferences prefs) {
    return Stream.periodic(const Duration(milliseconds: 500)).listen((_) async {
      final currentLocale = prefs.getString(_localeKey) ?? 'fr';
      if (currentLocale != state.languageCode) {
        emit(LocaleState(languageCode: currentLocale));
      }
    });
  }

  Future<void> _saveLocale(String localeCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_localeKey, localeCode);
    emit(LocaleState(languageCode: localeCode));
  }

  void changeLocale(String localeCode) async {
    await _saveLocale(localeCode);
  }

  void setFrench() => changeLocale('fr');
  void setEnglish() => changeLocale('en');
  void setArabic() => changeLocale('ar');
}