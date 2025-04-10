import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteVideoViewer extends StatefulWidget {
  final String videoUrl;

  const FavoriteVideoViewer({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _FavoriteVideoViewerState createState() => _FavoriteVideoViewerState();
}

class _FavoriteVideoViewerState extends State<FavoriteVideoViewer> {
  late VideoPlayerController _controller;
  bool _isPaused = false;
  bool _isLiked = false;
  bool _isLoading = true;
  Set<String> _favoriteVideos = {};

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {
          _isLoading = false;
        });
        _controller.play();
      });
    _controller.setLooping(true);
  }

  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteVideos = prefs.getStringList('favorite_videos')?.toSet() ?? {};
      _isLiked = _favoriteVideos.contains(widget.videoUrl);
    });
  }

  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_videos', _favoriteVideos.toList());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      setState(() => _isPaused = true);
    } else {
      _controller.play();
      setState(() => _isPaused = false);
    }
  }

  void _toggleFavorite() async {
    setState(() {
      if (_favoriteVideos.contains(widget.videoUrl)) {
        _favoriteVideos.remove(widget.videoUrl);
        _isLiked = false;
      } else {
        _favoriteVideos.add(widget.videoUrl);
        _isLiked = true;
      }
    });
    await _saveFavorites();
  }

  void _shareVideo(String url) {
    final text = """$url 🌸 Remembering Keneni Adugna
Explore the Keneni Memorial App — a heartfelt tribute with photos, videos, and a touching life story.
👉 Download & Experience the Memory""";
    Share.share(text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  backgroundColor: Colors.black,
  elevation: 0,
  leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.white),
    onPressed: () {
      Navigator.pop(context);
    },
  ),
),

      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : GestureDetector(
              onTap: _togglePlayPause,
              child: Stack(
                children: [
                  _controller.value.isInitialized
                      ? SizedBox.expand(
                          child: FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: VideoPlayer(_controller),
                            ),
                          ),
                        )
                      : Center(child: CircularProgressIndicator()),

                  if (_isPaused)
                    Center(
                      child: Icon(Icons.play_arrow, color: Colors.white, size: 80),
                    ),

                  Positioned(
                    bottom: 80,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '@Keneni_memorial',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Forever in our hearts ❤️ #memories',
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  Positioned(
                    bottom: 40,
                    left: 16,
                    right: 16,
                    child: VideoProgressIndicator(
                      _controller,
                      allowScrubbing: true,
                      colors: VideoProgressColors(
                        playedColor: Colors.white,
                        backgroundColor: Colors.grey.withOpacity(0.5),
                        bufferedColor: Colors.grey,
                      ),
                    ),
                  ),

                  Positioned(
                    bottom: 100,
                    right: 16,
                    child: Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            _isLiked ? Icons.favorite : Icons.favorite_border,
                            color: _isLiked ? Colors.red : Colors.white,
                            size: 30,
                          ),
                          onPressed: _toggleFavorite,
                        ),
                        SizedBox(height: 16),
                        IconButton(
                          icon: Icon(Icons.comment_outlined,
                              color: Colors.white, size: 30),
                          onPressed: () {},
                        ),
                        SizedBox(height: 16),
                        IconButton(
                          icon: Icon(Icons.share, color: Colors.white, size: 30),
                          onPressed: () => _shareVideo(widget.videoUrl),
                        ),
                        SizedBox(height: 16),
                        IconButton(
                          icon: Icon(Icons.download, color: Colors.white, size: 30),
                          onPressed: () {
                            // implement download if needed
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
