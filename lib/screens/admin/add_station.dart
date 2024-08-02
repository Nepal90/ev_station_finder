import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:flutter/material.dart';

class AddStationPage extends StatefulWidget {
  const AddStationPage({super.key});

  @override
  State<AddStationPage> createState() => _AddStationPageState();
}

class _AddStationPageState extends State<AddStationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _cityController = TextEditingController();

  // String? _stationName;
  // String? _locationName;
  // String? _cityName;

  bool _isStationEnabled = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Add Stations'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DefField(
                controller: _nameController,
                hint: "Enter Station Name",
                obsecure: false,
                lable: "Name Of Station",
                inputtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Station';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              DefField(
                controller: _locationController,
                hint: "Enter your state",
                obsecure: false,
                lable: "Station State",
                inputtype: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter State';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              DefField(
                controller: _cityController,
                hint: "Enter your City",
                obsecure: false,
                lable: "Station City",
                inputtype: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter City';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),

              Padding(
                padding: const EdgeInsets.fromLTRB(10,8,8,8),
                child: Row(
                  children: [
                    Text('Station Enabled:'),
                    Switch(
                      value: _isStationEnabled,
                      onChanged: (value) {
                        setState(() {
                          _isStationEnabled = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              Center(
                child: Button(
                  buttonText: "Add Station",
                  buttonFunction: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Station added successfully'),
                        ),
                      );
                      // Add station logic here, including the _isStationEnabled state
                    }
                  }, onTap: () {  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
