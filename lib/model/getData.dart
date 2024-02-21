
import 'dart:convert';

import 'package:http/http.dart'as http;
import 'package:intl/intl.dart';

class GetData{
  String api =
      'https://api.open-meteo.com/v1/forecast?latitude=49.4295&longitude=1.0791&hourly=temperature_2m';

  Future<Map<String, List<String>>> getData() async {
    http.Response response = await http.get(Uri.parse(api));
    Map<String, List<String>> ret = {};

    try {

      // Check if the Status code is correct

      if (response.statusCode == 200) {
        String data = response.body;

        var temperature = jsonDecode(data)['hourly']['temperature_2m'];
        List time = jsonDecode(data)['hourly']['time'];

        List<String> totalTime = [];
        List<String> totalTemperature = [];

        for (int i = 0; i < time.length; i++) {
          if (i % 24 == 0) {
            print(time[i]);
            print({temperature[i]});

            DateTime dateTime = DateTime.parse(time[i]);
            String formattedDate = DateFormat('yyyy-MM-dd').format(dateTime);

            totalTime.add(formattedDate);
            totalTemperature.add(temperature[i].toString());
          }
        }

        print(totalTime);
        print(totalTemperature);

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
}