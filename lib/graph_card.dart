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
  GraphCard({
    required this.name,
    required this.type,
    required this.data,
  });

  final String name;
  final GraphType type;
  final Map<DateTime, double> data;

  double min = 0.0, max = 0.0;

  @override
  Widget build(BuildContext context) {
    prepare();

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
          Text(name, style: style),
          data.isNotEmpty
              ? LineChart(
                  getLineChartData(data),
                )
              : const Text("No data"),
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

  prepare() {
    if (data.isEmpty) return;
    
    data.entries.toList().sort((a, b) => a.key.compareTo(b.key));

    min = max = data.values.toList()[0];
    for (var value in data.values) {
      if (value < min) {
        min = value;
      }
      if (value > max) {
        max = value;
      }
    }
  }

  getLineChartData(data) {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: const FlGridData(
        show: false,
      ),
      titlesData: FlTitlesData(
        show: true,
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: false,
          ),
        ),
      ],
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    return Text(
      value.toString(),
      textAlign: TextAlign.left,
    );
  }
}
