import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:ev_station_finder/components/Button.dart';

class BookSlotScreen extends StatefulWidget {
  final Map<String, dynamic> station;

  BookSlotScreen({required this.station});

  @override
  _BookSlotScreenState createState() => _BookSlotScreenState();
}

class _BookSlotScreenState extends State<BookSlotScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _voltageController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

 Future<void> _bookSlot() async {
  if (_selectedDate == null || _selectedTime == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please select both date and time.')),
    );
    return;
  }

  if (!_formKey.currentState!.validate()) {
    return;
  }

  final User? currentUser = _auth.currentUser;

  if (currentUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('You need to be logged in to book a slot.')),
    );
    return;
  }

  try {
    await _firestore.collection('bookings').add({
      'userId': currentUser.uid,
      'stationId': widget.station['id'],
      'stationName': widget.station['name'],
      'date': _selectedDate,
      'time': _selectedTime?.format(context),
      'duration': int.parse(_durationController.text),
      'price': double.parse(_priceController.text),
      'voltage': int.parse(_voltageController.text),
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Slot booked successfully!')),
    );
    Navigator.pop(context);
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Failed to book slot: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Slot at ${widget.station['name']}'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ListTile(
                title: Text('Select Date'),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
              ),
              if (_selectedDate != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Selected Date: ${_selectedDate!.toLocal()}'.split(' ')[0]),
                ),
              ListTile(
                title: Text('Select Time'),
                trailing: Icon(Icons.access_time),
                onTap: () async {
                  TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedTime = picked;
                    });
                  }
                },
              ),
              if (_selectedTime != null)
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0),
                  child: Text('Selected Time: ${_selectedTime!.format(context)}'),
                ),
              DefField(
                controller: _durationController,
                hint: 'Enter Duration (hours)',
                obsecure: false,
                lable: 'Duration',
                inputtype: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a duration';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              DefField(
                controller: _priceController,
                hint: 'Enter Price (₹)',
                obsecure: false,
                lable: 'Price (₹)',
                inputtype: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a price';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              DefField(
                controller: _voltageController,
                hint: 'Enter Voltage',
                obsecure: false,
                lable: 'Voltage',
                inputtype: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a voltage';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              Button(
                buttonText: 'Book Slot',
                buttonFunction: () {
                  _bookSlot();
                },
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
