import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:trend_notes/datum_dialog.dart';
import 'package:trend_notes/utils.dart';

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
  @override
  Widget build(BuildContext context) {
    var entries = getSortedEntries();

    final theme = Theme.of(context);

    final whiteStyle = theme.textTheme.displaySmall!.copyWith(
      color: Colors.white,
    );

    final card = Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Card(
        elevation: 10,
        color: theme.colorScheme.primary,
        child: Column(
          children: [
            const Padding(padding: EdgeInsets.all(5.0)),
            Text(widget.name, style: whiteStyle),
            entries.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.all(25.0),
                    child: SfSparkLineChart.custom(
                      dataCount: entries.length,
                      xValueMapper: (index) => widget.data.entries
                          .toList()[index]
                          .key
                          .millisecondsSinceEpoch,
                      yValueMapper: (index) =>
                          widget.data.entries.toList()[index].value,
                      color: lightColor,
                      marker: const SparkChartMarker(
                          displayMode: SparkChartMarkerDisplayMode.all,
                          size: 8.0,
                          color: white,
                          borderWidth: 1,
                          borderColor: lightColor),
                      axisLineColor:
                          widget.data.values.any((value) => value < 0) &&
                                  widget.data.values.any((value) => value > 0)
                              ? darkColor
                              : Colors.transparent,
                    ),
                  )
                : const Text("No data"),
            ButtonBar(
              children: [
                IconButton(
                    onPressed: () {
                      makeDatumDialog();
                    },
                    icon: const Icon(Icons.add, color: darkColor)),
                if (entries.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        makeDetailsDialog();
                      },
                      icon: const Icon(Icons.data_array, color: darkColor)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.bar_chart, color: darkColor))
              ],
            )
          ],
        ),
      ),
    );

    return card;
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
        var entries = getSortedEntries();

        return AlertDialog(
          content: Table(
            children: [
              for (var entry in entries)
                TableRow(children: [
                  Text(formatDate(entry.key) +
                      ' ' +
                      formatTime(TimeOfDay(
                          hour: entry.key.hour, minute: entry.key.minute))),
                  Text(entry.value.toString()),
                  TextButton(
                    onPressed: () {
                      setState(() => widget.data.remove(entry.key));
                      Navigator.of(context).pop();
                      if (widget.data.isNotEmpty) {
                        makeDetailsDialog();
                      }
                    },
                    child: const Icon(Icons.remove_circle_outline,
                        color: Colors.red),
                  )
                ])
            ],
          ),
        );
      });

  getSortedEntries() {
    var entries = widget.data.entries.toList();
    entries.sort((a, b) => a.key.compareTo(b.key));
    return entries;
  }
}
