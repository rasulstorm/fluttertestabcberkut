import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/providers/favorites_provider.dart';
import 'presentation/pages/home_page.dart';
import 'presentation/pages/favorites_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FavoritesProvider(),
      child: MaterialApp(
        title: 'Art Gallery',
        theme: ThemeData.dark(),
        home: const HomePage(),
        routes: {
          FavoritesPage.routeName: (_) => const FavoritesPage(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
