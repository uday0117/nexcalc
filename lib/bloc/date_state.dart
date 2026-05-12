import 'package:equatable/equatable.dart';

class DateState extends Equatable {
  final DateTime? startDate;
  final DateTime? endDate;
  final int days;
  final int months;
  final int years;
  final DateTime? resultDate;
  final int totalDays;

  const DateState({
    this.startDate,
    this.endDate,
    this.days = 0,
    this.months = 0,
    this.years = 0,
    this.resultDate,
    this.totalDays = 0,
  });

  DateState copyWith({
    DateTime? startDate,
    DateTime? endDate,
    int? days,
    int? months,
    int? years,
    DateTime? resultDate,
    int? totalDays,
  }) {
    return DateState(
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      days: days ?? this.days,
      months: months ?? this.months,
      years: years ?? this.years,
      resultDate: resultDate ?? this.resultDate,
      totalDays: totalDays ?? this.totalDays,
    );
  }

  @override
  List<Object?> get props => [
        startDate,
        endDate,
        days,
        months,
        years,
        resultDate,
        totalDays,
      ];
}
