import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';


class FullScreenGalleryPage extends StatefulWidget {
  final List<String> imageUrls;
  final int initialIndex;

  FullScreenGalleryPage({
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  _FullScreenGalleryPageState createState() => _FullScreenGalleryPageState();
}

class _FullScreenGalleryPageState extends State<FullScreenGalleryPage> {
  late PageController _pageController;
  late int _current;
  Set<String> _favorites = {};

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  void _toggleFavorite(String url) {
    setState(() {
      if (_favorites.contains(url)) {
        _favorites.remove(url);
      } else {
        _favorites.add(url);
      }
    });
  }

  void _setAsWallpaper(String url) {
    // Implement using platform channel or plugin like `wallpaper_manager_flutter`
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Set as wallpaper (not implemented)")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentImage = widget.imageUrls[_current];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.5),
        elevation: 0,
        title: Text("Image ${_current + 1} / ${widget.imageUrls.length}"),
        actions: [
          IconButton(
            icon: Icon(
              _favorites.contains(currentImage)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: _favorites.contains(currentImage)
                  ? Colors.red
                  : Colors.white,
            ),
            onPressed: () => _toggleFavorite(currentImage),
          ),
          IconButton(
            icon: Icon(Icons.wallpaper, color: Colors.white),
            onPressed: () => _setAsWallpaper(currentImage),
          ),
          IconButton(
            icon: Icon(Icons.share, color: Colors.white),
            onPressed: () => Share.share(currentImage),
          ),
        ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: (index) => setState(() => _current = index),
            itemBuilder: (context, index) {
              return Hero(
                tag: widget.imageUrls[index] + index.toString(),
                child: PhotoView(
                  imageProvider: NetworkImage(widget.imageUrls[index]),
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 2,
                  backgroundDecoration: BoxDecoration(color: Colors.black),
                ),
              );
            },
          ),
          Positioned(
            bottom: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Long press to zoom",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
          ),
          Positioned(
            bottom: 12,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imageUrls.length,
                itemBuilder: (context, index) {
                  final isSelected = _current == index;
                  return GestureDetector(
                    onTap: () => _pageController.jumpToPage(index),
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.transparent,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          widget.imageUrls[index],
                          width: 60,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
