import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:tinder_cards/categories.dart';
import 'package:tinder_cards/map.dart';
import 'package:tinder_cards/swipe_feed_page.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailPage extends StatefulWidget {
  final String name;
  final List photoURLs;
  final double distance;
  final List location;
  final List target;

  DetailPage(
      {this.name, this.photoURLs, this.distance, this.location, this.target});

  @override
  _DetailPageState createState() => new _DetailPageState();
}

enum AppBarBehavior { normal, pinned, floating, snapping }

class _DetailPageState extends State<DetailPage> with TickerProviderStateMixin {
  AnimationController _containerController;
  Animation<double> width;
  Animation<double> heigth;
  double _appBarHeight = 256.0;
  AppBarBehavior _appBarBehavior = AppBarBehavior.pinned;
  List<dynamic> images = [];

  _getPage(int page) {
    switch (page) {
      case 0:
        return SwipeFeedPage();
      case 1:
        return CategoriesPage();
      default:
        return SwipeFeedPage();
    }
  }

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
    widget.photoURLs.forEach((url) => images.add(NetworkImage(url)));
    _containerController.forward();
  }

  @override
  void dispose() {
    _containerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    GlobalKey bottomNavigationKey = GlobalKey();
    int currentPage = 0;
    timeDilation = 0.7;
    //print("detail");
    return Scaffold(
      body: Container(
          color: new Color.fromRGBO(23, 61, 86, 1),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: new Theme(
            data: new ThemeData(
              brightness: Brightness.light,
              primaryColor: new Color.fromRGBO(35, 74, 109, 1),
              platform: Theme.of(context).platform,
            ),
            child: new Container(
              width: width.value,
              height: heigth.value,
              child: new Hero(
                tag: "img",
                child: new Card(
                  color: Colors.transparent,
                  child: new Container(
                    alignment: Alignment.center,
                    width: width.value,
                    height: heigth.value,
                    decoration: new BoxDecoration(
                      color: new Color.fromRGBO(35, 74, 109, 1),
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
                              floating: _appBarBehavior ==
                                      AppBarBehavior.floating ||
                                  _appBarBehavior == AppBarBehavior.snapping,
                              snap: _appBarBehavior == AppBarBehavior.snapping,
                              flexibleSpace: new FlexibleSpaceBar(
                                background: new Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    SizedBox(
                                        height: 150.0,
                                        width: 300.0,
                                        child: Carousel(images: images)),
                                  ],
                                ),
                              ),
                            ),
                            new SliverList(
                              delegate: new SliverChildListDelegate(<Widget>[
                                new Container(
                                  color: new Color.fromRGBO(35, 74, 109, 1),
                                  child: new Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: new Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          child: Text(widget.name,
                                              style: GoogleFonts.openSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18))),
                                          padding:
                                              EdgeInsets.only(bottom: 10.0),
                                        ),
                                        new Container(
                                          padding:
                                              new EdgeInsets.only(bottom: 20.0),
                                          alignment: Alignment.center,
                                          decoration: new BoxDecoration(
                                              color: new Color.fromRGBO(
                                                  35, 74, 109, 1),
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
                                                    color: Colors.cyanAccent,
                                                  ),
                                                  new Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      "Opening hour: 10:00  AM",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              new Column(
                                                children: <Widget>[
                                                  new Icon(
                                                    Icons.map,
                                                    color: Colors.cyanAccent,
                                                  ),
                                                  new Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: new Text(
                                                      "Distance: ${double.parse((widget.distance).toStringAsFixed(2))} KMS",
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
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
                                            "Directions",
                                            style: new TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white),
                                          ),
                                        ),
                                        MapView(
                                            location: widget.location,
                                            target: widget.target),
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
                              color: new Color.fromRGBO(35, 74, 109, 1),
                            ),
                            alignment: Alignment.center,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[],
                            ))
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
      bottomNavigationBar: FancyBottomNavigation(
        barBackgroundColor: new Color.fromRGBO(23, 61, 86, 1),
        circleColor: new Color.fromRGBO(0, 172, 193, 1),
        inactiveIconColor: Colors.cyanAccent,
        textColor: Colors.white,
        tabs: [
          TabData(
              iconData: Icons.home,
              title: "Home",
              onclick: () {
                final FancyBottomNavigationState fstate =
                    bottomNavigationKey.currentState;
                fstate.setPage(0);
              }),
          TabData(
              iconData: Icons.search,
              title: "Search",
              onclick: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (_) => CategoriesPage()));
              }),
        ],
        initialSelection: 0,
        key: bottomNavigationKey,
        onTabChangedListener: (position) {
          setState(() {
            currentPage = position;
          });
        },
      ),
    );
  }
}
