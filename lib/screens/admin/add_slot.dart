import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:ev_station_finder/services/slots_firestore_service.dart';
import 'package:flutter/material.dart';

class AddSlot extends StatefulWidget {
  const AddSlot({super.key});

  @override
  State<AddSlot> createState() => _AddSlotState();
}

class _AddSlotState extends State<AddSlot> {
  final _formKey = GlobalKey<FormState>();
  final _firestoreService = SlotFirestoreService();

  final _voltageController = TextEditingController();
  final _priceController = TextEditingController();

  bool _isStationEnabled = true;

  @override
  void dispose() {
    _voltageController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Add Slot'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DefField(
                controller: _voltageController,
                hint: "Enter Voltage",
                obsecure: false,
                lable: "Voltage",
                inputtype: TextInputType.text,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Voltage';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              DefField(
                controller: _priceController,
                hint: "Enter voltage price",
                obsecure: false,
                lable: "Price",
                inputtype: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter Price';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                child: Row(
                  children: [
                    const Text('Slot Enabled:'),
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
                  buttonText: "Add Slot",
                  buttonFunction: () async {
                    if (_formKey.currentState!.validate()) {
                      await _firestoreService.addSlot(
                        _voltageController.text,
                        _priceController.text,
                        _isStationEnabled,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Slot added successfully'),
                        ),
                      );
                      Navigator.of(context).pop(); 
                    }
                  },
                  onTap: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
