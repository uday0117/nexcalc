import 'package:equatable/equatable.dart';

abstract class TipEvent extends Equatable {
  const TipEvent();

  @override
  List<Object?> get props => [];
}

class CalculateTip extends TipEvent {
  final double billAmount;
  final double tipPercentage;
  final int numberOfPeople;

  const CalculateTip({
    required this.billAmount,
    required this.tipPercentage,
    required this.numberOfPeople,
  });

  @override
  List<Object?> get props => [billAmount, tipPercentage, numberOfPeople];
}

class ResetTip extends TipEvent {
  const ResetTip();
}
