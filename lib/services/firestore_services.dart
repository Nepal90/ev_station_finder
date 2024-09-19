import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addVehicle(String userId, String number, String name) async {
    await _firestore.collection('vehicles').add({
      'userId': userId,
      'number': number,
      'name': name,
    });
  }

  Future<void> updateVehicle(String vehicleId, String number, String name) async {
    await _firestore.collection('vehicles').doc(vehicleId).update({
      'number': number,
      'name': name,
    });
  }

  Future<void> deleteVehicle(String vehicleId) async {
    await _firestore.collection('vehicles').doc(vehicleId).delete();
  }

  Stream<List<Map<String, dynamic>>> getVehiclesByUserId(String userId) {
    return _firestore
        .collection('vehicles')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data() as Map<String, dynamic>})
            .toList());
  }
}
