import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import 'bloc/calculator_bloc.dart';
import 'screens/splash_screen.dart';
import 'theme/theme_provider.dart';

void main() {
  // Set device orientation to portrait only
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const NexCalcApp());
}

class NexCalcApp extends StatelessWidget {
  const NexCalcApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        BlocProvider(create: (_) => CalculatorBloc()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'NexCalc',
            debugShowCheckedModeBanner: false,
            theme: themeProvider.currentTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}
