import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;

class CatData {
  final String imageUrl;
  final String breedName;
  final String breedDescription;

  CatData({
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
  });
}

class CatApi {
  static Future<CatData?> fetchCatData() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=1'),
        headers: {
          'x-api-key': 'live_JbuH8dvofieAnngzk6sej35EExSxX2WPkOt4oBwq0Qeo9IeKYHDsxJnoXaECdUXJ',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final catData = data.first;
          final breeds = catData['breeds'];
          if (breeds != null && breeds is List && breeds.isNotEmpty) {
            final breed = breeds.first;
            return CatData(
              imageUrl: catData['url'],
              breedName: breed['name'] ?? 'Неизвестно',
              breedDescription: breed['description'] ?? 'Описание отсутствует',
            );
          }
        }
      } else {
        developer.log('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      developer.log('Ошибка: $e');
    }
    return null;
  }
}

