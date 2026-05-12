import 'package:flutter_bloc/flutter_bloc.dart';

import 'discount_event.dart';
import 'discount_state.dart';

class DiscountBloc extends Bloc<DiscountEvent, DiscountState> {
  DiscountBloc() : super(const DiscountState()) {
    on<CalculateDiscount>(_onCalculateDiscount);
  }

  void _onCalculateDiscount(
    CalculateDiscount event,
    Emitter<DiscountState> emit,
  ) {
    if (event.originalPrice <= 0) {
      emit(const DiscountState());
      return;
    }

    // Calculate discount
    final discountAmount = (event.originalPrice * event.discountPercent) / 100;
    final priceAfterDiscount = event.originalPrice - discountAmount;

    // Calculate tax if provided
    final taxPercent = event.taxPercent ?? 0;
    final taxAmount = (priceAfterDiscount * taxPercent) / 100;
    final finalPrice = priceAfterDiscount + taxAmount;

    // Calculate total savings
    final savings = event.originalPrice - priceAfterDiscount;

    emit(
      DiscountState(
        originalPrice: event.originalPrice,
        discountPercent: event.discountPercent,
        discountAmount: discountAmount,
        priceAfterDiscount: priceAfterDiscount,
        taxPercent: taxPercent,
        taxAmount: taxAmount,
        finalPrice: finalPrice,
        savings: savings,
      ),
    );
  }
}
