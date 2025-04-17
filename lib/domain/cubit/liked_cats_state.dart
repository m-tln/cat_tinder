part of 'liked_cats_cubit.dart';

class LikedCatsState {}

class LikedCatsInitial extends LikedCatsState {}

class LikedCatsLoaded extends LikedCatsState {
  final List<LikedCat> likedCats;

  LikedCatsLoaded({required this.likedCats});
}
