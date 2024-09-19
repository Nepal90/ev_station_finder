import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatelessWidget {
  final T? value;
  final List<T> items;
  final String hint;
  final ValueChanged<T?> onChanged;
  final String? Function(T?)? validator;
  final String? label;
  final String Function(T) itemToString;

  CustomDropdown({
    required this.value,
    required this.items,
    required this.hint,
    required this.onChanged,
    this.validator,
    this.label,
    required this.itemToString,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (label != null)
            Text(label!, style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          DropdownButtonFormField<T>(
            decoration: InputDecoration(
              hintText: hint,
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            value: value,
            items: items.map<DropdownMenuItem<T>>((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(itemToString(item)), // Customize display as needed
              );
            }).toList(),
            onChanged: onChanged,
            validator: validator,
          ),
        ],
      ),
    );
  }
}
