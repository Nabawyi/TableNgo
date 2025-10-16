// ignore_for_file: deprecated_member_use

import 'package:TableNgo/Authentication/auth_service.dart';
import 'package:flutter/material.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final authservice = AuthService();

    final emailContoller = TextEditingController();
    final passwordContoller = TextEditingController();
    final confirmpasswordContoller = TextEditingController();

    void signup() async {
      final email = emailContoller.text;
      final password = passwordContoller.text;
      final confpassword = confirmpasswordContoller.text;
      if (password != confpassword) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("passwords don't match")));
      }
      try {
        await authservice.signupwithEmailandPassword(email, password);
        Navigator.pop(context);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Error : $e')));
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Image.asset('assets/images/Logo1.png', height: 50),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      // Remove appBar since you already have one
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepOrange, Colors.orangeAccent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),

                  // Title
                  Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Email Field
                  TextField(
                    cursorColor: Colors.white70,

                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.white70),

                    controller: emailContoller,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(82, 255, 255, 255),
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Colors.white70,
                      ),

                      labelText: 'Email',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    cursorColor: Colors.white70,

                    style: TextStyle(color: Colors.white70),

                    controller: passwordContoller,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(82, 255, 255, 255),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                      ),

                      labelText: 'Password',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextField(
                    cursorColor: Colors.white70,

                    style: TextStyle(color: Colors.white70),
                    controller: confirmpasswordContoller,
                    obscureText: true,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(82, 255, 255, 255),
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        color: Colors.white70,
                      ),

                      labelText: 'Conffirm Password',
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.deepOrange),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Sign In Button
                  SizedBox(
                    height: 60,
                    width: 200,
                    child: ElevatedButton(
                      onPressed: signup,
                      style: ElevatedButton.styleFrom(
                        elevation: 2,
                        shadowColor: Colors.grey,
                        backgroundColor: Colors.white.withOpacity(0.8),
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                      ),
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: Colors.deepOrange,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Forgot Password
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
