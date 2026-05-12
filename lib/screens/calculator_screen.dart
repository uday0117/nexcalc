import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/calculator_bloc.dart';
import '../bloc/calculator_event.dart';
import '../bloc/calculator_state.dart';
import '../widgets/calculator_button.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Calculator', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          // Display area
          Expanded(
            flex: 2,
            child: BlocBuilder<CalculatorBloc, CalculatorState>(
              builder: (context, state) {
                return Container(
                  padding: const EdgeInsets.all(24),
                  alignment: Alignment.bottomRight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      // Expression display
                      if (state.expression.isNotEmpty && !state.hasError)
                        Text(
                          state.expression,
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.right,
                        ),
                      const SizedBox(height: 8),
                      // Result display
                      Text(
                        state.display,
                        style: TextStyle(
                          fontSize: state.display.length > 8 ? 48 : 64,
                          color: state.hasError
                              ? Colors.red[400]
                              : Colors.white,
                          fontWeight: FontWeight.w300,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Buttons area
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  // First row
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(
                          text: 'C',
                          color: Colors.grey[700],
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const ClearPressed(),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '⌫',
                          color: Colors.grey[700],
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const DeletePressed(),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '÷',
                          color: Colors.orange[700],
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const OperatorPressed('÷'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Second row
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(
                          text: '7',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('7'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '8',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('8'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '9',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('9'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '×',
                          color: Colors.orange[700],
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const OperatorPressed('×'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Third row
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(
                          text: '4',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('4'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '5',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('5'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '6',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('6'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '-',
                          color: Colors.orange[700],
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const OperatorPressed('-'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Fourth row
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(
                          text: '1',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('1'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '2',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('2'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '3',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('3'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '+',
                          color: Colors.orange[700],
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const OperatorPressed('+'),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  // Fifth row
                  Expanded(
                    child: Row(
                      children: [
                        CalculatorButton(
                          text: '0',
                          isWide: true,
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const NumberPressed('0'),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '.',
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const DecimalPressed(),
                            );
                          },
                        ),
                        CalculatorButton(
                          text: '=',
                          color: Colors.orange,
                          onPressed: () {
                            context.read<CalculatorBloc>().add(
                              const EqualsPressed(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
