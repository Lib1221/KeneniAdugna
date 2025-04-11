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
                      "Keneni Adugna was born in 1991 in the Ethiopian calendar, in the town of Michita, located in the Daro Labu district of the Oromia region. She was the daughter of Adugna Wako and Aster Mekonin. Keneni grew up surrounded by love and happiness, playing joyfully in her community. As she matured, she embraced her faith and became a dedicated member of the Orthodox Church, allowing her life to be guided by God's teachings.\n\n"
                          "After completing her Grade 12 education, Keneni successfully passed the entrance exam and gained admission to Arba Minch University, where she began her studies in Hydraulics Engineering. It was during her time at university that she discovered her passion for modeling, which she pursued alongside her academic journey.\n\n"

                          "Keneni graduated with a degree in Hydraulics Engineering in 2011, but her interests in the arts continued to flourish. She was not only recognized for her academic achievements but also for her contributions to modeling. She gained popularity in the modeling industry, participating in various beauty contests and media projects. Her journey in the entertainment world extended to acting, where she graced the screen in several movies and music videos. Audiences were captivated by her talent, beauty, and vibrant personality.\n\n"

                          "Throughout her career, Keneni remained grounded, always striving to inspire others and encourage them to follow their dreams. Her humility and kindness earned her admiration from those who knew her. Despite her rising fame, she never lost touch with her roots.\n\n"

                          "Keneni was also passionate about making a difference in her community. She worked with the Oromia Water Limit Mahber, contributing her expertise to vital water projects. Additionally, she became a voice for the voiceless, especially during times of famine, advocating for the people of Borana and Salale.\n\n"

                          "In addition to her work in modeling and acting, Keneni ventured into film production, contributing to the creation of Ethiopian movies, such as 'Rebirra.' Her impact on the arts and society was profound, and her legacy continues to inspire many.\n\n"

                          "Tragically, Keneni's life was cut short on July 2, 2017, when she passed away under mysterious circumstances after falling from the fifth floor. Despite her untimely departure, her legacy of love, beauty, and service to others remains alive, and she is dearly missed by all who had the privilege of knowing her.",

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
