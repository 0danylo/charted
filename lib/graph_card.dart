import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:trend_notes/datum_dialog.dart';

enum GraphType {
  line,
  step,
  bar;

  getClass(type) {
    if (type == line) {
      return;
    } else if (type == step) {
      return;
    } else {
      return;
    }
  }
}

class GraphCard extends StatefulWidget {
  const GraphCard({
    super.key,
    required this.name,
    required this.type,
    required this.data,
  });

  final String name;
  final GraphType type;
  final Map<DateTime, double> data;

  @override
  State<GraphCard> createState() => GraphCardState();
}

class GraphCardState extends State<GraphCard> {
  double min = 0.0, max = 0.0;

  @override
  Widget build(BuildContext context) {
    var entries = widget.data.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));

    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      elevation: 10,
      color: theme.colorScheme.secondary,
      child: Column(
        children: [
          // const Padding(padding: EdgeInsets.all(10.0)),
          Text(widget.name, style: titleStyle),
          widget.data.isNotEmpty
              ? SfSparkLineChart.custom(
                  dataCount: widget.data.length,
                  xValueMapper: (index) => widget.data.entries
                      .toList()[index]
                      .key
                      .millisecondsSinceEpoch,
                  yValueMapper: (index) =>
                      widget.data.entries.toList()[index].value,
                )
              : const Text("No data"),
          Row(
            children: [
              ButtonBar(
                children: [
                  IconButton(
                      onPressed: () {
                        makeDatumDialog();
                      },
                      icon: const Icon(Icons.add)),
                  if (entries.isNotEmpty)
                    IconButton(
                        onPressed: () {
                          makeDetailsDialog();
                        },
                        icon: const Icon(Icons.data_array))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  makeDatumDialog() => showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return DatumDialog(graphName: widget.name);
      });

  makeDetailsDialog() => showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Table(
            children: [
              for (var entry in widget.data.entries)
                TableRow(children: [
                  Text(entry.key.toString()),
                  Text(entry.value.toString()),
                  TextButton(
                    onPressed: () {
                      setState(() => widget.data.remove(entry.key));
                      Navigator.of(context).pop();
                      if (widget.data.isNotEmpty) {
                        makeDetailsDialog();
                      }
                    },
                    child: const Icon(Icons.remove_circle_outline, color: Color.fromARGB(255, 255, 0, 0)),
                  )
                ])
            ],
          ),
        );
      });
}
