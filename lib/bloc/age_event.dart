import 'package:equatable/equatable.dart';

abstract class AgeEvent extends Equatable {
  const AgeEvent();

  @override
  List<Object?> get props => [];
}

class CalculateAge extends AgeEvent {
  final DateTime birthDate;

  const CalculateAge({required this.birthDate});

  @override
  List<Object?> get props => [birthDate];
}

class ResetAge extends AgeEvent {
  const ResetAge();
}
