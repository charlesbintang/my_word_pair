import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:my_word_pair/data/entities/wordpair.dart';

class WordPairService {
  /// Mendapatkan base URL berdasarkan platform
  /// Android emulator menggunakan 10.0.2.2 untuk mengakses localhost host
  /// iOS simulator dan web bisa menggunakan localhost
  static String get baseUrl {
    if (kIsWeb) {
      // Web bisa menggunakan localhost
      return 'http://localhost:3000/wordpairs';
    } else {
      // Untuk mobile, cek apakah Android
      if (defaultTargetPlatform == TargetPlatform.android) {
        // Android emulator menggunakan 10.0.2.2 untuk mengakses localhost host
        // Android physical device using computer IP address in the same network
        return 'http://${dotenv.env['IP_ADDRESS']}:3000/wordpairs';
      } else {
        // iOS simulator dan desktop menggunakan localhost
        return 'http://localhost:3000/wordpairs';
      }
    }
  }

  /// Mengirim WordPair ke backend dengan category tertentu
  Future<void> createWordPair({
    required WordPair pair,
    required String category,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(WordPairService.baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'firstWord': pair.first,
          'secondWord': pair.second,
          'category': category,
        }),
      );

      if (response.statusCode != 201) {
        debugPrint(
          'Error creating word pair: ${response.statusCode} - ${response.body}',
        );
      }
      // else {
      //   debugPrint('Created successfully');
      // }
    } catch (e) {
      debugPrint('Error calling API: $e');
      // Jangan throw error agar aplikasi tetap berjalan meski API gagal
    }
  }

  /// Menghapus word pair dari backend berdasarkan ID
  Future<void> deleteWordPair({required String id}) async {
    try {
      final response = await http.delete(
        Uri.parse('${WordPairService.baseUrl}/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 204) {
        debugPrint(
          'Error deleting word pair: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error calling API: $e');
      // Jangan throw error agar aplikasi tetap berjalan meski API gagal
    }
  }

  /// Mendapatkan semua data WordPair dari backend
  Future<List<WordPairEntity>> findAllWordPair({String? params}) async {
    try {
      var url = WordPairService.baseUrl;
      if (params != null && params.isNotEmpty) {
        url = url + params;
      }
      final response = await http.get(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse JSON response
        final List<dynamic> jsonList =
            jsonDecode(response.body) as List<dynamic>;

        // Convert setiap item JSON menjadi WordPairEntity
        final List<WordPairEntity> wordPairs = jsonList
            .map(
              (json) => WordPairEntity.fromJson(json as Map<String, dynamic>),
            )
            .toList();

        debugPrint(
          'All data has been successfully retrieved: ${wordPairs.length} items',
        );
        return wordPairs;
      } else {
        debugPrint(
          'Error find all word pair: ${response.statusCode} - ${response.body}',
        );
        return [];
      }
    } catch (e) {
      debugPrint('Error calling API: $e');
      // Return empty list jika terjadi error agar aplikasi tetap berjalan
      return [];
    }
  }

  /// Mengubah category word pair dari backend berdasarkan ID
  Future<void> updateWordPair({
    required String id,
    required String category,
  }) async {
    try {
      final response = await http.patch(
        Uri.parse('${WordPairService.baseUrl}/$id'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'category': category}),
      );

      if (response.statusCode != 200) {
        debugPrint(
          'Error update word pair: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('Error calling API: $e');
      // Jangan throw error agar aplikasi tetap berjalan meski API gagal
    }
  }
}
