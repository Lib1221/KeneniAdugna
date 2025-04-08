import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class UploadImagePage extends StatefulWidget {
  @override
  _UploadImagePageState createState() => _UploadImagePageState();
}

class _UploadImagePageState extends State<UploadImagePage> {
  double uploadProgress = 0.0;
  List<String> uploadedImageUrls = [];
  int totalSelected = 0;
  int totalUploaded = 0;

  // Function to upload image to Cloudinary
  Future<String> uploadToCloudinary(Uint8List imageBytes, String fileName) async {
    const cloudName = 'dkiuz3gfn'; // Cloudinary cloud name
    const uploadPreset = 'public'; // Cloudinary upload preset

    final dio = Dio(); // Initialize Dio instance to make HTTP requests
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(imageBytes, filename: fileName),
      'upload_preset': uploadPreset,
    });

    try {
      final response = await dio.post(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: formData,
        onSendProgress: (sent, total) {
          setState(() {
            uploadProgress = sent / total;
          });
        },
      );

      if (response.statusCode == 200) {
        return response.data['secure_url']; // Return the secure URL of the uploaded image
      } else {
        throw Exception('Upload failed with status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  // Function to pick multiple images from gallery
  Future<void> pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedFiles = await picker.pickMultiImage(); // pick multiple images

    if (pickedFiles != null && pickedFiles.isNotEmpty) {
      setState(() {
        totalSelected = pickedFiles.length;
        totalUploaded = 0; // Reset the upload count
      });

      List<String> urls = [];

      for (var pickedFile in pickedFiles) {
        final imageBytes = await pickedFile.readAsBytes();
        final fileName = pickedFile.name;

        // Upload image to Cloudinary
        try {
          final uploadedUrl = await uploadToCloudinary(imageBytes, fileName);
          urls.add(uploadedUrl);

          // Save the uploaded image URL to Firebase Firestore
          await saveImageUrlToFirestore(uploadedUrl);

          // Update the uploaded count
          setState(() {
            totalUploaded++;
          });

        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
        }
      }

      setState(() {
        uploadedImageUrls = urls;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Uploads successful!')));
    }
  }

  // Function to save the uploaded image URL to Firebase Firestore
  Future<void> saveImageUrlToFirestore(String imageUrl) async {
    try {
      // Reference to Firestore collection
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('images').add({
        'url': imageUrl,
        'uploaded_at': Timestamp.now(),
      });
    } catch (e) {
      print('Error saving URL to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Multiple Images'),
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Progress Indicator
              uploadProgress > 0
                  ? Card(
                      margin: EdgeInsets.only(bottom: 20),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(
                              'Uploading... ${(uploadProgress * 100).toStringAsFixed(2)}%',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 10),
                            LinearProgressIndicator(
                              value: uploadProgress,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                            ),
                          ],
                        ),
                      ),
                    )
                  : SizedBox.shrink(),

              // Upload Button
              ElevatedButton(
                onPressed: pickImages,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Pick Multiple Images',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),

              // Selected and Uploaded Count
              Card(
                margin: EdgeInsets.only(bottom: 20),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        'Selected: $totalSelected images',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Uploaded: $totalUploaded images',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ),

              // Uploaded Images Display
              uploadedImageUrls.isNotEmpty
                  ? Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: uploadedImageUrls
                          .map((url) => ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Image.network(
                                  url,
                                  width: 150,
                                  height: 150,
                                  fit: BoxFit.cover,
                                ),
                              ))
                          .toList(),
                    )
                  : Center(child: Text('No images uploaded')),
            ],
          ),
        ),
      ),
    );
  }
}
