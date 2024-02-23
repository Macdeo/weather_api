import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/bar_graph/individual_bar.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:weather_api/model/getData.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late List<IndividualBar> chartData;
  late String currentTemp;
  late List<double> currentDataTemp;

  String api =
      'https://api.open-meteo.com/v1/forecast?latitude=49.4295&longitude=1.0791&hourly=temperature_2m';

  Future<Map<String, List<String>>> getData = GetData().getData();

  Future<Map<String, List<String>>> getCurrentWeather =
      GetData().getCurrentWeather();

  // String temperature = GetData().temperature();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String todayDate = DateFormat('EEEE, d MMMM').format(date);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade50,
        title: const Text('Weather App'),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.3,
                  vertical: 20),
              child: Container(
                height: 25,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  todayDate.toString(),
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                )),
              ),
            ),
            SizedBox(
              child: FutureBuilder<Map<String, List<String>>>(
                  future: getCurrentWeather,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else {
                      currentDataTemp = snapshot.data!['currentDataTemp']!
                          .map<double>((temp) => double.parse(temp))
                          .toList();

                      if ((currentDataTemp[0] <= 0)) {
                        currentTemp = 'Freezing 🧊';
                      } else if ((currentDataTemp[0] > 0) &&
                          (currentDataTemp[0] <= 10)) {
                        currentTemp = 'Cold ❄️';
                      } else if ((currentDataTemp[0] > 10) &&
                          (currentDataTemp[0] <= 20)) {
                        currentTemp = 'Warm 🌤️';
                      } else if ((currentDataTemp[0] > 20) &&
                          (currentDataTemp[0] <= 40)) {
                        currentTemp = 'Sunny ☀️';
                      } else {
                        currentTemp = 'Extremely Hot 🥵';
                      }
                    }
                    return Column(
                      children: [
                        Text(
                          currentTemp,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(
                          '${currentDataTemp[0].toString().substring(0, 1)}°',
                          style: const TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.bold,
                              fontSize: 100),
                        )
                      ],
                    );
                  }),
            ),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.35,
              child: FutureBuilder<Map<String, List<String>>>(
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
                          axisLine: AxisLine(width: 0),
                        ),
                        series: <CartesianSeries>[
                          // Renders line chart
                          LineSeries<IndividualBar, String>(
                            markerSettings:
                                const MarkerSettings(isVisible: true),
                            color: const Color(0xFF06baab),
                            dataSource: chartData,
                            xValueMapper: (IndividualBar sales, _) => sales.day,
                            yValueMapper: (IndividualBar sales, _) =>
                                sales.degree,
                            dataLabelSettings:
                                const DataLabelSettings(isVisible: true),
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
