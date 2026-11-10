
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/currency.dart';

class ConversionResult extends StatelessWidget {
  final double convertedAmount;
  final double exchangeRate;
  final Currency fromCurrency;
  final Currency toCurrency;
  final String rateDate;

  const ConversionResult({
    super.key,
    required this.convertedAmount,
    required this.exchangeRate,
    required this.fromCurrency,
    required this.toCurrency,
    required this.rateDate,
  });

  String formatAmount(double amount, Currency currency) {
    final formatter = NumberFormat.currency(
      name: currency.code,
      symbol: currency.symbol,
      decimalDigits: 2,
    );

    return formatter.format(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF246BFD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Converted Amount',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              formatAmount(convertedAmount, toCurrency),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Divider(color: Colors.white30),
          const SizedBox(height: 10),
          Text(
            '1 ${fromCurrency.code} = '
            '${exchangeRate.toStringAsFixed(4)} ${toCurrency.code}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Reference rate date: $rateDate',
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}