//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_testando/calender/caelndario.dart';
import 'package:firestore_testando/calender/calendar.dart';
import 'package:firestore_testando/calender/calendario.dart';
import 'package:firestore_testando/loading.dart';
import 'package:firestore_testando/loginscreen.dart';
import 'package:firestore_testando/registerscreen.dart';
import 'package:firestore_testando/services/firestore_crud.dart';
import 'package:firestore_testando/widget/Showdialog.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'calender/calendar_final.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //INICIANDO O FIREBASE
  await Firebase.initializeApp();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Scaffold(
          body: Center(
            child: Text(snapshot.error.toString()),
          ),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Loading();
      }
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Firebase Authentication'),
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(35.0),
            child: Column(
              children: [
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginScreen();
                      }));
                    },
                    child: Text("Login Now")),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return RegistrationScreen();
                      }));
                    },
                    child: Text("Registration")),
                SizedBox(
                  height: 8,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return FirestoreAuthDemo();
                      }));
                    },
                    child: Text("Firestore Auth Demo")),
                SizedBox(
                  height: 8,
                ),
                RaisedButton(
                  child: Text('Alert Dialog'),
                  onPressed: () {
                    ShowDialog(context);
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return Calendar();
                    }));
                  },
                  child: Text("Calenderio Evento"),
                ),
              ],
            ),
          ),
        ),
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale("ja"),
      ],
    );
  }
}

//emai = abc@xyz.com senha = 123456789
