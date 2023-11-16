import 'package:flutter/material.dart';
import 'package:projectfinal/models/hotel.dart';

class HotelListItem extends StatefulWidget {
  static const iconSize = 18.0;

  final Hotel hotel;

  const HotelListItem({
    Key? key,
    required this.hotel,
  }) : super(key: key);

  @override
  _HotelListItemState createState() => _HotelListItemState();
}

class _HotelListItemState extends State<HotelListItem> {
  bool _isLiked = false;

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    var colorScheme = Theme.of(context).colorScheme;

    var hasRating = widget.hotel.averageRating > 0;
    var numWholeStar = widget.hotel.averageRating.truncate();
    var fraction = widget.hotel.averageRating - numWholeStar;
    var showHalfStar = fraction >= 0.5;
    var numBlankStar = 5 - numWholeStar - (showHalfStar ? 1 : 0);

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 60.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: colorScheme.background,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(child: Icon(Icons.hotel, size: 30.0)),
            ),
            SizedBox(width: 8.0),
            Expanded(
              child: Text(
                widget.hotel.name,
                style: TextStyle(
                  color: Color(0xff33344E),
                  fontSize: 20,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                hasRating
                    ? Row(
                  children: [
                    for (var i = 0; i < numWholeStar; i++)
                      Icon(Icons.star, size: HotelListItem.iconSize),
                    if (showHalfStar)
                      Icon(Icons.star_half, size: HotelListItem.iconSize),
                    for (var i = 0; i < numBlankStar; i++)
                      Icon(Icons.star_border, size: HotelListItem.iconSize),
                  ],
                )
                    : Text('ยังไม่มีคะแนน'),
                Text(
                  '${widget.hotel.distance.toString()} รีวิว',
                  style: textTheme.bodyLarge,
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _isLiked = !_isLiked;
                });
              },
              icon: Icon(
                _isLiked ? Icons.star : Icons.star_border,
                size: HotelListItem.iconSize,
                color: _isLiked ? Colors.yellow : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}