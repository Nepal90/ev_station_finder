import 'package:ev_station_finder/components/DefField.dart';
import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/screens/user/user_signin.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _showPassword = true;
  final _passwordController = TextEditingController();
  final _confirmpasswordController = TextEditingController();
  final _PhoneNumberController = TextEditingController();
  final _roleController = TextEditingController();

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        //....................... Create a new user with email and password......................
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        // Optionally update the user's profile with first and last name
        await userCredential.user?.updateProfile(
            displayName:
                '${_firstNameController.text} ${_lastNameController.text}');

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'firstName': _firstNameController.text.trim(),
          'lastName': _lastNameController.text.trim(),
          'email': _emailController.text.trim(),
          'mobileNumber': _PhoneNumberController.text.trim(),
          'password': _passwordController.text.trim(),
          'role': _roleController.text.trim()
          // Add more fields as needed
        });

        // Clear the form after successful registration
        _formKey.currentState!.reset();

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Successfully signed up!')),
        );

        // Navigate to the SignIn screen after showing the success message
        Future.delayed(const Duration(microseconds: 300), () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const signIn()),
          );
        });
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else {
          message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('An error occurred. Please try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const Column(
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      "Create Account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(5, 244, 164, 1),
                      ),
                    ),
                    Text(
                      "Please Enter your Information",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Image(
                      image: AssetImage("assets/icons/logo.png"),
                      height: 150,
                      width: 280,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: DefField(
                              controller: _firstNameController,
                              hint: "First Name",
                              obsecure: false,
                              lable: "First Name",
                              inputtype: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter First name';
                                } else if (!value
                                    .contains(RegExp(r'^[a-zA-Z\- ]+$'))) {
                                  return 'Invalid First name';
                                }
                                return null;
                              },
                            ),
                          ),
                          Expanded(
                            child: DefField(
                              controller: _lastNameController,
                              hint: "Last Name",
                              obsecure: false,
                              lable: "Last Name",
                              inputtype: TextInputType.name,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter Last name';
                                } else if (!value
                                    .contains(RegExp(r'^[a-zA-Z\- ]+$'))) {
                                  return 'Invalid Last name';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // -----------------------Email Field------------------------------------------
                      DefField(
                        controller: _emailController,
                        hint: "Enter your email",
                        obsecure: false,
                        lable: "Email",
                        inputtype: TextInputType.emailAddress,
                        iconName: Icons.lock,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Field cannot be empty';
                          } else if (!value.contains('@')) {
                            return 'Please enter a valid email';
                          } else if (!value.contains(
                              RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
                            return 'Please enter a valid email';
                          }
                          return null;
                        },
                      ),

                      // -------------------Phone Number field---------------------------
                      const SizedBox(
                        height: 12,
                      ),
                      DefField(
                        controller: _PhoneNumberController,
                        hint: "Enter Your Number",
                        obsecure: false,
                        lable: "Phone number",
                        inputtype: TextInputType.number,
                        inputformatter: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter your number!';
                          }
                          if (value.length < 10) {
                            return 'Enter valid number';
                          }
                          return null;
                        },
                      ),

                      // -------------------Password field---------------------------
                      const SizedBox(height: 12),
                      DefField(
                        controller: _passwordController,
                        hint: "Enter your password",
                        obsecure: _showPassword,
                        lable: "Password",
                        inputtype: TextInputType.visiblePassword,
                        iconName: _showPassword == false
                            ? Icons.visibility
                            : Icons.visibility_off,
                        iconFunction: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter a password';
                          } else if (!value.contains(RegExp(
                              r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$'))) {
                            return 'Requires at least 8 characters,\nAt least one uppercase letter [A-Z],\nAt least one lowercase letter [a-z],\nAt least one number [0-9].';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      // --------------------confirm password------------------------------------------
                      DefField(
                        controller: _confirmpasswordController,
                        lable: 'Confirm Password',
                        hint: 'Re-enter password',
                        obsecure: false,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please re-enter password';
                          } else if (value != _passwordController.text) {
                            return 'Confirm password does not match';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                // --------------------------------------Submit-BUTTON-----------------------------------------
                Button(
                  buttonText: "Sign up",
                  buttonFunction: _signUp,
                  onTap: () {},
                ),
                // -------------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 38,
                    ),
                    const Text(
                      "Already registered?",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 133, 133, 133),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const signIn(),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Color.fromRGBO(5, 244, 164, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
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
