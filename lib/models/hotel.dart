import 'package:collection/collection.dart';
import 'review.dart';

class Hotel {
  final int id;
  final String name;
  final double distance;
  final double averageRating;
  final List<Review> reviews;

  Hotel({
    required this.id,
    required this.name,
    required this.distance,
    required this.averageRating,
    required this.reviews,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    List<Review> reviews =
    json['reviews'].map<Review>((item) => Review.fromJson(item)).toList();
    var averageRating = 0.0;
    if (reviews.isNotEmpty) {
      averageRating = reviews.map((review) => review.rating).average;
    }

    return Hotel(
      id: json['id'],
      name: json['name'],
      distance: json['distance'],
      averageRating: averageRating,
      reviews: reviews,
    );
  }
}
