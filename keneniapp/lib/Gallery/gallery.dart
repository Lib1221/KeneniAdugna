import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class GalleryPage extends StatelessWidget {
  final List<String> imageUrls = [
    'a.jpg',
    'b.jpg',
    'c.jpg',
    'd.jpg',
    'e.jpg',
    'f.jpg',
    'a.jpg',
    'b.jpg',
    'c.jpg',
    'd.jpg',
    'e.jpg',
    'f.jpg',
    'a.jpg',
    'b.jpg',
    'c.jpg',
    'd.jpg',
    'e.jpg',
    'f.jpg',
    'a.jpg',
    'b.jpg',
    'c.jpg',
    'd.jpg',
    'e.jpg',
    'f.jpg',
    'a.jpg',
    'b.jpg',
    'c.jpg',
    'd.jpg',
    'e.jpg',
    'f.jpg',
    'a.jpg',
    'b.jpg',
    'c.jpg',
    'd.jpg',
    'e.jpg',
    'f.jpg',
    'z.mp4'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Keneni's Gallery"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: MasonryGridView.builder(
          gridDelegate: SliverSimpleGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemCount: imageUrls.length,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                // Open the full-screen view on tap
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PhotoViewGalleryPage(
                      imageUrls: imageUrls,
                      initialIndex: index,
                    ),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12.0), // Rounded corners
                child: Image.asset(
                  imageUrls[index],  // Use Image.asset for local images
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class PhotoViewGalleryPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  PhotoViewGalleryPage({required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Full Screen Image"),
      ),
      body: PhotoViewGallery.builder(
        itemCount: imageUrls.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(imageUrls[index]),  // Use AssetImage for local images
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered,
          );
        },
        scrollPhysics: BouncingScrollPhysics(),
        backgroundDecoration: BoxDecoration(
          color: Colors.black,
        ),
        pageController: PageController(initialPage: initialIndex),
      ),
    );
  }
}
