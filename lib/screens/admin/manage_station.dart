import 'package:ev_station_finder/screens/admin/add_station.dart';
import 'package:flutter/material.dart';

class ManageStationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage EV Stations'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('No Stations Available', style: TextStyle(fontSize: 16)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddStationPage(),
              ),
              );
        },
        label: const Text('Add Station'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        
      ),
    );
  }
}
