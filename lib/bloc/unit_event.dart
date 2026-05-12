import 'package:equatable/equatable.dart';

enum ConversionType { length, weight, temperature }

enum LengthUnit { meters, kilometers, miles, feet, inches, centimeters }

enum WeightUnit { kilograms, grams, pounds, ounces }

enum TemperatureUnit { celsius, fahrenheit, kelvin }

abstract class UnitEvent extends Equatable {
  const UnitEvent();

  @override
  List<Object?> get props => [];
}

class ChangeConversionTypeEvent extends UnitEvent {
  final ConversionType type;

  const ChangeConversionTypeEvent(this.type);

  @override
  List<Object?> get props => [type];
}

class ConvertValueEvent extends UnitEvent {
  final double value;
  final dynamic fromUnit;
  final dynamic toUnit;
  final ConversionType type;

  const ConvertValueEvent({
    required this.value,
    required this.fromUnit,
    required this.toUnit,
    required this.type,
  });

  @override
  List<Object?> get props => [value, fromUnit, toUnit, type];
}

class SwapUnitsEvent extends UnitEvent {
  const SwapUnitsEvent();
}

class ResetConverterEvent extends UnitEvent {
  const ResetConverterEvent();
}
