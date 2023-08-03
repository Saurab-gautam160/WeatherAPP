import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wheather_app/Secreat.dart';
import 'package:wheather_app/additionalIfo.dart';
import 'package:wheather_app/whetherforcast.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // double temp = 0;
  // bool isLoading = false;

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentWeather();
  // }

  Future<Map<String, dynamic>> getCurrentWeather() async {
    try {
      // setState(() {
      //   isLoading = true;
      // });
      // String cityname = 'London';
      final res = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/forecast?q=London,uk&APPID=aaede2a4be8a650ebe4f7c245afb2ce1'),
      );

      final data = jsonDecode(res.body);

      if (data['cod'] != '200') {
        throw 'An uxcepted error occured ';
      }

      return data;
      // setState(() {
      //   isLoading = false;
      //   temp = data['list'][0]['main']['temp'];
      // });
    } catch (e) {
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {});
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: FutureBuilder(
        future: getCurrentWeather(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          final data = snapshot.data!;

          // final currenWeatherData = data['list'][0];

          final currentTemp = data['list'][0]['main']['temp'];

          final currentSky = data['list'][0]['weather'][0]['main'];

          final currentPressure = data['list'][0]['main']['pressure'];

          final currentWindSpeed = data['list'][0]['wind']['speed'];

          final currentHumidity = data['list'][0]['main']['humidity'];

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              '$currentTemp °K',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Icon(
                              currentSky == 'Clouds' || currentSky == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              currentSky,
                              style: const TextStyle(
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Weather Forcast',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (int i = 0; i < 5; i++)
                      Forcastcard(
                        Time: data['list'][i + 1]['dt'].toString(),
                        icon:
                            data['list'][i + 1]['weather'][0]['main'] == 'Rain'
                                ? Icons.cloud
                                : Icons.sunny,
                        Temp: data['list'][i + 1]['main']['temp'].toString(),
                      ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'Additional Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AdditionalInfoitem(
                    icon: Icons.water_drop,
                    label: 'Humadity',
                    value: currentHumidity.toString(),
                  ),
                  AdditionalInfoitem(
                    icon: Icons.air,
                    label: 'Wind Speed',
                    value: currentWindSpeed.toString(),
                  ),
                  AdditionalInfoitem(
                    icon: Icons.beach_access_rounded,
                    label: 'Pressure',
                    value: currentPressure.toString(),
                  ),
                ],
              )
            ]),
          );
        },
      ),
    );
  }
}
