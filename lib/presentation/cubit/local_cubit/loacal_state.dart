import 'package:equatable/equatable.dart';

class LocaleState extends Equatable {
  final String languageCode;
  final String? countryCode;

  const LocaleState({
    required this.languageCode,
    this.countryCode,
  });

  factory LocaleState.initial() {
    return const LocaleState(languageCode: 'fr');
  }

  LocaleState copyWith({
    String? languageCode,
    String? countryCode,
  }) {
    return LocaleState(
      languageCode: languageCode ?? this.languageCode,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  @override
  List<Object?> get props => [languageCode, countryCode];
}