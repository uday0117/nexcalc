import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../bloc/date_bloc.dart';
import '../bloc/date_event.dart';
import '../bloc/date_state.dart';

class DateCalculatorScreen extends StatelessWidget {
  const DateCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DateBloc(),
      child: const _DateCalculatorView(),
    );
  }
}

class _DateCalculatorView extends StatefulWidget {
  const _DateCalculatorView();

  @override
  State<_DateCalculatorView> createState() => _DateCalculatorViewState();
}

class _DateCalculatorViewState extends State<_DateCalculatorView> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(const Duration(days: 30));
  final TextEditingController _daysController = TextEditingController();
  int _selectedTab = 0;

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isStartDate ? _startDate : _endDate,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFF00C9A7),
              surface: Color(0xFF2C2C54),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartDate) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });

      if (_selectedTab == 0) {
        context.read<DateBloc>().add(
          CalculateDateDifference(startDate: _startDate, endDate: _endDate),
        );
      }
    }
  }

  @override
  void dispose() {
    _daysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Date Calculator',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: BlocBuilder<DateBloc, DateState>(
        builder: (context, state) {
          return Column(
            children: [
              // Tab Selector
              Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: const Color(0xFF2C2C54),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTabButton(
                        'Date Difference',
                        0,
                        FontAwesomeIcons.calendar,
                      ),
                    ),
                    Expanded(
                      child: _buildTabButton(
                        'Add Days',
                        1,
                        FontAwesomeIcons.plus,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _selectedTab == 0
                      ? _buildDateDifferenceTab(context, state)
                      : _buildAddDaysTab(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTabButton(String label, int index, IconData icon) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTab = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00C9A7) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.white54,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.white54,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateDifferenceTab(BuildContext context, DateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDateCard(
          'From Date',
          _startDate,
          const Color(0xFF00C9A7),
          () => _selectDate(context, true),
        ),
        const SizedBox(height: 16),
        _buildDateCard(
          'To Date',
          _endDate,
          const Color(0xFF845EC2),
          () => _selectDate(context, false),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            context.read<DateBloc>().add(
              CalculateDateDifference(startDate: _startDate, endDate: _endDate),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00C9A7),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Calculate Difference',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (state.totalDays > 0) ...[
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00C9A7), Color(0xFF00A896)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00C9A7).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const FaIcon(
                  FontAwesomeIcons.calendarDays,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 16),
                Text(
                  '${state.years} years, ${state.months} months, ${state.days} days',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Total: ${state.totalDays} days',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildAddDaysTab(BuildContext context, DateState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDateCard(
          'Start Date',
          _startDate,
          const Color(0xFF845EC2),
          () => _selectDate(context, true),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF2C2C54),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFF00C9A7).withOpacity(0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const FaIcon(
                    FontAwesomeIcons.plus,
                    color: Color(0xFF00C9A7),
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Days to Add',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _daysController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter number of days',
                  hintStyle: TextStyle(
                    color: Colors.white.withOpacity(0.3),
                    fontSize: 20,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            final days = int.tryParse(_daysController.text) ?? 0;
            if (days != 0) {
              context.read<DateBloc>().add(
                AddDaysToDate(date: _startDate, days: days),
              );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF845EC2),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Calculate Result',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        if (state.resultDate != null) ...[
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF845EC2), Color(0xFF9B59B6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF845EC2).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const FaIcon(
                  FontAwesomeIcons.calendarCheck,
                  color: Colors.white,
                  size: 32,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Result Date',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  DateFormat('EEEE, MMMM d, y').format(state.resultDate!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateCard(
    String label,
    DateTime date,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF2C2C54),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(
                  FontAwesomeIcons.calendar,
                  color: color,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('MMM d, y').format(date),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.3),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}
