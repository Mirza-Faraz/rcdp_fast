import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF4A6FA5),
      appBar: AppBar(
        title: const Text('RCDP Fast'),
        backgroundColor: const Color(0xFF3A5A85),
        elevation: 0,
      ),
      body: const Center(
        child: Text(
          'Welcome to Financial Loan Application',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
