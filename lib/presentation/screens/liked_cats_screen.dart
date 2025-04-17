import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_tinder/domain/cubit/liked_cats_cubit.dart';

class LikedCatsScreen extends StatelessWidget {
  const LikedCatsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Лайкнутые котики'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: _BreedFilter(),
          ),
          Expanded(
            child: BlocBuilder<LikedCatsCubit, LikedCatsState>(
              builder: (context, state) {
                if (state is LikedCatsLoaded) {
                  final likedCats = state.likedCats;
                  if (likedCats.isEmpty) {
                    return const Center(child: Text('Нет лайкнутых котиков'));
                  }
                  return ListView.builder(
                    itemCount: likedCats.length,
                    itemBuilder: (context, index) {
                      final likedCat = likedCats[index];
                      return Dismissible(
                        key: UniqueKey(),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) {
                          context
                              .read<LikedCatsCubit>()
                              .removeLikedCat(likedCat);
                        },
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
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const Center(
                                  child: CircularProgressIndicator());
                            },
                          ),
                          title: Text(likedCat.catData.breedName),
                          subtitle: Text(
                            'Лайк: ${likedCat.likedAt.toLocal()}',
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _BreedFilter extends StatefulWidget {
  @override
  __BreedFilterState createState() => __BreedFilterState();
}

class __BreedFilterState extends State<_BreedFilter> {
  String? selectedBreed;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<LikedCatsCubit>();
    final breeds = cubit.allBreeds;

    // Если selectedBreed не в списке breeds, сбрасываем его
    if (selectedBreed != null && !breeds.contains(selectedBreed)) {
      selectedBreed = null;
    }

    // Если selectedBreed не установлен, устанавливаем текущий фильтр
    selectedBreed ??= cubit.currentFilter;

    return DropdownButton<String>(
      hint: const Text('Фильтр по породе'),
      value: selectedBreed,
      isExpanded: true,
      items: breeds
          .map((breed) => DropdownMenuItem(value: breed, child: Text(breed)))
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedBreed = value;
        });
        cubit.filterLikedCats(value);
      },
    );
  }
}
