// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TestSuba extends StatefulWidget {
  const TestSuba({super.key});

  @override
  State<TestSuba> createState() => _TestSubaState();
}

class _TestSubaState extends State<TestSuba> {
  List<dynamic> data = [];
  bool isLoading = true;
  String? errorMessage;

Future<void> addSampleData() async {
    try {
      await Supabase.instance.client.from('resturant').insert([
        {'name': 'Ali'},
        {'name': 'Sara'},
      ]);
      print('✅ Sample data added successfully');
    } catch (error) {
      print('❌ Error inserting data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
   // addSampleData().then((_) => fetchData());  
   }

  Future<void> fetchData() async {
    try {
      print('Fetching data...');
      final response = await Supabase.instance.client
          .from('restaurants')
          .select('id, name');

      print('Response: $response');

      setState(() {
        data = response;
        isLoading = false;
      });
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (errorMessage != null) {
      return Scaffold(body: Center(child: Text('Error: $errorMessage')));
    }

    if (data.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('No data found in table')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Supabase Test Data')),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return ListTile(
            title: Text(item['name'] ?? 'No name'),
            subtitle: Text('ID: ${item['id']}'),
          );
        },
      ),
    );
  }
}
