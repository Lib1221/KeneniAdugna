import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late PageController _pageController;
  late List<VideoPlayerController> _videoControllers;
  final List<String> videoUrls = [
    'z.mp4', // Replace with your video assets
    'z.mp4',
    'z.mp4',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // Initialize the video controllers for each video
    _videoControllers = videoUrls
        .map((url) => VideoPlayerController.asset(url)..initialize())
        .toList();
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
    // Pause all videos when changing pages and play the new video
    for (var controller in _videoControllers) {
      controller.pause();
    }
    _videoControllers[index].play();
  }

  void _onTap(int index) {
    final videoController = _videoControllers[index];
    if (videoController.value.isPlaying) {
      videoController.pause();
    } else {
      videoController.play();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // TikTok-like background color
      appBar: AppBar(
        title: Text("TikTok-like Scrolling"),
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow for the app bar
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical, // Vertical scroll direction
        itemCount: videoUrls.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final videoController = _videoControllers[index];
          return GestureDetector(
            onTap: () => _onTap(index), // Play/Pause on tap
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.black, // Black background for videos
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.8), // Dark shadow effect
                    spreadRadius: 3,
                    blurRadius: 6,
                    offset: Offset(0, 5), // Shadow beneath the video
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Center(
                    child: AspectRatio(
                      aspectRatio: videoController.value.aspectRatio,
                      child: VideoPlayer(videoController),
                    ),
                  ),
                  if (!videoController.value.isInitialized)
                    Center(child: CircularProgressIndicator()),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
