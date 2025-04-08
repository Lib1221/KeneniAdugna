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
      _favoriteVideos = prefs.getStringList('favoriteVideos') ?? [];
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

  // Print all video URLs
  void _printFavoriteVideos() {
    for (var url in _favoriteVideos) {
      print("Favorite Video URL: $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: Icon(Icons.print),
            onPressed: _printFavoriteVideos, // Print video URLs
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage(_profileImage),
                    backgroundColor: Colors.white,
                  ),
                  SizedBox(height: 16),
                  Text(
                    _profileName,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "This is your favorite gallery.",
                    style: TextStyle(
                      fontSize: 16,
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
                      elevation: 6,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      'Images',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                      elevation: 6,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: Text(
                      'Videos',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
            borderRadius: BorderRadius.circular(12),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey.withOpacity(0.6),
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: isVideo
                  ? Container(
                      color: Colors.black,
                      child: Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 50,
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