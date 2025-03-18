import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart'; // Для кэширования изображений
import '../models/cat.dart'; // Модель котика
import '../services/cat_api.dart'; // Сервис для работы с API
import '../widgets/like_button.dart'; // Виджет кнопки лайка
import '../widgets/dislike_button.dart'; // Виджет кнопки дизлайка
import 'cat_detail_screen.dart'; // Экран с деталями

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  Cat? _currentCat; // Текущий котик
  int _likeCount = 0; // Счетчик лайков
  bool _isLoading = false; // Флаг загрузки

  // Загрузка нового котика
  Future<void> _fetchCat() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final cat = await ApiService.fetchCat();
      if (cat != null) {
        setState(() {
          _currentCat = cat;
        });
      }
    } catch (e) {
      // Обработка ошибок (можно добавить логирование)
      debugPrint('Ошибка при загрузке котика: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Обработка лайка
  void _handleLike() {
    setState(() {
      _likeCount++;
    });
    _fetchCat();
  }

  // Обработка дизлайка
  void _handleDislike() {
    _fetchCat();
  }

  @override
  void initState() {
    super.initState();
    _fetchCat(); // Загружаем первого котика при инициализации
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Кототиндер"),
        leading: const Icon(Icons.pets), // Иконка котика
      ),
      body: _isLoading || _currentCat == null
          ? const Center(
              child: CircularProgressIndicator()) // Индикатор загрузки
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Счетчик лайков
                Text(
                  "Лайков: $_likeCount",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),

                // Карточка котика
                Expanded(
                  child: Center(
                    child: Dismissible(
                      key: Key(_currentCat!.imageUrl), // Уникальный ключ
                      direction:
                          DismissDirection.horizontal, // Свайп по горизонтали
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          _handleLike(); // Свайп вправо — лайк
                        } else if (direction == DismissDirection.endToStart) {
                          _handleDislike(); // Свайп влево — дизлайк
                        }
                      },
                      child: GestureDetector(
                        onTap: () {
                          // Переход на экран с деталями
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  CatDetailScreen(cat: _currentCat!),
                            ),
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl: _currentCat!.imageUrl,
                          fit: BoxFit.cover,
                          height: 300,
                          width: double.infinity,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Center(
                            child: Icon(Icons.error, color: Colors.red),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Кнопки лайка и дизлайка
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DislikeButton(onPressed: _handleDislike),
                    const SizedBox(width: 20),
                    LikeButton(onPressed: _handleLike),
                  ],
                ),

                const SizedBox(height: 20),

                // Название породы
                Text(
                  _currentCat!.breedName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
    );
  }
}