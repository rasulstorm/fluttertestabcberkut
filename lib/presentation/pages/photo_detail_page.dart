import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../core/models/photo.dart';
import '../providers/favorites_provider.dart';
import 'favorites_page.dart';

class PhotoDetailPage extends StatefulWidget {
  final Photo photo;

  const PhotoDetailPage({super.key, required this.photo});

  @override
  State<PhotoDetailPage> createState() => _PhotoDetailPageState();
}

class _PhotoDetailPageState extends State<PhotoDetailPage> {
  bool _isDownloading = false;

  Future<void> _downloadImage() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final status = await Permission.storage.request();
      if (!status.isGranted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Разрешение на доступ к хранилищу отклонено')),
        );
        setState(() => _isDownloading = false);
        return;
      }

      final response = await http.get(Uri.parse(widget.photo.fullUrl));
      final bytes = response.bodyBytes;

      final dir = await getExternalStorageDirectory();
      final file = File('${dir!.path}/${widget.photo.id}.jpg');

      await file.writeAsBytes(bytes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Скачано: ${file.path}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка скачивания: $e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  void _openFullscreen() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: const Text('Просмотр фото'),
          ),
          backgroundColor: Colors.black,
          body: Center(
            child: InteractiveViewer(
              child: Image.network(widget.photo.fullUrl),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final favorites = context.watch<FavoritesProvider>();
    final isFavorite = favorites.isFavorite(widget.photo);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
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
        title: const Text('Фото'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.favorite,
              color: Colors.yellow,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FavoritesPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                    'https://avatars.githubusercontent.com/u/9919?v=4',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.photo.authorName,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                      ),
                      Text(
                        '@${widget.photo.authorName.toLowerCase().replaceAll(' ', '')}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: isFavorite ? Colors.yellow : Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: IconButton(
                    icon: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite ? Colors.white : Colors.black,
                      size: 30,
                    ),
                    onPressed: () {
                      favorites.toggleFavorite(widget.photo);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: _isDownloading
                        ? const SizedBox(
                            width: 28,
                            height: 28,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.download,
                            color: Colors.black87,
                            size: 30,
                          ),
                    onPressed: _isDownloading ? null : _downloadImage,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(widget.photo.fullUrl,
                      width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: _openFullscreen,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.4),
                        shape: BoxShape.circle,
                      ),
                      padding: const EdgeInsets.all(8),
                      child:
                          const Icon(Icons.fullscreen, color: Colors.white, size: 28),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.photo.description.isNotEmpty
                  ? widget.photo.description
                  : 'Нет описания',
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),
            const SizedBox(height: 8),
            Text('Автор: ${widget.photo.authorName}',
                style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
          ],
        ),
      ),
    );
  }
}
