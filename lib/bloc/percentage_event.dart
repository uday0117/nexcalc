import 'package:equatable/equatable.dart';

abstract class PercentageEvent extends Equatable {
  const PercentageEvent();

  @override
  List<Object?> get props => [];
}

class CalculatePercentageOf extends PercentageEvent {
  final double percentage;
  final double number;

  const CalculatePercentageOf({required this.percentage, required this.number});

  @override
  List<Object?> get props => [percentage, number];
}

class CalculatePercentageChange extends PercentageEvent {
  final double oldValue;
  final double newValue;

  const CalculatePercentageChange({
    required this.oldValue,
    required this.newValue,
  });

  @override
  List<Object?> get props => [oldValue, newValue];
}

class CalculateDiscount extends PercentageEvent {
  final double originalPrice;
  final double discountPercentage;

  const CalculateDiscount({
    required this.originalPrice,
    required this.discountPercentage,
  });

  @override
  List<Object?> get props => [originalPrice, discountPercentage];
}

class ResetPercentage extends PercentageEvent {
  const ResetPercentage();
}
