import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = 'sk-live-y6nHpxNftkmANRvavSBQXBUJWRbsDILb0DCSAUMN';
  final String baseUrl = 'https://weather.indianapi.in/global/current';

  Future<Map<String, dynamic>> fetchWeather(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?location=$location'),
        headers: {
          'x-api-key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load weather data');
      }
    } catch (e) {
      throw Exception('Failed to connect to weather service');
    }
  }
}
