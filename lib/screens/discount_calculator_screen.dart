import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../bloc/discount_bloc.dart';
import '../bloc/discount_event.dart';
import '../bloc/discount_state.dart';

class DiscountCalculatorScreen extends StatelessWidget {
  const DiscountCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiscountBloc(),
      child: const _DiscountCalculatorView(),
    );
  }
}

class _DiscountCalculatorView extends StatefulWidget {
  const _DiscountCalculatorView();

  @override
  State<_DiscountCalculatorView> createState() =>
      _DiscountCalculatorViewState();
}

class _DiscountCalculatorViewState extends State<_DiscountCalculatorView> {
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  final TextEditingController _taxController = TextEditingController();

  @override
  void dispose() {
    _priceController.dispose();
    _discountController.dispose();
    _taxController.dispose();
    super.dispose();
  }

  void _calculate() {
    final price = double.tryParse(_priceController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    final tax = double.tryParse(_taxController.text);

    context.read<DiscountBloc>().add(
          CalculateDiscount(
            originalPrice: price,
            discountPercent: discount,
            taxPercent: tax,
          ),
        );
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
          'Discount Calculator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<DiscountBloc, DiscountState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input Fields
                _buildInputCard(
                  icon: FontAwesomeIcons.tag,
                  label: 'Original Price',
                  hint: 'Enter original price',
                  controller: _priceController,
                  color: const Color(0xFFFF6B6B),
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  icon: FontAwesomeIcons.percent,
                  label: 'Discount (%)',
                  hint: 'Enter discount percentage',
                  controller: _discountController,
                  color: const Color(0xFF00D9FF),
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  icon: FontAwesomeIcons.receipt,
                  label: 'Tax (%) - Optional',
                  hint: 'Enter tax percentage',
                  controller: _taxController,
                  color: const Color(0xFFFFBE0B),
                ),
                const SizedBox(height: 24),
                // Calculate Button
                ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00D9FF),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Calculate',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (state.originalPrice > 0) ...[
                  const SizedBox(height: 32),
                  // Final Price Display
                  Container(
                    padding: const EdgeInsets.all(24),
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
                      children: [
                        const Text(
                          'Final Price',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '\$${state.finalPrice.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (state.taxAmount > 0) ...[
                          const SizedBox(height: 4),
                          Text(
                            '(includes \$${state.taxAmount.toStringAsFixed(2)} tax)',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.8),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Savings Display
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00B894).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF00B894),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const FaIcon(
                          FontAwesomeIcons.piggyBank,
                          color: Color(0xFF00B894),
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'You Save',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              '\$${state.savings.toStringAsFixed(2)} (${state.discountPercent.toStringAsFixed(0)}%)',
                              style: const TextStyle(
                                color: Color(0xFF00B894),
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Breakdown
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C54),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        _buildBreakdownRow(
                          'Original Price',
                          '\$${state.originalPrice.toStringAsFixed(2)}',
                          Colors.white54,
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _buildBreakdownRow(
                          'Discount (${state.discountPercent.toStringAsFixed(0)}%)',
                          '-\$${state.discountAmount.toStringAsFixed(2)}',
                          const Color(0xFFFF6B6B),
                        ),
                        const Divider(color: Colors.white12, height: 24),
                        _buildBreakdownRow(
                          'Price After Discount',
                          '\$${state.priceAfterDiscount.toStringAsFixed(2)}',
                          Colors.white,
                        ),
                        if (state.taxAmount > 0) ...[
                          const Divider(color: Colors.white12, height: 24),
                          _buildBreakdownRow(
                            'Tax (${state.taxPercent.toStringAsFixed(0)}%)',
                            '+\$${state.taxAmount.toStringAsFixed(2)}',
                            const Color(0xFFFFBE0B),
                          ),
                        ],
                        const Divider(color: Colors.white12, height: 24),
                        _buildBreakdownRow(
                          'Final Amount',
                          '\$${state.finalPrice.toStringAsFixed(2)}',
                          const Color(0xFF00D9FF),
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInputCard({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C54),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              FaIcon(icon, color: color, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.white.withOpacity(0.3),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBreakdownRow(
    String label,
    String value,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: isBold ? 16 : 14,
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: isBold ? 18 : 16,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
