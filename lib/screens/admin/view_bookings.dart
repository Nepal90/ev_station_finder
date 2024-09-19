import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ViewBookingsScreen extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> _getUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data() as Map<String, dynamic>;
      } else {
        print('User document does not exist for userId: $userId');
      }
    } catch (e) {
      print('Error fetching user details for userId $userId: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View All Bookings'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('bookings').orderBy('timestamp', descending: true).snapshots(),
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

              // Fetch user details
              final userId = bookingData['userId'] ?? '';
              return FutureBuilder<Map<String, dynamic>?>(
                future: _getUserDetails(userId),
                builder: (context, userSnapshot) {
                  if (userSnapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (userSnapshot.hasError) {
                    return Center(child: Text('Error: ${userSnapshot.error}'));
                  }

                  final userData = userSnapshot.data;

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
                                'Duration: ${bookingData['duration'] ?? 'N/A'} hours',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.attach_money, color: Colors.blue),
                              SizedBox(width: 8.0),
                              Text(
                                'Price: ₹${bookingData['price'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.flash_on, color: Colors.blue),
                              SizedBox(width: 8.0),
                              Text(
                                'Voltage: ${bookingData['voltage'] ?? 'N/A'}V',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8.0),
                          Row(
                            children: [
                              Icon(Icons.flash_on, color: Colors.blue),
                              SizedBox(width: 8.0),
                              Text(
                                'Status: ${bookingData['status'] ?? 'N/A'}',
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.0),
                          Divider(color: Colors.grey[300]),
                          SizedBox(height: 8.0),
                          Text(
                            'User Details:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'First Name: ${userData?['firstName'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Last Name: ${userData?['lastName'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          SizedBox(height: 8.0),
                          Text(
                            'Email: ${userData?['email'] ?? 'N/A'}',
                            style: TextStyle(fontSize: 16),
                          ),
                          
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
