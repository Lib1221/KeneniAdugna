

// // import 'dart:typed_data';
// // import 'package:dio/dio.dart';
// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:keneniapp/firebase_options.dart';

// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// // );
// //   runApp(MaterialApp(
// //     home: UploadImagePage(),
// //   ));
// // }

// // class UploadImagePage extends StatefulWidget {
// //   @override
// //   _UploadImagePageState createState() => _UploadImagePageState();
// // }

// // class _UploadImagePageState extends State<UploadImagePage> {
// //   double uploadProgress = 0.0;
// //   String uploadedImageUrl = '';

// //   // Function to upload image to Cloudinary
// //   Future<String> uploadToCloudinary(Uint8List imageBytes, String fileName) async {
// //     const cloudName = 'dkiuz3gfn'; // Cloudinary cloud name
// //     const uploadPreset = 'public'; // Cloudinary upload preset

// //     final dio = Dio(); // Initialize Dio instance to make HTTP requests
// //     final formData = FormData.fromMap({
// //       'file': MultipartFile.fromBytes(imageBytes, filename: fileName),
// //       'upload_preset': uploadPreset,
// //     });

// //     try {
// //       final response = await dio.post(
// //         'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
// //         data: formData,
// //         onSendProgress: (sent, total) {
// //           setState(() {
// //             uploadProgress = sent / total;
// //           });
// //         },
// //       );

// //       if (response.statusCode == 200) {
// //         return response.data['secure_url']; // Return the secure URL of the uploaded image
// //       } else {
// //         throw Exception('Upload failed with status: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       throw Exception('Failed to upload image: $e');
// //     }
// //   }

// //   // Function to pick an image from gallery
// //   Future<void> pickImage() async {
// //     final ImagePicker picker = ImagePicker();
// //     final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

// //     if (pickedFile != null) {
// //       final imageBytes = await pickedFile.readAsBytes();
// //       final fileName = pickedFile.name;

// //       // Upload image to Cloudinary
// //       try {
// //         final uploadedUrl = await uploadToCloudinary(imageBytes, fileName);
// //         setState(() {
// //           uploadedImageUrl = uploadedUrl;
// //         });

// //         // Save the uploaded image URL to Firebase Firestore
// //         await saveImageUrlToFirestore(uploadedUrl);

// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful!')));
// //       } catch (e) {
// //         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
// //       }
// //     }
// //   }

// //   // Function to save the uploaded image URL to Firebase Firestore
// //   Future<void> saveImageUrlToFirestore(String imageUrl) async {
// //     try {
// //       // Reference to Firestore collection
// //       final firestore = FirebaseFirestore.instance;
// //       await firestore.collection('images').add({
// //         'url': imageUrl,
// //         'uploaded_at': Timestamp.now(),
// //       });
// //     } catch (e) {
// //       print('Error saving URL to Firestore: $e');
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Upload Image to Cloudinary'),
// //       ),
// //       body: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             uploadProgress > 0
// //                 ? CircularProgressIndicator(value: uploadProgress)
// //                 : SizedBox.shrink(),
// //             SizedBox(height: 20),
// //             ElevatedButton(
// //               onPressed: pickImage,
// //               child: Text('Pick an Image'),
// //             ),
// //             SizedBox(height: 20),
// //             uploadedImageUrl.isNotEmpty
// //                 ? Image.network(uploadedImageUrl)
// //                 : Text('No image uploaded'),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }




// // import 'package:firebase_core/firebase_core.dart';
// // import 'package:flutter/material.dart';
// // import 'package:keneniapp/Gallery/about.dart';
// // import 'package:keneniapp/Gallery/gallery.dart';
// // import 'package:keneniapp/Gallery/tiktok.dart';
// // import 'package:keneniapp/firebase_options.dart'; // Ensure this file exists and contains the VideoScrollPage class
// // void main() async {
// //   WidgetsFlutterBinding.ensureInitialized();
// //   await Firebase.initializeApp(
// //     options: DefaultFirebaseOptions.currentPlatform,
// // );
// // runApp(KeneniMemorialApp());
// //  }

// // class KeneniMemorialApp extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     return MaterialApp(
// //       title: 'Keneni Memorial',
// //       theme: ThemeData.dark().copyWith(
// //         scaffoldBackgroundColor: Colors.black,
// //         primaryColor: Colors.redAccent,
// //         bottomNavigationBarTheme: BottomNavigationBarThemeData(
// //           backgroundColor: Colors.black,
// //           selectedItemColor: Colors.redAccent,
// //           unselectedItemColor: Colors.white70,
// //         ),
// //       ),
// //       home: HomePage(),
// //       debugShowCheckedModeBanner: false,
// //     );
// //   }
// // }

