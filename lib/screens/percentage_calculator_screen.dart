import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/percentage_bloc.dart';
import '../bloc/percentage_event.dart';
import '../bloc/percentage_state.dart';

class PercentageCalculatorScreen extends StatefulWidget {
  const PercentageCalculatorScreen({super.key});

  @override
  State<PercentageCalculatorScreen> createState() =>
      _PercentageCalculatorScreenState();
}

class _PercentageCalculatorScreenState extends State<PercentageCalculatorScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Controllers for Percentage Of tab
  final TextEditingController _percentageController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  // Controllers for Percentage Change tab
  final TextEditingController _oldValueController = TextEditingController();
  final TextEditingController _newValueController = TextEditingController();

  // Controllers for Discount tab
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _percentageController.dispose();
    _numberController.dispose();
    _oldValueController.dispose();
    _newValueController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PercentageBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Percentage Calculator',
            style: TextStyle(color: Colors.white),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: const Color(0xFFFF6B6B),
            labelColor: const Color(0xFFFF6B6B),
            unselectedLabelColor: Colors.white60,
            tabs: const [
              Tab(text: '% of'),
              Tab(text: 'Change'),
              Tab(text: 'Discount'),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPercentageOfTab(),
            _buildPercentageChangeTab(),
            _buildDiscountTab(),
          ],
        ),
      ),
    );
  }

  // Tab 1: Calculate X% of Y
  Widget _buildPercentageOfTab() {
    return BlocBuilder<PercentageBloc, PercentageState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _percentageController,
                label: 'Percentage',
                suffix: '%',
                onChanged: (_) => _calculatePercentageOf(context),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'of',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _numberController,
                label: 'Number',
                onChanged: (_) => _calculatePercentageOf(context),
              ),
              const SizedBox(height: 30),
              if (state.isCalculated &&
                  state.calculationType ==
                      PercentageCalculationType.percentageOf)
                _buildResultCard(
                  'Result',
                  state.result.toStringAsFixed(2),
                  const Color(0xFFFF6B6B),
                  subtitle: state.resultLabel,
                ),
            ],
          ),
        );
      },
    );
  }

  // Tab 2: Percentage Change
  Widget _buildPercentageChangeTab() {
    return BlocBuilder<PercentageBloc, PercentageState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                controller: _oldValueController,
                label: 'Original Value',
                onChanged: (_) => _calculatePercentageChange(context),
              ),
              const SizedBox(height: 16),
              const Center(
                child: Icon(Icons.arrow_downward, color: Colors.white60),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _newValueController,
                label: 'New Value',
                onChanged: (_) => _calculatePercentageChange(context),
              ),
              const SizedBox(height: 30),
              if (state.isCalculated &&
                  state.calculationType ==
                      PercentageCalculationType.percentageChange) ...[
                _buildResultCard(
                  state.resultLabel,
                  '${state.result >= 0 ? '+' : ''}${state.result.toStringAsFixed(2)}%',
                  state.result >= 0
                      ? const Color(0xFF4ECDC4)
                      : const Color(0xFFFF6B6B),
                  subtitle:
                      'Change: ${state.additionalInfo?.toStringAsFixed(2)}',
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  // Tab 3: Discount Calculator
  Widget _buildDiscountTab() {
    return BlocBuilder<PercentageBloc, PercentageState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputField(
                controller: _priceController,
                label: 'Original Price',
                prefix: '\$',
                onChanged: (_) => _calculateDiscount(context),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _discountController,
                label: 'Discount',
                suffix: '%',
                onChanged: (_) => _calculateDiscount(context),
              ),
              const SizedBox(height: 30),
              if (state.isCalculated &&
                  state.calculationType ==
                      PercentageCalculationType.discount) ...[
                _buildResultCard(
                  'You Save',
                  '\$${state.additionalInfo?.toStringAsFixed(2)}',
                  const Color(0xFF4ECDC4),
                ),
                const SizedBox(height: 12),
                _buildResultCard(
                  'Final Price',
                  '\$${state.result.toStringAsFixed(2)}',
                  const Color(0xFFFF6B6B),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? prefix,
    String? suffix,
    required Function(String) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D44),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.white60),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            style: const TextStyle(
              fontSize: 28,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            decoration: InputDecoration(
              hintText: '0',
              hintStyle: TextStyle(color: Colors.white.withOpacity(0.2)),
              border: InputBorder.none,
              prefixText: prefix,
              suffixText: suffix,
              prefixStyle: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              suffixStyle: const TextStyle(
                fontSize: 28,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildResultCard(
    String label,
    String value,
    Color color, {
    String? subtitle,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 36,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.white60),
            ),
          ],
        ],
      ),
    );
  }

  void _calculatePercentageOf(BuildContext context) {
    final percentage = double.tryParse(_percentageController.text) ?? 0;
    final number = double.tryParse(_numberController.text) ?? 0;
    context.read<PercentageBloc>().add(
      CalculatePercentageOf(percentage: percentage, number: number),
    );
  }

  void _calculatePercentageChange(BuildContext context) {
    final oldValue = double.tryParse(_oldValueController.text) ?? 0;
    final newValue = double.tryParse(_newValueController.text) ?? 0;
    context.read<PercentageBloc>().add(
      CalculatePercentageChange(oldValue: oldValue, newValue: newValue),
    );
  }

  void _calculateDiscount(BuildContext context) {
    final price = double.tryParse(_priceController.text) ?? 0;
    final discount = double.tryParse(_discountController.text) ?? 0;
    context.read<PercentageBloc>().add(
      CalculateDiscount(originalPrice: price, discountPercentage: discount),
    );
  }
}
