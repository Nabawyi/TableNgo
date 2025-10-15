import 'package:flutter/material.dart';
class Test1 extends StatelessWidget {
  const Test1({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.network( "https://play-lh.googleusercontent.com/0tlx54ouzj_BFMCuV6vaSaJbVhCLHHP6FiZuY_S3SBv8dJ2sZd7KcB9E8Wbi5UE81co4", width: 300, height: 300, fit: BoxFit.cover,),
    );
  }
}