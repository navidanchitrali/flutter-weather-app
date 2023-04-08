import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../components/weather_item.dart';
import '../constants.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _cityController = TextEditingController();
  final Constants _constants = Constants();

  static String API_KEY = '0ed64696bf0f44c58b4111811230504';

  String location = 'Chitral';
  String weatherIcon = 'heavycloudy.png';
  int temperature = 0;
  int windSpeed = 0;
  int humidity = 0;
  int cloud = 0;
  String currentDate = '';

  List hourlyWeatherForecast = [];
  List dailyWeatherForecast = [];

  String currentWeatherStatus = '';

  //API Call
  String searchWeatherAPI = "https://api.weatherapi.com/v1/forecast.json?key=" +
      API_KEY +
      "&days=7&q=";

  void fetchWeatherData(String searchText) async {
    try {
      var searchResult =
          await http.get(Uri.parse(searchWeatherAPI + searchText));

      final weatherData = Map<String, dynamic>.from(
          json.decode(searchResult.body) ?? 'No data');

      var locationData = weatherData["location"];

      var currentWeather = weatherData["current"];

      setState(() {
        location = getShortLocationName(locationData["name"]);

        var parsedDate =
            DateTime.parse(locationData["localtime"].substring(0, 10));
        var newDate = DateFormat('MMMMEEEEd').format(parsedDate);
        currentDate = newDate;

        //updateWeather
        currentWeatherStatus = currentWeather["condition"]["text"];
        weatherIcon =
            currentWeatherStatus.replaceAll(' ', '').toLowerCase() + ".png";
        temperature = currentWeather["temp_c"].toInt();
        windSpeed = currentWeather["wind_kph"].toInt();
        humidity = currentWeather["humidity"].toInt();
        cloud = currentWeather["cloud"].toInt();

        //Forecast data
        dailyWeatherForecast = weatherData["forecast"]["forecastday"];
        hourlyWeatherForecast = dailyWeatherForecast[0]["hour"];
        print(dailyWeatherForecast);
      });
    } catch (e) {
      //debugPrint(e);
    }
  }

  //function to return the first two names of the string location
  static String getShortLocationName(String s) {
    List<String> wordList = s.split(" ");

    if (wordList.isNotEmpty) {
      if (wordList.length > 1) {
        return wordList[0] + " " + wordList[1];
      } else {
        return wordList[0];
      }
    } else {
      return " ";
    }
  }

  @override
  void initState() {
    fetchWeatherData(location);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: SystemUiOverlay.values);

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: size.width,
        height: size.height,
        padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
        color: _constants.primaryColor.withOpacity(.1),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 20, right: 10),
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        Colors.blue,
                        Colors.white,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  onChanged: (searchText) {
                    fetchWeatherData(searchText);
                  },
                  controller: _cityController,
                  autofocus: true,
                  decoration: InputDecoration(
                      suffixIcon: GestureDetector(
                        onTap: () => _cityController.clear(),
                        child: const Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                      hintText: 'Search city e.g. Islamabad',
                      border: InputBorder.none),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                height: 390,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blue,
                      Colors.red,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: _constants.primaryColor.withOpacity(.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 2,
                        ),
                        Text(
                          location,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          width: 100,
                        ),
                        Text(
                          currentDate,
                          style: const TextStyle(
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 100,
                      child: Image.asset("assets/" + weatherIcon),
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            temperature.toString(),
                            style: const TextStyle(
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const Text(
                          'o',
                          style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      currentWeatherStatus,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Divider(
                        color: Colors.white70,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          WeatherItem(
                            value: windSpeed.toInt(),
                            unit: 'km/h',
                            imageUrl: 'assets/windspeed.png',
                          ),
                          WeatherItem(
                            value: humidity.toInt(),
                            unit: '%',
                            imageUrl: 'assets/humidity.png',
                          ),
                          WeatherItem(
                            value: cloud.toInt(),
                            unit: '%',
                            imageUrl: 'assets/cloud.png',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    const Text(
                      '   Today',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    SizedBox(
                      height: 110,
                      child: ListView.builder(
                        itemCount: hourlyWeatherForecast.length,
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          String currentTime =
                              DateFormat('HH:mm:ss').format(DateTime.now());
                          String currentHour = currentTime.substring(0, 2);

                          String forecastTime = hourlyWeatherForecast[index]
                                  ["time"]
                              .substring(11, 16);
                          String forecastHour = hourlyWeatherForecast[index]
                                  ["time"]
                              .substring(11, 13);

                          String forecastWeatherName =
                              hourlyWeatherForecast[index]["condition"]["text"];
                          String forecastWeatherIcon =
                              "${forecastWeatherName.replaceAll(' ', '').toLowerCase()}.png";

                          String forecastTemperature =
                              hourlyWeatherForecast[index]["temp_c"]
                                  .round()
                                  .toString();
                          return Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            margin: const EdgeInsets.only(right: 20),
                            width: 65,
                            decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  begin: Alignment.topRight,
                                  end: Alignment.bottomLeft,
                                  colors: [
                                    Colors.blue,
                                    Colors.white,
                                  ],
                                ),
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 1),
                                    blurRadius: 5,
                                    color:
                                        _constants.primaryColor.withOpacity(.2),
                                  ),
                                ]),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  forecastTime,
                                  style: const TextStyle(
                                    fontSize: 17,
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Image.asset(
                                  'assets/' + forecastWeatherIcon,
                                  width: 20,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      forecastTemperature,
                                      style: const TextStyle(
                                        color: Colors.brown,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Text(
                                      '°',
                                      style: TextStyle(
                                        color: Colors.brown,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                        fontFeatures: [
                                          FontFeature.enable('sups'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DetailPage(
                                        dailyForecastWeather:
                                            dailyWeatherForecast,
                                      ))), //this will open forecast screen
                          child: const Text(
                            'Next 7 days',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                          child: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
