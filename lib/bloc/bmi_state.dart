import 'package:equatable/equatable.dart';

enum BmiCategory { underweight, normal, overweight, obese }

class BmiState extends Equatable {
  final double? bmi;
  final BmiCategory? category;
  final String? message;
  final String? advice;

  const BmiState({this.bmi, this.category, this.message, this.advice});

  const BmiState.initial() : this();

  BmiState copyWith({
    double? bmi,
    BmiCategory? category,
    String? message,
    String? advice,
  }) {
    return BmiState(
      bmi: bmi ?? this.bmi,
      category: category ?? this.category,
      message: message ?? this.message,
      advice: advice ?? this.advice,
    );
  }

  @override
  List<Object?> get props => [bmi, category, message, advice];
}
