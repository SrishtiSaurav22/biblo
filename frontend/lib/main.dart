import 'package:flutter/material.dart';
import 'start.dart';
import 'login.dart';
import 'signup.dart';
import 'home.dart';
import 'games.dart';

void main() {
  runApp(const Biblo());
}

class Biblo extends StatelessWidget {
  const Biblo({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
          '/start': (context) => const StartScreen(),
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignupScreen(),
          '/home': (context) => const HomeScreen(),
          '/games': (context) => const GamesScreen()
          /*
          1. You added 'const' to the screen constructors inside routes (e.g. StartScreen())
          2. If your screen constructors support const, it's a good habit to add it
          3. It's a minor Flutter performance hint telling the framework:
             "this widget never changes, don't rebuild it unnecessarily."
           */
        },
      initialRoute: '/start',
      // home: const StartScreen(),
      /*
      1. You cannot have both 'home:' and 'routes:' since home and a named route for / can conflict.
      2. The standard fix is to use 'initialRoute:' instead of 'home:' when you're using named routes.
      */
    );
  }
}

