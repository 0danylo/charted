import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:trend_notes/datum_dialog.dart';
import 'package:trend_notes/details_dialog.dart';
import 'package:trend_notes/util.dart';

enum GraphType {
  line,
  lineWithPoints,
  points,
  step;

  getNext(type) {
    if (type == line) {
      return lineWithPoints;
    } else if (type == lineWithPoints) {
      return points;
    } else if (type == points) {
      return step;
    } else {
      return line;
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

    var entries = getSortedEntries(widget.data);

    final card = Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
      child: Card(
        elevation: 10,
        color: theme.colorScheme.primary,
        child: Column(
          children: [
            getPadding(5),
            titleOf(widget.name),
            entries.isNotEmpty
                ? Container(
                    padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
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
                    icon: const Icon(Icons.add, color: white)),
                if (entries.isNotEmpty)
                  IconButton(
                      onPressed: () {
                        makeDetailsDialog();
                      },
                      icon: const Icon(Icons.data_array, color: white)),
                if (entries.isNotEmpty)
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.auto_graph, color: white))
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
        return DetailsDialog(parent: widget, data: widget.data);
      });
}
