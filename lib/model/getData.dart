import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GetData {
  String api =
      'https://api.open-meteo.com/v1/gfs?latitude=52.52&longitude=13.41&hourly=temperature_2m,relative_humidity_2m,visibility,wind_speed_10m';

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
          if (i % 24 == 11) {
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
      String message = 'Error fetching data because of: $e';
      print(message);
    }
    return ret;
  }

  Future<Map<String, List<String>>> getCurrentWeather() async {
    http.Response response = await http.get(Uri.parse(api));
    Map<String, List<String>> ret = {};

    DateTime dateTime = DateTime.now();
    String hour = DateFormat('H').format(dateTime);
    String day = DateFormat('d').format(dateTime);
    print(day);

    try {
      if (response.statusCode == 200) {
        String data = response.body;

        List<String> currentTime = [];
        List<String> currentTemp = [];
        List<String> totalHumidity = [];
        List<String> totalVisibility = [];
        List<String> totalWind = [];


        List currentDataTime = jsonDecode(data)['hourly']['time'];
        var currentDataTemp = jsonDecode(data)['hourly']['temperature_2m'];


        // Humidity / Wind / Visibility

        var humidity = jsonDecode(data)['hourly']['relative_humidity_2m'];
        var visibility = jsonDecode(data)['hourly']['visibility'];
        var wind = jsonDecode(data)['hourly']['wind_speed_10m'];

        print(currentDataTemp);

        print(currentDataTime[2].substring(8, 10));

        for (int i = 0; i < currentDataTemp.length; i++) {
          if ((hour == currentDataTime[i].substring(11, 13) &&
              (day == currentDataTime[i].substring(8, 10)))) {
            currentTime.add(currentDataTime[i]);
            currentTemp.add(currentDataTemp[i].toString());

            totalHumidity.add(humidity[i].toString());
            totalVisibility.add(visibility[i].toString());
            totalWind.add(wind[i].toString());
          }
        }

        ret['currentDataTime'] = currentTime;
        ret['currentDataTemp'] = currentTemp;
        ret['totalHumidity'] = totalHumidity;
        ret['totalVisibility'] = totalVisibility;
        ret['totalWind'] = totalWind;

      }
    } catch (e) {
      String message = 'Error fetching data because of: $e';
      print(message);
    }

    print(ret['currentDataTemp']);

    return ret;
  }

}
