import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_testando/calender/sfcalendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import "package:intl/intl.dart";

class SelectDay extends StatefulWidget {
  SelectDay({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SelectDayState createState() => _SelectDayState();
}

class _SelectDayState extends State<SelectDay> {
  var mydatetime = new DateTime.now();
  var formatterview = new DateFormat('yyyy/MM/dd HH:mm:ss');
  DateTime _date = new DateTime.now();
  void onPressedRaisedButton() async {
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
  // void onPressedRaisedButton() async {
  //   DatePicker.showDateTimePicker(context,
  //       showTitleActions: true, onChanged: (date) {}, onConfirm: (date) {
  //     setState(() {
  //       mydatetime = date;
  //     });
  //   }, currentTime: DateTime.now(), locale: LocaleType.jp);
  //   print(mydatetime);
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Center(child: Text(formatterview.format(mydatetime))),
          new RaisedButton(
            onPressed: () => onPressedRaisedButton(),
            child: new Text('日付選択'),
          ),
        ],
      ),
      // child: Column(
      //   //mainAxisAlignment: MainAxisAlignment.center,
      //   // children: <Widget>[
      //   //   Text(
      //   //     'あなたが選択した日時は以下です: ',
      //   //   ),
      //   //   Text(
      //   //     // フォーマッターを使用して指定したフォーマットで日時を表示
      //   //     // format()に渡すのはDate型の値で、String型で返される
      //   //     formatter.format(_mydatetime),
      //   //     style: Theme.of(context).textTheme.display1,
      //   //   ),
      //   // ],
      // ),
    );

    // FloatingActionButton(
    //   onPressed: () {
    //     DatePicker.showDateTimePicker(context, showTitleActions: true,
    //         // onChanged内の処理はDatepickerの選択に応じて毎回呼び出される
    //         onChanged: (date) {
    //       // print('change $date');
    //     },
    //         // onConfirm内の処理はDatepickerで選択完了後に呼び出される
    //         onConfirm: (date) {
    //       setState(() {
    //         mydatetime = date;
    //       });
    //     },
    //         // Datepickerのデフォルトで表示する日時
    //         currentTime: DateTime.now(),
    //         // localによって色々な言語に対応
    //         locale: LocaleType.jp);
    //   },
    //   tooltip: 'Datetime',
    //   child: Icon(Icons.access_time),
    // );
  }
}
