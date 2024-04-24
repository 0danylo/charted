import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/graph_card.dart';
import 'package:trend_notes/main.dart';

class GraphDialog extends StatefulWidget {
  final List names;
  final Map data;
  final Map types;

  const GraphDialog(this.names, this.types, this.data, {super.key});

  @override
  State<GraphDialog> createState() => GraphDialogState();
}

class GraphDialogState extends State<GraphDialog> {
  var newGraphName = "";

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return AlertDialog(
        content: Column(
      children: [
        Title(
            color: const Color.fromARGB(255, 106, 106, 106),
            child: const Text("New Graph")),
        TextFormField(
          decoration: const InputDecoration(labelText: "Name:"),
          onChanged: (value) => setState(() => newGraphName = value)
        ),
        ElevatedButton(
            onPressed: newGraphName == "" ||
                    appState.names.contains(newGraphName)
                ? null
                : () {
                    widget.names.add(newGraphName);
                    widget.types[newGraphName] = GraphType.line;
                    widget.data[newGraphName] = Map.of(<DateTime, double>{});
                    newGraphName = "018eujosbnd8192er1hue";
                    
                    Navigator.of(context).pop();
                    appState.notify();
                  },
            child: const Text("Create Graph")),
        Text(
            newGraphName == ""
                ? "Invalid name"
                : appState.names.contains(newGraphName)
                    ? "Name already used"
                    : "",
            style: const TextStyle(color: Color.fromARGB(195, 255, 0, 0)))
      ],
    ));
  }
}
