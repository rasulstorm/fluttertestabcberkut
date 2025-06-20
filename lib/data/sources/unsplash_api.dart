import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants.dart';
import '../../core/models/photo.dart';

class UnsplashApi {
  static const _baseUrl = 'https://api.unsplash.com';

  static Future<List<Photo>> fetchRandomPhotos(int count) async {
    final url = Uri.parse('$_baseUrl/photos/random?count=$count');
    final response = await http.get(url, headers: {'Authorization': 'Client-ID $unsplashAccessKey'});

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to fetch random photos');
    }
  }

  static Future<List<Photo>> searchPhotos(String query, {int perPage = photosPerPage}) async {
    final url = Uri.parse('$_baseUrl/search/photos?query=$query&per_page=$perPage');
    final response = await http.get(url, headers: {'Authorization': 'Client-ID $unsplashAccessKey'});

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      List<dynamic> results = jsonData['results'];
      return results.map((json) => Photo.fromJson(json)).toList();
    } else {
      throw Exception('Failed to search photos');
    }
  }
}
