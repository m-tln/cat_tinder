part of 'home_cubit.dart';

class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final CatData catData;

  HomeLoaded({required this.catData});
}

class HomeError extends HomeState {
  final String message;

  HomeError({required this.message});
}
