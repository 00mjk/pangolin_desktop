/*
Copyright 2019 The dahliaOS Authors

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
import 'package:Pangolin/utils/widgets/notification.dart';
import 'package:dnotify/dnotify.dart';
import 'package:flutter/services.dart';

import 'package:Pangolin/desktop/desktop.dart';
import 'package:Pangolin/utils/localization/localization.dart';
import 'package:Pangolin/desktop/window/model.dart';
import 'package:Pangolin/utils/hiveManager.dart';
import 'package:Pangolin/utils/themes/customization_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:provider/provider.dart';

/// Set this to disable certain things during testing.
/// Use this sparingly, or better yet, not at all.
bool isTesting = false;

WindowsData provisionalWindowData = new WindowsData();

void main() async {
  //init hive
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Pangolin.settingsBox = await Hive.openBox("settings");
  HiveManager.initializeHive();
  DNotifyDaemon.start((data) {
    OverlayEntry o;
    o = OverlayEntry(builder: (context) => Positioned(
      child: Center(
        child: SizedBox(
          width: 350,
          child: GestureDetector(
            onTap: () {
              //onClick;
              o.remove();
            },
            child: MouseRegion(
              onHover: (event) {
                //_hover = true;
              },
              child: DahliaNotification(
                id: data["id"],
                title: data["title"],
                body: data.containsKey("body") ? data["body"] : "",
                color: Colors.blue[700],
                source: data["source"],
              )
            ),
          ),
        ),
      ),
      bottom: 50,
      right: 5,
    ));
    Pangolin.overlayState.insert(o);
    Pangolin.overlayEntries.add(o);
  });
  runApp(Pangolin());
}

class Pangolin extends StatefulWidget {
  @override
  _PangolinState createState() => _PangolinState();

  static OverlayState overlayState;
  static List<OverlayEntry> overlayEntries = [];

  static void setLocale(BuildContext context, Locale locale) {
    _PangolinState state = context.findAncestorStateOfType<_PangolinState>();
    state.setLocale(locale);
  }

  static Box<dynamic> settingsBox;
  static Locale locale;
  static ThemeData theme;
}

class _PangolinState extends State<Pangolin> {
  @override
  void initState() {
    getLangFromHive() {
      Pangolin.settingsBox = Hive.box("settings");
      if (Pangolin.settingsBox.get("language").toString().length == 5) {
        Pangolin.settingsBox.delete("language");
      }
      if (Pangolin.settingsBox.get("language") == null) {
        Pangolin.locale = Locale("en");
      } else {
        Pangolin.locale = Locale(Pangolin.settingsBox.get("language"));
      }
    }

    getLangFromHive();
    super.initState();
  }

  void setLocale(Locale locale) {
    setState(() {
      Pangolin.locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    //Gets DahliaOS UI set up in a familiar way.
    return ChangeNotifierProvider<WindowsData>(
      create: (context) => provisionalWindowData,
      child: ChangeNotifierProvider(
        create: (_) => CustomizationNotifier(),
        child: Consumer<CustomizationNotifier>(
          builder: (context, CustomizationNotifier notifier, child) {
            return MaterialApp(
              title: 'Pangolin Desktop',
              theme: notifier.darkTheme
                  ? Themes.dark(CustomizationNotifier().accent)
                  : Themes.light(CustomizationNotifier().accent),
              home: Desktop(title: 'Pangolin Desktop'),
              supportedLocales: [
                Locale("en"),
                Locale("de"),
                Locale("fr"),
                Locale("pl"),
                Locale("hr"),
                Locale("nl"),
                Locale("es"),
                Locale("pt"),
                Locale("id"),
                Locale("sk"),
                Locale("tr"),
                Locale("zh"),
                Locale("ar"),
              ],
              localizationsDelegates: [
                Localization.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              locale: Pangolin.locale,
            );
          },
        ),
      ),
    );
  }
}
