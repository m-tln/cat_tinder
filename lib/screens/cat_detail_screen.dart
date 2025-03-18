import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/cat.dart'; // Импортируем модель Cat

class CatDetailScreen extends StatelessWidget {
  final Cat cat; // Используем модель Cat вместо Map

  const CatDetailScreen({super.key, required this.cat});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(cat.breedName), // Название породы в заголовке
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Изображение котика
            CachedNetworkImage(
              imageUrl: cat.imageUrl,
              height: 250,
              fit: BoxFit.cover,
              width: double.infinity,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            const SizedBox(height: 20),

            // Название породы
            Text(
              "Порода: ${cat.breedName}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}