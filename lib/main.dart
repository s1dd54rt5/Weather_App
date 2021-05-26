import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Weather App",
      home: Home(),
    ));

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> {
  FaIcon cusIcon = FaIcon(FontAwesomeIcons.search);
  Widget cusSearchBar = Container(
    padding: EdgeInsets.only(left: 100),
    child: Text(
      "Weather App",
      style: TextStyle(
        fontSize: 28,
        fontFamily: "SF Pro Display",
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  String location = "Vellore";
  var temp;
  var description;
  var currently;
  var humidity;
  var windspeed;

  Future getWeather() async {
    http.Response response = await http.get(
        'https://api.openweathermap.org/data/2.5/weather?q=${location}&units=metric&appid=01c3966469b8a7d87352aed9bbf50289');
    var results = jsonDecode(response.body);
    setState(() {
      this.temp = results['main']['temp'];
      this.description = results['weather'][0]['description'];
      this.currently = results['weather'][0]['main'];
      this.humidity = results['main']['humidity'];
      this.windspeed = results['wind']['speed'];
    });
  }

  @override
  void initState() {
    super.initState();
    this.getWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 5,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFF924EFF),
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 35,
                ),
                Container(
                  child: Row(
                    children: [
                      cusSearchBar,
                      Container(
                        child: IconButton(
                            icon: cusIcon,
                            color: Colors.white,
                            onPressed: () {
                              setState(() {
                                if (this.cusIcon.icon ==
                                    FontAwesomeIcons.search) {
                                  this.cusIcon =
                                      FaIcon(FontAwesomeIcons.backspace);
                                  this.cusSearchBar = Container(
                                    padding: EdgeInsets.only(left: 50),
                                    width: 300,
                                    child: TextField(
                                      onSubmitted: (text) {
                                        this.location = text;
                                        this.getWeather();
                                      },
                                      textInputAction: TextInputAction.go,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                      ),
                                    ),
                                  );
                                } else {
                                  this.cusIcon =
                                      FaIcon(FontAwesomeIcons.search);
                                  this.cusSearchBar = Container(
                                    padding: EdgeInsets.only(left: 100),
                                    child: Text(
                                      "Weather App",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontFamily: "SF Pro Display",
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  );
                                }
                              });
                            }),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  child: Text(
                    location,
                    style: TextStyle(
                      fontSize: 22,
                      fontFamily: "SF Pro Display",
                      color: Colors.white,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    temp != null ? temp.toString() + "\u00B0" : "Loading",
                    style: TextStyle(
                      fontSize: 28,
                      fontFamily: "SF Pro Display",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Container(
                  child: Text(
                    currently != null ? currently.toString() : "Loading",
                    style: TextStyle(
                      fontSize: 18,
                      fontFamily: "SF Pro Display",
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: ListView(
                children: [
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                    title: Text("Temperature"),
                    trailing: Text(
                      temp != null ? temp.toString() + "\u00B0" : "Loading",
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.cloud),
                    title: Text("Weather"),
                    trailing: Text(
                      description != null ? description.toString() : "Loading",
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.sun),
                    title: Text("Humidity"),
                    trailing: Text(
                      humidity != null ? humidity.toString() : "Loading",
                    ),
                  ),
                  ListTile(
                    leading: FaIcon(FontAwesomeIcons.wind),
                    title: Text("Wind Speed"),
                    trailing: Text(
                      windspeed != null ? windspeed.toString() : "Loading",
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
