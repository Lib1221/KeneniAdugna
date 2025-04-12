// ignore_for_file: avoid_web_libraries_in_flutter

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_player/video_player.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb

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
  bool _isLoading = true;
  Set<String> _favoriteVideos = {};
  bool _isFetching = false;
  bool _hasMore = true;
  final int _batchSize = 20;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _loadFavorites();
    _fetchRandomVideos();
  }

  // Load favorite videos from SharedPreferences
  Future<void> _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _favoriteVideos = prefs.getStringList('favorite_videos')?.toSet() ?? {};
    });
  }

  // Save favorite videos to SharedPreferences
  Future<void> _saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorite_videos', _favoriteVideos.toList());
  }

  // Fetch random videos from Firestore
  Future<void> _fetchRandomVideos() async {
    if (_isFetching || !_hasMore) return;

    setState(() {
      _isFetching = true;
      _isLoading = true;
    });

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('videos')
          .orderBy('uploaded_at', descending: true)
          .get();

      if (snapshot.docs.isEmpty) {
        setState(() {
          _isFetching = false;
          _isLoading = false;
        });
        return;
      }

      List<DocumentSnapshot> allDocs = snapshot.docs;
      List<DocumentSnapshot> randomDocs = _getRandomSubset(allDocs, _batchSize);
      List<String> randomVideoUrls =
      randomDocs.map((doc) => doc['url'] as String).toList();
      videoUrls.addAll(randomVideoUrls);

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
        _isFetching = false;
        _isLoading = false;
        _hasMore = videoUrls.length < snapshot.docs.length;
      });
    } catch (e) {
      setState(() {
        _isFetching = false;
        _isLoading = false;
      });
    }
  }

  List<DocumentSnapshot> _getRandomSubset(
      List<DocumentSnapshot> allDocs, int batchSize) {
    final random = Random();
    allDocs.shuffle(random);
    return allDocs.take(batchSize).toList();
  }

  Future<void> _downloadVideo(String url) async {
    if (kIsWeb) {
      try {
        print("Web download initiated");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video download started!')),
        );
      } catch (e) {
        print('Error downloading video on web: \$e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading video.')),
        );
      }
    } else {
      try {
        if (Platform.isAndroid) {
          var status = await Permission.storage.request();
          if (!status.isGranted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Storage permission is required.')),
            );
            return;
          }
        }

        Directory appDocDir = await getApplicationDocumentsDirectory();
        String filePath = '\${appDocDir.path}/KeneniMemorialVideo.mp4';

        Dio dio = Dio();
        await dio.download(url, filePath);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Video downloaded successfully!')),
        );
      } catch (e) {
        print('Error downloading video on mobile: \$e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error downloading video.')),
        );
      }
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

  void _shareVideo(String url) {
    final totallink = """\$url 🌸 Remembering Keneni Adugna
Explore the Keneni Memorial App — a heartfelt tribute with photos, videos, and a touching life story.
👉 Download & Experience the Memory""";
    Share.share(totallink);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: videoUrls.length + (_isLoading ? 1 : 0),
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) {
          if (index >= videoUrls.length) {
            return Center(child: CircularProgressIndicator());
          }

          final controller = _videoControllers[index];
          final videoUrl = videoUrls[index];
          final isLiked = _favoriteVideos.contains(videoUrl);

          return GestureDetector(
            onTap: _togglePlayPause,
            child: Stack(
              children: [
                controller.value.isInitialized
                    ? SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: controller.value.size.width,
                      height: controller.value.size.height,
                      child: VideoPlayer(controller),
                    ),
                  ),
                )
                    : Center(child: CircularProgressIndicator()),
                if (_isPaused)
                  Center(
                    child: Icon(Icons.play_arrow,
                        color: Colors.white, size: 80),
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
                        style:
                        TextStyle(color: Colors.white, fontSize: 14),
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
                          isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isLiked ? Colors.red : Colors.white,
                          size: 30,
                        ),
                        onPressed: () async {
                          setState(() {
                            if (_favoriteVideos.contains(videoUrl)) {
                              _favoriteVideos.remove(videoUrl);
                            } else {
                              _favoriteVideos.add(videoUrl);
                            }
                          });
                          await _saveFavorites();
                        },
                      ),
                      SizedBox(height: 16),
                      IconButton(
                        icon: Icon(Icons.comment_outlined,
                            color: Colors.white, size: 30),
                        onPressed: () {},
                      ),
                      SizedBox(height: 16),
                      IconButton(
                        icon: Icon(Icons.share,
                            color: Colors.white, size: 30),
                        onPressed: () => _shareVideo(videoUrl),
                      ),
                      SizedBox(height: 16),
                      IconButton(
                        icon: Icon(Icons.download,
                            color: Colors.white, size: 30),
                        onPressed: () => _downloadVideo(videoUrl),
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
