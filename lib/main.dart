import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/datum_dialog.dart';
import 'package:trend_notes/graph_card.dart';
import 'package:trend_notes/graph_dialog.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<MainPageState>(
      create: (context) => MainPageState(),
      child: MaterialApp(
        title: 'Chartnote',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme:
              ColorScheme.fromSeed(seedColor: const Color.fromRGBO(0, 0, 0, 1)),
        ),
        home: const MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> with ChangeNotifier {
  var names = ValueNotifier(List.empty(growable: true));
  var types = ValueNotifier({});
  var data = ValueNotifier({});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(children: [
          for (var name in names.value)
            GraphCard(name: name, type: types.value[name]!, chartData: data.value[name]!),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () => makeGraphDialog(context, names, types, data),
              child: const Text('+'),
            ),
          ),
        ]),
      ),
    );
  }
}

makeGraphDialog(context, names, types, data) => showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return GraphDialog(names, types, data);
    });

makeDatumDialog(context, state, graphName) => showDialog(
    barrierDismissible: true,
    context: context,
    builder: (BuildContext context) {
      return DatumDialog(graphName: graphName);
    });
