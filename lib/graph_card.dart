import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:trend_notes/datum_dialog.dart';
import 'package:trend_notes/util.dart';

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
    final theme = Theme.of(context);

    var entries = getSortedEntries();

    final card = Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Card(
        elevation: 10,
        color: theme.colorScheme.primary,
        child: Column(
          children: [
            getPadding(5),
            Text(widget.name, style: titleStyle),
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
                      color: white,
                      marker: const SparkChartMarker(
                          displayMode: SparkChartMarkerDisplayMode.all,
                          size: 8.0,
                          color: darkColor,
                          borderWidth: 1,
                          borderColor: white),
                      axisLineColor:
                          widget.data.values.any((value) => value < 0) &&
                                  widget.data.values.any((value) => value > 0)
                              ? darkColor
                              : Colors.transparent,
                    ),
                  )
                : errorOf("No data"),
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
                if (entries.isNotEmpty)
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
          backgroundColor: darkColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var entry in entries)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                  Column(children: [
                    formatDate(entry.key),
                    formatTime(TimeOfDay(
                        hour: entry.key.hour, minute: entry.key.minute))
                  ]),
                  styled(formatDouble(entry.value)),
                  IconButton(
                    onPressed: () {
                      setState(() => widget.data.remove(entry.key));
                      Navigator.of(context).pop();
                      if (widget.data.isNotEmpty) {
                        makeDetailsDialog();
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline,
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
