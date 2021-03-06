import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/categories.dart';
import 'cards_section_alignment.dart';

class SwipeFeedPage extends StatefulWidget {
  @override
  _SwipeFeedPageState createState() => _SwipeFeedPageState();
}

class _SwipeFeedPageState extends State<SwipeFeedPage> {
  bool showAlignmentCards = false;
  int currentPage = 0;

  GlobalKey bottomNavigationKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {}, icon: Icon(Icons.settings, color: Colors.grey)),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.question_answer, color: Colors.grey)),
        ],
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
                onclick: () => Navigator.of(context).push(MaterialPageRoute(builder: (context)=> CategoriesPage()))
            ),
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

  _getPage(int page) {
    switch (page) {
      case 0:
        return Column(
          children: <Widget>[CardsSection(context)],
        );
      case 1: return CategoriesPage();
      default:
        return Column(
    children: <Widget>[CardsSection(context)],
      );
    }
  }

}
