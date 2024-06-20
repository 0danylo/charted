import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charted/file_util.dart';
import 'package:charted/graph_card.dart';
import 'package:charted/main.dart';
import 'package:charted/style_util.dart';

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
    var appState = context.watch<MainPageState>();

    return AlertDialog(
        backgroundColor: darkColor,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Title(color: lightColor, child: subtitleOf("New Graph")),
            TextFormField(
                style: mediumStyle,
                decoration: const InputDecoration(
                    labelText: "Name:", labelStyle: labelStyle),
                onChanged: (value) => setState(() => newGraphName = value)),
            Text(
              newGraphName == ""
                  ? "Invalid name"
                  : widget.names.contains(newGraphName)
                      ? "Name already used"
                      : "",
              style: errorStyle,
            ),
            ElevatedButton(
                onPressed:
                    newGraphName == "" || widget.names.contains(newGraphName)
                        ? null
                        : () {
                            final type = widget.names.isNotEmpty
                                ? GraphType.values[
                                    Random().nextInt(GraphType.values.length)]
                                : GraphType.values[Random().nextInt(2) + 1];

                            writeGraph(newGraphName, type.name);
                            widget.names.add(newGraphName);
                            widget.types[newGraphName] = type;
                            widget.data[newGraphName] =
                                Map.of(<DateTime, double>{});
                            newGraphName = placeholderGraphName;

                            Navigator.of(context).pop();
                            appState.notify();
                          },
                style: buttonStyle,
                child: const Text("Create"))
          ],
        ));
  }
}
