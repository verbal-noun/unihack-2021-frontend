import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:tinder_cards/backend_calls.dart';
import 'package:tinder_cards/profile_card_expand.dart';
import 'profile_card_alignment.dart';
import 'backside_profile_card_alignment.dart';
import 'dart:math';

List<Alignment> cardsAlign = [
  // (W , H)
  Alignment(0.0, 0.4), // Bottom
  Alignment(0.0, 0.2), // Middle
  Alignment(0.0, -0.2) // Top
];
List<Size> cardsSize = [];

double deg2rad(deg) {
  return deg * (pi / 180);
}

double calculateDistance(lat1, lon1, lat2, lon2) {
  var R = 6371; // Radius of the earth in km
  var dLat = deg2rad(lat2 - lat1); // deg2rad below
  var dLon = deg2rad(lon2 - lon1);
  var a = sin(dLat / 2) * sin(dLat / 2) +
      cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * sin(dLon / 2) * sin(dLon / 2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  var d = R * c; // Distance in km
  return d;
}

class CardsSection extends StatefulWidget {
  final List location;
  CardsSection(BuildContext context, {this.location}) {
    cardsSize.add(Size(MediaQuery.of(context).size.width * 0.9,
        MediaQuery.of(context).size.height * 0.6));
    cardsSize.add(Size(MediaQuery.of(context).size.width * 0.85,
        MediaQuery.of(context).size.height * 0.55));
    cardsSize.add(Size(MediaQuery.of(context).size.width * 0.8,
        MediaQuery.of(context).size.height * 0.5));
  }

  @override
  _CardsSectionState createState() => _CardsSectionState();
}

class _CardsSectionState extends State<CardsSection>
    with SingleTickerProviderStateMixin {
  int dir = 0;

  List<ProfileCard> cards = [];
  List<ProfileBackCard> backCards = [];
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  ProfileCard lastCard;
  ProfileBackCard backLastCard;
  bool ready = false;

  AnimationController _controller;

  // Determine where the new card will pop up
  final Alignment defaultFrontCardAlign = Alignment(0.0, -0.2);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    print(widget.location);
    super.initState();
    frontCardAlign = cardsAlign[2];

    // Init the animation controller
    _controller =
        AnimationController(duration: Duration(milliseconds: 700), vsync: this);
    _controller.addListener(() => setState(() {}));
    _controller.addStatusListener((AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        changeCardsOrder();
        if (!cardKey.currentState.isFront) {
          cardKey.currentState.controller.reset();
          cardKey.currentState.isFront = true;
        }
        if (dir == 1) {
          Navigator.of(context).push(new PageRouteBuilder(
            pageBuilder: (_, __, ___) => new DetailPage(
                name: lastCard.name,
                photoURLs: lastCard.photoURLs,
                distance: lastCard.distance,
                location: widget.location,
                target: lastCard.target),
          ));
        }
      }
    });
    generateCards();
  }

  Future<bool> generateCards() async {
    if (ready) return true;
    List results = await Backend.fetchNearby(widget.location, ["bar"]);

    // Read cards from backend
    for (int i = 0; i < results.length; i++) {
      List imageURLs = [];
      var res = results[i];
      if (res["photos"] != null) {
        for (int j = 0; j < res["photos"].length; j++) {
          var photo = res["photos"][j];
          imageURLs.add(await Backend.fetchImage(photo["photo_reference"]));
        }
      } else {
        imageURLs.add(res["icon"]);
      }
      List target = [
        res["geometry"]["location"]["lat"],
        res["geometry"]["location"]["lng"]
      ];
      cards.add(ProfileCard(
          name: res["name"],
          distance: calculateDistance(
              target[0], target[1], widget.location[0], widget.location[1]),
          photoURLs: imageURLs,
          target: target));
      backCards.add(ProfileBackCard(
          cardLabel: res["name"], distance: "5 kms", photoURL: imageURLs[0]));
    }
    ready = true;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: generateCards(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Text("Loading");
          }
          return Expanded(
              child: Stack(
            children: <Widget>[
              backCard(),
              middleCard(),
              FlipCard(
                  key: cardKey, front: frontCard(), back: backsideFrontCard()),

              // Prevent swiping if the cards are animating
              _controller.status != AnimationStatus.forward
                  ? SizedBox.expand(
                      child: GestureDetector(
                      // While dragging the first card
                      onPanUpdate: (DragUpdateDetails details) {
                        // Add what the user swiped in the last frame to the alignment of the card
                        setState(() {
                          // 20 is the "speed" at which moves the card
                          frontCardAlign = Alignment(
                              frontCardAlign.x +
                                  20 *
                                      details.delta.dx /
                                      MediaQuery.of(context).size.width,
                              frontCardAlign.y +
                                  40 *
                                      details.delta.dy /
                                      MediaQuery.of(context).size.height);

                          frontCardRot = frontCardAlign.x; // * rotation speed;
                        });
                      },
                      // When releasing the first card
                      onPanEnd: (_) {
                        // If the front card was swiped far enough to count as swiped
                        if (frontCardAlign.x > 3.0 || frontCardAlign.x < -3.0) {
                          animateCards();
                        } else {
                          // Return to the initial rotation and alignment
                          setState(() {
                            frontCardAlign = defaultFrontCardAlign;
                            frontCardRot = 0.0;
                          });
                        }
                      },
                    ))
                  : Container(),
            ],
          ));
        });
  }

  Widget backCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: cards[2]),
    );
  }

  Widget middleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: cards[1]),
    );
  }

  Widget frontCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign, this)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(size: cardsSize[0], child: cards[0]),
        ));
  }

  Widget backsideFrontCard() {
    return Align(
        alignment: _controller.status == AnimationStatus.forward
            ? CardsAnimation.frontCardDisappearAlignmentAnim(
                    _controller, frontCardAlign, this)
                .value
            : frontCardAlign,
        child: Transform.rotate(
          angle: (pi / 180.0) * frontCardRot,
          child: SizedBox.fromSize(size: cardsSize[0], child: backCards[0]),
        ));
  }

  void changeCardsOrder() {
    setState(() {
      // Shift cards forward

      lastCard = cards[0];
      cards.removeAt(0);

      backLastCard = backCards[0];
      backCards.removeAt(0);

      frontCardAlign = defaultFrontCardAlign;
      frontCardRot = 0.0;
    });
  }

  void animateCards() {
    _controller.stop();
    _controller.value = 0.0;
    _controller.forward();
  }
}

class CardsAnimation {
  static Animation<Alignment> backCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[0], end: cardsAlign[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Size> backCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[2], end: cardsSize[1]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.4, 0.7, curve: Curves.easeIn)));
  }

  static Animation<Alignment> middleCardAlignmentAnim(
      AnimationController parent) {
    return AlignmentTween(begin: cardsAlign[1], end: cardsAlign[2]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Size> middleCardSizeAnim(AnimationController parent) {
    return SizeTween(begin: cardsSize[1], end: cardsSize[0]).animate(
        CurvedAnimation(
            parent: parent, curve: Interval(0.2, 0.5, curve: Curves.easeIn)));
  }

  static Animation<Alignment> frontCardDisappearAlignmentAnim(
      AnimationController parent,
      Alignment beginAlign,
      _CardsSectionState state) {
    // Has swiped to the left or right?
    state.dir = beginAlign.x > 0 ? 1 : -1;
    return AlignmentTween(
            begin: beginAlign,
            end: Alignment(beginAlign.x + (state.dir * 30.0), 0.0))
        .animate(CurvedAnimation(
            parent: parent, curve: Interval(0.0, 0.5, curve: Curves.easeIn)));
  }
}
