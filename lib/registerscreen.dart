import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final formKey = GlobalKey<FormState>();
  //bool isLoading = true;
  // email , password
  TextEditingController _email = TextEditingController();
  TextEditingController _pass = TextEditingController();

  sigMeUp() {
    if (formKey.currentState.validate()) {
      // setState(() {
      //   isLoading = true;
      // });
    }
  }

  // REGISTRO
  Future registerUser() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _email.text,
        password: _pass.text,
      );
      print("User register sucessfully");
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

  // INTERFACE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register User"),
      ),
      body: //isLoading
          //     ? Container(child: Center(child: CircularProgressIndicator()))
          //     :
          Form(
        key: formKey,
        child: Column(
          children: [
            //EMAIL
            TextFormField(
              validator: (val) {
                return RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val)
                    ? null
                    : "Please provide valid email";
              },
              controller: _email,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: "enter email here"),
            ),
            SizedBox(height: 20),
            TextFormField(
              // PASSWORD
              obscureText: true,
              validator: (val) {
                return val.length > 6
                    ? null
                    : "Please a provide password 6+ character";
              },
              controller: _pass,
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "enter password here"),
            ),
            SizedBox(height: 28),
            GestureDetector(
              child: ElevatedButton(
                  onPressed: () {
                    sigMeUp();
                    registerUser();
                  },
                  child: Text("Register")),
            )
          ],
        ),
      ),
    );
  }
}
