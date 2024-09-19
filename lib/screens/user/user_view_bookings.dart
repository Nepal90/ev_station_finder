import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewBookingsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final User? currentUser = _auth.currentUser;

    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('View Bookings'),
          backgroundColor: Colors.green,
        ),
        body: Center(
          child: Text('You need to be logged in to view bookings.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('View Bookings'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('bookings')
            .where('userId', isEqualTo: currentUser.uid)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final bookings = snapshot.data?.docs ?? [];

          if (bookings.isEmpty) {
            return Center(child: Text('No bookings found.'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16.0),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final bookingData = booking.data() as Map<String, dynamic>;

              // Handling null date field
              final DateTime? date = bookingData['date']?.toDate();
              final String formattedDate = date != null
                  ? DateFormat('yyyy-MM-dd').format(date)
                  : 'No date provided';

              return Card(
                margin: EdgeInsets.symmetric(vertical: 8.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bookingData['stationName'] ?? 'Unknown Station',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      ),
                      Divider(color: Colors.grey[300]),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Date: $formattedDate',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.access_time, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Time: ${bookingData['time'] ?? 'No time provided'}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Duration: ${bookingData['duration']} hours',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.money, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Price: ₹${bookingData['price']}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.electrical_services, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Voltage: ${bookingData['voltage']} V',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.0),
                      Row(
                        children: [
                          Icon(Icons.star_outline_sharp, color: Colors.blue),
                          SizedBox(width: 8.0),
                          Text(
                            'Status: ${bookingData['status']} ',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
