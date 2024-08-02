import 'package:flutter/material.dart';
import 'package:ev_station_finder/models/station.dart';

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({Key? key, required this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(station.imageUrl, height: 150, fit: BoxFit.cover),
            const SizedBox(height: 10),
            Text(
              station.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Text(station.address),
          ],
        ),
      ),
    );
  }
}
