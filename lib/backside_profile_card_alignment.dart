import 'package:flutter/material.dart';
import 'map.dart';

class ProfileBackCard extends StatefulWidget {
  final int cardNum;
  final String cardLabel;
  final String photoURL;
  final String about;
  final String distance;

  ProfileBackCard(
      {this.cardNum, this.cardLabel, this.photoURL, this.about, this.distance});

  @override
  _ProfileBackCardState createState() => _ProfileBackCardState();
}

class _ProfileBackCardState extends State<ProfileBackCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: Material(
              borderRadius: BorderRadius.circular(12.0),
              //child: Image.asset(widget.photoURL, fit: BoxFit.cover),
            ),
          ),
          SizedBox.expand(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Colors.transparent, Colors.black54],
                      begin: Alignment.center,
                      end: Alignment.bottomCenter)),
            ),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Strike Melbourne Central',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w700)),
                    Padding(padding: EdgeInsets.only(bottom: 8.0)),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(widget.distance,
                              textAlign: TextAlign.end,
                              style: TextStyle(color: Colors.white)),
                          // Column(
                          //   children: <Widget> [
                          //     Text("Strike Bowling is guaranteed to awaken your inner child. Located on level 3 of Melbourne Central it houses bowling, laser tag and even a pool table. Strike is a super fun venue, that’s bound to bring out a few giggles.",
                          //         textAlign: TextAlign.end,
                          //         style: TextStyle(color: Colors.white)),
                          //   ]
                          // )
                        ])
                  ],
                )),
          )
        ],
      ),
    );
  }
}
