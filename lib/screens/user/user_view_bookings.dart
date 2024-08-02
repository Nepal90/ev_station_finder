import 'package:flutter/material.dart';
import 'package:ev_station_finder/models/booking.dart';

class UserViewBooking extends StatelessWidget {
  final List<Booking> bookings;

  const UserViewBooking({Key? key, required this.bookings}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Bookings'),
        backgroundColor: Colors.green,
      ),
      body: bookings.isEmpty
          ? const Center(
              child: Text(
                'No bookings yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text(
                      booking.stationName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                        Text(
                          'Status: ${booking.status}',
                          style: TextStyle(
                            fontSize: 16,
                            color: booking.status == 'Confirmed' ? Colors.green : Colors.red,
                          ),
                        ),
                      ],
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle booking details navigation
                    },
                  ),
                );
              },
            ),
    );
  }
}
