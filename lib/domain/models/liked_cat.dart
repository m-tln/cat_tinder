import 'package:cat_tinder/domain/models/cat_api.dart';

class LikedCat {
  final CatData catData;
  final DateTime likedAt;

  LikedCat({
    required this.catData,
    required this.likedAt,
  });
}
