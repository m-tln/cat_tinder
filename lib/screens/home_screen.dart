import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/cat_api.dart';
import '../widgets/like_button.dart';
import 'cat_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CatApi _catApi = CatApi();
  Map<String, dynamic>? _currentCat;
  int _likeCount = 0;

  Future<void> _fetchNewCat() async {
    try {
      final cat = await _catApi.fetchRandomCat();
      setState(() {
        _currentCat = cat;
      });
    } catch (e) {
      print('Error fetching cat: $e');
    }
  }

  void _handleLike() {
    setState(() {
      _likeCount++;
    });
    _fetchNewCat();
  }

  void _handleDislike() {
    _fetchNewCat();
  }

  @override
  void initState() {
    super.initState();
    _fetchNewCat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Кототиндер'),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Colors.red),
                SizedBox(width: 4),
                Text('$_likeCount'),
              ],
            ),
          ),
        ],
      ),
      body: _currentCat == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CatDetailScreen(cat: _currentCat!),
                      ),
                    );
                  },
                  child: CachedNetworkImage(
                    imageUrl: _currentCat!['url'],
                    fit: BoxFit.cover,
                    height: MediaQuery.of(context).size.height * 0.6,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LikeButton(onPressed: _handleDislike, isLike: false),
                    LikeButton(onPressed: _handleLike, isLike: true),
                  ],
                ),
              ],
            ),
    );
  }
}