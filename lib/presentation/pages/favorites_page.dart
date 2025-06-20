import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/models/photo.dart';
import '../providers/favorites_provider.dart';
import 'photo_detail_page.dart';
import 'home_page.dart';

PreferredSizeWidget buildAppBar(BuildContext context) {
  return AppBar(
    backgroundColor: Colors.black,
    leadingWidth: 150,
    leading: Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Row(
        children: [
          Container(
            color: Colors.yellow,
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            child: const Text('ART',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 4),
          const Text('GALLERY', style: TextStyle(fontSize: 16)),
        ],
      ),
    ),
    actions: [
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: () {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (route) => false,
          );
        },
      ),
    ],
  );
}

class FavoritesPage extends StatelessWidget {
  const FavoritesPage({super.key});
  static const routeName = '/favorites';

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>().favorites;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: favorites.isEmpty
          ? const Center(child: Text('Избранных фото нет'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final photo = favorites[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PhotoDetailPage(photo: photo)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(photo.thumbUrl, fit: BoxFit.cover),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
