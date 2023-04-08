import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../components/weather_item.dart';
import '../constants.dart';

class DetailPage extends StatefulWidget {
  final dailyForecastWeather;

  const DetailPage({Key? key, this.dailyForecastWeather}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final Constants _constants = Constants();
  ScrollController _controller = new ScrollController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var weatherData = widget.dailyForecastWeather;

    //function to get weather
    Map getForecastWeather(int index) {
      int maxWindSpeed = weatherData[index]["day"]["maxwind_kph"].toInt();
      int avgHumidity = weatherData[index]["day"]["avghumidity"].toInt();
      int chanceOfRain =
          weatherData[index]["day"]["daily_chance_of_rain"].toInt();

      var parsedDate = DateTime.parse(weatherData[index]["date"]);
      var forecastDate = DateFormat('EEEE, d MMMM').format(parsedDate);

      String weatherName = weatherData[index]["day"]["condition"]["text"];
      String weatherIcon =
          weatherName.replaceAll(' ', '').toLowerCase() + ".png";

      int minTemperature = weatherData[index]["day"]["mintemp_c"].toInt();
      int maxTemperature = weatherData[index]["day"]["maxtemp_c"].toInt();

      var forecastData = {
        'maxWindSpeed': maxWindSpeed,
        'avgHumidity': avgHumidity,
        'chanceOfRain': chanceOfRain,
        'forecastDate': forecastDate,
        'weatherName': weatherName,
        'weatherIcon': weatherIcon,
        'minTemperature': minTemperature,
        'maxTemperature': maxTemperature
      };
      return forecastData;
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: InkWell(
            onTap: () => Navigator.of(context).pop(),
            child: Icon(
              Icons.arrow_back,
              color: Colors.brown,
            ),
          ),
          title: const Text(
            '7 Days Forecasts',
            style: TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.white,
        ),
        body: Padding(
          padding: EdgeInsets.all(15),
          child: ListView.builder(
              itemCount: 7,
              itemBuilder: ((context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.red,
                        Colors.blue,
                      ],
                    ),
                  ),
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              getForecastWeather(index)["forecastDate"],
                              style: const TextStyle(
                                color: Colors.brown,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      getForecastWeather(
                                              index)["minTemperature"]
                                          .toString(),
                                      style: TextStyle(
                                        color: _constants.greyColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '°',
                                      style: TextStyle(
                                          color: _constants.greyColor,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          fontFeatures: const [
                                            FontFeature.enable('sups'),
                                          ]),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      getForecastWeather(
                                              index)["maxTemperature"]
                                          .toString(),
                                      style: TextStyle(
                                        color: _constants.blackColor,
                                        fontSize: 30,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      '°',
                                      style: TextStyle(
                                          color: _constants.blackColor,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600,
                                          fontFeatures: const [
                                            FontFeature.enable('sups'),
                                          ]),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/' +
                                      getForecastWeather(index)["weatherIcon"],
                                  width: 30,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  getForecastWeather(index)["weatherName"],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  getForecastWeather(index)["chanceOfRain"]
                                          .toString() +
                                      "%",
                                  style: const TextStyle(
                                    fontSize: 18,
                                    color: Colors.grey,
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Image.asset(
                                  'assets/lightrain.png',
                                  width: 30,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              })),
        ));
  }
}
