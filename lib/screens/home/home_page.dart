import 'package:flutter/material.dart';
import 'package:projectfinal/models/hotel.dart';
import 'package:projectfinal/repositories/hotel_repository.dart';
import 'package:projectfinal/screens/home/add_hotel.dart';
import 'package:projectfinal/screens/home/hotel_list_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Hotel>? _hotels;
  var _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    getHotels();
  }

  getHotels() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      var hotels = await HotelRepository().getHotels();
      debugPrint('Number of toilets: ${hotels.length}');

      setState(() {
        _hotels = hotels;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
  sortHotelsByRating() {
    setState(() {
      _hotels?.sort((a, b) => b.averageRating.compareTo(a.averageRating));
    });
  }
  @override
  Widget build(BuildContext context) {
    buildLoadingOverlay() => Container(
        color: Colors.black.withOpacity(0.2),
        child: Center(child: CircularProgressIndicator()));

    buildError() => Center(
        child: Padding(
            padding: const EdgeInsets.all(40.0),
            child:
            Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(_errorMessage ?? '', textAlign: TextAlign.center),
              SizedBox(height: 32.0),
              ElevatedButton(onPressed: getHotels, child: Text('Retry'))
            ])));

    buildList() => ListView.builder(
        itemCount: _hotels!.length,
        itemBuilder: (ctx, i) {
          Hotel hotel = _hotels![i];
          return HotelListItem(hotel: hotel);
        });

    handleClickAdd() {
      Navigator.pushNamed(context, AddHotelPage.routeName).whenComplete(() {
        getHotels();
      });
    }

    handleClickLike() {
      sortHotelsByRating();
    }
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.topRight,
              colors: [Color(0xffBDDDFF), Color(0xffE4F1FF)]
          )
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text('Hotel List'),
            backgroundColor: Color(0xff1E3853),
            foregroundColor: Colors.white,
            centerTitle: true,
            leading: Icon(Icons.home),

            actions: [
              Icon(Icons.notifications)
            ],
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          floatingActionButton: FloatingActionButton(
            onPressed: handleClickAdd,
            shape: CircleBorder(),
            child: Icon(Icons.add),
            backgroundColor: Colors.black87,
            foregroundColor: Colors.blue,
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 4.0,
            shape: CircularNotchedRectangle(),
            color: Color(0xff1E3853),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                GestureDetector(
                onTap: handleClickLike,
                child:Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.favorite,
                        color: Colors.white,
                      ),
                      Text(
                          'Like',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                 ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.share,
                        color: Colors.white,
                      ),
                      Text(
                        'Share',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          body: Stack(
            children: [
              if (_hotels?.isNotEmpty ?? false) buildList(),
              if (_errorMessage != null) buildError(),
              if (_isLoading) buildLoadingOverlay()
            ],
          )),
    );
  }
}