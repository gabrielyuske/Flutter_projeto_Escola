import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_testando/calender/calendario_data.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class FirestoreCalendar extends StatefulWidget {
  @override
  _FirestoreCalendarState createState() => _FirestoreCalendarState();
}

class _FirestoreCalendarState extends State<FirestoreCalendar> {
  final TextEditingController _textEditingController = TextEditingController();
  DateTime _date = new DateTime.now();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("contacts");
  LinkedHashMap<DateTime, List<QuerySnapshot>> _groupedEvents;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  //////////
  Map<DateTime, List<Event>> selectedEvents;
  /////////
  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  ////////////
  @override
  void initStated() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }
  /////////
//   final events = LinkedHashMap(
//   equals: isSameDay,
//   hashCode: getHashCode,
// )..addAll(eventSource);

  // _groupEvents(List<Event> events) {
  //   _groupedEvents = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
  //   events.forEach((event) {
  //     DateTime date =
  //         DateTime.utc(event.data.year, event.data.month, event.data.day, 12);
  //     if (_groupedEvents[date] == null) _groupedEvents[date] = [];
  //     _groupedEvents[date].add(event);
  //   });
  // }

  // List<Event> _getEventsForDay(DateTime date) {
  //   return events[date] ?? [];
  // }

  void onPressedRaisedButton() async {
    DateTime picked = await showDatePicker(
        // locale: const Locale("ja"),
        context: context,
        initialDate: _date,
        firstDate: new DateTime(20),
        lastDate: new DateTime.now().add(new Duration(days: 360)));

    if (picked != null) {
      // 日時反映
      setState(() => _date = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            //
            child: Column(
              children: [
                Card(
                  child: TableCalendar(
                    // selectedDayPredicate: (day) => isSameDay(day, _selectedDay),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _focusedDay = focusedDay;
                        _selectedDay = selectedDay;
                      });
                    },
                    firstDay: DateTime.utc(2020, 1, 1),
                    focusedDay: _focusedDay,
                    lastDay: DateTime.utc(2030, 12, 31),
                    eventLoader: _getEventsfromDay,
                    selectedDayPredicate: (DateTime date) {
                      return isSameDay(_selectedDay, date);
                    },
                  ),
                ),

                // se houver dados no banco de dado ele devolve o valor
                //  somente a column == name do banco de dado
                // child: StreamBuilder(
                //   stream: collectionReference.orderBy("data").snapshots(),
                //   builder: (BuildContext context,
                //       AsyncSnapshot<QuerySnapshot> snapshot) {
                //     //se nao houver dado
                //     if (snapshot.hasError) {
                //       return Container(
                //         child: Text("エラー"),
                //       );
                //     }
                //     if (snapshot.hasData) {
                //       return ListView(
                //         children: snapshot.data.docs
                //             .map(
                //               (e) => Container(
                //                 color: Colors.blueGrey[100],
                //                 margin: const EdgeInsets.all(5),
                //                 child: ListTile(
                //                   title: Text(
                //                     "宿題: " + e["name"],
                //                     style:
                //                         TextStyle(fontWeight: FontWeight.bold),
                //                   ),
                //                   subtitle: Text(
                //                       DateFormat("EEEE ,dd MMMM, yyyy")
                //                           .format(e["data"].toDate())),
                //                   trailing: IconButton(
                //                       icon: Icon(Icons.edit),
                //                       onPressed: () => null
                //                       //arguments: snapshot.data.docs
                //                       ),
                //                 ),
                //               ),
                //             )
                //             .toList(),
                //       );
                //     }
                //     return SizedBox(
                //       child: CircularProgressIndicator(
                //         backgroundColor: Colors.amber,
                //         strokeWidth: 10,
                //       ),
                //       height: 200,
                //       width: 200,
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => modalCreate(context),
          tooltip: "宿題を追加",
          child: Icon(Icons.add),
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

  modalCreate(BuildContext context) async {
    var form = GlobalKey<FormState>();
    var titulo = TextEditingController();
    var descricao = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("宿題を追加"),
          content: Form(
            key: form,
            child: Container(
              height: 500, // MediaQuery.of(context).size.height / 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("科目"),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "例：国語",
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
                  Text("内容"),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "例：1から3ページまで",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    controller: descricao,
                    validator: (value) {
                      if (value.isEmpty) {
                        return "必須項目に必ずご記入ください";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("提出日"),
                  Toolcalendario(),
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
                  await FirebaseFirestore.instance.collection("contacts").add({
                    "name": titulo.text,
                    "descricao": descricao.text,
                    "feito": false,
                    //"data": _date,
                    "data": _date,
                  });

                  Navigator.of(context).pop();
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
}

class Event {
  final String title;
  final DateTime data;

  Event(this.title, this.data);

  // Event(DocumentSnapshot snapshot) {
  //   var map = snapshot.data();
  //   this.title = map["name"];
  //   this.data = map["data"];
  // }
  // Event(
  //   var map = snapshot.data();
  //   this.title = e,
  //   this.data);

  // Map<String, Object> toJson() {
  //   return {
  //     'title': title,
  //     'data': data,
  //   };
  // }

}
