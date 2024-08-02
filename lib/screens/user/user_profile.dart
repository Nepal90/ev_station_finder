import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/provider/UserProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:ev_station_finder/models/user.dart';
//import 'package:ev_station_finder/provider/UserProvider.dart';




class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.green,
      ),
      body: user == null
          ? const Center(
              child: Text(
                'No user logged in',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Card(
                  color: const Color.fromARGB(255, 229, 245, 233),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: CircleAvatar(
                            radius: 80,
                           
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'FName:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.firstname,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'LName:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.lastname,
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Email:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.email,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Phone Number:',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          user.phoneNumber,
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 20),
                        Button(buttonText: "Edit Profile", buttonFunction: () {

                        }, onTap: () {  },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
