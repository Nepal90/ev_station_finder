import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add station
  Future<void> addStation(String name, String location, String city, bool isEnabled) async {
    await _db.collection('stations').add({
      'name': name,
      'location': location,
      'city': city,
      'isEnabled': isEnabled,
    });
  }

  // Get stations
  Stream<List<Map<String, dynamic>>> getStations() {
    return _db.collection('stations').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => {
        'id': doc.id,
        'name': doc['name'],
        'location': doc['location'],
        'city': doc['city'],
        'isEnabled': doc['isEnabled'],
        // 'nearby': doc['nearby'] ?? false
      }).toList(),
    );
  }

  // Update station
  Future<void> updateStation(String id, String name, String location, String city, bool isEnabled) async {
    await _db.collection('stations').doc(id).update({
      'name': name,
      'location': location,
      'city': city,
      'isEnabled': isEnabled,
    });
  }

  // Delete station
  Future<void> deleteStation(String id) async {
    await _db.collection('stations').doc(id).delete();
  }
}
