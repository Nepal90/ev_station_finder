import 'package:cloud_firestore/cloud_firestore.dart';

class SlotFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add slot
  Future<void> addSlot(String voltage, String price, bool isAvailable) async {
    await _db.collection('slots').add({
      'voltage': voltage,
      'price': price,
      'isAvailable': isAvailable,
    });
  }

  // Get slots
  Stream<List<Map<String, dynamic>>> getSlots() {
    return _db.collection('slots').snapshots().map((snapshot) =>
      snapshot.docs.map((doc) => {
        'id': doc.id,
        'voltage': doc['voltage'],
        'price': doc['price'],
        'isAvailable': doc['isAvailable'],
      }).toList(),
    );
  }

  // Delete slot
  Future<void> deleteSlot(String id) async {
    await _db.collection('slots').doc(id).delete();
  }

  // Update slot
  Future<void> updateSlot(String id, String voltage, String price, bool isAvailable) async {
    await _db.collection('slots').doc(id).update({
      'voltage': voltage,
      'price': price,
      'isAvailable': isAvailable,
    });
  }
}
