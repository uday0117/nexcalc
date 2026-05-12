import 'package:flutter_bloc/flutter_bloc.dart';

import 'currency_event.dart';
import 'currency_state.dart';

class CurrencyBloc extends Bloc<CurrencyEvent, CurrencyState> {
  CurrencyBloc() : super(const CurrencyState()) {
    on<ConvertCurrency>(_onConvertCurrency);
    on<SwapCurrencies>(_onSwapCurrencies);
  }

  // Simplified exchange rates (base: USD)
  final Map<String, double> _exchangeRates = {
    'USD': 1.0,
    'EUR': 0.92,
    'GBP': 0.79,
    'JPY': 149.50,
    'INR': 83.25,
    'AUD': 1.52,
    'CAD': 1.36,
    'CHF': 0.88,
    'CNY': 7.24,
    'AED': 3.67,
  };

  void _onConvertCurrency(ConvertCurrency event, Emitter<CurrencyState> emit) {
    if (event.amount == 0) {
      emit(
        state.copyWith(
          amount: event.amount,
          fromCurrency: event.fromCurrency,
          toCurrency: event.toCurrency,
          result: 0.0,
        ),
      );
      return;
    }

    // Convert to USD first, then to target currency
    final fromRate = _exchangeRates[event.fromCurrency] ?? 1.0;
    final toRate = _exchangeRates[event.toCurrency] ?? 1.0;
    final amountInUSD = event.amount / fromRate;
    final result = amountInUSD * toRate;

    emit(
      state.copyWith(
        amount: event.amount,
        fromCurrency: event.fromCurrency,
        toCurrency: event.toCurrency,
        result: result,
      ),
    );
  }

  void _onSwapCurrencies(SwapCurrencies event, Emitter<CurrencyState> emit) {
    emit(
      state.copyWith(
        fromCurrency: state.toCurrency,
        toCurrency: state.fromCurrency,
        amount: state.result,
        result: state.amount,
      ),
    );
  }
}
