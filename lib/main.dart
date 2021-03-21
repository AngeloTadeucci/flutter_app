// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
//import 'package:firebase/firestore.dart';
import 'package:teste_app/pages/calendario.dart';
import 'package:teste_app/pages/googlemaps.dart';

import 'pages/calculadora_bits.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_icons/line_awesome_icons.dart';
import 'package:intl/date_symbol_data_local.dart';

const String _title = "App Estudo";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initializeDateFormatting().then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: HomePage(),
    );
  }
}

class DrawerItem {
  DrawerItem(this.title, this.icon);
  String title;
  IconData icon;
}

class HomePage extends StatefulWidget {
  final drawerItems = [
    DrawerItem("Calculadora Bits", LineAwesomeIcons.calculator),
    DrawerItem("Google Maps", LineAwesomeIcons.map_pin),
    DrawerItem("Calendário", LineAwesomeIcons.calendar),
    //DrawerItem("Teeeeeste", Icons.info)
  ];

  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _selectedDrawerIndex = 0;

  dynamic _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return CalculadoraBits();
      case 1:
        return GoogleMaps();
      case 2:
        return Calendario();
      // case 3:
      //   return TesteList();

      default:
        return Text("Error");
    }
  }

  dynamic _onSelectItem(int index) {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  Widget build(BuildContext context) {
    var drawerOptions = <Widget>[];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(ListTile(
        leading: Icon(d.icon),
        title: Text(d.title),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return Scaffold(
      appBar: AppBar(
        // here we display the title corresponding to the fragment
        // you can instead choose to have a static title
        title: Text(widget.drawerItems[_selectedDrawerIndex].title),
      ),
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            UserAccountsDrawerHeader(accountName: Text(_title), accountEmail: null),
            Column(children: drawerOptions)
          ],
        ),
      ),
      body: _getDrawerItemWidget(_selectedDrawerIndex),
    );
  }
}
