import 'dart:typed_data';
import 'package:ecosort_app_test/components/show_snackbar.dart';
import 'package:ecosort_app_test/components/text_field_input.dart';
import 'package:ecosort_app_test/screens/home_screen.dart';
import 'package:ecosort_app_test/screens/login_screen.dart';
import 'package:ecosort_app_test/services/auth_methods.dart';
import 'package:ecosort_app_test/utils/colors.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void signUpUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
    );

    setState(() {
      _isLoading = false;
    });

    // if string returned is success, user has been created
    if (res != "success") {
      showSnackBar(res, context);
    } else {
      // navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            padding: MediaQuery.of(context).size.width > 600
                ? EdgeInsets.symmetric(
                    horizontal: MediaQuery.of(context).size.width / 3,
                  )
                : const EdgeInsets.symmetric(horizontal: 32.0),
            width: double.infinity,
            color: mobileBackgroundColor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16.0),
                // Logo
                Image.asset(
                  'assets/appstore.png',
                  height: 300.0,
                ),
                const SizedBox(height: 74.0),

                // Username textfield
                TextFieldInput(
                  hintText: 'Enter your username',
                  textEditingController: _usernameController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24.0),
                // Email textfield
                TextFieldInput(
                  hintText: 'Enter your email',
                  textEditingController: _emailController,
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 24.0),
                // Password textfield
                TextFieldInput(
                  hintText: 'Enter your password',
                  textEditingController: _passwordController,
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 24.0),
                // Bio textfield
                TextFieldInput(
                  hintText: 'Enter your bio',
                  textEditingController: _bioController,
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24.0),
                // Button
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    decoration: const ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      color: blueColor,
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: primaryColor,
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(color: primaryColor),
                          ),
                  ),
                ),
                const SizedBox(height: 12.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account?"),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: blueColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 46.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
