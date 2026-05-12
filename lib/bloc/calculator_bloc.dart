import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:math_expressions/math_expressions.dart';

import 'calculator_event.dart';
import 'calculator_state.dart';

class CalculatorBloc extends Bloc<CalculatorEvent, CalculatorState> {
  CalculatorBloc() : super(const CalculatorState()) {
    on<NumberPressed>(_onNumberPressed);
    on<OperatorPressed>(_onOperatorPressed);
    on<EqualsPressed>(_onEqualsPressed);
    on<ClearPressed>(_onClearPressed);
    on<DeletePressed>(_onDeletePressed);
    on<DecimalPressed>(_onDecimalPressed);
  }

  void _onNumberPressed(NumberPressed event, Emitter<CalculatorState> emit) {
    String newExpression;
    String newDisplay;

    if (state.display == '0' || state.hasError || state.result != null) {
      newExpression = event.number;
      newDisplay = event.number;
    } else {
      newExpression = state.expression + event.number;
      newDisplay = state.display + event.number;
    }

    emit(
      CalculatorState(
        display: newDisplay,
        expression: newExpression,
        result: null,
        hasError: false,
      ),
    );
  }

  void _onOperatorPressed(
    OperatorPressed event,
    Emitter<CalculatorState> emit,
  ) {
    if (state.hasError) {
      return;
    }

    String newExpression;
    String newDisplay;

    // If there's a result, use it as the starting point
    if (state.result != null) {
      newExpression = state.result! + event.operator;
      newDisplay = state.result! + event.operator;
    } else if (state.expression.isEmpty) {
      // If expression is empty, start with 0
      newExpression = '0${event.operator}';
      newDisplay = '0${event.operator}';
    } else {
      // Check if last character is already an operator
      final lastChar = state.expression[state.expression.length - 1];
      if (_isOperator(lastChar)) {
        // Replace the last operator
        newExpression =
            state.expression.substring(0, state.expression.length - 1) +
            event.operator;
        newDisplay =
            state.display.substring(0, state.display.length - 1) +
            event.operator;
      } else {
        newExpression = state.expression + event.operator;
        newDisplay = state.display + event.operator;
      }
    }

    emit(
      CalculatorState(
        display: newDisplay,
        expression: newExpression,
        result: null,
        hasError: false,
      ),
    );
  }

  void _onEqualsPressed(EqualsPressed event, Emitter<CalculatorState> emit) {
    if (state.expression.isEmpty || state.hasError) {
      return;
    }

    try {
      // Replace operators with math_expressions compatible symbols
      String exp = state.expression.replaceAll('×', '*').replaceAll('÷', '/');

      // Check if the last character is an operator
      if (_isOperator(exp[exp.length - 1])) {
        exp = exp.substring(0, exp.length - 1);
      }

      Parser parser = Parser();
      Expression expression = parser.parse(exp);
      ContextModel cm = ContextModel();
      double eval = expression.evaluate(EvaluationType.REAL, cm);

      // Format the result
      String result;
      if (eval == eval.toInt()) {
        result = eval.toInt().toString();
      } else {
        result = eval
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0*$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }

      emit(
        CalculatorState(
          display: result,
          expression: state.expression,
          result: result,
          hasError: false,
        ),
      );
    } catch (e) {
      emit(
        CalculatorState(
          display: 'Error',
          expression: state.expression,
          hasError: true,
          errorMessage: 'Invalid expression',
        ),
      );
    }
  }

  void _onClearPressed(ClearPressed event, Emitter<CalculatorState> emit) {
    emit(const CalculatorState());
  }

  void _onDeletePressed(DeletePressed event, Emitter<CalculatorState> emit) {
    if (state.hasError || state.result != null) {
      emit(const CalculatorState());
      return;
    }

    if (state.expression.isEmpty || state.expression == '0') {
      return;
    }

    String newExpression = state.expression.substring(
      0,
      state.expression.length - 1,
    );
    String newDisplay = state.display.substring(0, state.display.length - 1);

    if (newExpression.isEmpty) {
      emit(const CalculatorState());
    } else {
      emit(
        CalculatorState(
          display: newDisplay,
          expression: newExpression,
          result: null,
          hasError: false,
        ),
      );
    }
  }

  void _onDecimalPressed(DecimalPressed event, Emitter<CalculatorState> emit) {
    if (state.hasError) {
      return;
    }

    // Get the current number (after the last operator or from the beginning)
    String currentNumber = _getCurrentNumber(state.expression);

    // Check if the current number already has a decimal point
    if (currentNumber.contains('.')) {
      return;
    }

    String newExpression;
    String newDisplay;

    if (state.result != null) {
      newExpression = '${state.result!}.';
      newDisplay = '${state.result!}.';
    } else if (state.expression.isEmpty ||
        _isOperator(state.expression[state.expression.length - 1])) {
      newExpression = '${state.expression}0.';
      newDisplay = '${state.display}0.';
    } else {
      newExpression = '${state.expression}.';
      newDisplay = '${state.display}.';
    }

    emit(
      CalculatorState(
        display: newDisplay,
        expression: newExpression,
        result: null,
        hasError: false,
      ),
    );
  }

  bool _isOperator(String char) {
    return char == '+' ||
        char == '-' ||
        char == '×' ||
        char == '÷' ||
        char == '*' ||
        char == '/';
  }

  String _getCurrentNumber(String expression) {
    if (expression.isEmpty) {
      return '';
    }

    int lastOperatorIndex = -1;
    for (int i = expression.length - 1; i >= 0; i--) {
      if (_isOperator(expression[i])) {
        lastOperatorIndex = i;
        break;
      }
    }

    if (lastOperatorIndex == -1) {
      return expression;
    } else {
      return expression.substring(lastOperatorIndex + 1);
    }
  }
}
