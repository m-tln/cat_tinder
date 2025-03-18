import 'dart:convert';
import '../models/cat.dart'; // Импортируйте класс Cat
import 'package:http/http.dart' as http;

class ApiService {
  static const String _apiKey = 'live_JbuH8dvofieAnngzk6sej35EExSxX2WPkOt4oBwq0Qeo9IeKYHDsxJnoXaECdUXJ'; // Замените на ваш API-ключ
  static const String _baseUrl = 'https://api.thecatapi.com/v1';

  static Future<Cat?> fetchCat() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/search?has_breeds=true'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)[0];
      return Cat(
        imageUrl: data['url'],
        breedName: data['breeds'][0]['name'],
        breedDescription: data['breeds'][0]['description'],
        breedTemperament: data['breeds'][0]['temperament'],
        breedOrigin: data['breeds'][0]['origin'],
      );
    } else {
      throw Exception('Failed to load cat data');
    }
  }
}