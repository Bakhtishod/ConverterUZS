import 'dart:convert';

import 'package:flutter/material.dart';

class ConverterPage extends StatefulWidget {
  const ConverterPage({Key? key}) : super(key: key);

  @override
  _ConverterPageState createState() => _ConverterPageState();
}

class _ConverterPageState extends State<ConverterPage> {
  final _controller = TextEditingController();
  String _text = "0";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blueAccent, width: 1)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Center(
                child: TextField(
                  onChanged: (v) => setState(() {
                    _text = v;
                  }),
                  textAlign: TextAlign.right,
                  maxLines: 20,
                  style: TextStyle(
                      color: Colors.black, fontSize: 50, fontFamily: "Roboto"),
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Enter text",
                    hintStyle: TextStyle(fontSize: 40),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 12,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(color: Colors.blueAccent, width: 1)),
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      )),
                  Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(color: Colors.blueAccent, width: 1)),
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        // padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                        child: Center(
                          child: Text(
                            "=",
                            style: TextStyle(color: Colors.blue, fontSize: 30),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),
                  Expanded(
                      flex: 3,
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                            border:
                                Border.all(color: Colors.blueAccent, width: 1)),
                        margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                        padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      )),
                ],
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blueAccent, width: 1)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
              child: Align(
                  alignment: Alignment.topRight,
                  child: Text(
                    _text,
                    style: TextStyle(color: Colors.blue, fontSize: 50),
                  )),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blueAccent, width: 1)),
              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
              padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
              child: Text(
                "* Data is taken from Central Bank of Uzbekistan!",
                style: TextStyle(
                    color: Colors.blue, fontSize: 14, fontFamily: "Roboto"),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
