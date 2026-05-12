import 'package:equatable/equatable.dart';

class CurrencyState extends Equatable {
  final double amount;
  final String fromCurrency;
  final String toCurrency;
  final double result;

  const CurrencyState({
    this.amount = 0.0,
    this.fromCurrency = 'USD',
    this.toCurrency = 'EUR',
    this.result = 0.0,
  });

  CurrencyState copyWith({
    double? amount,
    String? fromCurrency,
    String? toCurrency,
    double? result,
  }) {
    return CurrencyState(
      amount: amount ?? this.amount,
      fromCurrency: fromCurrency ?? this.fromCurrency,
      toCurrency: toCurrency ?? this.toCurrency,
      result: result ?? this.result,
    );
  }

  @override
  List<Object?> get props => [amount, fromCurrency, toCurrency, result];
}
