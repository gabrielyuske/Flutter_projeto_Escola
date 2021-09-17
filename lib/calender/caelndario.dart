import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_testando/model/app_model.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  Map<DateTime, List<Event>> selectedEvents;
  CalendarFormat format = CalendarFormat.month;
  DateTime selectedDay = DateTime.now();
  DateTime focusedDay = DateTime.now();

  TextEditingController _eventController = TextEditingController();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("contacts");

  @override
  void initState() {
    selectedEvents = {};
    super.initState();
  }

  List<Event> _getEventsfromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendar"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TableCalendar(
              focusedDay: selectedDay,
              firstDay: DateTime(1990),
              lastDay: DateTime(2050),
              calendarFormat: format,
              onFormatChanged: (CalendarFormat _format) {
                setState(() {
                  format = _format;
                });
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              daysOfWeekVisible: true,

              //Day Changed
              onDaySelected: (DateTime selectDay, DateTime focusDay) {
                setState(() {
                  selectedDay = selectDay;
                  focusedDay = focusDay;
                });
                // focusedday == diaselecionado
                print(focusedDay);
              },
              selectedDayPredicate: (DateTime date) {
                return isSameDay(selectedDay, date);
              },

              eventLoader: _getEventsfromDay,

              //To style the Calendar
              calendarStyle: CalendarStyle(
                isTodayHighlighted: true,
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                selectedTextStyle: TextStyle(color: Colors.white),
                todayDecoration: BoxDecoration(
                  color: Colors.purpleAccent,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                defaultDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                weekendDecoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(5.0),
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            //Resulatdo dos eventos
            ..._getEventsfromDay(selectedDay).map(
              (Event event) => ListTile(
                title: Text(
                  event.title,
                ),
              ),
            ),
            // ..._getEventsfromDay(selectedDay).map(
            //   (Event event) => StreamBuilder(
            //     stream: collectionReference.orderBy("data").snapshots(),
            //     builder: (BuildContext context, snapshot) {
            //       if (snapshot.hasData) {
            //         // final events = snapshot.data;
            //         ListView.builder(
            //           //shrinkWrap: true,
            //           //itemCount: snapshot.data.docs.length,
            //           physics: NeverScrollableScrollPhysics(),
            //           itemBuilder: (BuildContext context, index) {
            //             // Event event = events[title];
            //             DocumentSnapshot products = snapshot.data.docs[index];
            //             // return ProductItem(
            //             //   name: products["name"],
            //             //   price: products['price'],
            //             // );
            //           },
            //         );
            //       }
            //       return CircularProgressIndicator();
            //     },
            //   ),
            //),
            // Expanded(
            //   // se houver dados no banco de dado ele devolve o valor
            //   //  somente a column == name do banco de dado
            //   child: StreamBuilder(
            //     stream: collectionReference.orderBy("data").snapshots(),
            //     builder: (BuildContext context,
            //         AsyncSnapshot<QuerySnapshot> snapshot) {
            //       if (snapshot.hasData) {
            //         return ListView(
            //           children: snapshot.data.docs
            //               .map(
            //                 (e) => Container(
            //                   color: Colors.blueGrey[100],
            //                   margin: const EdgeInsets.all(5),
            //                   child: ListTile(
            //                     leading: IconButton(
            //                       icon: Icon(
            //                         e["feito"]
            //                             ? Icons.check
            //                             : Icons.radio_button_unchecked,
            //                         size: 28,
            //                       ),
            //                       onPressed: () => collectionReference
            //                           .doc(e.id)
            //                           .update({"feito": !e["feito"]}).then(
            //                               (value) => print("update")),
            //                     ),
            //                     title: Text(
            //                       e["name"],
            //                       style: TextStyle(fontWeight: FontWeight.bold),
            //                     ),
            //                     subtitle: Text(e["descricao"]),
            //                     trailing: CircleAvatar(
            //                       backgroundColor: Color(0xff0099FF),
            //                       child: IconButton(
            //                         icon: Icon(
            //                           Icons.delete,
            //                           color: Color(0xffFFFFFF),
            //                         ),
            //                         //
            //                         //icon: Icon(Icons.edit)
            //                         //
            //                         onPressed: () => collectionReference
            //                             .doc(e.id)
            //                             .delete()
            //                             .then((value) => print("deleted")),
            //                       ),
            //                     ),

            //                     // trailing: IconButton(
            //                     //     icon: Icon(Icons.edit),
            //                     //     onPressed: () => null
            //                     //     //arguments: snapshot.data.docs
            //                     //     ),
            //                   ),
            //                 ),
            //               )
            //               .toList(),
            //         );
            //       }
            //     },
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Add Event"),
            content: TextFormField(
              controller: _eventController,
            ),
            actions: [
              TextButton(
                child: Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  if (_eventController.text.isEmpty) {
                  } else {
                    if (selectedEvents[selectedDay] != null) {
                      selectedEvents[selectedDay].add(
                        Event(title: _eventController.text),
                      );
                    } else {
                      selectedEvents[selectedDay] = [
                        Event(title: _eventController.text)
                      ];
                    }
                  }
                  Navigator.pop(context);
                  _eventController.clear();
                  setState(() {});
                  return;
                },
              ),
            ],
          ),
        ),
        label: Text("Add Event"),
        icon: Icon(Icons.add),
      ),
    );
  }
}

class Event {
  final String title;
  Event({@required this.title});

  String toString() => this.title;
}
