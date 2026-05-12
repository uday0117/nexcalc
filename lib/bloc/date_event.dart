import 'package:equatable/equatable.dart';

abstract class DateEvent extends Equatable {
  const DateEvent();

  @override
  List<Object?> get props => [];
}

class CalculateDateDifference extends DateEvent {
  final DateTime startDate;
  final DateTime endDate;

  const CalculateDateDifference({
    required this.startDate,
    required this.endDate,
  });

  @override
  List<Object?> get props => [startDate, endDate];
}

class AddDaysToDate extends DateEvent {
  final DateTime date;
  final int days;

  const AddDaysToDate({
    required this.date,
    required this.days,
  });

  @override
  List<Object?> get props => [date, days];
}
