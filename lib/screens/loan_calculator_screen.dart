import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../bloc/loan_bloc.dart';
import '../bloc/loan_event.dart';
import '../bloc/loan_state.dart';

class LoanCalculatorScreen extends StatelessWidget {
  const LoanCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoanBloc(),
      child: const _LoanCalculatorView(),
    );
  }
}

class _LoanCalculatorView extends StatefulWidget {
  const _LoanCalculatorView();

  @override
  State<_LoanCalculatorView> createState() => _LoanCalculatorViewState();
}

class _LoanCalculatorViewState extends State<_LoanCalculatorView> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _tenureController = TextEditingController();

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    _tenureController.dispose();
    super.dispose();
  }

  void _calculate() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final rate = double.tryParse(_rateController.text) ?? 0;
    final tenure = int.tryParse(_tenureController.text) ?? 0;

    context.read<LoanBloc>().add(
      CalculateLoan(principal: principal, interestRate: rate, tenure: tenure),
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
          'Loan/EMI Calculator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<LoanBloc, LoanState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Input Fields
                _buildInputCard(
                  icon: FontAwesomeIcons.dollarSign,
                  label: 'Loan Amount',
                  hint: 'Enter principal amount',
                  controller: _principalController,
                  color: const Color(0xFF6C5CE7),
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  icon: FontAwesomeIcons.percent,
                  label: 'Interest Rate (% per year)',
                  hint: 'Enter annual interest rate',
                  controller: _rateController,
                  color: const Color(0xFF00B894),
                ),
                const SizedBox(height: 16),
                _buildInputCard(
                  icon: FontAwesomeIcons.calendarDays,
                  label: 'Tenure (months)',
                  hint: 'Enter loan duration',
                  controller: _tenureController,
                  color: const Color(0xFFE17055),
                  isInteger: true,
                ),
                const SizedBox(height: 24),
                // Calculate Button
                ElevatedButton(
                  onPressed: _calculate,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6C5CE7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Calculate EMI',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                if (state.emi > 0) ...[
                  const SizedBox(height: 32),
                  // EMI Result
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6C5CE7).withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Monthly EMI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${state.emi.toStringAsFixed(2)}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'for ${state.tenure} months',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Breakdown
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          'Total Amount',
                          '₹${state.totalAmount.toStringAsFixed(2)}',
                          const Color(0xFF00B894),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildInfoCard(
                          'Total Interest',
                          '₹${state.totalInterest.toStringAsFixed(2)}',
                          const Color(0xFFE17055),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2C2C54),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Loan Breakdown',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              flex: (state.principal / state.totalAmount * 100)
                                  .round(),
                              child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF00B894),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8),
                                    bottomLeft: Radius.circular(8),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Principal',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex:
                                  (state.totalInterest /
                                          state.totalAmount *
                                          100)
                                      .round(),
                              child: Container(
                                height: 40,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE17055),
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(8),
                                    bottomRight: Radius.circular(8),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Interest',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildLegendItem(
                              'Principal',
                              '${(state.principal / state.totalAmount * 100).toStringAsFixed(1)}%',
                              const Color(0xFF00B894),
                            ),
                            _buildLegendItem(
                              'Interest',
                              '${(state.totalInterest / state.totalAmount * 100).toStringAsFixed(1)}%',
                              const Color(0xFFE17055),
                            ),
                          ],
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
    bool isInteger = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C54),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
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
            keyboardType: isInteger
                ? TextInputType.number
                : const TextInputType.numberWithOptions(decimal: true),
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

  Widget _buildInfoCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C54),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.6),
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 12,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
