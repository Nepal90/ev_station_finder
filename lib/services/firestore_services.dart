import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Stream to get the list of vehicles
  Stream<List<Map<String, dynamic>>> getVehicles() {
    return _db.collection('vehicles').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'number': doc['number'],
          'name': doc['name'],
        };
      }).toList();
    });
  }

  // Method to add a new vehicle
  Future<void> addVehicle(String number, String name) {
    return _db.collection('vehicles').add({
      'number': number,
      'name': name,
    });
  }

  // Method to update an existing vehicle
  Future<void> updateVehicle(String id, String number, String name) {
    return _db.collection('vehicles').doc(id).update({
      'number': number,
      'name': name,
    });
  }

  // Method to delete a vehicle
  Future<void> deleteVehicle(String id) {
    return _db.collection('vehicles').doc(id).delete();
  }
}
