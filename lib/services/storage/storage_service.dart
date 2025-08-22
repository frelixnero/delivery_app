import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../navigator_key/navigator.dart';
import '../auth/auth_service.dart';

class StorageService with ChangeNotifier {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  // Declare final, but don't initialize here

  // get chat and auth servicce

  final AuthService _authService = AuthService();

  // list of image strings
  Map<String, dynamic> _imageUrl = {};

  // loading status
  bool _isLoading = false;

  // uploading status
  bool _isUploading = false;

  // create getter map for image url
  Map<String, dynamic> get imageUrls => _imageUrl;

  bool get isLoading => _isLoading;
  bool get isUploading => _isUploading;

  // R E A D    I M A G E S

  Future<void> fetchImages() async {
    _isLoading = true;
    notifyListeners();

    try {
      ListResult result =
          await _firebaseStorage.ref("uploaded_image").listAll();
      _imageUrl.clear();

      await Future.forEach(result.items, (Reference ref) async {
        try {
          // Get file metadata
          FullMetadata metadata = await ref.getMetadata();

          // Retrieve the user ID from metadata
          String? userId = metadata.customMetadata?["userId"];

          if (userId != null) {
            String downloadUrl = await ref.getDownloadURL();
            _imageUrl[userId] = downloadUrl;
          } else {
            print("Skipping file without userId metadata: ${ref.name}");
          }
        } catch (e) {
          print("Error fetching metadata for ${ref.name}: $e");
        }
      });
    } catch (e) {
      print("Error fetching images: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // D E L E T E    I M A G E S
  Future<void> deleteImage(String userId, String imageUrl) async {
    try {
      // Find the reference to the image in Firebase Storage
      Reference imageRef = _firebaseStorage.refFromURL(imageUrl);

      // Delete from Firebase Storage
      await imageRef.delete();

      // Remove from local image map
      _imageUrl.remove(userId);
      ScaffoldMessenger.of(
        NavigationService.navigatorKey.currentState!.context,
      ).showSnackBar(const SnackBar(content: Text("Image deleted")));

      print("Image deleted successfully.");
    } catch (e) {
      print("Error deleting image: $e");
    }

    notifyListeners();
  }

  //  U P L O A D    I M A G E S
  Future<void> uploadImage(BuildContext context) async {
    _isUploading = true;
    notifyListeners();

    final String userId = _authService.getCurrentUser()!.uid;
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) return;

    File file = File(image.path);

    try {
      String filePath =
          "uploaded_image/${DateTime.now().millisecondsSinceEpoch}.png";

      // Upload the file with metadata
      SettableMetadata metadata = SettableMetadata(
        customMetadata: {"userId": userId}, // Store userId in metadata
      );

      await _firebaseStorage.ref(filePath).putFile(file, metadata);

      // Get download URL
      String downloadUrl =
          await _firebaseStorage.ref(filePath).getDownloadURL();

      // Store the image URL in _imageUrl

      _imageUrl[userId] = downloadUrl;
      ScaffoldMessenger.of(
        NavigationService.navigatorKey.currentState!.context,
      ).showSnackBar(const SnackBar(content: Text("Image added")));
    } catch (e) {
      print("Upload error: $e");
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
