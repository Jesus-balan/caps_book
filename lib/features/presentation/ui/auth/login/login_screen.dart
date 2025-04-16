import 'package:caps_book/features/config/styles.dart';
import 'package:caps_book/features/data/model/login_model.dart';
import 'package:caps_book/features/presentation/blocs/login-auth/login_bloc.dart';
import 'package:caps_book/features/presentation/widgets/textfield_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? fieldValidator(String? value, {required String fieldType}) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldType is required';
    }

    if (fieldType == 'Phone') {
      final phoneRegex = RegExp(r'^\d{10}$'); // exactly 10 digits
      if (!phoneRegex.hasMatch(value.trim())) {
        return 'Enter a valid 10-digit phone number';
      }
    }

    if (fieldType == 'Password') {
      if (value.length < 4) {
        return 'Password must be at least 4 characters';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: ColorStyle.primaryColor,
      body: SafeArea(
        child: Stack(
          children: [
            /// **Top Logo**
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(child: Image.asset('assets/images/car-img.png')),
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
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                       constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: IntrinsicHeight(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: size.height * 0.03),
                        
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
                        
                              /// **Phone Field**
                              CustomTextField(
                                label: 'Phone',
                                hintText: 'Enter your phone number',
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                validator:
                                    (value) =>
                                        fieldValidator(value, fieldType: 'Phone'),
                                controller: phoneController,
                              ),
                        
                              /// **Password Field**
                              CustomTextField(
                                label: 'Password',
                                hintText: 'Enter your password',
                                controller: passwordController,
                                validator:
                                    (value) =>
                                        fieldValidator(value, fieldType: 'Password'),
                                isPassword: true,
                              ),
                        
                              SizedBox(height: size.height * 0.02),
                        
                              /// **Login Button**
                              BlocConsumer<LoginBloc, LoginState>(
                                listener: (context, state) {
                                  if (state is LoginSuccess) {
                                    Navigator.pushNamed(context, '/bottombar');
                                  }
                                  if (state is LoginFailure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(state.error),
                                        backgroundColor: Colors.red,
                                        behavior: SnackBarBehavior.floating,
                                      ),
                                    );
                                  }
                                },
                                builder: (context, state) {
                                  return SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: ColorStyle.primaryColor,
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 16,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                      ),
                                      onPressed:
                                          state is LoginLoading
                                              ? null
                                              : () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  context.read<LoginBloc>().add(
                                                    LoginAuthEvent(
                                                      LoginModel(
                                                        phone_number:
                                                            phoneController.text,
                                                        password:
                                                            passwordController.text,
                                                      ),
                                                    ),
                                                  );
                                                }
                                              },
                                      child:
                                          state is LoginLoading
                                              ? CircularProgressIndicator(
                                                color: ColorStyle.primaryColor,
                                              )
                                              : Text(
                                                "Login",
                                                style: GoogleFonts.lora(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                ),
                                              ),
                                    ),
                                  );
                                },
                              ),
                        
                              SizedBox(height: size.height * 0.01),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
