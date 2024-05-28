import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/file_util.dart';
import 'package:trend_notes/graph_card.dart';
import 'package:trend_notes/graph_dialog.dart';
import 'package:trend_notes/style_util.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MainPageState(),
      child: MaterialApp(
        title: 'Chartnote',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: blue),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPageState extends State<MainPage> with ChangeNotifier {
  List<String> names = List.empty(growable: true);
  Map<String, GraphType> types = {};
  Map<String, Map<DateTime, double>> data = {};

  @override
  initState() {
    super.initState();
    loadFile();
  }

  void notify() {
    notifyListeners();
  }

  loadFile() async {
    final file = (await localFile).then()

    if (file.exists()) {
      final contents = readFile();
      final graphs = contents.split('\n\n');
      for (var g in graphs) {
        final firstLine = g[0];
        final typeIndex = firstLine.lastIndexOf(' ') + 1;
        final name = firstLine.substring(0, typeIndex);
        final type = firstLine.substring(typeIndex);
        names.add(name);
        types[name] = type;

        Map<DateTime, double> dataMap = {};
        final dataList = g.sublist(1).split('\n');
        for (var d in dataList) {
          final data = d.split(' ');
          dataMap[DateTime.fromMillisecondsSinceEpoch(data[0])] =
              double.parse(data[1]);
        }

        data[name] = dataMap;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainPageState>();

    return Scaffold(
      backgroundColor: darkColor,
      body: ListView(children: [
        for (var name in appState.names)
          GraphCard(
            name: name,
            type: appState.types[name]!,
            data: appState.data[name]!,
          ),
        getPadding(5),
        Center(
          child: IconButton(
            onPressed: () => makeGraphDialog(
                context, appState.names, appState.types, appState.data),
            style: buttonStyle.copyWith(
              iconColor: MaterialStateProperty.resolveWith(
                (states) => Theme.of(context).colorScheme.primary,
              ),
            ),
            icon: const Icon(Icons.add, size: 30),
          ),
        )
      ]),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

// class MainPageState extends State<MainPage> {

// }

makeGraphDialog(context, names, types, data) => showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return GraphDialog(names, types, data);
    });
