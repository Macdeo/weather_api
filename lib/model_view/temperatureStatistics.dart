
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_api/bar_graph/individual_bar.dart';
import 'package:weather_api/config/config_color.dart';
import 'package:weather_api/model/getData.dart';

class TemperatureStatistics extends StatefulWidget {
  const TemperatureStatistics({super.key});

  @override
  State<TemperatureStatistics> createState() => _TemperatureStatisticsState();
}

class _TemperatureStatisticsState extends State<TemperatureStatistics> {

  Future<Map<String, List<String>>> getData = GetData().getData();

  late List<IndividualBar> chartData;


  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<String>>>(
      future: getData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> totalTime = snapshot.data!['totalTime']!;
          List<double> totalTemperature = snapshot
              .data!['totalTemperature']!
              .map<double>((temp) => double.parse(temp))
              .toList();

          chartData = [];
          for (int i = 0; i < totalTime.length; i++) {
            chartData.add(IndividualBar(
                ((totalTime[i])), totalTemperature[i]));
          }
          return Container(
            decoration: BoxDecoration(
                color: ConfigColor.black,
                borderRadius: BorderRadius.circular(10)),
            child: SfCartesianChart(
              // backgroundColor: ConfigColor.black,
                plotAreaBorderWidth: 0,
                title: const ChartTitle(
                    text: 'This Week Weather',
                    textStyle: TextStyle(
                        color: ConfigColor.primary,
                        fontWeight: FontWeight.bold)),
                enableAxisAnimation: true,
                primaryXAxis: const CategoryAxis(
                    axisLine: AxisLine(width: 0),
                    majorTickLines: MajorTickLines(width: 0),
                    majorGridLines: MajorGridLines(width: 0),
                    labelStyle: TextStyle(
                      // fontFamily: 'Roboto',
                        color: ConfigColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600),
                    labelRotation: 90),
                primaryYAxis: const NumericAxis(
                  rangePadding: ChartRangePadding.additional,
                  isVisible: false,
                  majorGridLines: MajorGridLines(width: 0),
                  edgeLabelPlacement: EdgeLabelPlacement.none,
                  labelFormat: '{value}℃',
                  labelStyle: TextStyle(color: ConfigColor.primary),
                ),
                series: <CartesianSeries>[
                  // Renders line chart
                  ColumnSeries<IndividualBar, String>(
                    // markerSettings:
                    //     const MarkerSettings(isVisible: true),
                    color: ConfigColor.primary,
                    dataSource: chartData,
                    xValueMapper: (IndividualBar sales, _) =>
                    sales.day,
                    yValueMapper: (IndividualBar sales, _) =>
                        sales.degree.round(),
                    dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                        // labelAlignment: ChartDataLabelAlignment.top,
                        textStyle:
                        TextStyle(color: ConfigColor.primary)),
                  )
                ]),
          );
        }
      },
    );
  }
}
