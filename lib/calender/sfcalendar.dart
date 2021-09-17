import 'dart:html';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';

import 'calendario_data.dart';
import 'date_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LoadDataFromFireBase());
}

class LoadDataFromFireBase extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'カレンダー',
      home: LoadDataFromFireStore(),
    );
  }
}

class LoadDataFromFireStore extends StatefulWidget {
  @override
  LoadDataFromFireStoreState createState() => LoadDataFromFireStoreState();
}

class LoadDataFromFireStoreState extends State<LoadDataFromFireStore> {
  List<Color> _colorCollection = <Color>[];
  MeetingDataSource events;
  final List<String> options = <String>['Add', 'Delete', 'Update', "+"];
  final databaseReference = FirebaseFirestore.instance;
  DateTime _date = new DateTime.now();
  var mydatetime = new DateTime.now();
  var form = GlobalKey<FormState>();
  var titulo = TextEditingController();

  @override
  void initState() {
    _initializeEventColor();
    getDataFromFireStore().then((results) {
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        setState(() {});
      });
    });
    super.initState();
  }

  void onPressedRaisedButton() async {
    DateTime picked = await showDatePicker(
        //locale: const Locale("ja"),
        context: context,
        initialDate: _date,
        firstDate: new DateTime(20),
        lastDate: new DateTime.now().add(new Duration(days: 360)));
    if (picked != null) {
      // 日時反映
      setState(() => _date = picked);
    }
  }

  Future<void> getDataFromFireStore() async {
    var snapShotsValue = await databaseReference
        .collection("CalendarAppointmentCollection")
        .get();
    var snapShotsValu2 = await databaseReference
        .collection("CalendarAppointmentCollection")
        .get();

    final Random random = new Random();

    List<Meeting> list = await snapShotsValue.docs
        .map(
          (e) => Meeting(
            eventName: e.data()['Subject'],
            from:
                DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['StartTime']),
            to: DateFormat('dd/MM/yyyy HH:mm:ss').parse(e.data()['EndTime']),
            background: _colorCollection[random.nextInt(9)],
            isAllDay: false,
          ),
        )
        .toList();
    setState(() {
      events = MeetingDataSource(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton<String>(
            icon: Icon(Icons.settings),
            itemBuilder: (BuildContext context) => options.map((String choice) {
              return PopupMenuItem<String>(
                value: choice,
                child: Text(choice),
              );
            }).toList(),
            onSelected: (String value) {
              if (value == 'Add') {
                DateTime now = DateTime.now();
                String day = titulo.text;
                String endDay = titulo.text;
                databaseReference
                    .collection("CalendarAppointmentCollection")
                    .doc()
                    .set({
                  'Subject': 'Mastering Flutter',
                  'StartTime': DateFormat("dd/MM/yyyy HH:mm:ss").format(_date),
                  'EndTime': DateFormat("dd/MM/yyyy HH:mm:ss").format(_date)
                });

                return showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.blueGrey,
                      title: new Text("リロード"),
                      content: new Text("更新します。"),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("OK"),
                          onPressed: () {
                            Navigator.of(context).push(new MaterialPageRoute(
                                builder: (context) => LoadDataFromFireBase()));
                          },
                        ),
                      ],
                    );
                  },
                );
              } else if (value == "Delete") {
                try {
                  databaseReference
                      .collection('CalendarAppointmentCollection')
                      .doc('1')
                      .delete();
                } catch (e) {}
              } else if (value == "Update") {
                try {
                  databaseReference
                      .collection('CalendarAppointmentCollection')
                      .doc('1')
                      .update({'Subject': 'Meeting'});
                } catch (e) {}
              } else if (value == "+") {
                // showDialog(
                //   context: context,
                //   builder: (BuildContext context) {
                //     var formatter = new DateFormat('dd/MM/yyyy HH:mm:ss');
                //     return AlertDialog(
                //       title: Text("イベントを追加"),
                //       content: Form(
                //         key: form,
                //         child: Container(
                //           height:
                //               250, // MediaQuery.of(context).size.height / 2,
                //           child: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: <Widget>[
                //               Text("イベント名"),
                //               TextFormField(
                //                 decoration: InputDecoration(
                //                   hintText: "例：運動会",
                //                   border: OutlineInputBorder(
                //                     borderRadius: BorderRadius.circular(15),
                //                   ),
                //                 ),
                //                 controller: titulo,
                //                 validator: (value) {
                //                   if (value.isEmpty) {
                //                     return "必須項目に必ずご記入ください";
                //                   }
                //                   return null;
                //                 },
                //               ),

                //               // SelectDay(),
                //               //Toolcalendario(),
                //               RaisedButton(onPressed: () {
                //                 Toolcalendario(

                //                 );
                //               }),
                //               // SizedBox(
                //               //   height: 10,
                //               // ),
                //               Center(
                //                 child: Text(
                //                   formatter.format(_date),
                //                 ),
                //               )
                //             ],
                //           ),
                //         ),
                //       ),
                //       actions: <Widget>[
                //         FlatButton(
                //           onPressed: () => Navigator.of(context).pop(),
                //           child: Text("キャンセル"),
                //         ),
                //         // FlatButton(
                //         //   onPressed: () async {
                //         //     if (form.currentState.validate()) {
                //         //       //mydatetime = date;
                //         //       var formatter =
                //         //           new DateFormat('dd/MM/yyyy HH:mm:ss');

                //         //       await FirebaseFirestore.instance
                //         //           .collection("CalendarAppointmentCollection")
                //         //           .add({
                //         //         // EndTime
                //         //         "EndTime": formatter.format(_date),
                //         //         //StartTime
                //         //         "StartTime": formatter.format(_date),
                //         //         //Subject
                //         //         "Subject": titulo.text,
                //         //       });

                //         //       Navigator.of(context).push(new MaterialPageRoute(
                //         //           builder: (context) =>
                //         //               LoadDataFromFireBase()));
                //         //     }
                //         //   },
                //         //   color: Colors.blue,
                //         //   child: Text("保存"),
                //         // ),
                //       ],
                //     );
                //   },
                // );
              }
            },
          ),
        ),
        body: Card(
          child: SfCalendar(
            view: CalendarView.month,
            initialDisplayDate: DateTime.now(),
            dataSource: events,
            monthViewSettings: MonthViewSettings(
              showAgenda: true,
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => modalCreate(context),
          tooltip: "イベントを追加",
          child: Icon(Icons.access_time),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("en"),
        const Locale("ja"),
      ],
    );
  }

  // void onPressedRaisedButton() async {
  //   DatePicker.showDateTimePicker(context,
  //       showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
  //     setState(() {
  //       mydatetime = date;
  //     });
  //   }, currentTime: DateTime.now(), locale: LocaleType.jp);

  // }
  // void onPressedRaisedButton() async {
  //   DateTime picked = await showDatePicker(
  //       //locale: const Locale("ja"),
  //       context: context,
  //       initialDate: _date,
  //       firstDate: new DateTime(20),
  //       lastDate: new DateTime.now().add(new Duration(days: 360)));
  //   if (picked != null) {
  //     // 日時反映
  //     setState(() => _date = picked);
  //   }
  // }

  void _initializeEventColor() {
    _colorCollection.add(const Color(0xFF0F8644));
    _colorCollection.add(const Color(0xFF8B1FA9));
    _colorCollection.add(const Color(0xFFD20100));
    _colorCollection.add(const Color(0xFFFC571D));
    _colorCollection.add(const Color(0xFF36B37B));
    _colorCollection.add(const Color(0xFF01A1EF));
    _colorCollection.add(const Color(0xFF3D4FB5));
    _colorCollection.add(const Color(0xFFE47C73));
    _colorCollection.add(const Color(0xFF636363));
    _colorCollection.add(const Color(0xFF0A8043));
  }

  modalCreate(BuildContext context) async {
    var form = GlobalKey<FormState>();
    var titulo = TextEditingController();
    var mydatetime = new DateTime.now();
    var formatter = new DateFormat('dd/MM/yyyy HH:mm:ss');

    // void onPressedRaisedButton() async {
    //   DateTime picked = await showDatePicker(
    //       locale: const Locale("ja"),
    //       context: context,
    //       initialDate: _date,
    //       firstDate: new DateTime(20),
    //       lastDate: new DateTime.now().add(new Duration(days: 360)));
    //   if (picked != null) {
    //     // 日時反映
    //     setState(() => _date);
    //     //print("$picked");
    //     //print(_date);
    //   }
    // }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("イベントを追加"),
          content: Form(
            key: form,
            child: Container(
              height: 250, // MediaQuery.of(context).size.height / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("イベント名"),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "例：運動会",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    controller: titulo,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "必須項目に必ずご記入ください";
                      }
                      return null;
                    },
                  ),

                  // SelectDay(),
                  //Toolcalendario(),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  // Center(
                  //   child: Text(
                  //     formatter.format(_date),
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  Center(
                    child: RaisedButton(
                      child: Text("日にちを選択"),
                      onPressed: () => Testededata(),
                    ),
                  )
                ],
              ),
            ),
          ),
          actions: <Widget>[
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("キャンセル"),
            ),
            FlatButton(
              onPressed: () async {
                if (form.currentState.validate()) {
                  //mydatetime = date;
                  var formatter = new DateFormat('dd/MM/yyyy HH:mm:ss');

                  await FirebaseFirestore.instance
                      .collection("CalendarAppointmentCollection")
                      .add({
                    // EndTime
                    "EndTime": formatter.format(_date),
                    //StartTime
                    "StartTime": formatter.format(_date),
                    //Subject
                    "Subject": titulo.text,
                  });

                  Navigator.of(context).push(new MaterialPageRoute(
                      builder: (context) => LoadDataFromFireBase()));
                }
              },
              color: Colors.blue,
              child: Text("保存"),
            ),
          ],
        );
      },
    );
  }

  void Testededata() async {
    final DateTime picked = await showDatePicker(
        //locale: const Locale("ja"),
        context: context,
        initialDate: _date,
        firstDate: new DateTime(20),
        lastDate: new DateTime.now().add(new Duration(days: 360)));

    if (picked != null) {
      // 日時反映
      setState(() => _date = picked);
    }
  }
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments[index].from;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments[index].to;
  }

  @override
  bool isAllDay(int index) {
    return appointments[index].isAllDay;
  }

  @override
  String getSubject(int index) {
    return appointments[index].eventName;
  }

  @override
  Color getColor(int index) {
    return appointments[index].background;
  }
}

class Meeting {
  String eventName;
  DateTime from;
  DateTime to;
  Color background;
  bool isAllDay;

  Meeting({this.eventName, this.from, this.to, this.background, this.isAllDay});
}
