import 'package:flutter/material.dart';
import 'package:weather_api/config/config_color.dart';
import 'package:weather_api/model/get_data.dart';

class WeeklyForecast extends StatelessWidget {
  const WeeklyForecast({super.key});

  @override
  Widget build(BuildContext context) {
    Future<Map<String, List<String>>> getData = GetData().getDailyData();

    return FutureBuilder(
      future: getData,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> time = snapshot.data!['time']!;
          List<double> temp = snapshot.data!['temp']!
              .map<double>((temp) => double.parse(temp))
              .toList();
          List<double> rain = snapshot.data!['rain']!
              .map<double>((rain) => double.parse(rain))
              .toList();
          List<double> rainShower = snapshot.data!['rainShower']!
              .map<double>((rainShower) => double.parse(rainShower))
              .toList();

          return SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                time.length,
                (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Container(
                    width: 65,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(width: 2, color: ConfigColor.black),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '${temp[index].round()}°',
                          style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: ConfigColor.black),
                        ),
                        const SizedBox(height: 5),
                        if (rain[index] > rainShower[index]) ...[
                          const Icon(Icons.bolt,
                              size: 22, color: ConfigColor.black)
                        ] else if (rainShower[index] > rain[index]) ...[
                          const Icon(Icons.water_drop,
                              size: 22, color: ConfigColor.black)
                        ] else ...[
                          const Icon(Icons.sunny,
                              size: 22, color: ConfigColor.black)
                        ],
                        const SizedBox(height: 5),
                        Text(
                          time[index],
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: ConfigColor.black),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
