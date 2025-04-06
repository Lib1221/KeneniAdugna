import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:keneniapp/Gallery/fullscreen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shimmer/shimmer.dart';

class GalleryPage extends StatefulWidget {
  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage>
    with AutomaticKeepAliveClientMixin {
  late Future<List<String>> _imageUrlsFuture;

  @override
  void initState() {
    super.initState();
    _imageUrlsFuture = _fetchImagesOnce();
  }

  Future<List<String>> _fetchImagesOnce() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('images')
        .orderBy('uploaded_at', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc['url'] as String).toList();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // for keepAlive

    return Scaffold(
      body: FutureBuilder<List<String>>(
        future: _imageUrlsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return _buildShimmerGrid();
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No images uploaded yet.'));
          }

          final imageUrls = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: MasonryGridView.builder(
              key: PageStorageKey('gallery_grid'),
              gridDelegate:
                  SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
              itemCount: imageUrls.length,
              mainAxisSpacing: 8.0,
              crossAxisSpacing: 8.0,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FullScreenGalleryPage(
                          imageUrls: imageUrls,
                          initialIndex: index,
                        ),
                      ),
                    );
                  },
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image.network(
                      imageUrls[index],
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
        },
      ),
    );
  }

  Widget _buildShimmerGrid() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MasonryGridView.builder(
        gridDelegate:
            SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemCount: 12,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            height: (100 + (index % 3) * 50).toDouble(),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
