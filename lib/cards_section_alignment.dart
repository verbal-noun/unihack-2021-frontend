import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
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

class CardsSection extends StatefulWidget {
  final String location;
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
  int cardsCounter = 0;
  int backCardsCounter = 0;
  int dir = 0;

  List<ProfileCard> cards = [];
  List<ProfileBackCard> backCards = [];
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  ProfileCard lastCard;
  ProfileBackCard backLastCard;

  AnimationController _controller;

  // Determine where the new card will pop up
  final Alignment defaultFrontCardAlign = Alignment(0.0, -0.2);
  Alignment frontCardAlign;
  double frontCardRot = 0.0;

  @override
  void initState() {
    print(widget.location);
    super.initState();

    // Read cards from backend
    for (cardsCounter = 0; cardsCounter < 3; cardsCounter++) {
      cards.add(ProfileCard(
          cardNum: cardsCounter,
          cardLabel: "PooPoo",
          photoURL: "res/portrait.jpeg"));
      backCards.add(ProfileBackCard(
          cardNum: backCardsCounter,
          cardLabel: "PeePee",
          photoURL: "res/portrait.jpeg"));
      backCardsCounter++;
    }

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
          print("Found a match! ${lastCard.cardNum}");
          Navigator.of(context).push(new PageRouteBuilder(
            pageBuilder: (_, __, ___) => new DetailPage(),
          ));
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Stack(
      children: <Widget>[
        backCard(),
        middleCard(),
        FlipCard(key: cardKey, front: frontCard(), back: backsideFrontCard()),

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

  Widget backsideBackCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.backCardAlignmentAnim(_controller).value
          : cardsAlign[0],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.backCardSizeAnim(_controller).value
              : cardsSize[2],
          child: backCards[2]),
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

  Widget backsideMiddleCard() {
    return Align(
      alignment: _controller.status == AnimationStatus.forward
          ? CardsAnimation.middleCardAlignmentAnim(_controller).value
          : cardsAlign[1],
      child: SizedBox.fromSize(
          size: _controller.status == AnimationStatus.forward
              ? CardsAnimation.middleCardSizeAnim(_controller).value
              : cardsSize[1],
          child: backCards[1]),
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
      // Swap cards (back card becomes the middle card; middle card becomes the front card, front card becomes a  bottom card)

      lastCard = cards[0];
      cards[0] = cards[1];
      cards[1] = cards[2];
      cards[2] = lastCard;

      backLastCard = backCards[0];
      backCards[0] = backCards[1];
      backCards[1] = backCards[2];
      backCards[2] = backLastCard;

      cards[2] = ProfileCard(
          cardNum: cardsCounter,
          cardLabel: "Poopypoo",
          photoURL: "res/portrait.jpeg");
      cardsCounter++;

      backCards[2] = ProfileBackCard(
          cardNum: backCardsCounter,
          cardLabel: "Peepypee",
          photoURL: "res/portrait.jpeg");
      backCardsCounter++;

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
