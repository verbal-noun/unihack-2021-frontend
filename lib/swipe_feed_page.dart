import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:tinder_cards/categories.dart';
import 'cards_section_alignment.dart';

class SwipeFeedPage extends StatefulWidget {
  final Location _location = Location();

  @override
  _SwipeFeedPageState createState() => _SwipeFeedPageState();
}

class _SwipeFeedPageState extends State<SwipeFeedPage> {
  bool showAlignmentCards = false;
  int currentPage = 0;
  String location = "-37.8095071373105,144.9626793693156";

  GlobalKey bottomNavigationKey = GlobalKey();

  Future<LocationData> initializeLocation() async {
    bool _serviceEnabled = await widget._location.serviceEnabled();
    PermissionStatus _permissionGranted =
        await widget._location.requestPermission();

    if (!_serviceEnabled) {
      _serviceEnabled = await widget._location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }
    if (_permissionGranted == PermissionStatus.DENIED) {
      _permissionGranted = await widget._location.requestPermission();
      if (_permissionGranted == PermissionStatus.GRANTED) {
        return null;
      }
    }

    return await widget._location.getLocation();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: initializeLocation(),
        builder: (BuildContext context, AsyncSnapshot<LocationData> snapshot) {
          // Melbourne Central default
          if (!snapshot.hasData) return Text("Loading...");
          if (snapshot.data != null) {
            location = "${snapshot.data.longitude},${snapshot.data.latitude}";
          }
          return Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              centerTitle: true,
              backgroundColor: Colors.white,
              leading: IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.settings, color: Colors.grey)),
            ),
            backgroundColor: Colors.white,
            body: Container(
              child: _getPage(currentPage),
            ),
            bottomNavigationBar: FancyBottomNavigation(
              tabs: [
                TabData(
                    iconData: Icons.home,
                    title: "Home",
                    onclick: () {
                      final FancyBottomNavigationState fstate =
                          bottomNavigationKey.currentState;
                      fstate.setPage(2);
                    }),
                TabData(
                    iconData: Icons.search,
                    title: "Search",
                    onclick: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CategoriesPage()))),
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
        });
  }

  _getPage(int page) {
    switch (page) {
      case 0:
        return Column(
          children: <Widget>[CardsSection(context, location: location)],
        );
      case 1:
        return CategoriesPage();
      default:
        return Column(
          children: <Widget>[CardsSection(context, location: location)],
        );
    }
  }
}
