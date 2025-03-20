import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// Запуск приложения
void main() {
  runApp(const MyApp());
}

/// Основное приложение с кастомной иконкой в AppBar
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Для демонстрации кастомной иконки создаём виджет CatIcon с использованием CustomPaint.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'cat_tinder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

/// Главный экран приложения, реализованный как StatefulWidget
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? imageUrl;
  String breedName = '';
  String breedDescription = '';
  int likeCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCat();
  }

  /// Функция для получения случайного котика с указанной породой через API
  Future<void> fetchCat({int retryCount = 0}) async {
    const maxRetries = 5;
    setState(() {
      isLoading = true;
    });
    try {
      final response = await http.get(
        Uri.parse('https://api.thecatapi.com/v1/images/search?has_breeds=1'),
        headers: {
          'x-api-key': 'live_JbuH8dvofieAnngzk6sej35EExSxX2WPkOt4oBwq0Qeo9IeKYHDsxJnoXaECdUXJ', // добавьте ваш API ключ здесь
        },
      );

      debugPrint('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (data.isNotEmpty) {
          final catData = data.first;
          final breeds = catData['breeds'];
          if (breeds != null && breeds is List && breeds.isNotEmpty) {
            final breed = breeds.first;
            setState(() {
              imageUrl = catData['url'];
              breedName = breed['name'] ?? 'Неизвестно';
              breedDescription = breed['description'] ?? 'Описание отсутствует';
            });
          } else {
            debugPrint('Нет данных о породе. Попытка $retryCount');
            if (retryCount < maxRetries) {
              await fetchCat(retryCount: retryCount + 1);
            } else {
              debugPrint(
                  'Превышено максимальное число попыток получения данных');
            }
          }
        }
      } else {
        debugPrint('Ошибка загрузки: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Ошибка: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  /// Обработка лайка. Если действие положительное, увеличиваем счетчик лайков.
  void onLike(bool liked) {
    if (liked) {
      setState(() {
        likeCount++;
      });
    }
    // Загружаем нового котика
    fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CatIcon(),
            SizedBox(width: 8),
            Text('cat_tinder'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : imageUrl == null
              ? const Center(child: Text('Нет данных'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Оборачиваем картинку в Dismissible для обработки свайпов
                    Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        // Если свайп вправо — считаем лайк
                        bool liked = direction == DismissDirection.endToStart
                            ? false
                            : true;
                        onLike(liked);
                      },
                      child: GestureDetector(
                        onTap: () {
                          // При нажатии открываем детальный экран
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                imageUrl: imageUrl!,
                                breedName: breedName,
                                breedDescription: breedDescription,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            // Используем Row или Column – здесь Column для расположения по вертикали
                            Image.network(
                              imageUrl!,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              breedName,
                              style: const TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Кнопки лайка и дизлайка, вынесенные в отдельные StatelessWidget
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DislikeButton(
                          onPressed: () => onLike(false),
                        ),
                        LikeButton(
                          onPressed: () => onLike(true),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Лайков: $likeCount',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
    );
  }
}

/// Экран детального описания породы
class DetailScreen extends StatelessWidget {
  final String imageUrl;
  final String breedName;
  final String breedDescription;

  const DetailScreen({
    Key? key,
    required this.imageUrl,
    required this.breedName,
    required this.breedDescription,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(breedName),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              imageUrl,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 16),
            Text(
              breedName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              breedDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

/// Кастомная кнопка лайка (StatelessWidget)
class LikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LikeButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.thumb_up, color: Colors.white),
      label: const Text('Лайк'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
    );
  }
}

/// Кастомная кнопка дизлайка (StatelessWidget)
class DislikeButton extends StatelessWidget {
  final VoidCallback onPressed;

  const DislikeButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.thumb_down, color: Colors.white),
      label: const Text('Дизлайк'),
      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
    );
  }
}

/// Пример кастомной иконки для приложения, реализованной через CustomPainter
class CatIcon extends StatelessWidget {
  const CatIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Размер иконки можно регулировать по необходимости
    return CustomPaint(
      size: const Size(24, 24),
      painter: _CatIconPainter(),
    );
  }
}

class _CatIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;

    // Рисуем простую голову кота (круг)
    canvas.drawCircle(
        Offset(size.width / 2, size.height / 2), size.width / 2, paint);

    final eyePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Рисуем два глаза
    canvas.drawCircle(
        Offset(size.width * 0.35, size.height * 0.4), 2, eyePaint);
    canvas.drawCircle(
        Offset(size.width * 0.65, size.height * 0.4), 2, eyePaint);

    final pupilPaint = Paint()..color = Colors.black;
    canvas.drawCircle(
        Offset(size.width * 0.35, size.height * 0.4), 1, pupilPaint);
    canvas.drawCircle(
        Offset(size.width * 0.65, size.height * 0.4), 1, pupilPaint);

    // Рисуем треугольные уши
    final earPath = Path();
    earPath.moveTo(size.width * 0.15, size.height * 0.2);
    earPath.lineTo(size.width * 0.3, size.height * 0.05);
    earPath.lineTo(size.width * 0.35, size.height * 0.25);
    earPath.close();
    canvas.drawPath(earPath, paint);

    earPath.reset();
    earPath.moveTo(size.width * 0.85, size.height * 0.2);
    earPath.lineTo(size.width * 0.7, size.height * 0.05);
    earPath.lineTo(size.width * 0.65, size.height * 0.25);
    earPath.close();
    canvas.drawPath(earPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
