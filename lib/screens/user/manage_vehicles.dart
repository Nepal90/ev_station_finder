import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ev_station_finder/services/firestore_services.dart';
import 'package:ev_station_finder/components/DefField.dart';

class ManageEvVehiclesScreen extends StatefulWidget {
  @override
  _ManageEvVehiclesScreenState createState() => _ManageEvVehiclesScreenState();
}

class _ManageEvVehiclesScreenState extends State<ManageEvVehiclesScreen> {
  final _formKey = GlobalKey<FormState>();
  final _numberController = TextEditingController();
  final _nameController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void _showAddVehicleDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Add Vehicle"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DefField(
                  controller: _numberController,
                  hint: "Enter your vehicle number",
                  obsecure: false,
                  lable: "vehicle number",
                  inputtype: TextInputType.text,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle number';
                    }
                    return null;
                  },
                ),
                DefField(
                  controller: _nameController,
                  hint: "Enter your vehicle name",
                  obsecure: false,
                  lable: "vehicle name",
                  inputtype: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter vehicle name';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Add"),
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  final userId = _auth.currentUser?.uid ?? '';
                  if (userId.isNotEmpty) {
                    await _firestoreService.addVehicle(
                      userId,
                      _numberController.text,
                      _nameController.text,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vehicle added successfully')),
                    );
                    _numberController.clear();
                    _nameController.clear();
                    Navigator.of(context).pop();
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(String vehicleId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Vehicle"),
          content: Text("Are you sure you want to delete this vehicle?"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Delete"),
              onPressed: () async {
                await _firestoreService.deleteVehicle(vehicleId);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Vehicle deleted successfully')),
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userId = _auth.currentUser?.uid ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Manage EV Vehicles'),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getVehiclesByUserId(userId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final vehicles = snapshot.data ?? [];

          return ListView.builder(
            itemCount: vehicles.length,
            itemBuilder: (context, index) {
              final vehicle = vehicles[index];
              return Card(
                margin: EdgeInsets.all(10.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.electric_car, color: Colors.green),
                  title: Text(vehicle['number'], style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(vehicle['name']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          _numberController.text = vehicle['number'];
                          _nameController.text = vehicle['name'];
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Edit Vehicle"),
                                content: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      DefField(
                                        controller: _numberController,
                                        hint: "Enter your vehicle number",
                                        obsecure: false,
                                        lable: "vehicle number",
                                        inputtype: TextInputType.text,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter vehicle number';
                                          }
                                          return null;
                                        },
                                      ),
                                      DefField(
                                        controller: _nameController,
                                        hint: "Enter your vehicle name",
                                        obsecure: false,
                                        lable: "vehicle name",
                                        inputtype: TextInputType.name,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter vehicle name';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: Text("Update"),
                                    onPressed: () async {
                                      if (_formKey.currentState!.validate()) {
                                        await _firestoreService.updateVehicle(
                                          vehicle['id'],
                                          _numberController.text,
                                          _nameController.text,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Vehicle updated successfully')),
                                        );
                                        _numberController.clear();
                                        _nameController.clear();
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _showDeleteConfirmationDialog(vehicle['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _showAddVehicleDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
