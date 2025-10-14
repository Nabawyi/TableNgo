import 'package:TableNgo/data/resturant_data.dart';

class BookingItem {
  final ResturantData restaurant;
  final int selectedSeatIndex;
  final DateTime bookingDate;

  BookingItem({
    required this.restaurant,
    required this.selectedSeatIndex,
    required this.bookingDate,
  });
}
