import 'package:flutter/material.dart';
import 'package:cat_tinder/services/cat_api.dart';
import 'package:cat_tinder/widgets/like_button.dart';
import 'package:cat_tinder/widgets/dislike_button.dart';
import 'package:cat_tinder/widgets/cat_icon.dart';
import 'package:cat_tinder/screens/cat_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? imageUrl;
  String breedName = '';
  String breedDescription = '';
  int likeCount = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    fetchCat();
  }

  Future<void> fetchCat() async {
    setState(() => isLoading = true);
    final catData = await CatApi.fetchCatData();
    if (catData != null) {
      setState(() {
        imageUrl = catData.imageUrl;
        breedName = catData.breedName;
        breedDescription = catData.breedDescription;
      });
    }
    setState(() => isLoading = false);
  }

  void onLike(bool liked) {
    if (liked) {
      setState(() => likeCount++);
    }
    fetchCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Row(
          children: [
            CatIcon(),
            SizedBox(width: 8),
            Text('cat_tinder'),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : imageUrl == null
              ? const Center(child: Text('Нет данных'))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Dismissible(
                      key: UniqueKey(),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        final liked = direction == DismissDirection.startToEnd;
                        onLike(liked);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetailScreen(
                                imageUrl: imageUrl!,
                                breedName: breedName,
                                breedDescription: breedDescription,
                              ),
                            ),
                          );
                        },
                        child: Column(
                          children: [
                            Image.network(
                              imageUrl!,
                              height: 300,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              breedName,
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
                        DislikeButton(onPressed: () => onLike(false)),
                        LikeButton(onPressed: () => onLike(true)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Лайков: $likeCount',
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
    );
  }
}
