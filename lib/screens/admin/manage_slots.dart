import 'package:ev_station_finder/screens/admin/add_slot.dart';
import 'package:flutter/material.dart';

class ManageSlots extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Slots'),
        backgroundColor: Colors.green,
      ),
      body: const Center(
        child: Text('No Slots Available', style: TextStyle(fontSize: 16)),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>AddSlot(),
              ),
              );
        },
        label: const Text('Add Slot'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
        
      ),
    );
  }
}
