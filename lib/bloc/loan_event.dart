import 'package:equatable/equatable.dart';

abstract class LoanEvent extends Equatable {
  const LoanEvent();

  @override
  List<Object?> get props => [];
}

class CalculateLoan extends LoanEvent {
  final double principal;
  final double interestRate;
  final int tenure; // in months

  const CalculateLoan({
    required this.principal,
    required this.interestRate,
    required this.tenure,
  });

  @override
  List<Object?> get props => [principal, interestRate, tenure];
}
