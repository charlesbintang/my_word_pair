import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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
      } else {
        debugPrint('Created successfully');
      }
    } catch (e) {
      debugPrint('Error calling API: $e');
      // Jangan throw error agar aplikasi tetap berjalan meski API gagal
    }
  }
}
