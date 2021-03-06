import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:carousel_pro/carousel_pro.dart';

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => new _DetailPageState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;
  List data = [];
  double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;

  void initState() {
    _containerController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);
    super.initState();
    width = new Tween<double>(
      begin: 200.0,
      end: 220.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth = new Tween<double>(
      begin: 400.0,
      end: 400.0,
    ).animate(
      new CurvedAnimation(
        parent: _containerController,
        curve: Curves.ease,
      ),
    );
    heigth.addListener(() {
      setState(() {
        if (heigth.isCompleted) {}
      });
    });
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.7;
    //print("detail");
    return new Theme(
      data: new ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.yellow,
        /////Carousel Below
        // SizedBox(
        //     height: 150.0,
        //     width: 300.0,
        //     child: Carousel(
        //       images: [
        //         NetworkImage('https://cdn-images-1.medium.com/max/2000/1*GqdzzfB_BHorv7V2NV7Jgg.jpeg'),
        //         NetworkImage('https://cdn-images-1.medium.com/max/2000/1*wnIEgP1gNMrK5gZU7QS0-A.jpeg'),
        //         ExactAssetImage("assets/images/LaunchImage.jpg")
        //       ],
        //     )
        // ),
        platform: Theme.of(context).platform,
      ),
      child: new Container(
        width: width.value,
        height: heigth.value,
        color: Colors.blue,
        child: new Hero(
          tag: "img",
          child: new Card(
            color: Colors.transparent,
            child: new Container(
              alignment: Alignment.center,
              width: width.value,
              height: heigth.value,
              decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: new Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  new CustomScrollView(
                    shrinkWrap: false,
                    slivers: <Widget>[
                      new SliverAppBar(
                        elevation: 0.0,
                        forceElevated: true,
                        leading: new IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: new Icon(
                            Icons.arrow_back,
                            color: Colors.cyan,
                            size: 30.0,
                          ),
                        ),
                        expandedHeight: _appBarHeight,
                        pinned: _appBarBehavior == AppBarBehavior.pinned,
                        floating: _appBarBehavior == AppBarBehavior.floating ||
                            _appBarBehavior == AppBarBehavior.snapping,
                        snap: _appBarBehavior == AppBarBehavior.snapping,
                        flexibleSpace: new FlexibleSpaceBar(
                          title: new Text("Party"),
                          background: new Stack(
                            fit: StackFit.expand,
                            children: <Widget>[
                              new Container(
                                width: width.value,
                                height: _appBarHeight,
                              ),
                            ],
                          ),
                        ),
                      ),
                      new SliverList(
                        delegate: new SliverChildListDelegate(<Widget>[
                          new Container(
                            color: Colors.white,
                            child: new Padding(
                              padding: const EdgeInsets.all(35.0),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  new Container(
                                    padding: new EdgeInsets.only(bottom: 20.0),
                                    alignment: Alignment.center,
                                    decoration: new BoxDecoration(
                                        color: Colors.white,
                                        border: new Border(
                                            bottom: new BorderSide(
                                                color: Colors.black12))),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        new Column(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.access_time,
                                              color: Colors.blueAccent,
                                            ),
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: new Text("Opening hour: 10:00  AM"),
                                            )
                                          ],
                                        ),
                                        new Column(
                                          children: <Widget>[
                                            new Icon(
                                              Icons.map,
                                              color: Colors.blueAccent,
                                            ),
                                            new Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: new Text("Distance: 5 KMS"),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  new Padding(
                                    padding: const EdgeInsets.only(
                                        top: 16.0, bottom: 8.0),
                                    child: new Text(
                                      "MAP",
                                      style: new TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Image.asset(
                                    "/SampleImage1.png",
                                    width: 292,
                                  ),
                                  new Container(
                                    height: 100.0,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      ),
                    ],
                  ),
                  new Container(
                      width: 600.0,
                      height: 80.0,
                      decoration: new BoxDecoration(
                        color: Colors.white,
                      ),
                      alignment: Alignment.center,
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          new TextButton(
                              onPressed: () {},
                              child: new Container(
                                height: 60.0,
                                width: 130.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: new BorderRadius.circular(60.0),
                                ),
                                child: new Text(
                                  "DON'T",
                                  style: new TextStyle(color: Colors.white),
                                ),
                              )),
                          new TextButton(
                              onPressed: () {},
                              child: new Container(
                                height: 60.0,
                                width: 130.0,
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: new BorderRadius.circular(60.0),
                                ),
                                child: new Text(
                                  "I'M IN",
                                  style: new TextStyle(color: Colors.white),
                                ),
                              ))
                        ],
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
