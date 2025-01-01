import 'package:flutter/material.dart';

class Weather {
  final String cityName;
  final String countryCode;
  final double temperature;
  final String mainCondition;
  final int humidity;
  final double windSpeed;

  Weather({
    required this.cityName,
    required this.countryCode,
    required this.temperature,
    required this.mainCondition,
    required this.humidity,
    required this.windSpeed,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      countryCode: json['sys']['country'], 
      temperature: json['main']['temp'].toDouble(),
      mainCondition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
    );
  }
}