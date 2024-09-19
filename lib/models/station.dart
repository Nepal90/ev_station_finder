class Station {
  final String id;
  final String name;
  final String location;
  final String city;
  final bool isEnabled;
  final String imageUrl;
  final bool nearby;

  Station({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.isEnabled,
    required this.imageUrl,
    required this.nearby,
  });

  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      city: map['city'] ?? '',
      isEnabled: map['isEnabled'] ?? false,
      imageUrl: map['imageUrl'] ?? '',
      nearby: map['nearby'] ?? false,
    );
  }
}
