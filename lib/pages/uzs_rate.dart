import 'dart:convert';

import 'package:converter/cards/currency_card.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class UZSRatePage extends StatefulWidget {
  const UZSRatePage({Key? key}) : super(key: key);

  @override
  _UZSRatePageState createState() => _UZSRatePageState();
}

class _UZSRatePageState extends State<UZSRatePage> {
  List data = [];
  late Box box;

  Future openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    box = await Hive.openBox('data');
    return;
  }

  Future<bool> getCurrencyData() async {
    await openBox();
    try {
      var response =
          await http.get(Uri.https("cbu.uz", "uz/arkhiv-kursov-valyut/json"));
      var jsonData = jsonDecode(response.body);
      await insertData(jsonData);
      setState(() {});
    } catch (SocketException) {
      print("No Internet");
    }

    var responseMap = box.toMap().values.toList();
    if (responseMap.isEmpty) {
      data.add("empty");
    } else {
      data.add(responseMap);
    }
    return Future.value(true);
  }

  Future<void> updateData() async {
    try {
      var response =
          await http.get(Uri.https("cbu.uz", "uz/arkhiv-kursov-valyut/json"));
      var jsonData = jsonDecode(response.body);
      await insertData(jsonData);
      setState(() {});
    } catch (SocketException) {
      Toast.show("No Internet!", context,
          duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  Future insertData(data) async {
    await box.clear();
    for (var i in data) {
      box.add(i);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Card(
          child: FutureBuilder(
            future: getCurrencyData(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (data.contains("empty")) {
                  return Container(
                    child: Center(
                      child: Text(
                        "No Data",
                        style: TextStyle(fontSize: 28),
                      ),
                    ),
                  );
                } else {
                  return RefreshIndicator(
                    onRefresh: updateData,
                    child:
                        NotificationListener<OverscrollIndicatorNotification>(
                      onNotification: (overscroll) {
                        overscroll.disallowGlow();
                        return true;
                      },
                      child: ListView.builder(
                          // physics: BouncingScrollPhysics(),
                          itemCount: data[0].length,
                          itemBuilder: (context, index) {
                            return CurrencyCard(
                              id: data[0][index]["id"],
                              code: data[0][index]["Code"],
                              ccy: data[0][index]["Ccy"],
                              ccy_name: data[0][index]["CcyNm_EN"],
                              rate: data[0][index]["Rate"],
                              diff: data[0][index]["Diff"],
                            );
                          }),
                    ),
                  );
                }
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    );
  }
}
