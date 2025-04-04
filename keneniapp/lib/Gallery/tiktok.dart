import 'dart:isolate';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late PageController _pageController;
  late List<VideoPlayerController> _videoControllers;
  int _currentIndex = 0;
  bool _isPaused = false;
  bool _isLiked = false; // Track Like status

  final List<String> videoUrls = [
    'z.mp4',
    'z.mp4',
    'z.mp4',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _videoControllers = videoUrls.map((url) {
      var controller = VideoPlayerController.asset(url)
        ..initialize().then((_) {
          setState(() {});
        });
      controller.setLooping(true);
      return controller;
    }).toList();
    _videoControllers[0].play();
    _initializeDownloader();
  }

  @override
  void dispose() {
    for (var controller in _videoControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _initializeDownloader() async {
    FlutterDownloader.initialize();
    IsolateNameServer.registerPortWithName(
      ReceivePort().sendPort,
      'downloader_send_port',
    );
  }

  void _onPageChanged(int index) {
    _videoControllers[_currentIndex].pause();
    _currentIndex = index;
    _videoControllers[_currentIndex].play();
    setState(() {
      _isPaused = false;
      _isLiked = false; // Reset like status when changing videos
    });
  }

  void _togglePlayPause() {
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

  Future<void> _downloadVideo() async {
    final status = await Permission.storage.request();
    if (status.isGranted || await Permission.manageExternalStorage.isGranted) {
      final dir = await getExternalStorageDirectory() ?? await getApplicationDocumentsDirectory();
      await FlutterDownloader.enqueue(
        url: videoUrls[_currentIndex], // Use remote URL if available
        savedDir: dir.path,
        fileName: 'video${_currentIndex + 1}.mp4',
        showNotification: true,
        openFileFromNotification: true,
      );
      _showDownloadPopup();
    }
  }

  void _showDownloadPopup() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Download Completed!"),
        backgroundColor: Colors.green,
      ),
    );
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
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          final videoController = _videoControllers[index];
          return GestureDetector(
            onTap: _togglePlayPause,
            child: Stack(
              children: [
                // Video Player
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: videoController.value.isInitialized
                      ? VideoPlayer(videoController)
                      : Center(child: CircularProgressIndicator()),
                ),

                // Play Icon
                if (_isPaused)
                  Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 80,
                    ),
                  ),

                // Video Info
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

                // Progress Bar
                Positioned(
                  bottom: 40,
                  left: 16,
                  right: 16,
                  child: VideoProgressIndicator(
                    videoController,
                    allowScrubbing: true,
                    colors: VideoProgressColors(
                      playedColor: Colors.white,
                      backgroundColor: Colors.grey.withOpacity(0.5),
                      bufferedColor: Colors.grey,
                    ),
                  ),
                ),

                // Like, Comment, Share, Download Buttons
                Positioned(
                  bottom: 100,
                  right: 16,
                  child: Column(
                    children: [
                      // Like Button
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

                      // Comment Button
                      IconButton(
                        icon: Icon(
                          Icons.comment_outlined,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          // TODO: Add comment functionality
                        },
                      ),
                      SizedBox(height: 16),

                      // Share Button
                      IconButton(
                        icon: Icon(
                          Icons.share,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: () {
                          // TODO: Add share functionality
                        },
                      ),
                      SizedBox(height: 16),

                      // Download Button
                      IconButton(
                        icon: Icon(
                          Icons.download,
                          color: Colors.white,
                          size: 30,
                        ),
                        onPressed: _downloadVideo,
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
