import 'dart:convert';

import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:weather_app/Additional_info.dart';
import 'package:weather_app/HourlyForecast_info.dart';

class WhetherScreen extends StatefulWidget {
  const WhetherScreen({super.key});

  @override
  State<WhetherScreen> createState() => _WhetherScreenState();
}

class _WhetherScreenState extends State<WhetherScreen> {
  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=Pune&APPID=2001537174ef1c7b2764b5295748bbe6'),
      );
      final data = jsonDecode(res.body);
      if (data['cod'] != '200') {
        throw 'An unexpected error occured';
      }

      //temp = data['list'][0]['main']['temp'];
      return data;
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App'),
        titleTextStyle: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh_sharp),
          ),
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }
          final data = snapshot.data!;
          final listss = data['list'][0];
          final currentTemp = listss['main']['temp'];

          final currentSky = listss['weather'][0]['main'];
          final currentPressure = listss['main']['pressure'];
          final currentHumidity = listss['main']['humidity'];
          final currentWindSpeed = listss['wind']['speed'];

          return Padding(
            padding: const EdgeInsets.all(13.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //main card

                SizedBox(
                  width: double.infinity,
                  child: Card(
                    elevation: 10,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(
                          sigmaX: 10,
                          sigmaY: 10,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            children: [
                              const SizedBox(height: 25),
                              Text(
                                //C = K - 273.15.

                                '$currentTemp ° k',
                                style: const TextStyle(
                                  fontSize: 35,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Icon(
                                currentSky == 'Rain' || currentSky == 'Clouds'
                                    ? Icons.cloud
                                    : Icons.sunny,
                                size: 78,
                              ),
                              const SizedBox(height: 15),
                              Text(
                                '$currentSky',
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Weather Forecast',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                //Weather forecast card
                //SingleChildScrollView(
                // scrollDirection: Axis.horizontal,
                // child: Row(
                //   children: [
                //CARD 1
                // for (int i = 0; i < 5; i++)
                //   HourlyForecast(
                //     time: data['list'][i + 1]['dt'].toString(),
                //     value: data['list'][i + 1]['main']['temp'].toString(),
                //     icon: data['list'][i + 1]['weather'][0]['main'] ==
                //                 'Rain' ||
                //             data['list'][i + 1]['weather'][0]['main'] ==
                //                 'Clouds'
                //         ? Icons.cloud
                //         : Icons.sunny,
                //   ),
                //],
                // ),
                //),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                      itemCount: 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final hourlyForecast = data['list'][index + 1];
                        final hourlySky =
                            data['list'][index + 1]['weather'][0]['main'];
                        final hourlyTemp =
                            hourlyForecast['main']['temp'].toString();
                        final time =
                            DateTime.parse(hourlyForecast['dt_txt'].toString());
                        return HourlyForecast(
                            time: DateFormat.j().format(time),
                            value: hourlyTemp,
                            icon: hourlySky == 'Rain' || hourlySky == 'Clouds'
                                ? Icons.cloud
                                : Icons.sunny);
                      }),
                ),
                const SizedBox(height: 15),
                //Additional information card
                const Text(
                  'Additional Information',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    AdditionalInfoItem(
                      icon: Icons.water_drop,
                      label: 'Humidity',
                      value: currentHumidity.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.air,
                      label: 'Wind Speed',
                      value: currentWindSpeed.toString(),
                    ),
                    AdditionalInfoItem(
                      icon: Icons.beach_access,
                      label: 'Pressure',
                      value: currentPressure.toString(),
                    ),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
