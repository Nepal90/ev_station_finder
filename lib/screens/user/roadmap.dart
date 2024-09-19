import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';

class RoadmapScreen extends StatefulWidget {
  @override
  _RoadmapScreenState createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();

  GoogleMapController? _mapController;
  List<LatLng> _polylineCoordinates = [];

  // Initial position for the map
  static const LatLng _initialPosition = LatLng(37.77483, -122.41942);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Roadmap'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: _initialPosition,
                  zoom: 12,
                ),
                onMapCreated: (GoogleMapController controller) {
                  _mapController = controller;
                },
                polylines: {
                  Polyline(
                    polylineId: PolylineId('route'),
                    points: _polylineCoordinates,
                    color: Colors.blue,
                    width: 5,
                  ),
                },
              ),
            ),
            const SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  DefField(
                    controller: _sourceController,
                    hint: "Enter your location",
                    obsecure: false,
                    lable: "Location",
                    inputtype: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your location';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  DefField(
                    controller: _destinationController,
                    hint: "Enter your Destination",
                    obsecure: false,
                    lable: "Destination",
                    inputtype: TextInputType.text,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your Destination';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Center(
                    child: Button(
                      buttonText: "Find Roadmap",
                      buttonFunction: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please wait! Roadmap loading')),
                          );

                          try {
                            final sourceCoordinates = await getCoordinates(_sourceController.text);
                            final destinationCoordinates = await getCoordinates(_destinationController.text);
                            final directions = await getDirections(sourceCoordinates, destinationCoordinates);
                            setState(() {
                              _polylineCoordinates = directions;
                            });
                            if (_mapController != null) {
                              _mapController!.animateCamera(CameraUpdate.newLatLngBounds(
                                LatLngBounds(
                                  southwest: sourceCoordinates,
                                  northeast: destinationCoordinates,
                                ),
                                50,
                              ));
                            }
                          } catch (e) {
                            print('Error occurred: $e');
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Failed to load roadmap: $e')),
                            );
                          }
                        }
                      },
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<LatLng> getCoordinates(String address) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?address=$address&key=AIzaSyCBabXELhEmRoVC4YR3ihVOz8j4uPmVC5k');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        final location = data['results'][0]['geometry']['location'];
        final lat = location['lat'];
        final lon = location['lng'];
        return LatLng(lat, lon);
      } else {
        throw Exception('No results found for address: $address');
      }
    } else {
      throw Exception('Failed to fetch coordinates');
    }
  }

  Future<List<LatLng>> getDirections(LatLng origin, LatLng destination) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${origin.latitude},${origin.longitude}&destination=${destination.latitude},${destination.longitude}&key=AIzaSyCBabXELhEmRoVC4YR3ihVOz8j4uPmVC5k');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        final points = data['routes'][0]['overview_polyline']['points'];
        return decodePolyline(points);
      } else {
        throw Exception('No routes found');
      }
    } else {
      throw Exception('Failed to fetch directions');
    }
  }

  List<LatLng> decodePolyline(String encoded) {
    var list = encoded.codeUnits;
    var lList = <LatLng>[];
    int index = 0;
    int len = encoded.length;
    int latitude = 0;
    int longitude = 0;

    while (index < len) {
      int b;
      int shift = 0;
      int result = 0;

      do {
        b = list[index++] - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      latitude += dlat;

      shift = 0;
      result = 0;

      do {
        b = list[index++] - 63;
        result |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);

      int dlon = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      longitude += dlon;

      lList.add(LatLng(
        (latitude / 1E5).toDouble(),
        (longitude / 1E5).toDouble(),
      ));
    }

    return lList;
  }
}
