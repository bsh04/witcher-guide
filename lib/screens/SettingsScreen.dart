import 'package:flutter/material.dart';
import 'package:witcher_guide/enums/index.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:witcher_guide/main.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Language language = Language.US;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: Container(
        padding: const EdgeInsets.all(10),
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Language", style: TextStyle(fontSize: 20),),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: DropdownButton<Language>(
                    value: language,
                    elevation: 16,
                    underline: Container(
                      height: 1,
                      color: Colors.black54,
                    ),
                    onChanged: (Language? value) {
                      if (value != null) {
                        setState(() {
                          language = value;
                        });
                      }
                    },
                    items:
                        Language.values
                            .map<DropdownMenuItem<Language>>((Language type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(LanguageExtension(type).displayTitle, style: TextStyle(fontSize: 20),),
                      );
                    }).toList(),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
