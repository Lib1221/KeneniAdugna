import 'dart:async';

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Carousel dependency

class LifeSummaryPage extends StatefulWidget {
  @override
  _LifeSummaryPageState createState() => _LifeSummaryPageState();
}

class _LifeSummaryPageState extends State<LifeSummaryPage> {
  int _daysPassed = 0;
  final DateTime dateOfPassing = DateTime(2025, 3, 11); // Adjust the date accordingly
  late Timer _timer;

  // List of quotes that Keneni believed in or said
  final List<String> quotes = [
    "Every person that you see on social media is not like you see.",
    "God is above all",
  ];

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
        child: SingleChildScrollView( // To ensure the content is scrollable
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
              // Keneni's Life Story Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Keneni's Life Story",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Keneni Adugna was born in Michit, Oromia, where she spent her early years growing up in a community filled with warmth and love. "
                      "Her journey toward academic excellence began at a young age. After finishing her primary education, she joined the prestigious Adama Science and Technology University, where she pursued a degree in Hydraulics Engineering.\n\n"
                      "Her passion for learning did not stop there. Keneni soon discovered her love for the arts, particularly modeling. "
                      "She entered the world of modeling with grace and soon became a well-known figure, participating in various beauty contests and media projects.\n\n"
                      "Keneni also ventured into acting, gracing the screen in several movies and music videos, where her talent and charisma captivated audiences. "
                      "She was admired not only for her beauty but also for her vibrant personality and the kindness she radiated. Her journey was one of self-discovery, growth, and immense potential, and she touched the lives of countless people.\n\n"
                      "Despite her rising fame, Keneni always remained humble and grounded, continually striving to inspire others to follow their dreams. "
                      "Her legacy lives on, inspiring all those who were fortunate enough to know her.",
                      style: TextStyle(
                        color: Colors.white60,
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),

              // Quote Section with Carousel
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Keneni's Inspirational Quotes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    CarouselSlider.builder(
                      itemCount: quotes.length,
                      itemBuilder: (context, index, realIndex) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10.0),
                          padding: EdgeInsets.all(20.0),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.purpleAccent, Colors.blueAccent],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 8.0,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              quotes[index],
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                      options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        aspectRatio: 2.0,
                        viewportFraction: 0.8,
                        enableInfiniteScroll: true,
                        autoPlayInterval: Duration(seconds: 5),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 40),
              Icon(Icons.favorite, size: 40, color: Colors.white24),
            ],
          ),
        ),
      ),
    );
  }
}
