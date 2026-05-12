import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/unit_bloc.dart';
import '../bloc/unit_event.dart';
import '../bloc/unit_state.dart';

class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});

  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  final TextEditingController _inputController = TextEditingController();

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UnitBloc(),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text('Unit Converter'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: BlocBuilder<UnitBloc, UnitState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Conversion Type Selection
                  const Text(
                    'Conversion Type',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _TypeButton(
                        label: 'Length',
                        icon: Icons.straighten,
                        isSelected: state.conversionType == ConversionType.length,
                        onTap: () {
                          context.read<UnitBloc>().add(
                                const ChangeConversionTypeEvent(ConversionType.length),
                              );
                          _inputController.clear();
                        },
                      ),
                      const SizedBox(width: 12),
                      _TypeButton(
                        label: 'Weight',
                        icon: Icons.fitness_center,
                        isSelected: state.conversionType == ConversionType.weight,
                        onTap: () {
                          context.read<UnitBloc>().add(
                                const ChangeConversionTypeEvent(ConversionType.weight),
                              );
                          _inputController.clear();
                        },
                      ),
                      const SizedBox(width: 12),
                      _TypeButton(
                        label: 'Temp',
                        icon: Icons.thermostat,
                        isSelected: state.conversionType == ConversionType.temperature,
                        onTap: () {
                          context.read<UnitBloc>().add(
                                const ChangeConversionTypeEvent(ConversionType.temperature),
                              );
                          _inputController.clear();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // From Unit
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A3E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'From',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildUnitDropdown(
                          context,
                          state.conversionType,
                          state.fromUnit,
                          true,
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _inputController,
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                          decoration: const InputDecoration(
                            hintText: '0',
                            hintStyle: TextStyle(
                              color: Colors.white30,
                              fontSize: 32,
                            ),
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            final numValue = double.tryParse(value) ?? 0;
                            context.read<UnitBloc>().add(
                                  ConvertValueEvent(
                                    value: numValue,
                                    fromUnit: state.fromUnit,
                                    toUnit: state.toUnit,
                                    type: state.conversionType,
                                  ),
                                );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Swap Button
                  Center(
                    child: InkWell(
                      onTap: () {
                        context.read<UnitBloc>().add(const SwapUnitsEvent());
                        _inputController.text = state.outputValue?.toStringAsFixed(4) ?? '0';
                      },
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFE66D),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFFFE66D).withOpacity(0.3),
                              blurRadius: 15,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.swap_vert,
                          color: Colors.black87,
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // To Unit
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2A3E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'To',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _buildUnitDropdown(
                          context,
                          state.conversionType,
                          state.toUnit,
                          false,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          state.outputValue?.toStringAsFixed(4) ?? '0',
                          style: const TextStyle(
                            color: Color(0xFFFFE66D),
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildUnitDropdown(
    BuildContext context,
    ConversionType type,
    dynamic currentUnit,
    bool isFrom,
  ) {
    List<dynamic> units;
    String Function(dynamic) getLabel;

    switch (type) {
      case ConversionType.length:
        units = LengthUnit.values;
        getLabel = (unit) => _getLengthUnitLabel(unit);
        break;
      case ConversionType.weight:
        units = WeightUnit.values;
        getLabel = (unit) => _getWeightUnitLabel(unit);
        break;
      case ConversionType.temperature:
        units = TemperatureUnit.values;
        getLabel = (unit) => _getTemperatureUnitLabel(unit);
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<dynamic>(
        value: currentUnit,
        isExpanded: true,
        underline: const SizedBox(),
        dropdownColor: const Color(0xFF2A2A3E),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        items: units.map((unit) {
          return DropdownMenuItem(
            value: unit,
            child: Text(getLabel(unit)),
          );
        }).toList(),
        onChanged: (value) {
          final state = context.read<UnitBloc>().state;
          if (isFrom) {
            context.read<UnitBloc>().add(
                  ConvertValueEvent(
                    value: state.inputValue,
                    fromUnit: value,
                    toUnit: state.toUnit,
                    type: type,
                  ),
                );
          } else {
            context.read<UnitBloc>().add(
                  ConvertValueEvent(
                    value: state.inputValue,
                    fromUnit: state.fromUnit,
                    toUnit: value,
                    type: type,
                  ),
                );
          }
        },
      ),
    );
  }

  String _getLengthUnitLabel(LengthUnit unit) {
    switch (unit) {
      case LengthUnit.meters:
        return 'Meters (m)';
      case LengthUnit.kilometers:
        return 'Kilometers (km)';
      case LengthUnit.centimeters:
        return 'Centimeters (cm)';
      case LengthUnit.miles:
        return 'Miles (mi)';
      case LengthUnit.feet:
        return 'Feet (ft)';
      case LengthUnit.inches:
        return 'Inches (in)';
    }
  }

  String _getWeightUnitLabel(WeightUnit unit) {
    switch (unit) {
      case WeightUnit.kilograms:
        return 'Kilograms (kg)';
      case WeightUnit.grams:
        return 'Grams (g)';
      case WeightUnit.pounds:
        return 'Pounds (lb)';
      case WeightUnit.ounces:
        return 'Ounces (oz)';
    }
  }

  String _getTemperatureUnitLabel(TemperatureUnit unit) {
    switch (unit) {
      case TemperatureUnit.celsius:
        return 'Celsius (°C)';
      case TemperatureUnit.fahrenheit:
        return 'Fahrenheit (°F)';
      case TemperatureUnit.kelvin:
        return 'Kelvin (K)';
    }
  }
}

class _TypeButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TypeButton({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFFFE66D).withOpacity(0.2) : const Color(0xFF2A2A3E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFFFE66D) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? const Color(0xFFFFE66D) : Colors.white60,
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFFFFE66D) : Colors.white60,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
