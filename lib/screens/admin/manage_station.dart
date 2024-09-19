import 'package:ev_station_finder/screens/admin/add_station.dart';
import 'package:ev_station_finder/services/admin_firestore_service.dart';
import 'package:flutter/material.dart';

class ManageStationPage extends StatelessWidget {
  final FirestoreServices _firestoreService = FirestoreServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage EV Stations'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getStations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final stations = snapshot.data ?? [];

          return ListView.builder(
            padding: EdgeInsets.all(16.0), // Add padding around the list
            itemCount: stations.length,
            itemBuilder: (context, index) {
              final station = stations[index];
              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0), // Margin between items
                padding: EdgeInsets.all(16.0), // Padding inside the container
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.electric_car,
                      color: Colors.green,
                      size: 40,
                    ),
                    SizedBox(width: 16.0),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station['name'],
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.0),
                          Text(
                            '${station['location']}, ${station['city']}',
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 16.0),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _showEditDialog(context, station);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () async {
                            await _firestoreService.deleteStation(station['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Station deleted successfully')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddStationPage()),
          );
        },
        label: const Text('Add Station'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> station) {
    showDialog(
      context: context,
      builder: (context) {
        return EditStationDialog(station: station);
      },
    );
  }
}

class EditStationDialog extends StatefulWidget {
  final Map<String, dynamic> station;

  EditStationDialog({required this.station});

  @override
  _EditStationDialogState createState() => _EditStationDialogState();
}

class _EditStationDialogState extends State<EditStationDialog> {
  final _formKey = GlobalKey<FormState>();
  final FirestoreServices _firestoreService = FirestoreServices();

  late String _name;
  late String _location;
  late String _city;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _name = widget.station['name'];
    _location = widget.station['location'];
    _city = widget.station['city'];
    _isEnabled = widget.station['isEnabled'];
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Station'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _name,
                decoration: InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a name'
                    : null,
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _location,
                decoration: InputDecoration(labelText: 'Location'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a location'
                    : null,
                onSaved: (value) => _location = value!,
              ),
              TextFormField(
                initialValue: _city,
                decoration: InputDecoration(labelText: 'City'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a city'
                    : null,
                onSaved: (value) => _city = value!,
              ),
              SwitchListTile(
                title: Text('Enabled'),
                value: _isEnabled,
                onChanged: (value) {
                  setState(() {
                    _isEnabled = value;
                  });
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await _firestoreService.updateStation(
                  widget.station['id'], _name, _location, _city, _isEnabled);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Station updated successfully')),
              );
              Navigator.of(context).pop();
            }
          },
          child: Text('Save Changes'),
        ),
      ],
    );
  }
}
