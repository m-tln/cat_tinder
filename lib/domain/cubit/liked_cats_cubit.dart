import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_tinder/domain/models/liked_cat.dart';
import 'package:cat_tinder/domain/models/cat_api.dart';
import 'package:cat_tinder/data/liked_cats_repository.dart';
import 'package:get_it/get_it.dart';

part 'liked_cats_state.dart';

class LikedCatsCubit extends Cubit<LikedCatsState> {
  final LikedCatsRepository _repository;
  String? _currentFilter;
  final Set<String> _allBreeds = {};

  LikedCatsCubit({LikedCatsRepository? repository})
      : _repository = repository ?? GetIt.instance<LikedCatsRepository>(),
        super(LikedCatsInitial());

  void loadLikedCats({String? filterBreed}) {
    _currentFilter = filterBreed;
    final cats = _repository.getLikedCats(filterBreed: filterBreed);
    emit(LikedCatsLoaded(likedCats: cats));
  }

  void addLikedCat(CatData catData) {
    final likedCat = LikedCat(catData: catData, likedAt: DateTime.now());
    _repository.addLikedCat(likedCat);
    _allBreeds.add(catData.breedName);
    loadLikedCats(filterBreed: _currentFilter);
  }

  void removeLikedCat(LikedCat likedCat) {
    _repository.removeLikedCat(likedCat);
    // Обновляем список пород
    final remainingBreeds =
        _repository.getLikedCats().map((cat) => cat.catData.breedName).toSet();
    _allBreeds.retainAll(remainingBreeds);
    // Если текущий фильтр больше не существует, сбрасываем его
    if (_currentFilter != null && !_allBreeds.contains(_currentFilter)) {
      _currentFilter = null;
    }
    loadLikedCats(filterBreed: _currentFilter);
  }

  void filterLikedCats(String? breed) {
    loadLikedCats(filterBreed: breed == 'All' ? null : breed);
  }

  String? get currentFilter => _currentFilter ?? 'All';

  List<String> get allBreeds => ['All', ..._allBreeds.toList()];
}
