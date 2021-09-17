import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';

class CalendarioTool extends StatefulWidget {
  @override
  _CalendarioToolState createState() => _CalendarioToolState();
}

class _CalendarioToolState extends State<CalendarioTool> {
  @override
  Widget build(BuildContext context) {
    DateTime _date = new DateTime.now();
    void onPressedRaisedButton() async {
      final DateTime picked = await showDatePicker(
          locale: const Locale("ja"),
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
}
