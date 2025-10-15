class ResturantData {
  final int? id;
  final String name;
  final String image;
  final String location;
  final String time;
  final double rating;
  final double refundAmount;
  final List<Map<String, dynamic>> seatData;

  ResturantData({
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
    final dynamic ratingVal = json['rating'];
    final dynamic refundVal = json['refund_amount'] ?? json['refundAmount'];
    final dynamic seats = json['seat_data'] ?? json['seatData'];

    double parsedRating;
    if (ratingVal is num) {
      parsedRating = ratingVal.toDouble();
    } else {
      parsedRating = double.tryParse('${ratingVal ?? 0}') ?? 0.0;
    }

    double parsedRefund;
    if (refundVal is num) {
      parsedRefund = refundVal.toDouble();
    } else {
      parsedRefund = double.tryParse('${refundVal ?? 0}') ?? 0.0;
    }

    List<Map<String, dynamic>> parsedSeatData = [];
    if (seats is List) {
      parsedSeatData = seats
          .whereType<Map>()
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    }

    return ResturantData(
      id: json['id'],
      name: json['name'] ?? '',
      image: json['image'] ?? json['image_url'] ?? '',
      location: json['location'] ?? '',
      time: json['time'] ?? '',
      rating: parsedRating,
      refundAmount: parsedRefund,
      seatData: parsedSeatData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'image': image,
      'location': location,
      'time': time,
      'rating': rating,
      'refund_amount': refundAmount,
      'seat_data': seatData,
    };
  }
}
