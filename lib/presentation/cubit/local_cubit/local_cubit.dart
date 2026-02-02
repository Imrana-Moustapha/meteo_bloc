import 'package:flutter_bloc/flutter_bloc.dart';
import 'local_state.dart';

class LocaleCubit extends Cubit<LocaleState> {
  // État initial en français
  LocaleCubit() : super(SelectedLocale('fr'));

  void changeLanguage(String code) {
    emit(SelectedLocale(code));
  }
}