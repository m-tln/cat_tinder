import 'package:flutter/material.dart';
import 'package:cat_tinder/domain/models/liked_cat.dart';
import 'package:intl/intl.dart';

class LikedCatCard extends StatelessWidget {
  final LikedCat likedCat;
  final VoidCallback onDismissed;

  const LikedCatCard({
    Key? key,
    required this.likedCat,
    required this.onDismissed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd.MM.yyyy, HH:mm').format(likedCat.likedAt);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        leading: Image.network(
          likedCat.catData.imageUrl,
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(likedCat.catData.breedName),
        subtitle: Text('Лайк: $formattedDate'),
      ),
    );
  }
}
