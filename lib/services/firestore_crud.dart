//import 'dart:html';

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_testando/calender/calendario_data.dart';
//import 'package:firestore_testando/calender/calendario.dart';
//import 'package:firestore_testando/calender/calender-test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class FirestoreAuthDemo extends StatefulWidget {
  @override
  _FirestoreAuthDemoState createState() => _FirestoreAuthDemoState();
}

class _FirestoreAuthDemoState extends State<FirestoreAuthDemo> {
  final TextEditingController _textEditingController = TextEditingController();
  DateTime _date = new DateTime.now();
  final CollectionReference collectionReference =
      FirebaseFirestore.instance.collection("contacts");
  DateTime _focusedDay = DateTime.now();

  DateTime _selectedDay = DateTime.now();

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 50),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.4,
                    child: TextFormField(
                      controller: _textEditingController,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                      decoration: InputDecoration(
                        hintText: "宿題：",
                        hintStyle: TextStyle(fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    // Botao de ADD
                    child: ElevatedButton(
                      onPressed: () async {
                        await collectionReference
                            // depois que mandar o .clear() limpa o TextEditin
                            .add({"name": _textEditingController.text}).then(
                                (value) => _textEditingController.clear());
                      },
                      child: Text(
                        "Add Data",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    // Botao de Update e Delete
                    child: ElevatedButton(
                      // EXEMPLO DO SITE DA FIREBASE
                      // site : https://firebase.google.com/docs/firestore/data-model?hl=pt-br#web-v8
                      // var messageRef = db.collection('rooms').doc('roomA').collection('messages').doc('message1');
                      onPressed: () async {
                        // update documnet code "V0b5Z1CVrISTgPR2YjWg"
                        await collectionReference
                            .doc("V0b5Z1CVrISTgPR2YjWg")
                            .update({"name": "Cofee"}).then(
                                (value) => print("update"));
                      },
                      child: Text(
                        "Update Data",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                // Edit text
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    // Botao de Delete
                    child: ElevatedButton(
                      onPressed: () async {
                        // delete documnet
                        await collectionReference
                            .doc("GLVJdROMRGGF2X7QOBHK")
                            .delete()
                            .then((value) => print("delete"));
                      },
                      child: Text(
                        "Delete Data",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                // Edit text
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    // Botao de Delete
                    child: ElevatedButton(
                      onPressed: () => onPressedRaisedButton(),
                      // delete documnet
                      // await collectionReference
                      //     .doc("GLVJdROMRGGF2X7QOBHK")
                      //     .delete()
                      //     .then((value) => print("delete"));

                      child: Text(
                        "testando os dados do calendario",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 16,
                child: Container(
                  color: Colors.amber,
                ),
              ),
              Expanded(
                // se houver dados no banco de dado ele devolve o valor
                //  somente a column == name do banco de dado
                child: StreamBuilder(
                  stream: collectionReference.orderBy("data").snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasData) {
                      return ListView(
                        children: snapshot.data.docs
                            .map(
                              (e) => Container(
                                color: Colors.blueGrey[100],
                                margin: const EdgeInsets.all(5),
                                child: ListTile(
                                  leading: IconButton(
                                    icon: Icon(
                                      e["feito"]
                                          ? Icons.check
                                          : Icons.radio_button_unchecked,
                                      size: 28,
                                    ),
                                    onPressed: () => collectionReference
                                        .doc(e.id)
                                        .update({"feito": !e["feito"]}).then(
                                            (value) => print("update")),
                                  ),
                                  title: Text(
                                    e["name"],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(e["descricao"]),
                                  trailing: CircleAvatar(
                                    backgroundColor: Color(0xff0099FF),
                                    child: IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color: Color(0xffFFFFFF),
                                      ),
                                      //
                                      //icon: Icon(Icons.edit)
                                      //
                                      onPressed: () => collectionReference
                                          .doc(e.id)
                                          .delete()
                                          .then((value) => print("deleted")),
                                    ),
                                  ),

                                  // trailing: IconButton(
                                  //     icon: Icon(Icons.edit),
                                  //     onPressed: () => null
                                  //     //arguments: snapshot.data.docs
                                  //     ),
                                ),
                              ),
                            )
                            .toList(),
                      );
                    }
                  },
                ),
              ),
            ],
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

    //DateTime _date = new DateTime.now();
    // void onPressedRaisedButton() async {
    //   DateTime picked = await showDatePicker(
    //       //locale: const Locale("ja"),
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
    //}

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
