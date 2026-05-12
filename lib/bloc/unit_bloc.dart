import 'package:flutter_bloc/flutter_bloc.dart';

import 'unit_event.dart';
import 'unit_state.dart';

class UnitBloc extends Bloc<UnitEvent, UnitState> {
  UnitBloc()
      : super(const UnitState(
          fromUnit: LengthUnit.meters,
          toUnit: LengthUnit.kilometers,
        )) {
    on<ChangeConversionTypeEvent>(_onChangeConversionType);
    on<ConvertValueEvent>(_onConvertValue);
    on<SwapUnitsEvent>(_onSwapUnits);
    on<ResetConverterEvent>(_onResetConverter);
  }

  void _onChangeConversionType(ChangeConversionTypeEvent event, Emitter<UnitState> emit) {
    dynamic fromUnit;
    dynamic toUnit;

    switch (event.type) {
      case ConversionType.length:
        fromUnit = LengthUnit.meters;
        toUnit = LengthUnit.kilometers;
        break;
      case ConversionType.weight:
        fromUnit = WeightUnit.kilograms;
        toUnit = WeightUnit.grams;
        break;
      case ConversionType.temperature:
        fromUnit = TemperatureUnit.celsius;
        toUnit = TemperatureUnit.fahrenheit;
        break;
    }

    emit(UnitState(
      conversionType: event.type,
      fromUnit: fromUnit,
      toUnit: toUnit,
      inputValue: 0,
      outputValue: null,
    ));
  }

  void _onConvertValue(ConvertValueEvent event, Emitter<UnitState> emit) {
    double result = 0;

    switch (event.type) {
      case ConversionType.length:
        result = _convertLength(event.value, event.fromUnit as LengthUnit, event.toUnit as LengthUnit);
        break;
      case ConversionType.weight:
        result = _convertWeight(event.value, event.fromUnit as WeightUnit, event.toUnit as WeightUnit);
        break;
      case ConversionType.temperature:
        result = _convertTemperature(
            event.value, event.fromUnit as TemperatureUnit, event.toUnit as TemperatureUnit);
        break;
    }

    emit(state.copyWith(
      inputValue: event.value,
      outputValue: result,
      fromUnit: event.fromUnit,
      toUnit: event.toUnit,
    ));
  }

  void _onSwapUnits(SwapUnitsEvent event, Emitter<UnitState> emit) {
    emit(state.copyWith(
      fromUnit: state.toUnit,
      toUnit: state.fromUnit,
      inputValue: state.outputValue ?? 0,
      outputValue: state.inputValue,
    ));
  }

  void _onResetConverter(ResetConverterEvent event, Emitter<UnitState> emit) {
    emit(state.copyWith(
      inputValue: 0,
      outputValue: 0,
    ));
  }

  // Length conversions (base: meters)
  double _convertLength(double value, LengthUnit from, LengthUnit to) {
    // Convert to meters first
    double meters = 0;
    switch (from) {
      case LengthUnit.meters:
        meters = value;
        break;
      case LengthUnit.kilometers:
        meters = value * 1000;
        break;
      case LengthUnit.centimeters:
        meters = value / 100;
        break;
      case LengthUnit.miles:
        meters = value * 1609.34;
        break;
      case LengthUnit.feet:
        meters = value * 0.3048;
        break;
      case LengthUnit.inches:
        meters = value * 0.0254;
        break;
    }

    // Convert from meters to target unit
    switch (to) {
      case LengthUnit.meters:
        return meters;
      case LengthUnit.kilometers:
        return meters / 1000;
      case LengthUnit.centimeters:
        return meters * 100;
      case LengthUnit.miles:
        return meters / 1609.34;
      case LengthUnit.feet:
        return meters / 0.3048;
      case LengthUnit.inches:
        return meters / 0.0254;
    }
  }

  // Weight conversions (base: kilograms)
  double _convertWeight(double value, WeightUnit from, WeightUnit to) {
    // Convert to kilograms first
    double kilograms = 0;
    switch (from) {
      case WeightUnit.kilograms:
        kilograms = value;
        break;
      case WeightUnit.grams:
        kilograms = value / 1000;
        break;
      case WeightUnit.pounds:
        kilograms = value * 0.453592;
        break;
      case WeightUnit.ounces:
        kilograms = value * 0.0283495;
        break;
    }

    // Convert from kilograms to target unit
    switch (to) {
      case WeightUnit.kilograms:
        return kilograms;
      case WeightUnit.grams:
        return kilograms * 1000;
      case WeightUnit.pounds:
        return kilograms / 0.453592;
      case WeightUnit.ounces:
        return kilograms / 0.0283495;
    }
  }

  // Temperature conversions
  double _convertTemperature(double value, TemperatureUnit from, TemperatureUnit to) {
    // Convert to Celsius first
    double celsius = 0;
    switch (from) {
      case TemperatureUnit.celsius:
        celsius = value;
        break;
      case TemperatureUnit.fahrenheit:
        celsius = (value - 32) * 5 / 9;
        break;
      case TemperatureUnit.kelvin:
        celsius = value - 273.15;
        break;
    }

    // Convert from Celsius to target unit
    switch (to) {
      case TemperatureUnit.celsius:
        return celsius;
      case TemperatureUnit.fahrenheit:
        return (celsius * 9 / 5) + 32;
      case TemperatureUnit.kelvin:
        return celsius + 273.15;
    }
  }
}
