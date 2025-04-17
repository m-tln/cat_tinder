import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_tinder/domain/models/cat_api.dart';
import 'package:get_it/get_it.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CatApi _catApi;

  HomeCubit({CatApi? catApi})
      : _catApi = catApi ?? GetIt.instance<CatApi>(),
        super(HomeInitial());

  Future<void> fetchCat() async {
    emit(HomeLoading());
    try {
      final catData = await _catApi.fetchCatData();
      if (catData != null) {
        emit(HomeLoaded(catData: catData));
      } else {
        emit(HomeError(message: 'Не удалось загрузить данные.'));
      }
    } catch (_) {
      emit(HomeError(
          message: 'Проверьте подключение к интернету и попробуйте снова.'));
    }
  }
}
