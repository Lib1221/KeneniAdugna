import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:keneniapp/fav.dart';
import 'package:keneniapp/life_summary/about.dart';
import 'package:keneniapp/Gallery/gallery.dart';
import 'package:keneniapp/permission.dart';
import 'package:keneniapp/upload.dart';
import 'package:keneniapp/video/tiktok.dart';
import 'package:keneniapp/firebase_options.dart';
import 'splash_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize timezone
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Africa/Addis_Ababa'));

  // Initialize local notifications
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  const InitializationSettings initSettings =
      InitializationSettings(android: androidSettings);

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await initializeNotifications();
  // Run the app
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
      home: SplashScreen(),
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
    GalleryPage(),
    VideoPage(),
    LifeSummaryPage(),
    UploadImagePage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _openFavoritesPage() {
    Navigator.pop(context); // Close drawer
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => FavoritesPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Keneni Memorial'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: SafeArea(
            child: Column(
              children: [
                Container(
                  height: 180,
                  margin:
                      EdgeInsets.only(left: 16, top: 24, right: 16, bottom: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 12,
                        offset: Offset(0, 6),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage('assets/a.jpg'),
                      fit: BoxFit.cover,
                      alignment: Alignment.topCenter,
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.2),
                        BlendMode.darken,
                      ),
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7)
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.all(16),
                    child: Text(
                      'Keneni Adugna',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.8),
                            blurRadius: 6,
                            offset: Offset(1, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      _buildDrawerItem(Icons.photo, "Gallery", 0),
                      _buildDrawerItem(Icons.video_collection, "Videos", 1),
                      _buildDrawerItem(Icons.favorite, "Summary", 2),
                      _buildDrawerItem(Icons.star, "Favourite", -2),
                      _buildDrawerItem(Icons.settings, "Settings", -1),
                      _buildDrawerItem(Icons.upload_file, "upload", 3),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Divider(
                        color: Colors.white,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Liben Adugna',
                      style: TextStyle(
                        fontSize: 18, // Slightly larger font size
                        fontWeight:
                            FontWeight.w600, // Stronger emphasis on the name
                        color: Colors.white
                            .withOpacity(0.85), // More refined white shade
                        letterSpacing: 1.5, // Slightly more spacing for clarity
                        fontFamily:
                            'SourceCodePro', // Developer-style font family
                        shadows: [
                          Shadow(
                            color: Colors.black
                                .withOpacity(0.5), // Darker shadow for depth
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: _pages[_selectedIndex],
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
      leading: Icon(
        icon,
        color: Colors.white,
        size: 26, // Slightly larger for a more modern touch
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Colors.white,
          fontSize: 18, // Slightly larger font size
          fontWeight: FontWeight.w600,
          letterSpacing: 1.1,
          shadows: [
            Shadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(0, 1),
              blurRadius: 4,
            ),
          ],
        ),
      ),
      onTap: () {
        if (index >= 0) {
          if (index == 3) {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadImagePage()),
            );
          } else {
            _onItemTapped(index);
            Navigator.pop(context);
          }
        } else {
          if (title == "Settings") {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Settings feature coming soon!")),
            );
            Navigator.pop(context);
          } else if (index == -2) {
            _openFavoritesPage();
          } else if (index == 3) {
            Navigator.pop(context); // Close drawer
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UploadImagePage()),
            );
          }
        }
      },
      tileColor: index == _selectedIndex
          ? Colors.redAccent.withOpacity(0.2) // Highlight active item
          : Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      hoverColor: Colors.redAccent.withOpacity(0.1), // Hover effect
      onLongPress: () {
        // Example of long press effect, can be customized
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Long pressed $title")),
        );
      },
    );
  }
}
