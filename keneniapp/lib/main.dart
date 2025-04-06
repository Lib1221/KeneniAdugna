import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keneniapp/life_summary/about.dart'; // Importing the LifeSummaryPage
import 'package:keneniapp/Gallery/gallery.dart'; // Importing the GalleryPage
import 'package:keneniapp/video/tiktok.dart'; // Importing the VideoPage
import 'package:keneniapp/firebase_options.dart';
import 'splash_screen.dart'; // Import splash screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(KeneniMemorialApp());
}

class KeneniMemorialApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keneni Memorial',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.redAccent,
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Colors.redAccent,
          unselectedItemColor: Colors.white70,
        ),
      ),
      home: SplashScreen(), // Use SplashScreen as the initial route
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    GalleryPage(),  // Imported GalleryPage
    VideoPage(),    // Imported VideoPage
    LifeSummaryPage(),  // Imported LifeSummaryPage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keneni Memorial'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black, // Set background color of the sidebar to black
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Image header at the top of the sidebar
              Container(
                height: 180,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/a.jpg'), // Image for header
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _buildDrawerItem(Icons.photo, "Gallery", 0),
              _buildDrawerItem(Icons.video_collection, "Videos", 1),
              _buildDrawerItem(Icons.favorite, "Summary", 2),
              _buildDrawerItem(Icons.settings, "Settings", -1),
              _buildDrawerItem(Icons.star, "Favourite", -2),
              const Divider(), // Break line before footer
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Liben Adugna',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White color for footer text
                    letterSpacing: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _pages[_selectedIndex], // Display pages based on selected index
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.photo),
            label: 'Gallery',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection),
            label: 'Videos',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Summary',
          ),
        ],
      ),
    );
  }

  ListTile _buildDrawerItem(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: Colors.white), // White icon color
      title: Text(
        title,
        style: TextStyle(color: Colors.white), // White text color
      ),
      onTap: () {
        if (index >= 0) {
          _onItemTapped(index);
        } else {
          // Handle special cases like Settings or Favourite
          if (index == -1) {
            // Handle Settings
            print('Settings tapped');
          } else if (index == -2) {
            // Handle Favourite
            print('Favourite tapped');
          }
        }
        Navigator.pop(context); // Close the drawer
      },
    );
  }
}
