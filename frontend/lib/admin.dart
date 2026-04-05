import 'package:flutter/material.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                // redundant for Column widget
                children: [
                  Text(
                    'Biblo Admin Screen',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 30
                    ),
                  ),

                  // LOGIN BUTTON
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/login');
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.deepOrange.shade900)
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                        ),
                      )
                  ),

                  // SIGNUP BUTTON
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.deepOrange.shade900)
                      ),
                      child: Text(
                        'SIGNUP',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                        ),
                      )
                  ),

                  // HOME BUTTON
                  // SIGNUP BUTTON
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/home');
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.deepOrange.shade900)
                      ),
                      child: Text(
                        'HOME',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                        ),
                      )
                  ),

                  // GAMES BUTTON
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/games');
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.deepOrange.shade900)
                      ),
                      child: Text(
                        'GAMES',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                        ),
                      )
                  ),

                  // SIGNUP BUTTON
                  ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/games');
                      },
                      style: ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.deepOrange.shade900)
                      ),
                      child: Text(
                        'GAMES',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                            fontSize: 15
                        ),
                      )
                  )
                ]
            )
        )
    );
  }
}