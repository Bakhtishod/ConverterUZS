import 'dart:convert';

import 'package:converter/pages/converter.dart';
import 'package:converter/pages/uzs_rate.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

import 'cards/currency_card.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Converter Uz',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  InterstitialAd? interstitialAd;
  BannerAd? bannerAd;
  bool isBannerAdLoaded = false;
  bool isInterstitialAdLoaded = false;

  @override
  initState(){
    super.initState();
    _initBannerAd();
  }

  _initBannerAd() {
    bannerAd = BannerAd(size: AdSize.banner,
        adUnitId: "ca-app-pub-4257423021523762/8290426123",
        listener: BannerAdListener(
          onAdLoaded: (ad){
            setState(() {
              isBannerAdLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, error){

          }
        ),
        request: AdRequest());
    bannerAd!.load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    InterstitialAd.load(
        adUnitId: "ca-app-pub-4257423021523762/5558459184",
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: (ad) {
              setState(() {
                isInterstitialAdLoaded = true;
                this.interstitialAd = ad;
              });
              print("Ad Loaded");
            }, onAdFailedToLoad: (error) {
          print("Interstitial Ad Failed to load!");
        }));
  }

  int _index = 0;

  // Widget currentPage = ConverterPage();
  int currentPage = 0;
  List data = [];
  late Box box;
  final _controller = TextEditingController();
  String _text = "0";

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

    var responseMap = box
        .toMap()
        .values
        .toList();
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
      if (isInterstitialAdLoaded) {
        interstitialAd!.show();
      }
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

  final currencyItems = [
    "UZS",
    "USD",
    "EUR",
    "RUB",
    "GBP",
    "JPY",
    "AZN",
    "BDT",
    "BGN",
    "BHD",
    "BND",
    "BRL",
    "BYN",
    "CAD",
    "CHF",
    "CNY",
    "CUP",
    "CZK",
    "DKK",
    "DZD",
    "EGP",
    "AFN",
    "ARS",
    "GEL",
    "HKD",
    "HUF",
    "IDR",
    "ILS",
    "INR",
    "IQD",
    "IRR",
    "ISK",
    "JOD",
    "AUD",
    "KGS",
    "KHR",
    "KRW",
    "KWD",
    "KZT",
    "LAK",
    "LBP",
    "LYD",
    "MAD",
    "MDL",
    "MMK",
    "MNT",
    "MXN",
    "MYR",
    "NOK",
    "NZD",
    "OMR",
    "PHP",
    "PKR",
    "PLN",
    "QAR",
    "RON",
    "RSD",
    "AMD",
    "SAR",
    "SDG",
    "SEK",
    "SGD",
    "SYP",
    "THB",
    "TJS",
    "TMT",
    "TND",
    "TRY",
    "UAH",
    "AED",
    "UYU",
    "VES",
    "VND",
    "XDR",
    "YER",
    "ZAR"
  ];

  String? valueFirst;
  String? valueSecond;
  int? indexFirst;
  int? indexSecond;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Center(child: Text("Converter Uz", style: TextStyle(fontFamily: "Roboto", fontSize: 22),)),
      // ),
      body: SafeArea(
          child: currentPage == 0
              ? Container(
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 3,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Colors.blueAccent, width: 1)),
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      child: Center(
                        child: TextField(
                          keyboardType: TextInputType.number,
                          onChanged: (v) =>
                              setState(() {
                                _text = v;
                              }),
                          textAlign: TextAlign.right,
                          maxLines: 20,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 50,
                              fontFamily: "Roboto"),
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
                      height: MediaQuery
                          .of(context)
                          .size
                          .height / 12,
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
                                    border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1)),
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                child: Center(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text("Select currency"),
                                      isExpanded: true,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.blue,
                                      ),
                                      iconSize: 26,
                                      value: valueFirst,
                                      items: currencyItems
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          this.valueFirst = value;
                                          indexFirst =
                                              currencyItems.indexOf(value!);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )),
                          Expanded(
                              flex: 1,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1)),
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                // padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                child: Center(
                                  child: Text(
                                    "=",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 30),
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
                                    border: Border.all(
                                        color: Colors.blueAccent,
                                        width: 1)),
                                margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                padding: EdgeInsets.fromLTRB(6, 2, 6, 2),
                                child: Center(
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      hint: Text("Select currency"),
                                      isExpanded: true,
                                      icon: Icon(
                                        Icons.keyboard_arrow_down_outlined,
                                        color: Colors.blue,
                                      ),
                                      iconSize: 26,
                                      value: valueSecond,
                                      items: currencyItems
                                          .map(buildMenuItem)
                                          .toList(),
                                      onChanged: (value) {
                                        setState(() {
                                          this.valueSecond = value;
                                          indexSecond =
                                              currencyItems.indexOf(value!);
                                        });
                                      },
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                    FutureBuilder(
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
                            return Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
                              height:
                              MediaQuery
                                  .of(context)
                                  .size
                                  .height / 3,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.blueAccent, width: 1)),
                              margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    _text.isEmpty ? "0" : convert(),
                                    // "${(int.parse(_text).toDouble()*double.parse(data[0][indexFirst!-1]["Rate"]).toDouble()/double.parse(data[0][indexSecond!-1]["Rate"]))}",
                                    // "${int.parse(_text)/2}",
                                    style: TextStyle(
                                        color: Colors.blue, fontSize: 50),
                                  )),
                            );
                          }
                        } else {
                          return Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            height: MediaQuery
                                .of(context)
                                .size
                                .height / 3,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                    color: Colors.blueAccent, width: 1)),
                            margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Align(
                                alignment: Alignment.center,
                                child: CircularProgressIndicator()),
                          );
                        }
                      },
                    ),
                    Container(
                      width: MediaQuery
                          .of(context)
                          .size
                          .width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                              color: Colors.blueAccent, width: 1)),
                      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
                      child: Text(
                        "* Data is taken from API of CBU !",
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                            fontFamily: "Roboto"),
                      ),
                    ),
                    Container(
                      child: isBannerAdLoaded?Container(
                        height: bannerAd!.size.height.toDouble(),
                        width: bannerAd!.size.width.toDouble(),
                        child: AdWidget(ad: bannerAd!,),
                      ):SizedBox(),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.blue, width: 1)),
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      // child: Text("Information by uzbekistan.travel", textAlign: TextAlign.center, style: TextStyle(fontFamily: "Roboto", color: Colors.blue, fontSize: 24),))
                      child: RichText(softWrap: true, textAlign: TextAlign.center, text: TextSpan(
                          text: "Application was created by",
                          style: TextStyle(fontFamily: "Roboto", color: Colors.black, fontSize: 22),
                          children: [
                            TextSpan(text: "\n</Bakhtishod", style: TextStyle(fontFamily: "Roboto", color: Colors.blue, fontSize: 24)),
                            TextSpan(text: "Dev>", style: TextStyle(fontFamily: "Roboto", color: Colors.greenAccent, fontSize: 26)),
                          ]
                      ),),
                    ),
                  ],
                ),
              ))
              : Container(
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
                        child: NotificationListener<
                            OverscrollIndicatorNotification>(
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
          )),
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.blue,
        elevation: 20,
        onTap: (int val) {
          switch (val) {
            case 0:
              {
                currentPage = 0;
              }
              break;
            case 1:
              {
                currentPage = 1;
              }
              break;
          }
          setState(() => _index = val);
        },
        currentIndex: _index,
        items: [
          FloatingNavbarItem(
              icon: Icons.wifi_protected_setup,
              title: 'Converter'.toUpperCase()),
          FloatingNavbarItem(
              icon: Icons.explore, title: 'UZS Rate'.toUpperCase()),
          // FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        ],
      ),
    );
  }

  String convert() {
    String finalValue = "0";
    if (indexFirst == null || indexSecond == null) {
      finalValue = "Please select currency!";
    } else {
      if (indexFirst == 0 && indexSecond != 0) {
        finalValue =
        "${int.parse(_text).toDouble() /
            double.parse(data[0][indexSecond! - 1]["Rate"])}";
      } else if (indexSecond == 0 && indexFirst != 0) {
        finalValue =
        "${int.parse(_text).toDouble() *
            double.parse(data[0][indexFirst! - 1]["Rate"])}";
      } else if (indexFirst == 0 && indexSecond == 0) {
        finalValue = double.parse(_text).toString();
      } else {
        finalValue =
        "${(int.parse(_text).toDouble() *
            double.parse(data[0][indexFirst! - 1]["Rate"]).toDouble() /
            double.parse(data[0][indexSecond! - 1]["Rate"]))}";
      }
    }
    return finalValue;
  }

  DropdownMenuItem<String> buildMenuItem(String item) =>
      DropdownMenuItem(
        value: item,
        child: Text(
          item,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              fontFamily: "Roboto",
              color: Colors.blue),
        ),
      );
}
