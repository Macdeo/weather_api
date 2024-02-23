import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class GetData {
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

        List currentDataTime = jsonDecode(data)['hourly']['time'];
        var currentDataTemp = jsonDecode(data)['hourly']['temperature_2m'];
        print(currentDataTemp);

        print(currentDataTime[2].substring(8, 10));

        for (int i = 0; i < currentDataTemp.length; i++) {
          if ((hour == currentDataTime[i].substring(11, 13) &&
              (day == currentDataTime[i].substring(8, 10)))) {
            currentTime.add(currentDataTime[i]);
            currentTemp.add(currentDataTemp[i].toString());
          }
        }

        ret['currentDataTime'] = currentTime;
        ret['currentDataTemp'] = currentTemp;
      }
    } catch (e) {
      String message = 'Error fetching data because of: $e';
      print(message);
    }

    print(ret['currentDataTemp']);

    return ret;
  }

}
