import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Chartnote',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 0, 100, 255)),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  List<String> names = List.empty(growable: true);
  Map<String, GraphType> types = {};
  Map<String, Map<DateTime, double>> data = {};

  void notify() {
    notifyListeners();
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

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

makeGraphDialog(context, names, types, data) => showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return GraphDialog(names, types, data);
    });
