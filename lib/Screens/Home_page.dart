// ignore: file_names
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TableNgo'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          //width: double.infinity,
          //height: double.infinity,
          color: Colors.white70,
          child: Column(
            children: [
              searchBar(),
              filterSearchBar(),
              SizedBox(height: 15),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(4),
                  itemCount: 10, // Example item count
                  itemBuilder: (context, index) {
                    return cardCustom();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget searchBar() {
  return SizedBox(
    height: 70,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search here...",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.search),
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

Widget filterSearchBar() {
  return SizedBox(
    height: 70,
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Filter",
          hintStyle: TextStyle(color: Colors.grey),
          prefixIcon: Icon(Icons.filter_alt_outlined),
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

Widget cardCustom() {
  return InkWell(
    child: Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 2),
      child: Row(
        children: [
          // Image on the left side with rounded left corners only
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
            child: Image.asset(
              "assets/images/images.jpeg",
              width: 120,
              height: 120, // ensure same height as card
              fit: BoxFit.cover,
            ),
          ),

          SizedBox(width: 12),

          // Card Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Item Title',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 18),
                          SizedBox(width: 4),
                          Text(
                            "4.5",
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  // Location Row
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.grey,
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          "New York City",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  // Time Row
                  Row(
                    children: [
                      Icon(Icons.access_time, color: Colors.grey, size: 18),
                      SizedBox(width: 4),
                      Text(
                        "10:00 AM - 12:00 PM",
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),

                  SizedBox(height: 10),

                  // Rating Row
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
