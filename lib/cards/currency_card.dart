import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final int id;
  final String code;
  final String ccy;
  final String ccy_name;
  final String rate;
  final String diff;

  const CurrencyCard(
      {Key? key,
        required this.id,
        required this.code,
        required this.ccy,
        required this.ccy_name,
        required this.rate,
        required this.diff})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.blueAccent, width: 1)),
      margin: EdgeInsets.fromLTRB(5, 5, 5, 5),
      padding: EdgeInsets.fromLTRB(8, 5, 8, 5),
      child: Row(
        children: [
          Expanded(flex: 1, child: Image.asset("assets/flags/$code.png")),
          SizedBox(
            width: 10,
          ),
          Expanded(
            flex: 5,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      ccy,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: "Roboto"),
                    ),
                    Expanded(child: Container()),
                    Text(
                      rate,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 20,
                          fontFamily: "Roboto"),
                    ),
                  ],
                ),
                Divider(
                  thickness: 2,
                  color: Colors.blueAccent,
                ),
                Row(
                  children: [
                    Text(
                      ccy_name,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16,
                          fontFamily: "Roboto"),
                    ),
                    Expanded(child: Container()),
                    Container(
                        child: diff.toString().startsWith("-")
                            ?
                        Row(
                          children: [
                            Text(
                              diff,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 16,
                                  fontFamily: "Roboto"),
                            ),
                            SizedBox(width: 4,),
                            Icon(Icons.trending_down, color: Colors.red, size: 14,)
                          ],
                        )
                            :
                        Row(
                          children: [
                            Text(
                              diff,
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 16,
                                  fontFamily: "Roboto"),
                            ),
                            SizedBox(width: 4,),
                            Icon(Icons.trending_up, color: Colors.green,size: 14,)
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
