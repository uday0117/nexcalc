import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/tip_bloc.dart';
import '../bloc/tip_event.dart';
import '../bloc/tip_state.dart';

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final TextEditingController _billController = TextEditingController();
  double _tipPercentage = 15.0;
  int _numberOfPeople = 1;

  @override
  void dispose() {
    _billController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TipBloc(),
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
            'Tip Calculator',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: BlocBuilder<TipBloc, TipState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bill Amount Card
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Bill Amount',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _billController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          style: const TextStyle(
                            fontSize: 32,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: InputDecoration(
                            hintText: '\$0.00',
                            hintStyle: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                            ),
                            border: InputBorder.none,
                            prefixIcon: const Icon(
                              Icons.attach_money,
                              color: Color(0xFF4ECDC4),
                              size: 32,
                            ),
                          ),
                          onChanged: (value) => _calculate(context),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Tip Percentage
                  _buildCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Tip Percentage',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              '${_tipPercentage.toStringAsFixed(0)}%',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Color(0xFF4ECDC4),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Slider(
                          value: _tipPercentage,
                          min: 0,
                          max: 50,
                          divisions: 50,
                          activeColor: const Color(0xFF4ECDC4),
                          inactiveColor: Colors.white12,
                          onChanged: (value) {
                            setState(() {
                              _tipPercentage = value;
                            });
                            _calculate(context);
                          },
                        ),
                        // Preset tip buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildPresetButton('10%', 10),
                            _buildPresetButton('15%', 15),
                            _buildPresetButton('18%', 18),
                            _buildPresetButton('20%', 20),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Number of People
                  _buildCard(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Split Between',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (_numberOfPeople > 1) {
                                  setState(() {
                                    _numberOfPeople--;
                                  });
                                  _calculate(context);
                                }
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                                color: Color(0xFF4ECDC4),
                              ),
                            ),
                            Container(
                              width: 60,
                              alignment: Alignment.center,
                              child: Text(
                                '$_numberOfPeople',
                                style: const TextStyle(
                                  fontSize: 24,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  _numberOfPeople++;
                                });
                                _calculate(context);
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                                color: Color(0xFF4ECDC4),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Results
                  if (state.isCalculated) ...[
                    const Text(
                      'Summary',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildResultCard(
                      'Tip Amount',
                      '\$${state.tipAmount.toStringAsFixed(2)}',
                      const Color(0xFF4ECDC4),
                    ),
                    const SizedBox(height: 12),
                    _buildResultCard(
                      'Total Amount',
                      '\$${state.totalAmount.toStringAsFixed(2)}',
                      const Color(0xFFFF6B6B),
                    ),
                    const SizedBox(height: 12),
                    _buildResultCard(
                      'Per Person',
                      '\$${state.amountPerPerson.toStringAsFixed(2)}',
                      const Color(0xFFFFE66D),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D44),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildPresetButton(String label, double percentage) {
    final isSelected = _tipPercentage == percentage;
    return GestureDetector(
      onTap: () {
        setState(() {
          _tipPercentage = percentage;
        });
        _calculate(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF4ECDC4)
              : Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF4ECDC4)
                : Colors.white.withOpacity(0.2),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.black : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 16, color: Colors.white70),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _calculate(BuildContext context) {
    final billAmount = double.tryParse(_billController.text) ?? 0.0;
    context.read<TipBloc>().add(
      CalculateTip(
        billAmount: billAmount,
        tipPercentage: _tipPercentage,
        numberOfPeople: _numberOfPeople,
      ),
    );
  }
}
