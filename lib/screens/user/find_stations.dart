import 'package:ev_station_finder/components/DefField.dart';
import 'package:flutter/material.dart';
import 'package:ev_station_finder/models/station.dart';
import 'package:ev_station_finder/widgets/station_card.dart';

class StationListScreen extends StatefulWidget {
  @override
  _StationListScreenState createState() => _StationListScreenState();
}

class _StationListScreenState extends State<StationListScreen> {
  final _nameController = TextEditingController();
  final List<Station> allStations = [
    Station(
      name: 'charge_station 1',
      address: 'niharika, Korba, Chhattisgarh',
      imageUrl: 'https://media.istockphoto.com/id/1393199281/photo/charging-stations-for-electric-cars-at-a-parking-lot.jpg?s=612x612&w=0&k=20&c=wJicZeR-yfR1I3MHWxQ0ZZUV2nUMhovwq-zVGJrYZPI=',
      city: 'Korba',
      nearby: true,
      status: 'Enabled',
    ),
    Station(
      name: 'charge_station 2',
      address: 'koshabadi, Korba, Chhattisgarh',
      imageUrl: 'https://media.istockphoto.com/id/1348631007/photo/ev-charging-station-for-electric-car-in-concept-of-green-energy-and-eco-power.jpg?s=612x612&w=0&k=20&c=yTL95mCTPWTNqEO4NqiWWSeC_JMINNUJeChE9a6YKVc=',
      city: 'korba',
      nearby: true,
      status: 'Enabled',
    ),
    Station(
      name: 'charge_station 3',
      address: 'Transport nagar, Korba, Chhattisgarh',
      imageUrl: 'https://media.istockphoto.com/id/1292252309/photo/electric-cars-are-charging-in-station.jpg?s=612x612&w=0&k=20&c=i2hMAmP83hPn-NKTm7iIE6JVh3mFvIpChHxPD3dtg4M=',
      city: 'korba',
      nearby: true,
      status: 'Enabled',
    ),
    Station(
      name: 'charge_station 4',
      address: 'dipka, korba, Chhattisgarh',
      imageUrl: 'https://media.istockphoto.com/id/1073405402/photo/power-supply-box-in-an-electric-vehicle-charging-station-at-a-parking-lot.jpg?s=612x612&w=0&k=20&c=oMPdqM67RNpTDZpZ-EhaqyUkiNy15C8Dl9JaaJ5GW5c=',
      city: 'korba',
      nearby: false,
      status: 'Enabled',
    ),
  ];

  List<Station> filteredStations = [];
  String searchCity = '';
  bool searchNearby = false;
  String searchStatus = 'All';

  @override
  void initState() {
    super.initState();
    filteredStations = allStations;
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
                          searchNearby = value!;
                          filterStations();
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
                      searchStatus = value!;
                      filterStations();
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
