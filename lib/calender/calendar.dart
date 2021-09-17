import 'package:flutter/material.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:table_calendar/table_calendar.dart';

class Calender extends StatefulWidget {
  @override
  _CalenderState createState() => _CalenderState();
}

class _CalenderState extends State<Calender> {
  DateTime _currentDate = DateTime.now();

  void onDayPressed(DateTime date, List<Event> events) {
    this.setState(() => _currentDate = date);
    Fluttertoast.showToast(msg: date.toString());
    print(date.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text("Calender Example"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            color: Colors.blue[100],
            margin: const EdgeInsets.all(16.0),
            child: CalendarCarousel<Event>(
              height: 420.0,
              width: 420.0,
              locale: "ja",
              onDayPressed: onDayPressed,
              weekendTextStyle: TextStyle(color: Colors.red, fontSize: 16),
              weekdayTextStyle:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              thisMonthDayBorderColor: Colors.grey,
              weekFormat: false,
              //height: MediaQuery.of(context).size.height / 1.5,
              //width: MediaQuery.of(context).size.width / 2,
              selectedDateTime: _currentDate,
              //daysHaveCircularBorder: true,
              //customGridViewPhysics: NeverScrollableScrollPhysics(),
              markedDateShowIcon: false,
              //markedDateIconMaxShown: 2,
              todayTextStyle: TextStyle(
                color: Colors.white,
              ),

              markedDateIconBuilder: (event) {
                return event.icon;
              },
              todayBorderColor: Colors.green,
              markedDateMoreShowTotal: false,
              selectedDayTextStyle: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ),
    );
  }
}
