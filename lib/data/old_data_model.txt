class ResturantData {
  final String name;
  final String location;
  final String time;
  final double rating;
  final String image;
  final double refundAmount;

  List<Map<String, String>> seatData;
  ResturantData({
    required this.name,
    required this.location,
    required this.time,
    required this.rating,
    required this.image,
    required this.refundAmount,
    this.seatData = const [],
  });
}

List<ResturantData> resturants = [
  ResturantData(
    name: "The Gourmet Kitchen",
    location: "New York City",
    time: "10:00 AM - 12:00 PM",
    rating: 4.5,
    image: "assets/images/images.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Seafood Delight",
    location: "San Francisco",
    time: "11:00 AM - 1:00 PM",
    rating: 4.7,
    image: "assets/images/images1.jpeg",
    refundAmount: 70,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Pasta Paradise",
    location: "Chicago",
    time: "12:00 PM - 2:00 PM",
    rating: 4.3,
    image: "assets/images/resturant.jpg",
    refundAmount: 50,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Sushi World",
    location: "Los Angeles",
    time: "1:00 PM - 3:00 PM",
    rating: 4.8,
    image: "assets/images/images.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "BBQ Haven",
    location: "Austin",
    time: "2:00 PM - 4:00 PM",
    rating: 4.6,
    image: "assets/images/images1.jpeg",
    refundAmount: 70,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "The Gourmet Kitchen",
    location: "New York City",
    time: "10:00 AM - 12:00 PM",
    rating: 4.5,
    image: "assets/images/images.jpeg",
    refundAmount: 90,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Seafood Delight",
    location: "San Francisco",
    time: "11:00 AM - 1:00 PM",
    rating: 4.7,
    image: "assets/images/images1.jpeg",
    refundAmount: 50,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Pasta Paradise",
    location: "Chicago",
    time: "12:00 PM - 2:00 PM",
    rating: 4.3,
    image: "assets/images/resturant.jpg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Sushi World",
    location: "Los Angeles",
    time: "1:00 PM - 3:00 PM",
    rating: 4.8,
    image: "assets/images/images.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "BBQ Haven",
    location: "Austin",
    time: "2:00 PM - 4:00 PM",
    rating: 4.6,
    image: "assets/images/images1.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "The Gourmet Kitchen",
    location: "New York City",
    time: "10:00 AM - 12:00 PM",
    rating: 4.5,
    image: "assets/images/images.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Seafood Delight",
    location: "San Francisco",
    time: "11:00 AM - 1:00 PM",
    rating: 4.7,
    image: "assets/images/images1.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Pasta Paradise",
    location: "Chicago",
    time: "12:00 PM - 2:00 PM",
    rating: 4.3,
    image: "assets/images/resturant.jpg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "Sushi World",
    location: "Los Angeles",
    time: "1:00 PM - 3:00 PM",
    rating: 4.8,
    image: "assets/images/images.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
  ResturantData(
    name: "BBQ Haven",
    location: "Austin",
    time: "2:00 PM - 4:00 PM",
    rating: 4.6,
    image: "assets/images/images1.jpeg",
    refundAmount: 80,
    seatData: [
      {"seats": "2 Seats", "time": "7:00 PM", "Deposit": "EGP 50"},
      {"seats": "4 Seats", "time": "8:00 PM", "Deposit": "EGP 70"},
      {"seats": "6 Seats", "time": "9:00 PM", "Deposit": "EGP 80"},
    ],
  ),
];
