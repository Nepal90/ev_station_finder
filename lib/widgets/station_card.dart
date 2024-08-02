import 'package:flutter/material.dart';
import 'package:ev_station_finder/models/station.dart';

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({required this.station});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: ListTile(
        leading: Image.network(station.imageUrl, fit: BoxFit.cover, width: 100),
        title: Text(station.name),
        subtitle: Text('${station.address}\nCity: ${station.city}\nStatus: ${station.status}'),
        isThreeLine: true,
        trailing: station.nearby ? Icon(Icons.location_on, color: Colors.red) : null,
      ),
    );
  }
}
