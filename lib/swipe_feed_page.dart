import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'cards_section_alignment.dart';
import 'cards_section_draggable.dart';

class SwipeFeedPage extends StatefulWidget {
  @override
  _SwipeFeedPageState createState() => _SwipeFeedPageState();
}

class _SwipeFeedPageState extends State<SwipeFeedPage> {
  bool showAlignmentCards = false;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {}, icon: Icon(Icons.settings, color: Colors.grey)),
        title: Switch(
          onChanged: (bool value) => setState(() => showAlignmentCards = value),
          value: showAlignmentCards,
          activeColor: Colors.red,
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {},
              icon: Icon(Icons.question_answer, color: Colors.grey)),
        ],
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          showAlignmentCards
              ? CardsSectionAlignment(context)
              : CardsSectionDraggable(),
          /*buttonsRow()*/
        ],
      ),
        bottomNavigationBar: FancyBottomNavigation(
          tabs: [
            TabData(
                iconData: Icons.home,
                title: "Home",
                onclick: () {
                  
            }),
            TabData(iconData: Icons.search, title: "Search"),
          ],
          onTabChangedListener: (position) {
            setState(() {
              currentPage = position;
            });
          },
        ),
    );
  }

}
