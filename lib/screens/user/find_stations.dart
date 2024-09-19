import 'package:flutter/material.dart';
import 'package:ev_station_finder/screens/user/book_slot_screen.dart';
import 'package:ev_station_finder/services/admin_firestore_service.dart';

class StationListScreen extends StatefulWidget {
  @override
  _StationListScreenState createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  final FirestoreServices _firestoreService = FirestoreServices();
  String _searchText = "";
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Find EV Stations'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by city',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchText = value.toLowerCase();
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: _firestoreService.getStations(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final stations = snapshot.data ?? [];
                final filteredStations = stations.where((station) {
                  final stationCity = station['city'].toLowerCase();
                  return stationCity.contains(_searchText);
                }).toList();

                return ListView.builder(
                  padding: EdgeInsets.all(16.0),
                  itemCount: filteredStations.length,
                  itemBuilder: (context, index) {
                    final station = filteredStations[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookSlotScreen(station: station),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.2),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.electric_car,
                              color: Colors.green,
                              size: 40,
                            ),
                            SizedBox(width: 16.0),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    station['name'],
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    '${station['location']}, ${station['city']}',
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 16.0),
                            Icon(
                              station['isEnabled']
                                  ? Icons.check_circle
                                  : Icons.remove_circle,
                              color: station['isEnabled']
                                  ? Colors.green
                                  : Colors.red,
                              size: 30,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
