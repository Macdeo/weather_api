import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:weather_api/bar_graph/individual_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<IndividualBar> chartData;

  String api =
      'https://api.open-meteo.com/v1/forecast?latitude=49.4295&longitude=1.0791&hourly=temperature_2m';

  Future<Map<String, List<String>>> getData() async {
    http.Response response = await http.get(Uri.parse(api));
    Map<String, List<String>> ret = {};

    try {
      if (response.statusCode == 200) {
        String data = response.body;

        var temperature = jsonDecode(data)['hourly']['temperature_2m'];
        List time = jsonDecode(data)['hourly']['time'];

        List<String> totalTime = [];
        List<String> totalTemperature = [];

        for (int i = 0; i < time.length; i++) {
          if (i % 24 == 0) {
            DateTime dateTime = DateTime.parse(time[i]);
            // String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);
            // String formattedDate = DateFormat('dd').format(dateTime);
            String formattedDate = DateFormat('E').format(dateTime);

            totalTime.add(formattedDate);
            totalTemperature.add(temperature[i].toString());
          }
        }

        ret['totalTime'] = totalTime;
        ret['totalTemperature'] = totalTemperature;
      } else {
        print(response.statusCode);
      }
    } catch (e) {
      String message = 'Error fecthing data because of: $e';
      print(message);
    }
    return ret;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.35,
              child: FutureBuilder<Map<String, List<String>>>(
                future: getData(),
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
                      chartData.add(
                          IndividualBar(((totalTime[i])), totalTemperature[i]));
                    }

                    return SfCartesianChart(
                        title: const ChartTitle(text: 'This Week Weather'),
                        // primaryXAxis: DateTimeAxis(),
                        enableAxisAnimation: true,
                        primaryXAxis: const CategoryAxis(
                            labelStyle: TextStyle(
                                // fontFamily: 'Roboto',
                                fontSize: 14,
                                fontWeight: FontWeight.w600),
                            labelRotation: 90),
                        primaryYAxis: const NumericAxis(
                          edgeLabelPlacement: EdgeLabelPlacement.none,
                          labelFormat: '{value}℃',
                          axisLine: AxisLine( width: 0),
                        ),
                        series: <CartesianSeries>[
                          // Renders line chart
                          LineSeries<IndividualBar, String>(
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            color: Colors.blue[200],
                            dataSource: chartData,
                            xValueMapper: (IndividualBar sales, _) => sales.day,
                            yValueMapper: (IndividualBar sales, _) =>
                                sales.degree,
                            dataLabelSettings:
                                DataLabelSettings(isVisible: true),
                          )
                        ]);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
