import 'package:equatable/equatable.dart';

abstract class BmiEvent extends Equatable {
  const BmiEvent();

  @override
  List<Object?> get props => [];
}

class CalculateBmiEvent extends BmiEvent {
  final double height; // in cm
  final double weight; // in kg
  final int age;
  final bool isMale;

  const CalculateBmiEvent({
    required this.height,
    required this.weight,
    required this.age,
    required this.isMale,
  });

  @override
  List<Object?> get props => [height, weight, age, isMale];
}

class ResetBmiEvent extends BmiEvent {
  const ResetBmiEvent();
}
