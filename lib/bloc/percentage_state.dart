import 'package:equatable/equatable.dart';

enum PercentageCalculationType { percentageOf, percentageChange, discount }

class PercentageState extends Equatable {
  final double result;
  final String resultLabel;
  final bool isCalculated;
  final PercentageCalculationType? calculationType;
  final double?
  additionalInfo; // For discount: savings, For change: change amount

  const PercentageState({
    this.result = 0.0,
    this.resultLabel = '',
    this.isCalculated = false,
    this.calculationType,
    this.additionalInfo,
  });

  PercentageState copyWith({
    double? result,
    String? resultLabel,
    bool? isCalculated,
    PercentageCalculationType? calculationType,
    double? additionalInfo,
  }) {
    return PercentageState(
      result: result ?? this.result,
      resultLabel: resultLabel ?? this.resultLabel,
      isCalculated: isCalculated ?? this.isCalculated,
      calculationType: calculationType ?? this.calculationType,
      additionalInfo: additionalInfo ?? this.additionalInfo,
    );
  }

  @override
  List<Object?> get props => [
    result,
    resultLabel,
    isCalculated,
    calculationType,
    additionalInfo,
  ];
}
