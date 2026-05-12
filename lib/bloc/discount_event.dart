import 'package:equatable/equatable.dart';

abstract class DiscountEvent extends Equatable {
  const DiscountEvent();

  @override
  List<Object?> get props => [];
}

class CalculateDiscount extends DiscountEvent {
  final double originalPrice;
  final double discountPercent;
  final double? taxPercent;

  const CalculateDiscount({
    required this.originalPrice,
    required this.discountPercent,
    this.taxPercent,
  });

  @override
  List<Object?> get props => [originalPrice, discountPercent, taxPercent];
}
