import 'package:flutter_bloc/flutter_bloc.dart';

import 'date_event.dart';
import 'date_state.dart';

class DateBloc extends Bloc<DateEvent, DateState> {
  DateBloc() : super(const DateState()) {
    on<CalculateDateDifference>(_onCalculateDateDifference);
    on<AddDaysToDate>(_onAddDaysToDate);
  }

  void _onCalculateDateDifference(
    CalculateDateDifference event,
    Emitter<DateState> emit,
  ) {
    final difference = event.endDate.difference(event.startDate);
    final totalDays = difference.inDays.abs();

    int years = 0;
    int months = 0;
    int days = 0;

    // Calculate years, months, and days
    DateTime temp = event.startDate;
    while (temp.add(Duration(days: 365)).isBefore(event.endDate) ||
        temp.add(Duration(days: 365)).isAtSameMomentAs(event.endDate)) {
      years++;
      temp = temp.add(Duration(days: 365));
    }

    while (temp.add(Duration(days: 30)).isBefore(event.endDate) ||
        temp.add(Duration(days: 30)).isAtSameMomentAs(event.endDate)) {
      months++;
      temp = temp.add(Duration(days: 30));
    }

    days = event.endDate.difference(temp).inDays;

    emit(
      DateState(
        startDate: event.startDate,
        endDate: event.endDate,
        years: years,
        months: months,
        days: days,
        totalDays: totalDays,
      ),
    );
  }

  void _onAddDaysToDate(AddDaysToDate event, Emitter<DateState> emit) {
    final resultDate = event.date.add(Duration(days: event.days));

    emit(
      DateState(
        startDate: event.date,
        resultDate: resultDate,
        totalDays: event.days,
      ),
    );
  }
}
