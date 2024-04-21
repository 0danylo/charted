import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/graph_card.dart';
import 'package:trend_notes/main.dart';

class GraphDialog extends StatelessWidget {
  final ValueListenable names;
  final ValueListenable data;
  final ValueListenable types;

  GraphDialog(this.names, this.types, this.data, {super.key});

  var newGraphName = "";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainPageState>();

    return AlertDialog(
        content: Column(
      children: [
        Title(
            color: const Color.fromARGB(255, 106, 106, 106),
            child: const Text("New Graph")),
        TextFormField(
          decoration: const InputDecoration(labelText: "Name:"),
          onChanged: (value) => newGraphName = value,
        ),
        ElevatedButton(
            onPressed: newGraphName == "" ||
                    appState.names.value.contains(newGraphName)
                ? null
                : () {
                    appState.names.value.add(newGraphName);
                    appState.types.value[newGraphName] = GraphType.line;
                    appState.data.value[newGraphName] = Map.of({});
                    newGraphName = "018eujosbnd8192er1hue";
                    Navigator.of(context).pop();
                  },
            child: const Text("Create Graph")),
        Text(
            newGraphName == ""
                ? "Invalid name"
                : appState.names.value.contains(newGraphName)
                    ? "Name already used"
                    : "",
            style: const TextStyle(color: Color.fromARGB(195, 255, 0, 0)))
      ],
    ));
  }
}
