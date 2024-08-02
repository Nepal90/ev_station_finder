import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:flutter/material.dart';

class RoadmapScreen extends StatefulWidget {
  @override
  _RoadmapScreenState createState() => _RoadmapScreenState();
}

class _RoadmapScreenState extends State<RoadmapScreen> {
  final _formKey = GlobalKey<FormState>();

  final _sourceController = TextEditingController();
  final _destinationController = TextEditingController();

  String? _source;
  String? _destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Roadmap'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
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
              DefField(
                controller: _sourceController,
                hint: "Enter your location",
                obsecure: false,
                lable: "location",
                inputtype: TextInputType.name,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your location';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20.0),
              Column(
                children: [
                  Center(
                    child: Button(
                      buttonText: "Roadmap",
                      buttonFunction: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('please wait ! roadmap  loading')),
                          );
                          // Add vehicle logic here
                        }
                      }, onTap: () {  },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
