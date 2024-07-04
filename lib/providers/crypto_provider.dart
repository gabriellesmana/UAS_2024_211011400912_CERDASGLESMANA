// lib/providers/crypto_provider.dart

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/crypto.dart';

class CryptoProvider with ChangeNotifier {
  List<Crypto> _cryptos = [];

  List<Crypto> get cryptos => _cryptos;

  Future<void> fetchCryptos() async {
    final url = Uri.parse('https://api.coinlore.net/api/tickers/');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body)['data'] as List;
        _cryptos = data.map((crypto) => Crypto.fromJson(crypto)).toList();
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }
}
