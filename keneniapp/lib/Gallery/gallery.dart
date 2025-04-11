import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keneniapp/Gallery/fullscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:math';

class GalleryPage extends StatefulWidget {
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> with AutomaticKeepAliveClientMixin {
  late List<String> _imageUrls;
  bool _isLoading = false;
  bool _hasMore = true;
  bool _isFetching = false;
  final int _batchSize = 20;

  @override
  void initState() {
    super.initState();
    _imageUrls = [];
    _fetchRandomImages();
  }

  Future<void> _fetchRandomImages() async {
    if (_isFetching || !_hasMore) return;

    setState(() {
      _isFetching = true;
      _isLoading = true;
    });

    // Fetch all image IDs from Firestore
    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('images')
        .orderBy('uploaded_at', descending: true) // or use another field like 'timestamp'
        .get();

    if (snapshot.docs.isEmpty) {
      setState(() {
        _isFetching = false;
        _isLoading = false;
      });
      return;
    }

    // Get a random subset of images from the fetched documents
    List<DocumentSnapshot> allDocs = snapshot.docs;
    List<DocumentSnapshot> randomDocs = _getRandomSubset(allDocs, _batchSize);

    // Add the URLs of the selected random images to the list
    List<String> randomImageUrls = randomDocs.map((doc) => doc['url'] as String).toList();
    _imageUrls.addAll(randomImageUrls);

    setState(() {
      _isFetching = false;
      _isLoading = false;
      _hasMore = _imageUrls.length < snapshot.docs.length; // Check if there are more images to fetch
    });
  }

  List<DocumentSnapshot> _getRandomSubset(List<DocumentSnapshot> allDocs, int batchSize) {
    final random = Random();
    allDocs.shuffle(random);  // Shuffle the list
    return allDocs.take(batchSize).toList();  // Take the first 'batchSize' documents
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for keepAlive

    return Scaffold(
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollInfo) {
          if (!_isFetching && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            _fetchRandomImages();  // Load more images when scrolled to the bottom
          }
          return false;
        },
        child: _buildGallery(),
      ),
    );
  }

  Widget _buildGallery() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MasonryGridView.builder(
        key: PageStorageKey('gallery_grid'),
        gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: _imageUrls.length + (_isLoading ? 1 : 0),  // Show loading indicator when fetching
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        itemBuilder: (context, index) {
          if (index >= _imageUrls.length) {
            return Center(child: CircularProgressIndicator());
          }

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenGalleryPage(
                    imageUrls: _imageUrls,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: Image.network(
                _imageUrls[index],
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: 120,
                      color: Colors.white,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey,
                  height: 120,
                  child: Icon(Icons.broken_image, color: Colors.white),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
