import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/config/config_color.dart';
import 'package:weather_api/model_view/temperatureStatistics.dart';
import 'package:weather_api/model_view/temperatureStatus.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  Widget build(BuildContext context) {
    DateTime date = DateTime.now();
    String todayDate = DateFormat('EEEE, d MMMM').format(date);

    return Scaffold(
      backgroundColor: ConfigColor.primary,
      appBar: AppBar(
        backgroundColor: ConfigColor.primary,
        title: const Text(
          'Paris',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: double.parse(todayDate.length.toString()) * 4.2,
                  vertical: 5),
              child: Container(
                height: 32,
                decoration: BoxDecoration(
                    color: ConfigColor.black,
                    borderRadius: BorderRadius.circular(20)),
                child: Center(
                    child: Text(
                  todayDate.toString(),
                  style: const TextStyle(
                    color: ConfigColor.primary,
                    fontWeight: FontWeight.w500,
                  ),
                )),
              ),
            ),
            const TemperatureStatus(),
            const SizedBox(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: TemperatureStatistics(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
