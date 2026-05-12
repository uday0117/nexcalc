import 'package:equatable/equatable.dart';

import 'unit_event.dart';

class UnitState extends Equatable {
  final ConversionType conversionType;
  final double inputValue;
  final double? outputValue;
  final dynamic fromUnit;
  final dynamic toUnit;

  const UnitState({
    this.conversionType = ConversionType.length,
    this.inputValue = 0,
    this.outputValue,
    this.fromUnit,
    this.toUnit,
  });

  UnitState copyWith({
    ConversionType? conversionType,
    double? inputValue,
    double? outputValue,
    dynamic fromUnit,
    dynamic toUnit,
  }) {
    return UnitState(
      conversionType: conversionType ?? this.conversionType,
      inputValue: inputValue ?? this.inputValue,
      outputValue: outputValue ?? this.outputValue,
      fromUnit: fromUnit ?? this.fromUnit,
      toUnit: toUnit ?? this.toUnit,
    );
  }

  @override
  List<Object?> get props => [conversionType, inputValue, outputValue, fromUnit, toUnit];
}
