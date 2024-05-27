import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trend_notes/graph_card.dart';
import 'package:trend_notes/main.dart';
import 'package:trend_notes/style_util.dart';

class DetailsDialog extends StatefulWidget {
  const DetailsDialog({super.key, required this.parent, required this.data});

  final GraphCard parent;
  final Map<DateTime, double> data;

  @override
  State<StatefulWidget> createState() => DetailsDialogState();
}

class DetailsDialogState extends State<DetailsDialog> {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    var parent = widget.parent;
    var entries = getSortedEntries(widget.data);

    return AlertDialog(
      scrollable: true,
      backgroundColor: darkColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          titleOf(parent.name),
          for (var entry in entries)
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Column(children: [
                formatDate(entry.key),
                formatTime(
                    TimeOfDay(hour: entry.key.hour, minute: entry.key.minute))
              ]),
              largeStyled(formatDouble(entry.value)),
              IconButton(
                onPressed: () {
                  setState(() => widget.data.remove(entry.key));
                  appState.notify();
                },
                icon:
                    const Icon(Icons.remove_circle_outline, color: Colors.red),
              )
            ])
        ],
      ),
    );
  }
}
