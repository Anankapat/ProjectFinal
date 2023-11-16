import 'package:flutter/material.dart';
import 'package:projectfinal/repositories/hotel_repository.dart';

class AddHotelPage extends StatefulWidget {
  static const routeName = 'add_hotel';

  const AddHotelPage({super.key});

  @override
  State<AddHotelPage> createState() => _AddHotelPageState();
}

class _AddHotelPageState extends State<AddHotelPage> {
  var _isLoading = false;
  String? _errorMessage;

  final _hotelNameController = TextEditingController();
  final _distanceController = TextEditingController();

  validateForm() {
    return _hotelNameController.text.isNotEmpty &&
        _distanceController.text.isNotEmpty;
  }

  saveHotel() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      var hotelName = _hotelNameController.text;
      var distance = double.parse(_distanceController.text);

      await HotelRepository().addHotel(name: hotelName, distance: distance);

      if (mounted) Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    buildLoadingOverlay() => Container(
        color: Colors.black.withOpacity(0.2),
        child: Center(child: CircularProgressIndicator()));

    handleClickSave() {
      if (validateForm()) {
        saveHotel();
      }
    }

    buildForm() => SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _hotelNameController,
                      decoration: InputDecoration(
                          hintText: 'Hotel name',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              )))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                      controller: _distanceController,
                      decoration: InputDecoration(
                          hintText: 'Review',
                          border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.greenAccent,
                              )))),
                ),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: handleClickSave,
                      child: Text('SAVE'),
                    ))
              ],
            )));

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
            title: Text('ADD HOTEL'),
            backgroundColor: Color(0xff1E3853),
            foregroundColor: Colors.white,
          ),
          bottomNavigationBar: BottomAppBar(
            notchMargin: 4.0,
            shape: CircularNotchedRectangle(),
            color: Color(0xff1E3853),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [

              ],
            ),
          ),
          body: Stack(
            children: [
              buildForm(),
              if (_isLoading) buildLoadingOverlay(),
            ],
          )),
    );
  }
}
