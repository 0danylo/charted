import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:trend_notes/datum_dialog.dart';
import 'package:trend_notes/details_dialog.dart';
import 'package:trend_notes/main.dart';
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
    var appState = context.watch<AppState>();
    final theme = Theme.of(context);

    var entries = getEntries();

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
                      xValueMapper: (index) =>
                          getEntries()[index].key.millisecondsSinceEpoch,
                      yValueMapper: (index) => getEntries()[index].value,
                      color: [
                        GraphType.line,
                        GraphType.lineWithPoints,
                        GraphType.step
                      ].contains(widget.type)
                          ? white
                          : invisible,
                      width: 2,
                      marker: SparkChartMarker(
                          displayMode: SparkChartMarkerDisplayMode.all,
                          size: 8,
                          color: [GraphType.lineWithPoints, GraphType.points]
                                  .contains(widget.type)
                              ? darkColor
                              : invisible,
                          borderWidth: 1,
                          borderColor: [
                            GraphType.lineWithPoints,
                            GraphType.points
                          ].contains(widget.type)
                              ? white
                              : invisible),
                      axisLineWidth:
                          widget.data.values.any((value) => value <= 0) &&
                                  widget.data.values.any((value) => value >= 0)
                              ? 2
                              : 0,
                    ),
                  )
                : errorOf('No data'),
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
                      onPressed: () {
                        appState.types[widget.name] =
                            GraphType.line.getNext(appState.types[widget.name]);
                        appState.notify();
                      },
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
        return DatumDialog(name: widget.name);
      });

  makeDetailsDialog() => showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return DetailsDialog(parent: widget, data: widget.data);
      });

  getEntries() {
    var entriesFunction =
        widget.type == GraphType.step ? getStepEntries : getSortedEntries;
    return entriesFunction(widget.data);
  }
}
