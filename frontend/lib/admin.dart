import 'theme.dart';
import 'package:flutter/material.dart';

class AdminScreenButton extends StatelessWidget {

  // final = value is assigned once, never reassigned
  final String route;
  final String title;

  /*
  When all properties of a widget are final, the widget's value
  is completely fixed at creation time and will never change.
  Dart can then create it at compile time instead of runtime —
  meaning it's built before the app even runs.

  The const keyword on the constructor is how you tell Dart:
  "all the values in this widget are fixed, you can build
  this ahead of time."
   */
  const AdminScreenButton({
    super.key,
    required this.route,
    required this.title
  });

  @override
  Widget build(BuildContext context) {
    return  ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(context, route);
        },
        style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll(secondaryColor)
        ),
        child: Text(
          title,
          style: TextStyle(
              color: buttonTextColor,
              fontWeight: FontWeight.bold,
              fontSize: 15
          ),
        )
    );
  }
}

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: primaryColor,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                // redundant for Column widget
                children: [
                  Text(
                    'Biblo Admin Screen',
                    style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  ),

                  // START BUTTON
                  const AdminScreenButton(route: '/start', title: 'START'),

                  // LOGIN BUTTON
                  const AdminScreenButton(route: '/login', title: 'LOGIN'),

                  // SIGNUP BUTTON
                  const AdminScreenButton(route: '/signup', title: 'SIGNUP'),

                  // HOME BUTTON
                  const AdminScreenButton(route: '/home', title: 'HOME'),

                  // GAMES BUTTON
                  const AdminScreenButton(route: '/games', title: 'GAMES')
                ]
            )
        )
    );
  }
}