import 'package:flutter/material.dart';

class Toolcalendario extends StatefulWidget {
  @override
  _ToolcalendarioState createState() => _ToolcalendarioState();
}

class _ToolcalendarioState extends State<Toolcalendario> {
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

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(70.0),
      child: Column(
        children: <Widget>[
          // 日時表示部分
          Center(child: Text("${_date}")),

          // DatePicker表示ボタン。
          new RaisedButton(
            onPressed: () =>
                // 押下時のイベントを宣言。
                onPressedRaisedButton(),
            child: new Text('日付選択'),
          ),
        ],
      ),
    );
  }
}
