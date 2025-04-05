import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:io';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Firestore Operations
  Future<void> addReel({
    required String title,
    required String videoUrl,
    required String category,
    String? musicName,
    String? description,
    String? profileUrl,
  }) async {
    try {
      await _firestore.collection('reels').add({
        'title': title,
        'videoUrl': videoUrl,
        'category': category,
        'likes': 0,
        'createdAt': FieldValue.serverTimestamp(),
        'userId': _auth.currentUser?.uid,
        'musicName': musicName ?? 'Unknown Music',
        'description': description ?? '',
        'profileUrl': profileUrl ?? '',
      });
    } catch (e) {
      throw Exception('Failed to add reel: $e');
    }
  }

  Stream<QuerySnapshot> getReelsByCategory(String category) {
    return _firestore
        .collection('reels')
        .where('category', isEqualTo: category)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  Future<void> likeReel(String reelId) async {
    try {
      await _firestore.collection('reels').doc(reelId).update({
        'likes': FieldValue.increment(1),
      });
    } catch (e) {
      throw Exception('Failed to like reel: $e');
    }
  }

  // Storage Operations
  Future<String> uploadVideo(String filePath) async {
    try {
      final ref = _storage
          .ref()
          .child('reels/${DateTime.now().millisecondsSinceEpoch}.mp4');
      final uploadTask = await ref.putFile(File(filePath));
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload video: $e');
    }
  }

  Future<void> deleteVideo(String videoUrl) async {
    try {
      final ref = _storage.refFromURL(videoUrl);
      await ref.delete();
    } catch (e) {
      throw Exception('Failed to delete video: $e');
    }
  }
}
