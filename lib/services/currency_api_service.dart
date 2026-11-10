
import 'dart:convert';
import 'package:http/http.dart' as http;

class ExchangeRate {
  final double rate;
  final String date;

  const ExchangeRate({
    required this.rate,
    required this.date,
  });
}

class CurrencyApiService {
  static const String baseUrl = 'https://api.frankfurter.dev/v2';

  Future<ExchangeRate> getExchangeRate({
    required String from,
    required String to,
  }) async {
    if (from == to) {
      return ExchangeRate(
        rate: 1.0,
        date: DateTime.now().toIso8601String().split('T').first,
      );
    }

    final uri = Uri.parse(
      '$baseUrl/rate/${from.toLowerCase()}/${to.toLowerCase()}',
    );

    try {
      final response = await http.get(uri).timeout(
        const Duration(seconds: 20),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        return ExchangeRate(
          rate: (data['rate'] as num).toDouble(),
          date: data['date'] as String,
        );
      }

      String message = 'Unable to retrieve exchange rates.';

      try {
        final data = jsonDecode(response.body);
        message = data['message'] ?? message;
      } catch (_) {
        // Keep the default error message.
      }

      throw Exception(
        'API Error (${response.statusCode}): $message',
      );
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception('Network error. Please check your internet.');
    }
  }
}
