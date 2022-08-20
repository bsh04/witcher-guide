import 'package:flutter/material.dart';
import 'package:witcher_guide/API/URLs.dart';
import 'package:witcher_guide/API/httpManager.dart';
import 'package:witcher_guide/routes.dart';
import 'package:witcher_guide/secureStorageManager.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  void _handleAuth() async {
    String? token = await getStorageKey(tokenKey);

    if (token == null) {
      return;
    }

    RequestParams params = RequestParams();
    params.url = getUrl(userAuthUrl);
    params.method = Method.POST;
    params.body = {"token": token};

    await request(params);
  }

  @override
  void initState() {
    super.initState();
    _handleAuth();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: routes,
    );
  }
}
