import 'package:flutter/material.dart';
import 'package:witcher_guide/screens/MainScreen/MainScreen.dart';
import 'package:witcher_guide/screens/LoginScreen.dart';
import 'package:witcher_guide/screens/RegistrationScreen.dart';
import 'package:witcher_guide/screens/Character/CharacterEditScreen.dart';
import 'package:witcher_guide/screens/Character/CharacterViewScreen.dart';
import 'package:witcher_guide/screens/SettingsScreen.dart';

final Map<String, WidgetBuilder> routes = <String, WidgetBuilder>{
  "/": (BuildContext context) => const MainScreen(),
  "/main": (BuildContext context) => const MainScreen(),
  "/registration": (BuildContext context) => const RegistrationScreen(),
  "/login": (BuildContext context) => const LoginScreen(),
  "/character": (BuildContext context) => const CharacterEditScreen(),
  "/viewCharacter": (BuildContext context) => const CharacterViewScreen(),
  "/settings": (BuildContext context) => const SettingsScreen()
};
