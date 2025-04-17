import 'package:get_it/get_it.dart';
import 'package:cat_tinder/domain/models/cat_api.dart';
import 'package:cat_tinder/data/liked_cats_repository.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<CatApi>(() => CatApi());
  getIt.registerLazySingleton<LikedCatsRepository>(() => LikedCatsRepository());
}
