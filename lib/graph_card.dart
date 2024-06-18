import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:charted/datum_dialog.dart';
import 'package:charted/details_dialog.dart';
import 'package:charted/file_util.dart';
import 'package:charted/main.dart';
import 'package:charted/style_util.dart';

enum GraphType {
  line,
  lineWithPoints,
  points,
  step;

  static getNext(type) {
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
  final String name;
  final GraphType type;
  final Map<DateTime, double> data;

  const GraphCard({
    super.key,
    required this.name,
    required this.type,
    required this.data,
  });

  @override
  State<GraphCard> createState() => GraphCardState();
}

class GraphCardState extends State<GraphCard> {
  int tapCount = 0;
  DateTime? lastTapTime;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MainPageState>();
    final theme = Theme.of(context);

    var entries = getEntries();

    final card = Container(
      padding: const EdgeInsets.fromLTRB(
        10,
        10,
        10,
        0,
      ),
      child: Card(
        elevation: 10,
        color: theme.colorScheme.primary,
        child: Column(
          children: [
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
                        GraphType.step,
                      ].contains(widget.type)
                          ? white
                          : invisible,
                      width: 2,
                      marker: SparkChartMarker(
                          displayMode: SparkChartMarkerDisplayMode.all,
                          size: 8,
                          color: [
                            GraphType.lineWithPoints,
                            GraphType.points,
                          ].contains(widget.type)
                              ? darkColor
                              : invisible,
                          borderWidth: 1,
                          borderColor: [
                            GraphType.lineWithPoints,
                            GraphType.points,
                          ].contains(widget.type)
                              ? white
                              : invisible),
                      axisLineWidth:
                          widget.data.values.any((value) => value <= 0) &&
                                  widget.data.values.any((value) => value >= 0)
                              ? 2
                              : 0,
                      // trackball: widget.type != GraphType.step ? SparkChartTrackball(
                      //   borderColor: invisible,
                      //     tooltipFormatter: (details) =>
                      //         formatDouble(details.y!.toDouble()).toString(),
                      //         labelStyle: smallStyle,
                      //         color: darkColor
                      //         ) : null,
                    ),
                  )
                : errorOf('No data'),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    tapDelete(appState);
                  },
                  icon: const Icon(Icons.remove_circle_outline, color: red),
                ),
                const Spacer(),
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
                            GraphType.getNext(appState.types[widget.name]);
                        editType(widget.name, appState.types[widget.name]!);
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
        return DatumDialog(name: widget.name, data: widget.data);
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

  void tapDelete(appState) {
    final now = DateTime.now();
    if (lastTapTime == null ||
        now.difference(lastTapTime!) > const Duration(milliseconds: 500)) {
      tapCount = 0;
    }

    tapCount++;
    lastTapTime = now;

    if (tapCount == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Triple tap fast to delete'),
        ),
      );
    } else if (tapCount == 3) {
      eraseGraph(widget.name);

      appState.names.remove(widget.name);
      appState.data.remove(widget.name);
      appState.types.remove(widget.name);

      appState.notify();
    }
  }
}
