import 'package:flutter/material.dart';
import 'package:weather_api/config/config_color.dart';
import 'package:weather_api/model/get_data.dart';

class TemperatureStatus extends StatefulWidget {
  const TemperatureStatus({super.key});

  @override
  State<TemperatureStatus> createState() => _TemperatureStatusState();
}

class _TemperatureStatusState extends State<TemperatureStatus> {
  late String currentTemp;
  late List<double> currentDataTemp;
  late List<double> totalHumidity;
  late List<double> totalVisibility;
  late List<double> totalWind;
  late double totalVisibilityKM;

  Future<Map<String, List<String>>> getCurrentWeather =
      GetData().getCurrentWeather();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, List<String>>>(
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
            } else if ((currentDataTemp[0] > 0) && (currentDataTemp[0] <= 10)) {
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
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: ConfigColor.black),
              ),
              // Temperature Degree
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.15,
                child: Text(
                  '${currentDataTemp[0].round().toString()}°',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: MediaQuery.sizeOf(context).height * 0.12,
                      color: ConfigColor.black),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.18,
                  width: MediaQuery.sizeOf(context).width * 0.85,
                  decoration: BoxDecoration(
                      color: ConfigColor.black,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Table(
                      children: [
                        const TableRow(children: <Widget>[
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                                child: Icon(
                              Icons.air_outlined,
                              color: ConfigColor.primary,
                              size: 50,
                            )),
                          ),
                          Center(
                              child: Icon(
                            Icons.water_drop_outlined,
                            color: ConfigColor.primary,
                            size: 50,
                          )),
                          Center(
                              child: Icon(
                            Icons.visibility_outlined,
                            color: ConfigColor.primary,
                            size: 50,
                          )),
                        ]),
                        TableRow(children: <Widget>[
                          Center(
                              child: Text(
                            '${totalWind[0].round().toString()}km/h',
                            style: const TextStyle(
                                color: ConfigColor.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                          Center(
                              child: Text(
                            '${totalHumidity[0].round().toString()}%',
                            style: const TextStyle(
                                color: ConfigColor.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                          Center(
                              child: Text(
                            '${totalVisibilityKM.toStringAsFixed(1).toString()}km',
                            style: const TextStyle(
                                color: ConfigColor.primary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                        ]),
                        const TableRow(children: <Widget>[
                          Center(
                              child: Text(
                            'Wind',
                            style: TextStyle(
                              color: ConfigColor.primary,
                            ),
                          )),
                          Center(
                              child: Text(
                            'Humidity',
                            style: TextStyle(
                              color: ConfigColor.primary,
                            ),
                          )),
                          Center(
                              child: Text(
                            'Visibility',
                            style: TextStyle(
                              color: ConfigColor.primary,
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
        });
  }
}
