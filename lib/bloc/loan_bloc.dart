import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'loan_event.dart';
import 'loan_state.dart';

class LoanBloc extends Bloc<LoanEvent, LoanState> {
  LoanBloc() : super(const LoanState()) {
    on<CalculateLoan>(_onCalculateLoan);
  }

  void _onCalculateLoan(CalculateLoan event, Emitter<LoanState> emit) {
    if (event.principal <= 0 || event.interestRate < 0 || event.tenure <= 0) {
      emit(const LoanState());
      return;
    }

    // Convert annual interest rate to monthly
    final monthlyRate = event.interestRate / 12 / 100;

    double emi;
    if (monthlyRate == 0) {
      // If interest rate is 0, simple division
      emi = event.principal / event.tenure;
    } else {
      // EMI = [P x R x (1+R)^N]/[(1+R)^N-1]
      final rateFactorN = pow(1 + monthlyRate, event.tenure);
      emi = (event.principal * monthlyRate * rateFactorN) / (rateFactorN - 1);
    }

    final totalAmount = emi * event.tenure;
    final totalInterest = totalAmount - event.principal;

    emit(
      LoanState(
        principal: event.principal,
        interestRate: event.interestRate,
        tenure: event.tenure,
        emi: emi,
        totalAmount: totalAmount,
        totalInterest: totalInterest,
      ),
    );
  }
}
