import 'package:flutter/material.dart';
import 'package:redux/redux.dart';

@immutable
class AppState {
  final Locale locale;

  const AppState({
    required this.locale,
  });
}

enum Actions { SetLocale }

AppState reducer(AppState previousState, action) {
  if (action == Actions.SetLocale) {
    return AppState(locale: previousState.locale);
  }
  return previousState;
}
