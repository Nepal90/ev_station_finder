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
        title: Text(
          station.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '${station.location}\nCity: ${station.city}\nStatus: ${station.isEnabled ? 'Enabled' : 'Disabled'}',
          style: TextStyle(color: Colors.black54),
        ),
        isThreeLine: true,
        trailing: station.nearby ? Icon(Icons.location_on, color: Colors.red) : null,
      ),
    );
  }
}
