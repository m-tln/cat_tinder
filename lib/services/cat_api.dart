import 'package:http/http.dart' as http;
import 'dart:convert';

class CatApi {
  static const String _apiKey = 'YOUR_API_KEY'; // Замените на ваш API-ключ
  static const String _baseUrl = 'https://api.thecatapi.com/v1';

  Future<Map<String, dynamic>> fetchRandomCat() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/images/search?has_breeds=true'),
      headers: {'x-api-key': _apiKey},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body)[0];
    } else {
      throw Exception('Failed to load cat data');
    }
  }
}