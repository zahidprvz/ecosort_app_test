import 'package:ecosort_app_test/components/show_snackbar.dart';
import 'package:ecosort_app_test/components/text_field_input.dart';
import 'package:ecosort_app_test/screens/home_screen.dart';
import 'package:ecosort_app_test/screens/signup_screen.dart';
import 'package:ecosort_app_test/services/auth_methods.dart';
import 'package:ecosort_app_test/utils/colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
      email: _emailController.text,
      password: _passwordController.text,
    );

    if (res == 'success') {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigateToSignup() {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => const SignupScreen(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Expanded(
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
                  const SizedBox(
                    height: 64.0,
                  ),
                  // Logo
                  Image.asset(
                    'assets/appstore.png',
                    height: 300.0,
                  ),
                  const SizedBox(
                    height: 120.0,
                  ),
                  // Email textfield
                  TextFieldInput(
                    hintText: 'Enter your email',
                    textEditingController: _emailController,
                    textInputType: TextInputType.emailAddress,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  // Password textfield
                  TextFieldInput(
                    hintText: 'Enter your password',
                    textEditingController: _passwordController,
                    textInputType: TextInputType.text,
                    isPass: true,
                  ),
                  const SizedBox(
                    height: 24.0,
                  ),
                  // Button
                  InkWell(
                    onTap: loginUser,
                    child: Container(
                      width: double.infinity,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                      decoration: const ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(4.0),
                          ),
                        ),
                        color: blueColor,
                      ),
                      child: _isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: primaryColor,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(color: primaryColor),
                            ),
                    ),
                  ),
                  const SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                        ),
                        child: const Text("Don't have an account?"),
                      ),
                      GestureDetector(
                        onTap: navigateToSignup,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            vertical: 8.0,
                          ),
                          child: const Text(
                            "Sign Up",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: blueColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 64.0,
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
