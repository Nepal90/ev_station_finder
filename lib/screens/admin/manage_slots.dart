import 'package:ev_station_finder/screens/admin/add_slot.dart';
import 'package:ev_station_finder/services/slots_firestore_service.dart';
import 'package:flutter/material.dart';

class ManageSlots extends StatelessWidget {
  final SlotFirestoreService _firestoreService = SlotFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Slots'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _firestoreService.getSlots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final slots = snapshot.data ?? [];

          if (slots.isEmpty) {
            return const Center(
              child: Text('No Slots Available', style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            itemCount: slots.length,
            itemBuilder: (context, index) {
              final slot = slots[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    leading: Icon(Icons.electrical_services, color: Colors.green),
                    title: Text(slot['voltage'], style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Price: ${slot['price']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditDialog(context, slot);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            await _firestoreService.deleteSlot(slot['id']);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Slot deleted successfully')),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
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
            MaterialPageRoute(
              builder: (context) => AddSlot(),
            ),
          );
        },
        label: const Text('Add Slot'),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> slot) {
    showDialog(
      context: context,
      builder: (context) {
        return EditSlotDialog(slot: slot);
      },
    );
  }
}

class EditSlotDialog extends StatefulWidget {
  final Map<String, dynamic> slot;

  EditSlotDialog({required this.slot});

  @override
  _EditSlotDialogState createState() => _EditSlotDialogState();
}

class _EditSlotDialogState extends State<EditSlotDialog> {
  final _formKey = GlobalKey<FormState>();
  final SlotFirestoreService _firestoreService = SlotFirestoreService();

  late String _voltage;
  late String _price;
  late bool _isEnabled;

  @override
  void initState() {
    super.initState();
    _voltage = widget.slot['voltage'] ?? '';
    _price = widget.slot['price'] ?? '';
    _isEnabled = widget.slot['isEnabled'] ?? true; // Default to true if null
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Edit Slot'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                initialValue: _voltage,
                decoration: InputDecoration(labelText: 'Voltage'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a voltage'
                    : null,
                onSaved: (value) => _voltage = value!,
              ),
              TextFormField(
                initialValue: _price,
                decoration: InputDecoration(labelText: 'Price'),
                validator: (value) => value == null || value.isEmpty
                    ? 'Please enter a price'
                    : null,
                onSaved: (value) => _price = value!,
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
              await _firestoreService.updateSlot(
                  widget.slot['id'], _voltage, _price, _isEnabled);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Slot updated successfully')),
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
