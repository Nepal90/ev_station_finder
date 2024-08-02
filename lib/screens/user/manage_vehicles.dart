import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:flutter/material.dart';

class ManageEvVehiclesScreen extends StatefulWidget {
  @override
  _ManageEvVehiclesScreenState createState() => _ManageEvVehiclesScreenState();
}

class _ManageEvVehiclesScreenState extends State<ManageEvVehiclesScreen> {
  final _formKey = GlobalKey<FormState>();

  final _numberController = TextEditingController();
  final _nameController = TextEditingController();

  String? _vehicleNumber;
  String? _vehicleName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Manage EV Vehicles'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              const SizedBox(height: 20.0),
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
              const SizedBox(height: 20.0),
              Column(
                children: [
                  Center(
                    child: Button(
                      buttonText: "Add Vehicle",
                      buttonFunction: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Vehicle added successfully')),
                          );
                          // Add vehicle logic here
                        }
                      }, onTap: () {  },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
