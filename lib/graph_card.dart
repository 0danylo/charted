import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

enum GraphType {
  line,
  step,
  bar;

  getClass(type) {
    if (type == line) {
      return LineChart;
    } else if (type == step) {
      return LineChart;
    } else {
      return BarChart;
    }
  }
}

class GraphCard extends StatelessWidget {
  const GraphCard({
    super.key,
    required this.name,
    required this.type,
    required this.chartData,
  });

  final String name;
  final GraphType type;
  final Map<DateTime, double> chartData;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      elevation: 10,
      color: theme.colorScheme.secondary,
      child: Column(
        children: [
          const Padding(padding: EdgeInsets.all(20.0)),
          Text(chartData.toString(), style: style),
          LineChart(
            LineChartData(),
          ),
          Row(
            children: [
              ButtonBar(
                children: [
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.abc_outlined)),
                  IconButton(
                      onPressed: () {}, icon: const Icon(Icons.ac_unit_sharp))
                ],
              )
            ],
          )
        ],
      ),
    );
  }
}
