import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:ev_station_finder/components/Colors.dart';
import 'package:ev_station_finder/screens/user/user_signin.dart';
import 'package:ev_station_finder/utils/alert_dialog.dart';
import 'package:ev_station_finder/utils/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class ResetScreen extends StatefulWidget {
  const ResetScreen({super.key});
  @override
  State<ResetScreen> createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  Future<void> _sendResetEmail() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: _emailController.text);
      showAlertDialogBox(
          context, "Email Sent!", "Check your email to reset password", () {
        Navigator.popUntil(context, (route) => route.isFirst);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: ((context) => const signIn())));
      });
    } catch (e) {
      Snackbars.error(context, e.toString());
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
              child: Center(
            child: Column(
              children: [
                const Column(
                  children: [
                    SizedBox(
                      height: 38,
                    ),
                    Text(
                      "Reset Password",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    Text(
                      "Please Enter your Information",
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Image(
                      image: AssetImage("assets/icons/forget.png"),
                      height: 180,
                      width: 310,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),
                Center(
                  child: Column(children: [
                    const SizedBox(
                      height: 25,
                    ),
                    Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      child: DefField(
                          controller: _emailController,
                          hint: "Enter your email",
                          obsecure: false,
                          lable: "Email",
                          iconName: Icons.lock,
                          inputtype: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Field cannot be empty';
                            } else if (!value.contains(
                                RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          }),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Button(
                      buttonText: "Reset",
                      buttonFunction: () {
                        if (_formKey.currentState!.validate()) {
                          _sendResetEmail();
                        }
                      }, onTap: () {  },
                    ),
                  ]),
                )
              ],
            ),
          )),
        ),
      ),
    );
  }
}