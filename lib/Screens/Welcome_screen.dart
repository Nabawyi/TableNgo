// ignore_for_file: file_names, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tablengo/Screens/Bottom_Nav.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepOrange, Colors.orangeAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomContainer(icon: Icons.restaurant_outlined),
                SizedBox(height: 10),
                Text(
                  "TableNgo",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Your table is waiting",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Book tables with confidence. Pay a small deposit, get refunded when you show up, or have it deducted from your bill.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        CustomContainer(
                          widthforcontainer: 60,
                          heightforcontainer: 60,
                          icon: Icons.person_search_outlined,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Easy Booking",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        CustomContainer(
                          widthforcontainer: 60,
                          heightforcontainer: 60,
                          icon: Icons.security_outlined,
                          size: 40,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Secure Payment",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(width: 8),
                    Column(
                      children: [
                        CustomContainer(
                          icon: Icons.attach_money_outlined,
                          size: 40,
                          widthforcontainer: 60,
                          heightforcontainer: 60,
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Smart Refunds",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to the next screen
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.black87,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Sign In",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BottomNavExample(),
                        ),
                      );
                      // Navigate to the next screen
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 10,
                      shadowColor: Colors.black87,
                      backgroundColor: Colors.white.withOpacity(0.8),
                      padding: EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: Text(
                      "Login ",
                      style: TextStyle(
                        color: Colors.deepOrange,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CustomContainer extends StatelessWidget {
  final IconData? icon;
  final double? size;
  final double? widthforcontainer;
  final double? heightforcontainer;

  const CustomContainer({
    super.key,
    this.icon,
    this.size,
    this.widthforcontainer,
    this.heightforcontainer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widthforcontainer ?? 100,
      height: heightforcontainer ?? 100,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Center(
        child: Icon(
          icon ?? Icons.abc, // Use default icon if none provided
          color: Colors.white,
          size: size ?? 50, // Use default size if none provided
        ),
      ),
    );
  }
}
