import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AdminProfilePage extends StatefulWidget {
  @override
  _AdminProfilePageState createState() => _AdminProfilePageState();
}

class _AdminProfilePageState extends State<AdminProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<DocumentSnapshot>? _adminDetails;

  @override
  void initState() {
    super.initState();
    _fetchAdminDetails();
  }

  void _fetchAdminDetails() {
    final String uid = _auth.currentUser?.uid ?? '';
    if (uid.isNotEmpty) {
      _adminDetails = _firestore.collection('users').doc(uid).get();
    } else {
      _adminDetails = Future.value(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Profile'),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _adminDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData || snapshot.data == null || !snapshot.data!.exists) {
            return Center(child: Text('No admin details found'));
          }

          final adminData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildProfileDetail('Name', '${adminData['firstName']} ${adminData['lastName']}', Icons.person),
                  _buildDivider(),
                  _buildProfileDetail('Email', '${adminData['email']}', Icons.email),
                  _buildDivider(),
                  _buildProfileDetail('Phone', '${adminData['mobileNumber']}', Icons.phone),
                  _buildDivider(),
                  _buildProfileDetail('Role', '${adminData['role']}', Icons.verified_user),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileDetail(String title, String value, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      subtitle: Text(
        value,
        style: TextStyle(fontSize: 16),
      ),
      contentPadding: EdgeInsets.all(16),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: Colors.grey[300],
      height: 1,
    );
  }
}
