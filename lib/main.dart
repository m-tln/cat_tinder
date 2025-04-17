import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cat_tinder/core/di/service_locator.dart';
import 'package:cat_tinder/domain/cubit/liked_cats_cubit.dart';
import 'package:cat_tinder/presentation/screens/home_screen.dart';

void main() {
  setupServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => LikedCatsCubit()),
      ],
      child: MaterialApp(
        title: 'cat_tinder',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const HomeScreen(),
      ),
    );
  }
}
