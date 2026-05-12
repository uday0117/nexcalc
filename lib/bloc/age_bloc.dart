import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import 'age_event.dart';
import 'age_state.dart';

class AgeBloc extends Bloc<AgeEvent, AgeState> {
  AgeBloc() : super(const AgeState()) {
    on<CalculateAge>(_onCalculateAge);
    on<ResetAge>(_onResetAge);
  }

  void _onCalculateAge(CalculateAge event, Emitter<AgeState> emit) {
    final now = DateTime.now();
    final birthDate = event.birthDate;

    // Validate birth date is not in the future
    if (birthDate.isAfter(now)) {
      emit(state.copyWith(isCalculated: false));
      return;
    }

    // Calculate age
    int years = now.year - birthDate.year;
    int months = now.month - birthDate.month;
    int days = now.day - birthDate.day;

    // Adjust for negative days
    if (days < 0) {
      months--;
      // Get the number of days in the previous month
      final previousMonth = DateTime(now.year, now.month, 0);
      days += previousMonth.day;
    }

    // Adjust for negative months
    if (months < 0) {
      years--;
      months += 12;
    }

    // Calculate total days lived
    final totalDays = now.difference(birthDate).inDays;

    // Calculate next birthday
    DateTime nextBirthday = DateTime(now.year, birthDate.month, birthDate.day);
    if (nextBirthday.isBefore(now) || nextBirthday.isAtSameMomentAs(now)) {
      nextBirthday = DateTime(now.year + 1, birthDate.month, birthDate.day);
    }

    final daysUntilBirthday = nextBirthday.difference(now).inDays;
    final nextBirthdayFormatted = DateFormat(
      'MMM dd, yyyy',
    ).format(nextBirthday);
    final nextBirthdayText = daysUntilBirthday == 0
        ? 'Today! 🎉'
        : '$daysUntilBirthday days ($nextBirthdayFormatted)';

    emit(
      state.copyWith(
        years: years,
        months: months,
        days: days,
        totalDays: totalDays,
        nextBirthday: nextBirthdayText,
        isCalculated: true,
      ),
    );
  }

  void _onResetAge(ResetAge event, Emitter<AgeState> emit) {
    emit(const AgeState());
  }
}
