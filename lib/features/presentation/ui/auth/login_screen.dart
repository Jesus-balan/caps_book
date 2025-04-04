import 'package:caps_book/features/presentation/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            /// **Top Logo**
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  'assets/images/car-img.png'
                ),
              ),
            ),

            /// **White Container - Login Form**
            Positioned(
              top: size.height * 0.4,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(50)),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: size.height * 0.04),

                      /// **Login Title**
                      Center(
                        child: Text(
                          "Login",
                          style: GoogleFonts.lora(
                            fontSize: size.width * 0.09,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// **Email Field**
                      CustomTextField(
                        label: 'Phone',
                        hintText: 'Enter your phone number',
                        keyboardType: TextInputType.number,
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// **Password Field**
                      CustomTextField(
                        label: 'Password', hintText: 'Enter your password',
                        isPassword: true, // No need to pass suffixIcon for password
                      ),

                      SizedBox(height: size.height * 0.02),

                      /// **Login Button**
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed:(){
                             Navigator.pushNamed(context, '/bottombar');
                          },
                          child: Text(
                                    "Login",
                                    style: GoogleFonts.lora(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                                  ),
                        ),
                      ),

                      SizedBox(height: size.height * 0.01),

                      /// **Sign Up Navigation**
                      // Center(
                      //   child: TextButton(
                      //     onPressed: () {
                      //      Navigator.pushNamed(context, '/home');
                      //     },
                      //     child: Text(
                      //       "Don't have an account? Sign Up",
                      //       style: GoogleFonts.lora(fontSize: 16),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
