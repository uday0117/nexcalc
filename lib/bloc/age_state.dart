import 'package:equatable/equatable.dart';

class AgeState extends Equatable {
  final int years;
  final int months;
  final int days;
  final int totalDays;
  final String nextBirthday;
  final bool isCalculated;

  const AgeState({
    this.years = 0,
    this.months = 0,
    this.days = 0,
    this.totalDays = 0,
    this.nextBirthday = '',
    this.isCalculated = false,
  });

  AgeState copyWith({
    int? years,
    int? months,
    int? days,
    int? totalDays,
    String? nextBirthday,
    bool? isCalculated,
  }) {
    return AgeState(
      years: years ?? this.years,
      months: months ?? this.months,
      days: days ?? this.days,
      totalDays: totalDays ?? this.totalDays,
      nextBirthday: nextBirthday ?? this.nextBirthday,
      isCalculated: isCalculated ?? this.isCalculated,
    );
  }

  @override
  List<Object?> get props => [
    years,
    months,
    days,
    totalDays,
    nextBirthday,
    isCalculated,
  ];
}
