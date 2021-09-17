import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Replace the 3 second delay with your initialization code:
      future: Future.delayed(Duration(seconds: 3)),
      builder: (context, AsyncSnapshot snapshot) {
        // Show splash screen while waiting for app resources to load:
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(home: Splash());
        } else {
          // Loading is done, return the app:
          return MaterialApp(
            home: Scaffold(body: Center(child: Text('App loaded'))),
          );
        }
      },
    );
  }
}

class Splash extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaterialApp(
        theme: ThemeData(
          primaryColor: Colors.blueGrey,
          brightness: Brightness.dark,
        ),
        home: Container(
          color: Colors.blueGrey,
          child: Center(
            child: Icon(
              Icons.apartment_outlined,
              size: MediaQuery.of(context).size.width * 0.3,
              color: Colors.pink,
            ),
          ),
        ),
      ),
    );
  }
}
