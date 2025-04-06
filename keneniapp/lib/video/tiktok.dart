import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late PageController _pageController;
  List<VideoPlayerController> _videoControllers = [];
  List<String> videoUrls = [];
  int _currentIndex = 0;
  bool _isPaused = false;
  bool _isLiked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _fetchVideos();
  }

  Future<void> _fetchVideos() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('videos').orderBy('uploaded_at', descending: true).get();
      videoUrls = snapshot.docs.map((doc) => doc['url'] as String).toList();

      _videoControllers = videoUrls.map((url) {
        var controller = VideoPlayerController.network(url)
          ..initialize().then((_) {
            setState(() {});
          });
        controller.setLooping(true);
        return controller;
      }).toList();

      if (_videoControllers.isNotEmpty) {
        _videoControllers[0].play();
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching videos: $e');
    }
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    if (_videoControllers.isNotEmpty) {
      _videoControllers[_currentIndex].pause();
      _currentIndex = index;
      _videoControllers[_currentIndex].play();
    }
    setState(() {
      _isPaused = false;
      _isLiked = false;
    });
  }

  void _togglePlayPause() {
    if (_videoControllers.isEmpty) return;
    final videoController = _videoControllers[_currentIndex];
    setState(() {
      if (videoController.value.isPlaying) {
        videoController.pause();
        _isPaused = true;
      } else {
        videoController.play();
        _isPaused = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Keneni's Video"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: videoUrls.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final controller = _videoControllers[index];
                return GestureDetector(
                  onTap: _togglePlayPause,
                  child: Stack(
                    children: [
                      controller.value.isInitialized
                          ? SizedBox.expand(child: FittedBox(
                              fit: BoxFit.cover,
                              child: SizedBox(
                                width: controller.value.size.width,
                                height: controller.value.size.height,
                                child: VideoPlayer(controller),
                              ),
                            ))
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
                              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
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
                          controller,
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
                              onPressed: () {
                                setState(() {
                                  _isLiked = !_isLiked;
                                });
                              },
                            ),
                            SizedBox(height: 16),
                            IconButton(
                              icon: Icon(Icons.comment_outlined, color: Colors.white, size: 30),
                              onPressed: () {},
                            ),
                            SizedBox(height: 16),
                            IconButton(
                              icon: Icon(Icons.share, color: Colors.white, size: 30),
                              onPressed: () {},
                            ),
                            SizedBox(height: 16),
                            IconButton(
                              icon: Icon(Icons.download, color: Colors.white, size: 30),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
