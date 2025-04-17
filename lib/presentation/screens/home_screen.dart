import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_tinder/domain/cubit/home_cubit.dart';
import 'package:cat_tinder/domain/cubit/liked_cats_cubit.dart';
import 'package:cat_tinder/presentation/screens/cat_detail_screen.dart';
import 'package:cat_tinder/presentation/screens/liked_cats_screen.dart';
import 'package:cat_tinder/presentation/widgets/like_button.dart';
import 'package:cat_tinder/presentation/widgets/dislike_button.dart';
import 'package:cat_tinder/presentation/widgets/cat_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _showErrorDialog(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Ошибка'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onRetry();
            },
            child: const Text('Повторить'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Отмена'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..fetchCat(),
      child: BlocListener<HomeCubit, HomeState>(
        listener: (context, state) {
          if (state is HomeError) {
            final message = state.message.contains('Failed host lookup') ||
                    state.message.contains('No Internet') ||
                    state.message.contains('SocketException')
                ? 'Отсутствует интернет-соединение'
                : state.message;
            _showErrorDialog(
              context,
              message,
              () => context.read<HomeCubit>().fetchCat(),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: const Row(
              children: [
                CatIcon(),
                SizedBox(width: 8),
                Text('cat_tinder'),
              ],
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LikedCatsScreen()),
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeLoading || state is HomeInitial) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is HomeLoaded) {
                final catData = state.catData;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        final liked = direction == DismissDirection.startToEnd;
                        if (liked) {
                          context.read<LikedCatsCubit>().addLikedCat(catData);
                        }
                        context.read<HomeCubit>().fetchCat();
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                imageUrl: catData.imageUrl,
                                breedName: catData.breedName,
                                breedDescription: catData.breedDescription,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.network(
                              catData.imageUrl,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const Center(
                                    child: CircularProgressIndicator());
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              catData.breedName,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        DislikeButton(
                            onPressed: () =>
                                context.read<HomeCubit>().fetchCat()),
                        LikeButton(
                          onPressed: () {
                            context.read<LikedCatsCubit>().addLikedCat(catData);
                            context.read<HomeCubit>().fetchCat();
                          },
                        ),
                      ],
                    ),
                  ],
                );
              } else if (state is HomeError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        state.message.contains('Failed host lookup') ||
                                state.message.contains('No Internet') ||
                                state.message.contains('SocketException')
                            ? 'Отсутствует интернет-соединение'
                            : state.message,
                        style: const TextStyle(fontSize: 16, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<HomeCubit>().fetchCat(),
                        child: const Text('Повторить'),
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(child: Text('Нет данных'));
              }
            },
          ),
        ),
      ),
    );
  }
}
