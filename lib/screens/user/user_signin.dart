import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:ev_station_finder/screens/user/forget_password.dart';
import 'package:ev_station_finder/screens/user/user_dashboard.dart';
import 'package:ev_station_finder/screens/admin/admin_dashboard.dart';
import 'package:ev_station_finder/screens/user/user_signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class signIn extends StatefulWidget {
  const signIn({Key? key}) : super(key: key);

  @override
  _signInState createState() => _signInState();
}

class _signInState extends State<signIn> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = true;
  bool _isLoading = false; // Added to manage loading state

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Show loading indicator
      });

      try {
        print('Attempting to sign in with email: ${_emailController.text.trim()}');
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        User? user = userCredential.user;
        if (user != null) {
          DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
          String role = userDoc['role'];

          if (!mounted) return; // Check if the widget is still mounted before navigating

          if (role == 'admin') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminDashboard()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => DashboardScreen()),
            );
          }
        }
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else if (e.code == 'wrong-password') {
          message = 'Wrong password provided for that user.';
        } else {
          message = 'An error occurred: ${e.message}';
        }

        if (mounted) { // Check if the widget is still mounted before showing a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(message),
          ));
        }
      } catch (e) {
        if (mounted) { // Check if the widget is still mounted before showing a SnackBar
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('An unexpected error occurred: $e'),
          ));
        }
      } finally {
        if (mounted) { // Check if the widget is still mounted before updating the state
          setState(() {
            _isLoading = false; // Hide loading indicator
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(height: 18),
                    Text(
                      "Welcome to ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(5, 244, 164, 1),
                      ),
                    ),
                    Text(
                      "Elecharge",
                      textAlign: TextAlign.end,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(5, 244, 164, 1),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please login to continue",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Image(
                  image: AssetImage("assets/icons/logo.png"),
                  height: 180,
                  width: 310,
                  fit: BoxFit.contain,
                ),
                Center(
                  child: Column(
                    children: [
                      SizedBox(height: 19),
                      Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            DefField(
                              controller: _emailController,
                              hint: "Enter your email",
                              obsecure: false,
                              lable: "Email",
                              iconName: Icons.email,
                              inputtype: TextInputType.emailAddress,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Field cannot be empty';
                                } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 18),
                            DefField(
                              controller: _passwordController,
                              hint: "Enter your password",
                              obsecure: _showPassword,
                              lable: "Password",
                              iconName: _showPassword ? Icons.visibility_off : Icons.visibility,
                              iconFunction: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              inputtype: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            GestureDetector(
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ResetScreen(),
                                ),
                              ),
                              child: Container(
                                padding: const EdgeInsets.fromLTRB(0, 8, 15, 5),
                                alignment: Alignment.topRight,
                                child: const Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Button(
  buttonText: "Sign In",
  buttonFunction: _isLoading ? null : _signIn, // Disable button when loading
  onTap: () {},
),
                      if (_isLoading) CircularProgressIndicator(), // Show loading indicator
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 38),
                    Text(
                      "Don't have an Account?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(width: 5),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      ),
                      child: const Text(
                        "Register",
                        style: TextStyle(
                          color: Color.fromRGBO(5, 244, 164, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      color: Colors.grey,
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        size: 22,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
