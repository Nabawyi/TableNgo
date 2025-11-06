import 'package:tablengo/data/resturant_data.dart';

class Booking {
  final int id;
  final String userId;
  final int restaurantId;
  final DateTime bookedDate;
  final String bookedTime; // Represented as 'HH:mm:ss' string
  final int numberOfSeats;
  final double deposit;
  final double refund;
  final double totalPayable;
  final String status;
  final DateTime? createdAt;

  Booking({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.bookedDate,
    required this.bookedTime,
    required this.numberOfSeats,
    required this.deposit,
    required this.refund,
    required this.totalPayable,
    required this.status,
    this.createdAt,
  });

  factory Booking.fromJson(
    Map<String, dynamic> json,
    ResturantData restaurant,
  ) {
    return Booking(
      id: json['id'] as int,
      userId: json['user_id'] as String,
      restaurantId: json['restaurant_id'] as int,
      bookedDate: DateTime.parse(json['booked_date'] as String),
      bookedTime: json['booked_time'] as String,
      numberOfSeats: json['number_of_seats'] as int,
      deposit: (json['deposit'] as num).toDouble(),
      refund: (json['refund'] as num).toDouble(),
      totalPayable: (json['total_payable'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'restaurant_id': restaurantId,
      'booked_date': bookedDate.toIso8601String().split('T').first,
      'booked_time': bookedTime,
      'number_of_seats': numberOfSeats,
      'deposit': deposit,
      'refund': refund,
      'total_payable': totalPayable,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
