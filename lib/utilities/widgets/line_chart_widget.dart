import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class LineChartWidget extends StatefulWidget {
  LineChartWidget({super.key, required this.yLabel, required this.data, required this.dates});
  String yLabel;
  List<int> data;
  List<DateTime> dates;

  @override
  State<LineChartWidget> createState() => LineChartWidgetState();
}

class LineChartWidgetState extends State<LineChartWidget> {
  List<ChartData> chartData = []; // List to store data points

  @override
  void initState() {
    super.initState();
  }

  void _generateChartData() {
    final formatter = DateFormat('dd-MM'); // Formatter for dates
    chartData = [];

    for (int i = 0; i < widget.data.length; i++) {
      final formattedDate = formatter.format(widget.dates[i]);
      chartData.add(ChartData(formattedDate, widget.data[i].toDouble()));
    }
  }

  @override
  Widget build(BuildContext context) {
    _generateChartData();

    return SfCartesianChart(
      primaryXAxis: const CategoryAxis(
        title: AxisTitle(text: 'Date'),
        isVisible: true,
      ),
      primaryYAxis: NumericAxis(
        title: AxisTitle(text: widget.yLabel),
        isVisible: true,
      ),
      series: <CartesianSeries<ChartData, String>>[
        LineSeries<ChartData, String>(
          dataSource: chartData,
          xValueMapper: (ChartData data, _) => data.date,
          yValueMapper: (ChartData data, _) => data.value,
          dataLabelSettings: const DataLabelSettings(isVisible: true),
        ),
      ],
    );
  }
}

class ChartData {
  final String date;
  final double value;

  const ChartData(this.date, this.value);
}
