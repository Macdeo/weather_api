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
  late List<double> totalHumidity;
  late List<double> totalVisibility;
  late List<double> totalWind;
  late double totalVisibilityKM;

  String api =
      'https://api.open-meteo.com/v1/gfs?latitude=52.52&longitude=13.41&hourly=temperature_2m,relative_humidity_2m,visibility,wind_speed_10m';

  Future<Map<String, List<String>>> getData = GetData().getData();

  Future<Map<String, List<String>>> getCurrentWeather =
      GetData().getCurrentWeather();

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String todayDate = DateFormat('EEEE, d MMMM').format(date);

    return Scaffold(
      backgroundColor: const Color(0xFFfae143),
      appBar: AppBar(
        backgroundColor: const Color(0xFFfae143),
        title: const Text('Paris', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.sizeOf(context).width * 0.28,
                  vertical: 5),
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  todayDate.toString(),
                  style: const TextStyle(
                    color: Color(0xFFfae143),
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            ),
            FutureBuilder<Map<String, List<String>>>(
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

                    totalHumidity = snapshot.data!['totalHumidity']!
                        .map<double>((temp) => double.parse(temp))
                        .toList();

                    totalVisibility = snapshot.data!['totalVisibility']!
                        .map<double>((temp) => double.parse(temp))
                        .toList();

                    totalWind = snapshot.data!['totalWind']!
                        .map<double>((temp) => double.parse(temp))
                        .toList();

                    totalVisibilityKM = (totalVisibility[0] / 1000);

                    if ((currentDataTemp[0] <= 0)) {
                      currentTemp = 'Freezing';
                    } else if ((currentDataTemp[0] > 0) &&
                        (currentDataTemp[0] <= 10)) {
                      currentTemp = 'Cold';
                    } else if ((currentDataTemp[0] > 10) &&
                        (currentDataTemp[0] <= 20)) {
                      currentTemp = 'Warm️';
                    } else if ((currentDataTemp[0] > 20) &&
                        (currentDataTemp[0] <= 40)) {
                      currentTemp = 'Sunny';
                    } else {
                      currentTemp = 'Extremely Hot';
                    }
                  }
                  return Column(
                    children: [
                      Text(
                        currentTemp,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 22),
                      ),
                      // Temperature Degree
                      SizedBox(
                        height: MediaQuery.sizeOf(context).height * 0.18,
                        child: Text(
                          '${currentDataTemp[0].toString().substring(0, 1)}°',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: MediaQuery.sizeOf(context).height * 0.15),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(bottom: 15.0),
                        child: Container(
                          height: MediaQuery.sizeOf(context).height * 0.18,
                          width: MediaQuery.sizeOf(context).width * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10)),
                          child: Center(
                            child: Table(
                              children: [
                                const TableRow(children: <Widget>[
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 8.0),
                                    child: Center(
                                        child: Icon(
                                      Icons.air_outlined,
                                      color: Color(0xFFfae143),
                                      size: 50,
                                    )),
                                  ),
                                  Center(
                                      child: Icon(
                                    Icons.water_drop_outlined,
                                    color: Color(0xFFfae143),
                                    size: 50,
                                  )),
                                  Center(
                                      child: Icon(
                                    Icons.visibility_outlined,
                                    color: Color(0xFFfae143),
                                    size: 50,
                                  )),
                                ]),
                                TableRow(children: <Widget>[
                                  Center(
                                      child: Text(
                                    '${totalWind[0].round().toString()}km/h',
                                    style: const TextStyle(
                                        color: Color(0xFFfae143),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Center(
                                      child: Text(
                                    '${totalHumidity[0].round().toString()}%',
                                    style: const TextStyle(
                                        color: Color(0xFFfae143),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                  Center(
                                      child: Text(
                                    '${totalVisibilityKM.toStringAsFixed(1).toString()}km',
                                    style: const TextStyle(
                                        color: Color(0xFFfae143),
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  )),
                                ]),
                                const TableRow(children: <Widget>[
                                  Center(
                                      child: Text(
                                    'Wind',
                                    style: TextStyle(
                                      color: Color(0xFFfae143),
                                    ),
                                  )),
                                  Center(
                                      child: Text(
                                    'Humidity',
                                    style: TextStyle(
                                      color: Color(0xFFfae143),
                                    ),
                                  )),
                                  Center(
                                      child: Text(
                                    'Visibility',
                                    style: TextStyle(
                                      color: Color(0xFFfae143),
                                    ),
                                  )),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
            SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.35,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
                        chartData.add(IndividualBar(
                            ((totalTime[i])), totalTemperature[i]));
                      }
                      return Container(
                        decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10)),
                        child: SfCartesianChart(
                            // backgroundColor: Colors.black,
                            plotAreaBorderWidth:0,
                            title: const ChartTitle(
                                text: 'This Week Weather',
                                textStyle: TextStyle(
                                  color: Color(0xFFfae143),
                                  fontWeight: FontWeight.bold
                                )),
                            enableAxisAnimation: true,
                            primaryXAxis: const CategoryAxis(
                              axisLine: AxisLine(width: 0),
                                majorTickLines: MajorTickLines(width: 0),
                                majorGridLines: MajorGridLines(width: 0),
                                labelStyle: TextStyle(
                                    // fontFamily: 'Roboto',
                                    color: Color(0xFFfae143),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                                labelRotation: 90),
                            primaryYAxis: const NumericAxis(
                              isVisible: false,
                              majorGridLines: MajorGridLines(width: 0),
                              edgeLabelPlacement: EdgeLabelPlacement.none,
                              labelFormat: '{value}℃',
                              labelStyle: TextStyle(color: Color(0xFFfae143)),
                            ),
                            series: <CartesianSeries>[
                              // Renders line chart
                              ColumnSeries<IndividualBar, String>(
                                // markerSettings:
                                //     const MarkerSettings(isVisible: true),
                                color: const Color(0xFFfae143),
                                dataSource: chartData,
                                xValueMapper: (IndividualBar sales, _) =>
                                    sales.day,
                                yValueMapper: (IndividualBar sales, _) =>
                                    sales.degree.round(),
                                dataLabelSettings: const DataLabelSettings(
                                    isVisible: true,
                                    textStyle:
                                        TextStyle(color: Color(0xFFfae143))),
                              )
                            ]),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
