import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/Screens/Welcome_screen.dart';

class ProfileScreen extends StatelessWidget {
  final phoneController = TextEditingController();

  final SupabaseClient supabase = Supabase.instance.client;

  ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    if (user == null) {
      return Scaffold(body: Center(child: Text('No logged-in user')));
    }
    final name = user.userMetadata?['User_Name'] ?? 'Unknown User';
    final phone = user.userMetadata?['phone'] ?? 'Unknown User';
    final email = user.email ?? 'No email';
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(backgroundColor: Colors.white70),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.orange.shade200,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              SizedBox(height: 16),
              Text(
                name,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 30),
              Container(
                padding: EdgeInsets.all(12),
                width: double.infinity,
                height: 320,
                decoration: BoxDecoration(
                  color: Colors.white60,
                  border: BoxBorder.all(
                    color: Colors.grey,
                    width: 0.5,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadiusGeometry.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text('Personal information ')),
                    SizedBox(height: 6),
                    Text("User name", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 4),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.white70,
                        style: const TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(237, 252, 252, 252),
                          prefixIcon: const Icon(
                            Icons.person_outline_outlined,
                            color: Colors.grey,
                          ),
                          labelText: name,
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final egyptPhoneRegExp = RegExp(
                            r'^(?:\+20|0020|0)?1[0-2,5][0-9]{8}$',
                          );

                          if (!egyptPhoneRegExp.hasMatch(value)) {
                            return 'Enter a valid Egyptian phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 6),
                    Text("Email", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 4),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.white70,
                        style: const TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(237, 252, 252, 252),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: Colors.grey,
                          ),
                          labelText: email,
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final egyptPhoneRegExp = RegExp(
                            r'^(?:\+20|0020|0)?1[0-2,5][0-9]{8}$',
                          );

                          if (!egyptPhoneRegExp.hasMatch(value)) {
                            return 'Enter a valid Egyptian phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 6),
                    Text("Phone", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 4),
                    SizedBox(
                      height: 50,
                      child: TextFormField(
                        enabled: false,
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Colors.white70,
                        style: const TextStyle(color: Colors.white70),
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          filled: true,
                          fillColor: const Color.fromARGB(237, 252, 252, 252),
                          prefixIcon: const Icon(
                            Icons.phone_android_outlined,
                            color: Colors.grey,
                          ),
                          labelText: phone,
                          labelStyle: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Colors.deepOrange,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          final egyptPhoneRegExp = RegExp(
                            r'^(?:\+20|0020|0)?1[0-2,5][0-9]{8}$',
                          );

                          if (!egyptPhoneRegExp.hasMatch(value)) {
                            return 'Enter a valid Egyptian phone number';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 6),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.orange),
                title: Text("Settings"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.help, color: Colors.orange),
                title: Text("Help & Support"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.logout, color: Colors.red),
                title: Text("Logout"),
                trailing: Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const WelcomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
