import 'package:flutter/material.dart';
import 'dart:async';

class LifeSummaryPage extends StatefulWidget {
  @override
  _LifeSummaryPageState createState() => _LifeSummaryPageState();
}

class _LifeSummaryPageState extends State<LifeSummaryPage> {
  int _daysPassed = 0;
  final DateTime dateOfPassing = DateTime(2025, 3, 11); // Adjust the date accordingly
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _calculateDays();
    _timer = Timer.periodic(Duration(days: 1), (_) => _calculateDays());
  }

  void _calculateDays() {
    final now = DateTime.now();
    setState(() {
      _daysPassed = now.difference(dateOfPassing).inDays;
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 20),
            CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage("assets/a.jpg"), // Replace with your image path
            ),
            SizedBox(height: 16),
            Text(
              "Keneni Adugna",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              "In Loving Memory",
              style: TextStyle(color: Colors.white70),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                "Keneni was a bright light in our lives. Her kindness, smile, and warm heart touched many. "
                "Her spirit lives on in every memory we hold dear.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 16,
                ),
              ),
            ),
            SizedBox(height: 30),
            Text(
              "$_daysPassed Days Since You Left Us",
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 18,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 40),
            Icon(Icons.favorite, size: 40, color: Colors.white24),
          ],
        ),
      ),
    );
  }
}
