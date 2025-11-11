// ignore_for_file: file_names, avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:tablengo/data/resturant_data.dart';
import 'package:tablengo/WedgetsC/search_bar.dart';

class SearchPage extends StatefulWidget {
  final Function(ResturantData, int, DateTime) onBooking;
  final Function(ResturantData) onNavigateToBooking;

  const SearchPage({
    super.key,
    required this.onBooking,
    required this.onNavigateToBooking,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<ResturantData> restaurants = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadRestaurants();
  }

  Future<void> loadRestaurants() async {
    try {
      print('📡 Fetching data from Supabase...');
      final response = await Supabase.instance.client
          .from('restaurants')
          .select(
            'id, name, image, location, time, rating, refund_amount, seat_data,deposit_per_person',
          );

      print('✅ Response: $response');

      final list = (response as List)
          .map((json) => ResturantData.fromJson(json))
          .toList();

      setState(() {
        restaurants = list;
        isLoading = false;
      });
    } catch (error) {
      print('❌ Error fetching data: $error');
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

    if (restaurants.isEmpty) {
      return const Scaffold(body: Center(child: Text('No restaurants found.')));
    }

    return Scaffold(
      appBar: AppBar(
        title: Image.asset('assets/images/Logo_orange.png', height: 50),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.deepOrange),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: const <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepOrange),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(leading: Icon(Icons.home), title: Text('Home')),
            ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Contact Us'),
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        color: Colors.deepOrange,
        onRefresh: loadRestaurants,
        child: Column(
          children: [
            searchBar(),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(8),
                itemCount: restaurants.length,
                itemBuilder: (context, index) {
                  return cardCustom(restaurants[index], index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
Widget cardCustom(ResturantData restaurant, int index) {
    return InkWell(
      onTap: () {
        widget.onNavigateToBooking(restaurant);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  child: restaurant.image.isNotEmpty
                      ? Image.network(
                          restaurant.image,
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: double.infinity,
                          height: 180,
                          color: Colors.grey[200],
                          child: const Icon(
                            Icons.restaurant,
                            size: 64,
                            color: Colors.grey,
                          ),
                        ),
                ),
                // Rating Badge
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          restaurant.rating.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Content Section
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Restaurant Name
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 12),

                  // Location
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.location_on,
                          color: Colors.deepOrange,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          restaurant.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Time
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.access_time,
                          color: Colors.blue,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        restaurant.time,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  //   Widget cardCustom(ResturantData restaurant, int index) {
  //     return InkWell(
  //       onTap: () {
  //         widget.onNavigateToBooking(restaurant);
  //       },
  //       child: Card(
  //         color: Colors.white,
  //         elevation: 4,
  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  //         margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 2),
  //         child: SizedBox(
  //           height: 110,
  //           child: Row(
  //             children: [
  //               ClipRRect(
  //                 borderRadius: const BorderRadius.only(
  //                   topLeft: Radius.circular(12),
  //                   bottomLeft: Radius.circular(12),
  //                 ),
  //                 child: restaurant.image.isNotEmpty
  //                     ? Image.network(
  //                         restaurant.image,
  //                         width: 120,
  //                         height: 110,
  //                         fit: BoxFit.cover,
  //                       )
  //                     : Container(
  //                         width: 120,
  //                         height: 110,
  //                         color: Colors.grey[200],
  //                         child: const Icon(Icons.image_not_supported),
  //                       ),
  //               ),
  //               const SizedBox(width: 12),
  //               Expanded(
  //                 child: Padding(
  //                   padding: const EdgeInsets.symmetric(
  //                     horizontal: 8,
  //                     vertical: 4,
  //                   ),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                         children: [
  //                           Text(
  //                             restaurant.name,
  //                             style: const TextStyle(
  //                               fontSize: 12,
  //                               fontWeight: FontWeight.bold,
  //                               color: Colors.black87,
  //                             ),
  //                           ),
  //                           Row(
  //                             children: [
  //                               const Icon(
  //                                 Icons.star,
  //                                 color: Colors.amber,
  //                                 size: 18,
  //                               ),
  //                               const SizedBox(width: 4),
  //                               Text(
  //                                 restaurant.rating.toString(),
  //                                 style: const TextStyle(
  //                                   fontWeight: FontWeight.normal,
  //                                   fontSize: 12,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 4),
  //                       Row(
  //                         children: [
  //                           const Icon(
  //                             Icons.location_on_outlined,
  //                             color: Colors.grey,
  //                             size: 18,
  //                           ),
  //                           const SizedBox(width: 4),
  //                           Text(
  //                             restaurant.location,
  //                             style: const TextStyle(
  //                               fontSize: 12,
  //                               color: Colors.grey,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                       const SizedBox(height: 2),
  //                       SizedBox(
  //                         height: 30,
  //                         child: Row(
  //                           // mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             const Icon(
  //                               Icons.access_time,
  //                               color: Colors.grey,
  //                               size: 17,
  //                             ),
  //                             const SizedBox(width: 4),
  //                             Text(
  //                               restaurant.time,
  //                               style: const TextStyle(
  //                                 fontSize: 12,
  //                                 color: Colors.grey,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     );
  //   }
  // }
}
