import 'package:flutter_bloc/flutter_bloc.dart';

import 'bmi_event.dart';
import 'bmi_state.dart';

class BmiBloc extends Bloc<BmiEvent, BmiState> {
  BmiBloc() : super(const BmiState.initial()) {
    on<CalculateBmiEvent>(_onCalculateBmi);
    on<ResetBmiEvent>(_onResetBmi);
  }

  void _onCalculateBmi(CalculateBmiEvent event, Emitter<BmiState> emit) {
    // Calculate BMI: weight (kg) / (height (m))^2
    final heightInMeters = event.height / 100;
    final bmi = event.weight / (heightInMeters * heightInMeters);

    // Determine category
    BmiCategory category;
    String message;
    String advice;

    if (bmi < 18.5) {
      category = BmiCategory.underweight;
      message = 'Underweight';
      advice = 'You may need to gain weight. Consult with a healthcare provider for a proper diet plan.';
    } else if (bmi >= 18.5 && bmi < 25) {
      category = BmiCategory.normal;
      message = 'Normal Weight';
      advice = 'Great! You have a healthy weight. Keep maintaining your healthy lifestyle.';
    } else if (bmi >= 25 && bmi < 30) {
      category = BmiCategory.overweight;
      message = 'Overweight';
      advice = 'Consider a balanced diet and regular exercise to achieve a healthier weight.';
    } else {
      category = BmiCategory.obese;
      message = 'Obese';
      advice = 'It\'s important to consult with a healthcare provider for a personalized weight management plan.';
    }

    emit(BmiState(
      bmi: bmi,
      category: category,
      message: message,
      advice: advice,
    ));
  }

  void _onResetBmi(ResetBmiEvent event, Emitter<BmiState> emit) {
    emit(const BmiState.initial());
  }
}
