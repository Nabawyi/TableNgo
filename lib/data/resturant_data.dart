// lib/models/restaurant_data.dart
class ResturantData {
  final String? userPhone;
  final String? userName;
  final int? id;
  final String name;
  final String image;
  final String location;
  final String time;
  final double rating;
  final double refundAmount;
  final List<Map<String, dynamic>> seatData;

  ResturantData({
    this.userPhone,
    this.userName,
    this.id,
    required this.name,
    required this.image,
    required this.location,
    required this.time,
    required this.rating,
    required this.refundAmount,
    required this.seatData,
  });

  factory ResturantData.fromJson(Map<String, dynamic> json) {
    final seats = json['seat_data'] ?? json['seatData'];
    List<Map<String, dynamic>> parsedSeatData = [];
    if (seats is List) {
      parsedSeatData = seats.map((e) {
        final map = Map<String, dynamic>.from(e);
        map['isBooked'] ??= false;
        map['id'] ??= map.containsKey('seat_number')
            ? map['seat_number']
            : parsedSeatData.length + 1;
        return map;
      }).toList();
    }

    double parseDouble(dynamic v) =>
        (v is num) ? v.toDouble() : double.tryParse('${v ?? 0}') ?? 0.0;

    return ResturantData(      
      userName: json['user_name'],
      userPhone: json['user_phone'],
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? json['image_url'] ?? '',
      location: json['location'] ?? '',
      time: json['time'] ?? '',
      rating: parseDouble(json['rating']),
      refundAmount: parseDouble(json['refund_amount'] ?? json['refundAmount']),
      seatData: parsedSeatData,
    );
  }

  Map<String, dynamic> toJson() => {
    'user_name': userName,
    'user_phone': userPhone,
    'name': name,
    'image': image,
    'location': location,
    'time': time,
    'rating': rating,
    'refund_amount': refundAmount,
    'seat_data': seatData,
  };
}
