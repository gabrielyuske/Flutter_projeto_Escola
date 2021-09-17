import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // email , password
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  // SIGN-IN
  Future loginUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      );
      print("User logged sucessfully");
    } on FirebaseAuthException catch (e) {
      if (e.code == "weak-password") {
        print("The password provided is too weak.");
      } else if (e.code == "email-already-in-use") {
        print("The account already exists for that email.");
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          child: Column(
            children: [
              TextFormField(
                controller: _email,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: "enter email here"),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _pass,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "enter password here"),
              ),
              SizedBox(height: 28),
              ElevatedButton(
                  onPressed: () {
                    loginUser();
                  },
                  child: Text("Login Now"))
            ],
          ),
        ),
      ),
    );
  }
}