// // class HomePage extends StatefulWidget {
// //   @override
// //   _HomePageState createState() => _HomePageState();
// // }

// // class _HomePageState extends State<HomePage> {
// //   int _selectedIndex = 0;

// //   final List<Widget> _pages = [
// //     GalleryPage(),
// //     VideoPage(),
// //     LifeSummaryPage(),
// //   ];

// //   void _onItemTapped(int index) {
// //     setState(() {
// //       _selectedIndex = index;
// //     });
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: _pages[_selectedIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         currentIndex: _selectedIndex,
// //         onTap: _onItemTapped,
// //         items: [
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.photo),
// //             label: 'Gallery',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.video_collection),
// //             label: 'Videos',
// //           ),
// //           BottomNavigationBarItem(
// //             icon: Icon(Icons.favorite),
// //             label: 'Summary',
// //           ),
// //         ],
// //       ),
// //     );
// //   }
// // }


// import 'dart:typed_data';
// import 'package:dio/dio.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:keneniapp/firebase_options.dart';
// import 'package:video_player/video_player.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp(
//     options: DefaultFirebaseOptions.currentPlatform,
//   );
//   runApp(MaterialApp(
//     home: UploadVideoPage(),
//   ));
// }

// class UploadVideoPage extends StatefulWidget {
//   @override
//   _UploadVideoPageState createState() => _UploadVideoPageState();
// }

// class _UploadVideoPageState extends State<UploadVideoPage> {
//   double uploadProgress = 0.0;
//   String uploadedVideoUrl = '';
//   VideoPlayerController? _videoController;

//   Future<String> uploadVideoToCloudinary(Uint8List videoBytes, String fileName) async {
//     const cloudName = 'dkiuz3gfn';
//     const uploadPreset = 'public';

//     final dio = Dio();
//     final formData = FormData.fromMap({
//       'file': MultipartFile.fromBytes(videoBytes, filename: fileName),
//       'upload_preset': uploadPreset,
//       'resource_type': 'video',
//     });

//     try {
//       final response = await dio.post(
//         'https://api.cloudinary.com/v1_1/$cloudName/video/upload',
//         data: formData,
//         onSendProgress: (sent, total) {
//           setState(() {
//             uploadProgress = sent / total;
//           });
//         },
//       );

//       if (response.statusCode == 200) {
//         return response.data['secure_url'];
//       } else {
//         throw Exception('Upload failed: ${response.statusCode}');
//       }
//     } catch (e) {
//       throw Exception('Failed to upload video: $e');
//     }
//   }

//   Future<void> pickVideo() async {
//     final picker = ImagePicker();
//     final XFile? pickedFile = await picker.pickVideo(source: ImageSource.gallery);

//     if (pickedFile != null) {
//       final videoBytes = await pickedFile.readAsBytes();
//       final fileName = pickedFile.name;

//       try {
//         final uploadedUrl = await uploadVideoToCloudinary(videoBytes, fileName);
//         setState(() {
//           uploadedVideoUrl = uploadedUrl;
//           _videoController = VideoPlayerController.network(uploadedUrl)
//             ..initialize().then((_) => setState(() {}));
//         });

//         await saveVideoUrlToFirestore(uploadedUrl);

//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Upload successful!')));
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
//       }
//     }
//   }

//   Future<void> saveVideoUrlToFirestore(String videoUrl) async {
//     try {
//       final firestore = FirebaseFirestore.instance;
//       await firestore.collection('videos').add({
//         'url': videoUrl,
//         'uploaded_at': Timestamp.now(),
//       });
//     } catch (e) {
//       print('Error saving video URL: $e');
//     }
//   }

//   @override
//   void dispose() {
//     _videoController?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Upload Video to Cloudinary')),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             uploadProgress > 0 && uploadProgress < 1
//                 ? CircularProgressIndicator(value: uploadProgress)
//                 : SizedBox.shrink(),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: pickVideo,
//               child: Text('Pick a Video'),
//             ),
//             SizedBox(height: 20),
//             uploadedVideoUrl.isNotEmpty && _videoController != null
//                 ? AspectRatio(
//                     aspectRatio: _videoController!.value.aspectRatio,
//                     child: VideoPlayer(_videoController!),
//                   )
//                 : Text('No video uploaded'),
//             if (_videoController != null && _videoController!.value.isInitialized)
//               IconButton(
//                 icon: Icon(
//                   _videoController!.value.isPlaying ? Icons.pause : Icons.play_arrow,
//                 ),
//                 onPressed: () {
//                   setState(() {
//                     _videoController!.value.isPlaying
//                         ? _videoController!.pause()
//                         : _videoController!.play();
//                   });
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
