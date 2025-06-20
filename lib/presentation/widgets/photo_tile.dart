import 'package:flutter/material.dart';
import '../../core/models/photo.dart';

class PhotoTile extends StatelessWidget {
  final Photo photo;

  const PhotoTile({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      photo.thumbUrl,
      fit: BoxFit.cover,
      loadingBuilder: (context, child, progress) {
        if (progress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.broken_image)),
    );
  }
}
