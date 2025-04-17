import 'package:cat_tinder/domain/models/liked_cat.dart';

class LikedCatsRepository {
  final List<LikedCat> _likedCats = [];

  void addLikedCat(LikedCat likedCat) {
    _likedCats.add(likedCat);
  }

  void removeLikedCat(LikedCat likedCat) {
    _likedCats.remove(likedCat);
  }

  List<LikedCat> getLikedCats({String? filterBreed}) {
    if (filterBreed == null || filterBreed.isEmpty) {
      return List.from(_likedCats);
    } else {
      return _likedCats
          .where((c) => c.catData.breedName == filterBreed)
          .toList();
    }
  }
}
