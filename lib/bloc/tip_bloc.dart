import 'package:flutter_bloc/flutter_bloc.dart';

import 'tip_event.dart';
import 'tip_state.dart';

class TipBloc extends Bloc<TipEvent, TipState> {
  TipBloc() : super(const TipState()) {
    on<CalculateTip>(_onCalculateTip);
    on<ResetTip>(_onResetTip);
  }

  void _onCalculateTip(CalculateTip event, Emitter<TipState> emit) {
    if (event.billAmount <= 0 || event.numberOfPeople <= 0) {
      emit(state.copyWith(isCalculated: false));
      return;
    }

    final tipAmount = event.billAmount * (event.tipPercentage / 100);
    final totalAmount = event.billAmount + tipAmount;
    final amountPerPerson = totalAmount / event.numberOfPeople;

    emit(
      state.copyWith(
        tipAmount: tipAmount,
        totalAmount: totalAmount,
        amountPerPerson: amountPerPerson,
        isCalculated: true,
      ),
    );
  }

  void _onResetTip(ResetTip event, Emitter<TipState> emit) {
    emit(const TipState());
  }
}
