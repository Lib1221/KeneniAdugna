import 'package:flutter/material.dart';
import 'package:keneniapp/Gallery/fullscreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favoriteImages = [];
  List<String> _favoriteVideos = [];
  final String _profileName = "Keneni Adugna";
  final String _profileImage = 'a.jpg'; // Replace with actual profile image URL
  bool _showImages = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  // Load favorite images and videos from SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteImages = prefs.getStringList('favoriteImages') ?? [];
      _favoriteVideos = prefs.getStringList('favorite_videos') ?? [];
    });
  }

  // Toggle between image and video favorites
  void _toggleFavoriteType(bool isImage) {
    setState(() {
      _showImages = isImage;
    });
  }

  // Navigate to Full-Screen Gallery on Image Click
  void _openFullScreenGallery(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenGalleryPage(
          imageUrls: _favoriteImages,
          initialIndex: index,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header with modern design
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 70, // Increased profile image size
                    backgroundImage: AssetImage(_profileImage),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _profileName,
                    style: TextStyle(
                      fontSize: 30, // Increased font size
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "In Loving Memory ❤️",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Toggle Buttons (Image / Video)
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => _toggleFavoriteType(true),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _showImages ? Colors.red : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8, // Added elevation for modern look
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16), // Increased padding
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text(
                      'Images',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => _toggleFavoriteType(false),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !_showImages ? Colors.red : Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 8,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: Text(
                      'Videos',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Display the Grid (either Images or Videos)
            Expanded(
              child: _showImages
                  ? _buildFavoriteGrid(_favoriteImages, false)
                  : _buildFavoriteGrid(_favoriteVideos, true),
            ),
          ],
        ),
      ),
    );
  }

  // Build the grid of favorite items (images or videos)
  Widget _buildFavoriteGrid(List<String> favorites, bool isVideo) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        String url = favorites[index];
        return GestureDetector(
          onTap: () {
            if (!isVideo) {
              // Open full-screen gallery on image click
              _openFullScreenGallery(index);
            } else {
              // Handle video tap if needed (e.g., play video)
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16), // Added more rounded corners
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.4), // Lightened border color
                  width: 1.5,
                ),
                borderRadius: BorderRadius.circular(16), // More rounded corners
              ),
              child: isVideo
                  ? Container(
                      color: Colors.black,
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 60, // Increased play icon size
                      ),
                    )
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        );
      },
    );
  }
}
