import 'package:flutter/material.dart';
import '../../core/models/photo.dart';
import 'photo_tile.dart';

class PhotoGrid extends StatelessWidget {
  final List<Photo> photos;
  final void Function(Photo) onPhotoTap;

  const PhotoGrid({
    super.key,
    required this.photos,
    required this.onPhotoTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: photos.length,
      itemBuilder: (context, index) {
        final photo = photos[index];
        return GestureDetector(
          onTap: () => onPhotoTap(photo),
          child: PhotoTile(photo: photo),
        );
      },
    );
  }
}
