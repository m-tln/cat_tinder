import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CatDetailScreen extends StatelessWidget {
  final Map<String, dynamic> cat;

  const CatDetailScreen({required this.cat});

  @override
  Widget build(BuildContext context) {
    final breed = cat['breeds'][0];
    return Scaffold(
      appBar: AppBar(title: Text(breed['name'])),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: cat['url'],
              fit: BoxFit.cover,
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Порода: ${breed['name']}', style: TextStyle(fontSize: 20)),
                  SizedBox(height: 10),
                  Text('Описание: ${breed['description']}'),
                  SizedBox(height: 10),
                  Text('Характер: ${breed['temperament']}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}