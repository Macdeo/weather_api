import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GetData {
  String api =
      'https://api.open-meteo.com/v1/gfs?latitude=52.52&longitude=13.41&hourly=temperature_2m,relative_humidity_2m,visibility,wind_speed_10m';
  String dailyApi =
      'https://api.open-meteo.com/v1/gfs?latitude=52.52&longitude=13.41&current=temperature_2m,is_day&daily=temperature_2m_max,rain_sum,showers_sum,wind_speed_10m_max&timezone=auto';

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
          if (i % 24 == 13) {
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

    return ret;
  }

  Future<Map<String, List<String>>> getDailyData() async {
    http.Response response = await http.get(Uri.parse(dailyApi));

    Map<String, List<String>> ret = {};

    try {
      if (response.statusCode == 200) {
        String data = response.body;

        List<String> time = [];
        List<String> temp = [];
        List<String> rain = [];
        List<String> rainShower = [];


        var dailyTime = jsonDecode(data)['daily']['time'];
        List dailyTemp = jsonDecode(data)['daily']['temperature_2m_max'];
        List dailyRain = jsonDecode(data)['daily']['rain_sum'];
        List dailyRainShower = jsonDecode(data)['daily']['showers_sum'];



        for(int i = 0; i < dailyTemp.length; i++){

          DateTime dateTime = DateTime.parse(dailyTime[i]);
          String formattedDate = DateFormat('d MMM').format(dateTime);

          time.add(formattedDate);
          temp.add(dailyTemp[i].toString());
          rain.add(dailyRain[i].toString());
          rainShower.add(dailyRainShower[i].toString());
        }

        ret['time'] = time;
        ret['temp'] = temp;
        ret['rain'] = rain;
        ret['rainShower'] = rainShower;


      }
    } catch (e) {
      String message = 'Error fetching data because of: $e';
      print(message);
    }

    return ret;
  }
}
