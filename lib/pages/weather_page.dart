import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:minmal_weather_app/models/weather_model.dart';
import 'package:minmal_weather_app/service/weather_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:country_icons/country_icons.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  final _weatherService = WeatherService('5836cb55918ddca62514f92d06748267');
  Weather? _weather;
  bool _isLoading = false;
  String _errorMessage = '';
  final TextEditingController _cityController = TextEditingController();

  Future<void> _fetchWeather([String? cityName]) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final city = cityName ?? await _weatherService.getCurrentCity();
      final weather = await _weatherService.getWeather(city);
      setState(() {
        _weather = weather;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not fetch weather data. Please try again.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String getWeatherAnimation(String? mainCondition) {
    if (mainCondition == null) {
      return 'assets/sunny.json';
    }
    switch (mainCondition.toLowerCase()) {
      case 'clouds':
        return '/Users/akimaliev/VSProjects/minmal_weather_app/lib/assets/cloudy.json';
      case 'rain':
        return 'assets/rainy.json';
      case 'wind':
        return 'assets/windy.json';
      case 'haze':
        return '/Users/akimaliev/VSProjects/minmal_weather_app/lib/assets/fog.json';
      case 'snow':
        return '/Users/akimaliev/VSProjects/minmal_weather_app/lib/assets/snowy.json';
      case 'shower rain':
      case 'mist':
        return '/Users/akimaliev/VSProjects/minmal_weather_app/lib/assets/notmuchcloudy.json';
      case 'smoke':
        return '/Users/akimaliev/VSProjects/minmal_weather_app/lib/assets/fog.json';
      case 'fog':
        return '/Users/akimaliev/VSProjects/minmal_weather_app/lib/assets/notmuchcloudy.json';
      default:
        return '/Users/akimaliev/VSProjects/minmal_weather_app/lib/assets/sunny.json';
    }
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _cityController,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Enter city name',
                hintStyle: const TextStyle(color: Colors.grey),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                suffixIcon: _cityController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _cityController.clear();
                          setState(() {});
                        },
                      )
                    : null,
              ),
              onSubmitted: (value) => _fetchWeather(value),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: () => _fetchWeather(_cityController.text),
            child: const Text('Search', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherInfo() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Text(
          _errorMessage,
          style: const TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    if (_weather == null) {
      return const Center(
        child: Text('No weather data available. Please search for a city.'),
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.location_on,
          color: Colors.blueAccent,
          size: 50,
        ),
        Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    if (_weather?.countryCode != null)
      Image.network(
        'https://flagcdn.com/w320/${_weather!.countryCode.toLowerCase()}.png',
        width: 30,
        height: 30,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.flag, color: Colors.grey); // Fallback icon
        },
      ),
    const SizedBox(width: 8),
    Text(
      _weather?.cityName ?? "Loading city...",
      style: GoogleFonts.lato(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[800],
      ),
    ),
  ],
),

        Lottie.asset(getWeatherAnimation(_weather?.mainCondition), height: 150),
        Text(
          '${_weather?.temperature.round()}°C',
          style: GoogleFonts.lato(
            fontSize: 48.0,
            fontWeight: FontWeight.w700,
            color: Colors.blueAccent,
          ),
        ),
        Text(
          _weather?.mainCondition ?? "",
          style: GoogleFonts.lato(
            fontSize: 24.0,
            fontWeight: FontWeight.w400,
            color: Colors.grey[600],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildWeatherDetail('Humidity', '${_weather?.humidity ?? '--'}%'),
            const SizedBox(width: 16),
            _buildWeatherDetail('Wind', '${_weather?.windSpeed ?? '--'} km/h'),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherDetail(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.lato(
            fontSize: 18,
            color: Colors.blueGrey,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.lato(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[350],
      body: SafeArea(
        child: Column(
          children: [
            _buildSearchBar(),
            Expanded(child: _buildWeatherInfo()),
          ],
        ),
      ),
    );
  }
}
