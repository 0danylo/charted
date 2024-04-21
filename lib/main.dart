import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Trend Notes',
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

class MyAppState extends ChangeNotifier {
  var current = 0;
  List<Map<DateTime, double>> data = List.empty();
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Scaffold(
      body: Center(
        child: ListView(children: [
          for (var datum in appState.data) GraphCard(chartData: datum),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () => showDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const DataDialog();
                  }),
              child: const Text('+'),
            ),
          ),
        ]),
      ),
    );
  }
}

class DataDialog extends StatefulWidget {
  const DataDialog({super.key});

  @override
  State<StatefulWidget> createState() => DataDialogState();
}

class DataDialogState extends State<DataDialog> {
  var newDate = DateTime.now();
  var newTime = TimeOfDay.now();
  var newDatum = 0.0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        children: [
          Title(
              color: const Color.fromARGB(255, 106, 106, 106),
              child: const Text("Add data point")),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    var date = showDatePicker(
                      context: context,
                      firstDate: DateTime.fromMillisecondsSinceEpoch(0),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    ).then(
                        (value) => setState(() => newDate = value ?? newDate));
                  },
                  child: const Text("Set date")),
              Text(newDate.toString()),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                  onPressed: () {
                    var time = showTimePicker(
                            context: context, initialTime: TimeOfDay.now())
                        .then((value) =>
                            setState(() => newTime = value ?? newTime));
                  },
                  child: const Text("Set time")),
              Text(newTime.toString()),
            ],
          ),
          TextField(
            decoration: const InputDecoration(labelText: "Value:"),
            keyboardType: TextInputType.number,
            // inputFormatters: [
            //   FilteringTextInputFormatter.digitsOnly,
            // ],
            onChanged: (value) => setState(() => newDatum =
                RegExp("[+-]?([0-9]*[.])?[0-9]+").firstMatch(value) != null
                    ? double.parse(value)
                    : newDatum),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Okay"))
        ],
      ),
    );
  }
}

class GraphCard extends StatelessWidget {
  const GraphCard({
    super.key,
    required this.chartData,
  });

  final Map<DateTime, double> chartData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      elevation: 10,
      color: theme.colorScheme.secondary,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20.0)),
          Text(chartData.toString(), style: style),
          LineChart(
            LineChartData(),
          ),
          Row(
            children: [
              ButtonBar(
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.abc_outlined)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.ac_unit_sharp))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
