import 'package:flutter_bloc/flutter_bloc.dart';

import 'percentage_event.dart';
import 'percentage_state.dart';

class PercentageBloc extends Bloc<PercentageEvent, PercentageState> {
  PercentageBloc() : super(const PercentageState()) {
    on<CalculatePercentageOf>(_onCalculatePercentageOf);
    on<CalculatePercentageChange>(_onCalculatePercentageChange);
    on<CalculateDiscount>(_onCalculateDiscount);
    on<ResetPercentage>(_onResetPercentage);
  }

  void _onCalculatePercentageOf(
    CalculatePercentageOf event,
    Emitter<PercentageState> emit,
  ) {
    final result = (event.percentage / 100) * event.number;
    emit(
      state.copyWith(
        result: result,
        resultLabel: '${event.percentage}% of ${event.number}',
        isCalculated: true,
        calculationType: PercentageCalculationType.percentageOf,
      ),
    );
  }

  void _onCalculatePercentageChange(
    CalculatePercentageChange event,
    Emitter<PercentageState> emit,
  ) {
    if (event.oldValue == 0) {
      emit(state.copyWith(isCalculated: false));
      return;
    }

    final change = event.newValue - event.oldValue;
    final percentageChange = (change / event.oldValue) * 100;

    emit(
      state.copyWith(
        result: percentageChange,
        resultLabel: percentageChange >= 0 ? 'Increase' : 'Decrease',
        isCalculated: true,
        calculationType: PercentageCalculationType.percentageChange,
        additionalInfo: change.abs(),
      ),
    );
  }

  void _onCalculateDiscount(
    CalculateDiscount event,
    Emitter<PercentageState> emit,
  ) {
    final discount = (event.discountPercentage / 100) * event.originalPrice;
    final finalPrice = event.originalPrice - discount;

    emit(
      state.copyWith(
        result: finalPrice,
        resultLabel: 'Final Price',
        isCalculated: true,
        calculationType: PercentageCalculationType.discount,
        additionalInfo: discount,
      ),
    );
  }

  void _onResetPercentage(
    ResetPercentage event,
    Emitter<PercentageState> emit,
  ) {
    emit(const PercentageState());
  }
}
