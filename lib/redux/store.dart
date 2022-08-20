import 'package:flutter/cupertino.dart';
import 'package:witcher_guide/redux/app_state.dart';
import 'package:redux/redux.dart';

final Store<AppState> store = Store<AppState>(
    reducer, initialState: const AppState(locale: Locale("en"))
);