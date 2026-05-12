import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/bmi_bloc.dart';
import '../bloc/bmi_event.dart';
import '../bloc/bmi_state.dart';

class BmiCalculatorScreen extends StatefulWidget {
  const BmiCalculatorScreen({super.key});

  @override
  State<BmiCalculatorScreen> createState() => _BmiCalculatorScreenState();
}

class _BmiCalculatorScreenState extends State<BmiCalculatorScreen> {
  double _height = 170;
  double _weight = 70;
  int _age = 25;
  bool _isMale = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BmiBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('BMI Calculator'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<BmiBloc, BmiState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  // Gender Selection
                  Row(
                    children: [
                      Expanded(
                        child: _GenderCard(
                          icon: Icons.male,
                          label: 'Male',
                          isSelected: _isMale,
                          onTap: () {
                            setState(() {
                              _isMale = true;
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _GenderCard(
                          icon: Icons.female,
                          label: 'Female',
                          isSelected: !_isMale,
                          onTap: () {
                            setState(() {
                              _isMale = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Height Slider
                  _InputCard(
                    child: Column(
                      children: [
                        const Text(
                          'HEIGHT',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 16,
                            letterSpacing: 1.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              _height.round().toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'cm',
                              style: TextStyle(
                                color: Colors.white60,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                        Slider(
                          value: _height,
                          min: 100,
                          max: 220,
                          activeColor: const Color(0xFF4ECDC4),
                          inactiveColor: Colors.white24,
                          onChanged: (value) {
                            setState(() {
                              _height = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Weight and Age
                  Row(
                    children: [
                      Expanded(
                        child: _InputCard(
                          child: Column(
                            children: [
                              const Text(
                                'WEIGHT',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.baseline,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    _weight.round().toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 40,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'kg',
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _CircleButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      setState(() {
                                        if (_weight > 30) _weight--;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  _CircleButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      setState(() {
                                        if (_weight < 300) _weight++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _InputCard(
                          child: Column(
                            children: [
                              const Text(
                                'AGE',
                                style: TextStyle(
                                  color: Colors.white60,
                                  fontSize: 16,
                                  letterSpacing: 1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _age.toString(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _CircleButton(
                                    icon: Icons.remove,
                                    onPressed: () {
                                      setState(() {
                                        if (_age > 1) _age--;
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  _CircleButton(
                                    icon: Icons.add,
                                    onPressed: () {
                                      setState(() {
                                        if (_age < 150) _age++;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Result Display
                  if (state.bmi != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(state.category!),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: _getCategoryColor(state.category!).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Your BMI',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.bmi!.toStringAsFixed(1),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 64,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            state.advice!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                  // Calculate Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<BmiBloc>().add(
                              CalculateBmiEvent(
                                height: _height,
                                weight: _weight,
                                age: _age,
                                isMale: _isMale,
                              ),
                            );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4ECDC4),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'CALCULATE',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Color _getCategoryColor(BmiCategory category) {
    switch (category) {
      case BmiCategory.underweight:
        return const Color(0xFF3498DB);
      case BmiCategory.normal:
        return const Color(0xFF2ECC71);
      case BmiCategory.overweight:
        return const Color(0xFFF39C12);
      case BmiCategory.obese:
        return const Color(0xFFE74C3C);
    }
  }
}

class _GenderCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderCard({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 150,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF4ECDC4).withOpacity(0.2) : const Color(0xFF2A2A3E),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF4ECDC4) : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: isSelected ? const Color(0xFF4ECDC4) : Colors.white60,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF4ECDC4) : Colors.white60,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InputCard extends StatelessWidget {
  final Widget child;

  const _InputCard({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A3E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFF4ECDC4).withOpacity(0.2),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: const Color(0xFF4ECDC4),
          size: 24,
        ),
      ),
    );
  }
}
