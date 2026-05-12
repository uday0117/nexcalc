import 'package:equatable/equatable.dart';

class DiscountState extends Equatable {
  final double originalPrice;
  final double discountPercent;
  final double discountAmount;
  final double priceAfterDiscount;
  final double taxPercent;
  final double taxAmount;
  final double finalPrice;
  final double savings;

  const DiscountState({
    this.originalPrice = 0.0,
    this.discountPercent = 0.0,
    this.discountAmount = 0.0,
    this.priceAfterDiscount = 0.0,
    this.taxPercent = 0.0,
    this.taxAmount = 0.0,
    this.finalPrice = 0.0,
    this.savings = 0.0,
  });

  DiscountState copyWith({
    double? originalPrice,
    double? discountPercent,
    double? discountAmount,
    double? priceAfterDiscount,
    double? taxPercent,
    double? taxAmount,
    double? finalPrice,
    double? savings,
  }) {
    return DiscountState(
      originalPrice: originalPrice ?? this.originalPrice,
      discountPercent: discountPercent ?? this.discountPercent,
      discountAmount: discountAmount ?? this.discountAmount,
      priceAfterDiscount: priceAfterDiscount ?? this.priceAfterDiscount,
      taxPercent: taxPercent ?? this.taxPercent,
      taxAmount: taxAmount ?? this.taxAmount,
      finalPrice: finalPrice ?? this.finalPrice,
      savings: savings ?? this.savings,
    );
  }

  @override
  List<Object?> get props => [
    originalPrice,
    discountPercent,
    discountAmount,
    priceAfterDiscount,
    taxPercent,
    taxAmount,
    finalPrice,
    savings,
  ];
}
