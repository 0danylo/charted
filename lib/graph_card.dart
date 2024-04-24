import 'package:flutter/material.dart';
import 'package:trend_notes/datum_dialog.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

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
  GraphCard({
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
    prepare();
    var keys = widget.data.keys.toList();

    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    print(widget.data);
    return Card(
      elevation: 10,
      color: theme.colorScheme.secondary,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20.0)),
          Text(widget.name, style: style),
          widget.data.isNotEmpty
              ? LineSeries(
                  xValueMapper: (t, index) =>
                      widget.data.keys.toList()[index].millisecondsSinceEpoch,
                  yValueMapper: (t, index) => widget.data.values.toList()[index],
                )
              : const Text("No data"),
          Row(
            children: [
              ButtonBar(
                children: [
                  IconButton(
                      onPressed: () {
                        makeDatumDialog(context, widget.name);
                      },
                      icon: const Icon(Icons.add)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.data_array))
                ],
              )
            ],
          )
        ],
      ),
    );
  }

  prepare() {
    if (widget.data.isEmpty) return;

    widget.data.entries.toList().sort((a, b) => a.key.compareTo(b.key));

    min = max = widget.data.values.toList()[0];
    for (var value in widget.data.values) {
      if (value < min) {
        min = value;
      }
      if (value > max) {
        max = value;
      }
    }
  }

  makeDatumDialog(context, graphName) => showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return DatumDialog(graphName: graphName);
      });
}
