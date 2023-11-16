import 'dart:convert';

import 'package:projectfinal/models/hotel.dart';

import 'package:projectfinal/services/api_call.dart';

class HotelRepository {
  Future<List<Hotel>> getHotels() async {
    try {
      var result = await ApiCaller().get('hotels?_embed=reviews');
      List list = jsonDecode(result);
      List<Hotel> hotelList =
      list.map<Hotel>((item) => Hotel.fromJson(item)).toList();
      return hotelList;
    } catch (e) {
      // TODO:
      rethrow;
    }
  }

  Future<void> addHotel(
      {required String name, required double distance}) async {
    try {
      var result = await ApiCaller()
          .post('hotels', params: {'name': name, 'distance': distance});
    } catch (e) {
      // TODO:
      rethrow;
    }
  }
}
