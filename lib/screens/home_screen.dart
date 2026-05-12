import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../theme/theme_provider.dart';
import 'age_calculator_screen.dart';
import 'bmi_calculator_screen.dart';
import 'calculator_screen.dart';
import 'currency_converter_screen.dart';
import 'date_calculator_screen.dart';
import 'discount_calculator_screen.dart';
import 'loan_calculator_screen.dart';
import 'percentage_calculator_screen.dart';
import 'tip_calculator_screen.dart';
import 'unit_converter_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _version = '';

  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      _version = 'v${packageInfo.version}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'NexCalc',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.textColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Choose your tool',
                            style: TextStyle(
                              fontSize: 16,
                              color: themeProvider.subtitleColor,
                            ),
                          ),
                        ],
                      ),
                      // Theme Toggle - Clear indicator
                      GestureDetector(
                        onTap: () => themeProvider.toggleTheme(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF2C2C54)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? Colors.transparent
                                      : const Color(
                                          0xFFFFB84D,
                                        ).withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.sun,
                                  size: 16,
                                  color: isDark
                                      ? Colors.grey.shade600
                                      : const Color(0xFFFFB84D),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF4ECDC4).withOpacity(0.2)
                                      : Colors.transparent,
                                  shape: BoxShape.circle,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.moon,
                                  size: 16,
                                  color: isDark
                                      ? const Color(0xFF4ECDC4)
                                      : Colors.grey.shade400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Feature Cards
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main Tools Section
                    Text(
                      'Popular Tools',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: themeProvider.subtitleColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.9,
                      children: [
                        _FeatureCard(
                          title: 'Calculator',
                          subtitle: 'Basic Math',
                          icon: FontAwesomeIcons.calculator,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CalculatorScreen(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'BMI',
                          subtitle: 'Health Check',
                          icon: FontAwesomeIcons.heartPulse,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF4ECDC4), Color(0xFF44A08D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const BmiCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Unit Converter',
                          subtitle: 'Quick Convert',
                          icon: FontAwesomeIcons.arrowRightArrowLeft,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFFE66D), Color(0xFFFFAA00)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const UnitConverterScreen(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Currency',
                          subtitle: 'Exchange Rates',
                          icon: FontAwesomeIcons.dollarSign,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00D9FF), Color(0xFF0099CC)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const CurrencyConverterScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Financial Tools Section
                    Text(
                      'Financial Tools',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: themeProvider.subtitleColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.9,
                      children: [
                        _FeatureCard(
                          title: 'Tip',
                          subtitle: 'Split Bills',
                          icon: FontAwesomeIcons.moneyBill1Wave,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF11998E), Color(0xFF38EF7D)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const TipCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Discount',
                          subtitle: 'Save Money',
                          icon: FontAwesomeIcons.tag,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE17055), Color(0xFFFD79A8)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DiscountCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Loan/EMI',
                          subtitle: 'Calculate EMI',
                          icon: FontAwesomeIcons.handHoldingDollar,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const LoanCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Percentage',
                          subtitle: 'Quick Percent',
                          icon: FontAwesomeIcons.percent,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFC466B), Color(0xFF3F5EFB)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const PercentageCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Date & Personal Tools Section
                    Text(
                      'Personal Tools',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: themeProvider.subtitleColor,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      childAspectRatio: 0.9,
                      children: [
                        _FeatureCard(
                          title: 'Age',
                          subtitle: 'Calculate Age',
                          icon: FontAwesomeIcons.cakeCandles,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9B59B6), Color(0xFF8E44AD)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const AgeCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                        _FeatureCard(
                          title: 'Date',
                          subtitle: 'Date Math',
                          icon: FontAwesomeIcons.calendarDays,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF00C9A7), Color(0xFF00A896)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const DateCalculatorScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // Version display at bottom
            if (_version.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 16,
                      color: themeProvider.subtitleColor.withOpacity(0.6),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Version $_version',
                      style: TextStyle(
                        fontSize: 12,
                        color: themeProvider.subtitleColor.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Gradient gradient;
  final VoidCallback onTap;

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: FaIcon(icon, color: Colors.white, size: 24),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
