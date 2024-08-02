import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ev_station_finder/services/admin_firestore_service.dart';
import 'package:ev_station_finder/models/station.dart';
import 'package:ev_station_finder/widgets/station_card.dart';
import 'package:ev_station_finder/components/DefField.dart';

class StationListScreen extends StatefulWidget {
  @override
  _StationListScreenState createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  final _nameController = TextEditingController();
  final FirestoreServices _firestoreService = FirestoreServices();
  List<Station> allStations = [];
  List<Station> filteredStations = [];
  String searchCity = '';
  bool searchNearby = false;
  String searchStatus = 'All';

  @override
  void initState() {
    super.initState();
    _fetchStations();
  }

  void _fetchStations() async {
    _firestoreService.getStations().listen((stations) {
      setState(() {
        allStations = stations.cast<Station>();
        filteredStations = allStations;
      });
    });
  }

  void filterStations() {
    setState(() {
      filteredStations = allStations.where((station) {
        final cityMatch = searchCity.isEmpty || station.city.toLowerCase().contains(searchCity.toLowerCase());
        final nearbyMatch = !searchNearby || station.nearby;
        final statusMatch = searchStatus == 'All' || station.status == searchStatus;

        return cityMatch && nearbyMatch && statusMatch;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('EV Stations'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  DefField(
                    controller: _nameController,
                    hint: "Search by city",
                    obsecure: false,
                    lable: "Search city",
                    inputtype: TextInputType.name,
                    onChanged: (value) {
                      searchCity = value;
                      filterStations();
                    },
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Checkbox(
                        value: searchNearby,
                        onChanged: (value) {
                          setState(() {
                            searchNearby = value!;
                            filterStations();
                          });
                        },
                      ),
                      const Text('Nearby'),
                    ],
                  ),
                  const SizedBox(height: 10),
                  DropdownButton<String>(
                    value: searchStatus,
                    items: <String>['All', 'Enabled', 'Disabled'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        searchStatus = value!;
                        filterStations();
                      });
                    },
                  ),
                ],
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: filteredStations.length,
              itemBuilder: (context, index) {
                return StationCard(station: filteredStations[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}
