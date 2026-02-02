abstract class LocaleState {
  final String languageCode;
  LocaleState(this.languageCode);
}

class SelectedLocale extends LocaleState {
  SelectedLocale(super.languageCode);
}