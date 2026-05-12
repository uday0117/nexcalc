import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/currency_bloc.dart';
import '../bloc/currency_event.dart';
import '../bloc/currency_state.dart';

class CurrencyConverterScreen extends StatelessWidget {
  const CurrencyConverterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CurrencyBloc(),
      child: const _CurrencyConverterView(),
    );
  }
}

class _CurrencyConverterView extends StatefulWidget {
  const _CurrencyConverterView();

  @override
  State<_CurrencyConverterView> createState() => _CurrencyConverterViewState();
}

class _CurrencyConverterViewState extends State<_CurrencyConverterView> {
  final TextEditingController _amountController = TextEditingController();

  final List<String> _currencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'INR',
    'AUD', 'CAD', 'CHF', 'CNY', 'AED',
  ];

  final Map<String, String> _currencyNames = {
    'USD': 'US Dollar',
    'EUR': 'Euro',
    'GBP': 'British Pound',
    'JPY': 'Japanese Yen',
    'INR': 'Indian Rupee',
    'AUD': 'Australian Dollar',
    'CAD': 'Canadian Dollar',
    'CHF': 'Swiss Franc',
    'CNY': 'Chinese Yuan',
    'AED': 'UAE Dirham',
  };

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Currency Converter',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<CurrencyBloc, CurrencyState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // From Currency
                _buildCurrencyCard(
                  context,
                  title: 'From',
                  currency: state.fromCurrency,
                  currencies: _currencies,
                  controller: _amountController,
                  onCurrencyChanged: (currency) {
                    context.read<CurrencyBloc>().add(
                          ConvertCurrency(
                            amount: double.tryParse(_amountController.text) ?? 0,
                            fromCurrency: currency!,
                            toCurrency: state.toCurrency,
                          ),
                        );
                  },
                  onAmountChanged: (value) {
                    context.read<CurrencyBloc>().add(
                          ConvertCurrency(
                            amount: double.tryParse(value) ?? 0,
                            fromCurrency: state.fromCurrency,
                            toCurrency: state.toCurrency,
                          ),
                        );
                  },
                ),
                const SizedBox(height: 16),
                // Swap Button
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C54),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.arrowRightArrowLeft,
                        color: Color(0xFF00D9FF),
                        size: 20,
                      ),
                      onPressed: () {
                        context.read<CurrencyBloc>().add(const SwapCurrencies());
                        if (state.result > 0) {
                          _amountController.text = state.result.toStringAsFixed(2);
                        }
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // To Currency
                _buildResultCard(
                  context,
                  title: 'To',
                  currency: state.toCurrency,
                  amount: state.result,
                  currencies: _currencies,
                  onCurrencyChanged: (currency) {
                    context.read<CurrencyBloc>().add(
                          ConvertCurrency(
                            amount: double.tryParse(_amountController.text) ?? 0,
                            fromCurrency: state.fromCurrency,
                            toCurrency: currency!,
                          ),
                        );
                  },
                ),
                const SizedBox(height: 32),
                // Exchange Rate Info
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2C2C54),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFF00D9FF).withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const FaIcon(
                            FontAwesomeIcons.circleInfo,
                            color: Color(0xFF00D9FF),
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Exchange Rate',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '1 ${state.fromCurrency} = ${(state.amount > 0 ? state.result / state.amount : 0).toStringAsFixed(4)} ${state.toCurrency}',
                        style: const TextStyle(
                          color: Color(0xFF00D9FF),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _currencyNames[state.fromCurrency] ?? '',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // Note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.orange.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const FaIcon(
                        FontAwesomeIcons.triangleExclamation,
                        color: Colors.orange,
                        size: 16,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Rates are indicative. Check with your bank for actual rates.',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.7),
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCurrencyCard(
    BuildContext context, {
    required String title,
    required String currency,
    required List<String> currencies,
    required TextEditingController controller,
    required ValueChanged<String?> onCurrencyChanged,
    required ValueChanged<String> onAmountChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF00D9FF), Color(0xFF0099CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00D9FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: '0.00',
              hintStyle: TextStyle(
                color: Colors.white54,
                fontSize: 32,
              ),
            ),
            onChanged: onAmountChanged,
          ),
          const SizedBox(height: 16),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currency,
              dropdownColor: const Color(0xFF2C2C54),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              isExpanded: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onCurrencyChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context, {
    required String title,
    required String currency,
    required double amount,
    required List<String> currencies,
    required ValueChanged<String?> onCurrencyChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C54),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF00D9FF).withOpacity(0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            amount.toStringAsFixed(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: currency,
              dropdownColor: const Color(0xFF2C2C54),
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white54),
              isExpanded: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
              items: currencies.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: onCurrencyChanged,
            ),
          ),
        ],
      ),
    );
  }
}
