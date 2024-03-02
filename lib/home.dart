import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_api/config/config_color.dart';
import 'package:weather_api/model_view/temperature_statistics.dart';
import 'package:weather_api/model_view/temperature_status.dart';
import 'package:weather_api/model_view/weekly_forecast.dart';

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
        child: ListView(
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                title: const Text(
                  'Weekly forecast',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 17, color: ConfigColor.black),
                ),
                trailing: Image.asset(
                  'assets/icons/right_arrow_50.png',
                  height: 45,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                  top: 0.0, bottom: 25, left: 30, right: 30),
              child: SizedBox(
                height: 98,
                child: WeeklyForecast(),
              ),
            ),
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
