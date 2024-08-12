import 'package:flutter/material.dart';
import 'package:agoy_weather/screens/home_screen.dart';

void main() {
  runApp(AgoyWeatherApp());
}

class AgoyWeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agoy Weather',
      theme: ThemeData(
  primarySwatch: Colors.blue,
  colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.orange),
  visualDensity: VisualDensity.adaptivePlatformDensity,
),
      home: HomeScreen(),
    );
  }
}
