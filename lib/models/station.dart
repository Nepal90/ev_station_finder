import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  final String id;
  final String name;
  final String address;
  final String imageUrl;
  final String city;
  final bool nearby;
  final String status;

  Station({
    required this.id,
    required this.name,
    required this.address,
    required this.imageUrl,
    required this.city,
    required this.nearby,
    required this.status,
  });

  factory Station.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Station(
      id: doc.id,
      name: data['name'] ?? '',
      address: data['address'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      city: data['city'] ?? '',
      nearby: data['nearby'] ?? false,
      status: data['status'] ?? '',
    );
  }
}
