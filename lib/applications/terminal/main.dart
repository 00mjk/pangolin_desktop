/*
Copyright 2020 The dahliaOS Authors

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
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'terminal-widget.dart';

void main() => runApp(TerminalApp());

class TerminalApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Terminal',
      theme: new ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepOrange,
        primaryColor: const Color(0xFF212121),
        accentColor: const Color(0xFFff6507),
        canvasColor: const Color(0xFF303030),
        platform: TargetPlatform.fuchsia,
      ),
      initialRoute: '/',
      routes: {
        // When navigating to the "/" route, build the FirstScreen widget.
        '/': (context) => TerminalUI(),
        // When navigating to the "/second" route, build the SecondScreen widget.
        '/second': (context) => SettingsScreen(),
      },
    );
  }
}

class TerminalUI extends StatefulWidget {
  TerminalUI({Key key}) : super(key: key);
  @override
  TerminalUIState createState() => new TerminalUIState();
}

class TerminalUIState extends State<TerminalUI> with TickerProviderStateMixin {
  List<Tab> tabs = [];
  TabController tabController;
  var count = 1;
  void newTab() {
    setState(() {
      tabs.add(
        Tab(
          child: Row(
            children: <Widget>[
              Text('Session ' '$count'),
              Padding(
                padding: EdgeInsets.only(left: 8),
              ),
              new Expanded(child: new Container()),
              GestureDetector(
                child: Icon(
                  Icons.clear,
                  size: 16,
                  //color: Colors.black,
                ),
                onTap: closeCurrentTab,
              ),
            ],
          ),
        ),
      );
      count++;
      tabController = TabController(length: tabs.length, vsync: this);
    });
  }

  void handleClick(String value) {
    switch (value) {
      case 'Logout':
        break;
      case 'Settings':
        break;
    }
  }

  void closeCurrentTab() {
    setState(() {
      tabs.removeAt(tabController.index);
      tabController = TabController(length: tabs.length, vsync: this);
    });
  }

  @override
  void initState() {
    super.initState();
    tabs.add(
      Tab(
        child: Row(
          children: <Widget>[
            Text('Session ' '0'),
            Padding(
              padding: EdgeInsets.only(left: 8),
            ),
            new Expanded(child: new Container()),
            GestureDetector(
              child: Icon(
                Icons.clear,
                size: 16,
                //color: Colors.black,
              ),
              onTap: closeCurrentTab,
            ),
          ],
        ),
      ),
    );
    tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF212121),
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(55.0), // here the desired height
            child: AppBar(
                elevation: 0.0,
                backgroundColor: Color(0xFF282828),
                bottom: PreferredSize(
                    preferredSize:
                        Size.fromHeight(55.0), // here the desired height
                    child: new Row(
                      children: [
                        new Expanded(
                            child: new Container(
                          child: TabBar(
                              controller: tabController,
                              labelColor: Color(0xFFffffff),
                              unselectedLabelColor: Colors.white,
                              indicator: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  color: Color(0xFF212121)),
                              tabs: tabs.map((tab) => tab).toList()),
                        )),
                        new Center(
                          child: new IconButton(
                              icon: Icon(Icons.add),
                              color: Colors.white,
                              onPressed: newTab),
                        ),
                        new Center(
                          child: new IconButton(
                            icon: Icon(Icons.settings),
                            color: Colors.white,
                            onPressed: () {
                              // Navigate to the second screen using a named route.
                              Navigator.pushNamed(context, '/second');
                            },
                          ),
                        ),
                      ],
                    )) // A trick to trigger TabBar rebuild.
                )),
        body: TabBarView(
          controller: tabController,
          children: tabs.map((tab) => Terminal()).toList(),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF282828),
            title: Text("Settings"),
            bottom: TabBar(
              tabs: [
                Tab(
                  text: "Appearance",
                ),
                Tab(text: "Keyboard & mouse"),
                Tab(
                  text: "Behavior",
                ),
                Tab(
                  text: "About",
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              AppearanceWidget(),
              Icon(Icons.directions_transit),
              Icon(Icons.directions_bike),
              Icon(Icons.directions_bike),
            ],
          ),
        ));
  }
}

Widget themeCard(Color bgcolor, Color fgcolor) {
  return new Container(
    color: bgcolor,
    child: new Text(
      "user@dahliaOS~\$",
      style: new TextStyle(color: fgcolor, fontFamily: "Cousine"),
    ),
  );
}

class AppearanceWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      padding: EdgeInsets.all(25),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          new Text(
            "Theme",
            style: new TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ));
  }
}
