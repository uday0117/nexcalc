import 'package:equatable/equatable.dart';

class LoanState extends Equatable {
  final double principal;
  final double interestRate;
  final int tenure;
  final double emi;
  final double totalAmount;
  final double totalInterest;

  const LoanState({
    this.principal = 0.0,
    this.interestRate = 0.0,
    this.tenure = 0,
    this.emi = 0.0,
    this.totalAmount = 0.0,
    this.totalInterest = 0.0,
  });

  LoanState copyWith({
    double? principal,
    double? interestRate,
    int? tenure,
    double? emi,
    double? totalAmount,
    double? totalInterest,
  }) {
    return LoanState(
      principal: principal ?? this.principal,
      interestRate: interestRate ?? this.interestRate,
      tenure: tenure ?? this.tenure,
      emi: emi ?? this.emi,
      totalAmount: totalAmount ?? this.totalAmount,
      totalInterest: totalInterest ?? this.totalInterest,
    );
  }

  @override
  List<Object?> get props => [
    principal,
    interestRate,
    tenure,
    emi,
    totalAmount,
    totalInterest,
  ];
}
