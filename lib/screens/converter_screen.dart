
import 'package:flutter/material.dart';

import '../models/currency.dart';
import '../services/currency_api_service.dart';
import '../widgets/amount_input.dart';
import '../widgets/currency_dropdown.dart';
import '../widgets/conversion_results.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final TextEditingController _amountController =
      TextEditingController(text: '1000');

  final CurrencyApiService _apiService = CurrencyApiService();

  Currency _fromCurrency = Currency.currencies[0];
  Currency _toCurrency = Currency.currencies[1];

  ExchangeRate? _exchangeRate;
  double? _convertedAmount;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _convertCurrency() async {
    final amount = double.tryParse(_amountController.text.trim());

    if (amount == null || amount <= 0) {
      setState(() {
        _errorMessage = 'Please enter a valid amount.';
        _convertedAmount = null;
        _exchangeRate = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _convertedAmount = null;
      _exchangeRate = null;
    });

    try {
      final result = await _apiService.getExchangeRate(
        from: _fromCurrency.code,
        to: _toCurrency.code,
      );

      if (!mounted) return;

      setState(() {
        _exchangeRate = result;
        _convertedAmount = amount * result.rate;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _errorMessage = e.toString().replaceFirst('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  void _swapCurrencies() {
    setState(() {
      final previousCurrency = _fromCurrency;
      _fromCurrency = _toCurrency;
      _toCurrency = previousCurrency;

      _convertedAmount = null;
      _exchangeRate = null;
      _errorMessage = null;
    });
  }

  void _clearResult() {
    setState(() {
      _convertedAmount = null;
      _exchangeRate = null;
      _errorMessage = null;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 15),

              const Text(
                'Exchange your money',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              // Conversion result
              if (_convertedAmount != null &&
                  _exchangeRate != null)
                ConversionResult(
                  convertedAmount: _convertedAmount!,
                  exchangeRate: _exchangeRate!.rate,
                  fromCurrency: _fromCurrency,
                  toCurrency: _toCurrency,
                  rateDate: _exchangeRate!.date,
                ),

              const SizedBox(height: 20),

              // Amount input
              const Text(
                'Amount',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              AmountInput(
                controller: _amountController,
                currencySymbol: _fromCurrency.symbol,
                onChanged: (_) => _clearResult(),
              ),

              const SizedBox(height: 25),

              // From currency
              const Text(
                'From',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              CurrencyDropdown(
                selectedCurrency: _fromCurrency,
                onChanged: (currency) {
                  if (currency == null) return;

                  setState(() {
                    _fromCurrency = currency;
                    _clearResult();
                  });
                },
              ),

              // Swap button
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: IconButton(
                    onPressed: _swapCurrencies,
                    icon: const Icon(
                      Icons.swap_vert_rounded,
                      size: 28,
                      color: Color(0xFF246BFD),
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFFE8EFFF),
                      fixedSize: const Size(50, 50),
                    ),
                  ),
                ),
              ),

              // To currency
              const Text(
                'To',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 10),

              CurrencyDropdown(
                selectedCurrency: _toCurrency,
                onChanged: (currency) {
                  if (currency == null) return;

                  setState(() {
                    _toCurrency = currency;
                    _clearResult();
                  });
                },
              ),

              const SizedBox(height: 30),

              // Convert button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _convertCurrency,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF246BFD),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 23,
                          width: 23,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Convert Currency',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 25),

              // Error message
              if (_errorMessage != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(
                      color: Colors.red.shade700,
                      fontSize: 13,
                    ),
                  ),
                ),


              const SizedBox(height: 20),

              Center(
                child: Text(
                  'Exchange rates provided by Frankfurter API',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}