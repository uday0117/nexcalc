import 'package:equatable/equatable.dart';

class TipState extends Equatable {
  final double tipAmount;
  final double totalAmount;
  final double amountPerPerson;
  final bool isCalculated;

  const TipState({
    this.tipAmount = 0.0,
    this.totalAmount = 0.0,
    this.amountPerPerson = 0.0,
    this.isCalculated = false,
  });

  TipState copyWith({
    double? tipAmount,
    double? totalAmount,
    double? amountPerPerson,
    bool? isCalculated,
  }) {
    return TipState(
      tipAmount: tipAmount ?? this.tipAmount,
      totalAmount: totalAmount ?? this.totalAmount,
      amountPerPerson: amountPerPerson ?? this.amountPerPerson,
      isCalculated: isCalculated ?? this.isCalculated,
    );
  }

  @override
  List<Object?> get props => [
    tipAmount,
    totalAmount,
    amountPerPerson,
    isCalculated,
  ];
}
