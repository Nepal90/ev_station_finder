//import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

//import 'package:ev_station_finder/models/user.dart';
import 'package:ev_station_finder/main.dart';
import 'package:ev_station_finder/provider/UserProvider.dart';
import 'package:ev_station_finder/screens/user/find_stations.dart';
import 'package:ev_station_finder/screens/user/manage_vehicles.dart';
import 'package:ev_station_finder/screens/user/roadmap.dart';
import 'package:ev_station_finder/screens/user/user_profile.dart';
import 'package:ev_station_finder/screens/user/user_view_bookings.dart';
import 'package:flutter/material.dart';
import 'package:ev_station_finder/screens/user/user_signin.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('DASHBOARD'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: (){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => signIn()));
            },
            
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 30, 16, 16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            DashboardCard(
              title: 'MANAGE EV VEHICLES',
              iconPath: 'assets/icons/manage_ev_vehicle.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageEvVehiclesScreen(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'FIND STATIONS',
              iconPath: 'assets/icons/map_location.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StationListScreen(),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'VIEW BOOKINGS',
              iconPath: 'assets/icons/bookings_car.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const UserViewBooking(bookings: [],),
                  ),
                );
              },
            ),
            DashboardCard(
              title: 'PROFILE',
              iconPath: 'assets/icons/user_profile.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),

          DashboardCard(
              title: 'ROADMAP',
              iconPath: 'assets/icons/road.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RoadmapScreen(),
                  ),
                );
              },
              ),
          ],
        ),
      ),
    );
  }
}

class DashboardCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  DashboardCard(
      {required this.title, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              SvgPicture.asset(iconPath, height: 50, width: 50),
              SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
