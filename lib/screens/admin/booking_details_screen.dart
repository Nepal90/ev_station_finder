import 'package:ev_station_finder/models/booking.dart';
import 'package:flutter/material.dart';

class BookingDetailsScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailsScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Station: ${booking.stationName}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Date: ${booking.dateTime.toLocal().toString().split(' ')[0]}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            Text(
              'Time: ${booking.dateTime.toLocal().toString().split(' ')[1].substring(0, 5)}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 5),
            // Text(
            //   'Status: ${booking.status}',
            //   style: TextStyle(
            //     fontSize: 16,
            //     color: booking.status == 'Confirmed' ? Colors.green : Colors.red,
            //   ),
            // ),
            const SizedBox(height: 10),
            Text(
              'Booked by: ${booking.userFirstName} ${booking.userLastName}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text(
              'Email: ${booking.userEmail}',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
