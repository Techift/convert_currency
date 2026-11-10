
class Currency {
  final String code;
  final String name;
  final String symbol;
  final String flag;

  const Currency({
    required this.code,
    required this.name,
    required this.symbol,
    required this.flag,
  });

  static const List<Currency> currencies = [
    Currency(
      code: 'NGN',
      name: 'Nigerian Naira',
      symbol: '₦',
      flag: '🇳🇬',
    ),
    Currency(
      code: 'USD',
      name: 'US Dollar',
      symbol: r'$',
      flag: '🇺🇸',
    ),
    Currency(
      code: 'GBP',
      name: 'British Pound',
      symbol: '£',
      flag: '🇬🇧',
    ),
    Currency(
      code: 'EUR',
      name: 'Euro',
      symbol: '€',
      flag: '🇪🇺',
    ),
    Currency(
      code: 'GHS',
      name: 'Ghanaian Cedi',
      symbol: '₵',
      flag: '🇬🇭',
    ),
    Currency(
      code: 'CAD',
      name: 'Canadian Dollar',
      symbol: r'C$',
      flag: '🇨🇦',
    ),
    Currency(
      code: 'AUD',
      name: 'Australian Dollar',
      symbol: r'A$',
      flag: '🇦🇺',
    ),
    Currency(
      code: 'JPY',
      name: 'Japanese Yen',
      symbol: '¥',
      flag: '🇯🇵',
    ),
    Currency(
      code: 'INR',
      name: 'Indian Rupee',
      symbol: '₹',
      flag: '🇮🇳',
    ),
    Currency(
      code: 'ZAR',
      name: 'South African Rand',
      symbol: 'R',
      flag: '🇿🇦',
    ),
    Currency(
      code: 'KES',
      name: 'Kenyan Shilling',
      symbol: 'KSh',
      flag: '🇰🇪',
    ),
    Currency(
      code: 'CHF',
      name: 'Swiss Franc',
      symbol: 'Fr',
      flag: '🇨🇭',
    ),
  ];
}