import 'package:flutter/material.dart';
import '../../core/models/photo.dart';
import '../../data/repositories/photo_repository.dart';
import 'favorites_page.dart';
import 'photo_detail_page.dart';

// Общий AppBar для всего приложения — версия без лупы (поиск только через поле)
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
        icon: const Icon(Icons.favorite_border),
        onPressed: () {
          Navigator.pushNamed(context, FavoritesPage.routeName);
        },
      ),
    ],
  );
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PhotoRepository _repository = PhotoRepository();
  final TextEditingController _searchController = TextEditingController();

  final List<Photo> _photos = [];
  bool _isLoading = false;
  bool _hasMore = true;
  String _searchQuery = '';

  final int _perPage = 6;

  @override
  void initState() {
    super.initState();
    _loadPhotos(reset: true);
  }

  Future<void> _loadPhotos({bool reset = false}) async {
    if (_isLoading) return;
    if (reset) {
      _photos.clear();
      _hasMore = true;
    }
    if (!_hasMore) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Photo> fetched;
      if (_searchQuery.isEmpty) {
        fetched = await _repository.fetchRandomPhotosForUI(_perPage);
      } else {
        fetched = await _repository.searchPhotosForUI(_searchQuery);
      }

      setState(() {
        if (fetched.length < _perPage) {
          _hasMore = false;
        }
        _photos.addAll(fetched);
      });
    } catch (e) {
      _hasMore = false;
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onSearchSubmitted(String query) {
    setState(() {
      _searchQuery = query.trim();
    });
    _loadPhotos(reset: true);
  }

  void _onClearSearch() {
    _searchController.clear();
    setState(() {
      _searchQuery = '';
    });
    _loadPhotos(reset: true);
  }

  bool _onScrollNotification(ScrollNotification scrollInfo) {
    if (!_isLoading &&
        _hasMore &&
        scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent - 100) {
      _loadPhotos();
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: buildAppBar(context),
      body: NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Image.network(
                    'https://images.unsplash.com/photo-1506744038136-46273834b3fb?auto=format&fit=crop&w=800&q=60',
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    color: Colors.black.withOpacity(0.3),
                  ),
                  Positioned(
                    top: 24,
                    left: 16,
                    right: 16,
                    child: Material(
                      color: Colors.white,
                      elevation: 4,
                      borderRadius: BorderRadius.circular(12),
                      child: TextField(
                        controller: _searchController,
                        onSubmitted: _onSearchSubmitted,
                        decoration: InputDecoration(
                          hintText: 'Поиск',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: _onClearSearch,
                                )
                              : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    if (index == _photos.length) {
                      return _hasMore
                          ? const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox.shrink();
                    }
                    final photo = _photos[index];
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
                  childCount: _photos.length + 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
