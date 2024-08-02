import 'package:ev_station_finder/screens/admin/admin_dashboard.dart';
import 'package:ev_station_finder/screens/user/user_dashboard.dart';
import 'package:ev_station_finder/screens/user/user_signup.dart';
import 'package:ev_station_finder/components/Button.dart';
import 'package:ev_station_finder/components/DefField.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class login extends StatefulWidget {
  const login({super.key});
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _showPassword = true;
  

  // Future<void> _signIn() {}
  // async {}
  //   try {
  //     await FirebaseAuth.instance.signInWithEmailAndPassword(
  //       email: _emailController.text,
  //       password: _passwordController.text,
  //     );
  //   } on FirebaseAuthException catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //       content: Text(e.message ?? 'Unknown error'),
  //     ));
  //   }
  // }
//---------------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Column(
                children: [
                  SizedBox(
                    height: 18,
                  ),
                  //-------------------Page Heading-------------------------------------

                  Text("Welcome to ",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        decorationThickness: 8,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(5, 244, 164, 1),
                      )),
                  Text(
                    "Elecharge",
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontSize: 21,
                      decorationThickness: 8,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(5, 244, 164, 1),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "Please login to continue",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              //------------------------------------ Page Imag-e-----------------------------------
              const Image(
                image: AssetImage("assets/icons/logo.png"),
                height: 180,
                width: 310,
                fit: BoxFit.contain,
              ),
              Center(
                child: Column(
                  children: [
                    const SizedBox(
                      height: 19,
                    ),

                    Form(
                        key: _formKey,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        child: Column(
                          children: [
                            //--------------------------------Email Field--------------------------------------------
                            DefField(
                              controller: _emailController,
                              hint: "Enter your email",
                              obsecure: false,
                              lable: "Email",
                              iconName: Icons.lock,
                              inputtype: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Field cannot be empty';
                                } else if (!value.contains(RegExp(
                                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'))) {
                                  return 'Please enter a valid Email';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            //----------------------------- Password field-------------------------------------------
                            DefField(
                              controller: _passwordController,
                              hint: "Enter your password",
                              obsecure: _showPassword,
                              lable: "Password",
                              iconName: _showPassword == false
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              iconFunction: () {
                                setState(() {
                                  _showPassword = !_showPassword;
                                });
                              },
                              inputtype: TextInputType.visiblePassword,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                            ),
                            //-------------------------------------------Forget password button-------------------------------------
                            GestureDetector(
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
                        )),
                    const SizedBox(
                      height: 5,
                    ),
                    //----------------------- Login button-----------------------
                    Button(
                        buttonText: "Log In",
                        buttonFunction: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminDashboard()));
                          }
                        }, onTap: () {  },)
                  ],
                ),
              ),
              //-------------------------- Register screen Navigation---------------------------------------
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 38,
                  ),
                  const Text(
                    "Don't have an Account ?",
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
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => const SignUpScreen()))),
                    child: const Text("Register",
                        style: TextStyle(
                          color: Color.fromRGBO(5, 244, 164, 1),
                          fontWeight: FontWeight.w500,
                          fontSize: 15,
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      )),
    );
  }
}
