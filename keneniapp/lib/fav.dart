import 'package:flutter/material.dart';
import 'package:keneniapp/Gallery/fullscreen.dart';
import 'package:keneniapp/videoPlayer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favoriteImages = [];
  List<String> _favoriteVideos = [];
  final String _profileName = "Keneni Adugna";
  final String _profileImage = 'a.jpg';
  bool _showImages = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteImages = prefs.getStringList('favoriteImages') ?? [];
      _favoriteVideos = prefs.getStringList('favorite_videos') ?? [];
    });
  }

  void _toggleFavoriteType(bool isImage) {
    setState(() {
      _showImages = isImage;
    });
  }

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

  void _openVideoPlayer(String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FavoriteVideoViewer(videoUrl: url),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Favorites"),
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: AssetImage(_profileImage),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.darken),
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _profileName,
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 8),
                  Text("In Loving Memory ❤️", style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildToggleButton("Images", _showImages, () => _toggleFavoriteType(true)),
                SizedBox(width: 16),
                _buildToggleButton("Videos", !_showImages, () => _toggleFavoriteType(false)),
              ],
            ),
            SizedBox(height: 20),
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

  Widget _buildToggleButton(String label, bool isActive, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isActive ? Colors.red : Colors.grey[800],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      ),
      child: Text(label, style: TextStyle(fontSize: 16, color: Colors.white)),
    );
  }

  Widget _buildFavoriteGrid(List<String> favorites, bool isVideo) {
    // Shuffle the favorite videos to show random order
    favorites.shuffle();

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: favorites.length,
      itemBuilder: (context, index) {
        String url = favorites[index];
        return GestureDetector(
          onTap: () {
            isVideo ? _openVideoPlayer(url) : _openFullScreenGallery(index);
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24, width: 1.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: isVideo
                  ? VideoPlayerItem(videoUrl: url)
                  : Image.network(
                      url,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Center(child: CircularProgressIndicator(color: Colors.red));
                      },
                    ),
            ),
          ),
        );
      },
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String videoUrl;

  VideoPlayerItem({required this.videoUrl});

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isInitialized = true;
        });
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isInitialized
        ? Container(
            width: double.infinity,
            height: double.infinity,
            child: VideoPlayer(_controller),
          )
        : Center(child: CircularProgressIndicator(color: Colors.red));
  }
}
