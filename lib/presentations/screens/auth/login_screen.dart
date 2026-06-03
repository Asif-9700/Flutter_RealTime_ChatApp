import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nine_hour_chat_app/config/core/common/custom_button.dart';
import 'package:nine_hour_chat_app/config/core/common/custom_text_field.dart';
import 'package:nine_hour_chat_app/data/services/service_locator.dart';
import 'package:nine_hour_chat_app/logic/cubit/auth/auth_state.dart';
import 'package:nine_hour_chat_app/presentations/home/home_screen.dart';
import 'package:nine_hour_chat_app/presentations/screens/auth/signup_screen.dart';
import 'package:nine_hour_chat_app/router/app_router.dart';

import '../../../logic/cubit/auth/auth_cubit.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  //email validator
  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter valid email";
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email address (e.g., example@.com';
    }
    return null;
  }

  //password validator
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter a password";
    }
    if (value.length < 6) {
      return "Password must be 6 character long";
    }
    return null;
  }

  Future<void> handleSignIn() async {
    FocusScope.of(context).unfocus();

    if (_formKey.currentState?.validate() ?? false) {
      try {
        await getIt<AuthCubit>().signIn(
          email: emailController.text,
          password: passwordController.text,
        );

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Signin successful")));
      } catch (e) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.toString())));
      }
    } else {
      print("form validation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      bloc: getIt<AuthCubit>(),
      listenWhen: (previous, current) {
        return previous.status != current.status ||
            previous.error != current.error;
      },
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          getIt<AppRouter>().pushAndRemoveUntil(const HomeScreen());
        }
      },
      child: Scaffold(
        appBar: AppBar(),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Text(
                    "Welcome back",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Sign in to continue",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                  ),
                  SizedBox(height: 30),
                  CustomTextField(
                    controller: emailController,
                    hintText: "Email",
                    prefixIcon: Icon(Icons.email_outlined),
                    validator: _emailValidator,
                    focusNode: _emailFocus,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    controller: passwordController,
                    hintText: "Password",
                    obscureText: !_isPasswordVisible,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                      ),
                    ),
                    prefixIcon: Icon(Icons.lock_outline),
                    validator: _passwordValidator,
                    focusNode: _passwordFocus,
                  ),
                  SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      "Forgot password",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 30),
                  CustomButton(onPressed: handleSignIn, text: "Login"),
                  SizedBox(height: 20),
                  Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account?    ",
                        style: TextStyle(color: Colors.grey[600]),
                        children: [
                          TextSpan(
                            text: "Sign Up",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: Theme.of(context).primaryColor,
                                ),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const SignupScreen(),
                                //   ),
                                // );
                                getIt<AppRouter>().push(const SignupScreen());
                              },
                          ),
                        ],
                      ),
                    ),
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
