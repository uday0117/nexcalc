import 'package:equatable/equatable.dart';

class CalculatorState extends Equatable {
  final String display;
  final String expression;
  final String? result;
  final bool hasError;
  final String? errorMessage;

  const CalculatorState({
    this.display = '0',
    this.expression = '',
    this.result,
    this.hasError = false,
    this.errorMessage,
  });

  CalculatorState copyWith({
    String? display,
    String? expression,
    String? result,
    bool? hasError,
    String? errorMessage,
  }) {
    return CalculatorState(
      display: display ?? this.display,
      expression: expression ?? this.expression,
      result: result ?? this.result,
      hasError: hasError ?? this.hasError,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    display,
    expression,
    result,
    hasError,
    errorMessage,
  ];
}
