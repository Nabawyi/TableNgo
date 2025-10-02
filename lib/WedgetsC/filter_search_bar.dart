// ignore: file_names

import 'package:flutter/material.dart';

Widget filterSearchBar() {
  return SizedBox(
    height: 70,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Filter",
          hintStyle: const TextStyle(color: Colors.grey),
          prefixIcon: const Icon(Icons.filter_alt_outlined),
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    ),
  );
}
