import 'package:ev_station_finder/screens/admin/admin_profile.dart';
import 'package:ev_station_finder/screens/admin/manage_slots.dart';
import 'package:ev_station_finder/screens/admin/manage_station.dart';
import 'package:ev_station_finder/screens/admin/view_bookings.dart';
import 'package:flutter/material.dart';
import 'package:ev_station_finder/screens/user/user_signin.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';

class AdminDashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('DASHBOARD'),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => signIn()));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 190, 20, 25),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          children: <Widget>[
            AdminDashboardCard(
              title: 'MANAGE STATIONS',
              iconPath: 'assets/icons/manage_ev_vehicle.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManageStationPage(),
                  ),
                );
              },
            ),
            AdminDashboardCard(
              title: 'MANAGE SLOT',
              iconPath: 'assets/icons/slot.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>ManageSlots(),
                  ),
                );
              },
            ),
            AdminDashboardCard(
              title: 'VIEW BOOKINGS',
              iconPath: 'assets/icons/bookings_car.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewBookingsScreen(),
                  ),
                );
              },
            ),
            AdminDashboardCard(
              title: 'PROFILE',
              iconPath: 'assets/icons/user_profile.svg',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdminProfilePage(),
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

class AdminDashboardCard extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  AdminDashboardCard(
      {required this.title, required this.iconPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: 
      InkWell(
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
