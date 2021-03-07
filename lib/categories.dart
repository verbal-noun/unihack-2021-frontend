import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';


class CategoriesPage extends StatelessWidget {
  @override
  Items item1 = new Items(
      title: "Indoor",
      img: "/indoor.jpg");

  Items item2 = new Items(
    title: "Outdoor",
    img: "/outdoor.jpg",
  );
  Items item3 = new Items(
    title: "Board-games",
    img: "/boardgames.jpg",
  );
  Items item4 = new Items(
    title: "Sports",
    img: "/sports.jpg",
  );
  Items item5 = new Items(
    title: "Sightseeing ",
    img: "/sightseeing.jpeg",
  );
  Items item6 = new Items(
    title: "Night Activities",
    img: "/nightactivities.jpg",
  );
  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item5, item2, item4, item3, item6];
    var color = 0xff453658;
    return Scaffold(
        backgroundColor: new Color.fromRGBO(35, 74, 109, 1),
        appBar: AppBar(
          title: Text("Categories page"),
          backgroundColor: new Color.fromRGBO(23, 61, 86, 1),
        ),

        body: Column(
            children: [Flexible(
              child: GridView.count(
                  childAspectRatio: 1.0,
                  padding: EdgeInsets.only(top: 16.0, left: 16, right: 16),
                  crossAxisCount: 2,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                  children: myList.map((data) {
                    return InkWell(
                      // onTap: () => Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (_) => RoomPage())),
                        child: Container(
                          decoration: BoxDecoration(
                              color: new Color.fromRGBO(47, 38, 117, 1),
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                data.img,
                                width: 92,
                              ),
                              SizedBox(
                                height: 14,
                              ),
                              Text(
                                data.title,
                                style: GoogleFonts.openSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600)),
                              ),
                              SizedBox(
                                height: 8,
                              ),
                              SizedBox(
                                height: 14,
                              ),
                            ],
                          ),
                        ));
                  }).toList()),
            )])
        );
  }
}

class Items {
  String title;
  String subtitle;
  String event;
  String img;
  Items({this.title, this.subtitle, this.event, this.img});
}


// class _CategoriesPageState extends State<CategoriesPage> {
//   @override
//   Widget build(BuildContext context) {
//     List<Items> myList = [item1, item5, item2, item4, item3, item6];
//     var color = 0xff453658;
//     // return Scaffold(
//     //   appBar: AppBar(title: Text("Categories page"),),
//     //   body: Center(child: Text("Browse activities by categories"),),
//     // );
//     return Flexible(
//       child: GridView.count(
//           childAspectRatio: 1.0,
//           padding: EdgeInsets.only(left: 16, right: 16),
//           crossAxisCount: 2,
//           crossAxisSpacing: 18,
//           mainAxisSpacing: 18,
//           children: myList.map((data) {
//             return InkWell(
//                 onTap: () => Navigator.of(context)
//                     .push(MaterialPageRoute(builder: (_) => RoomPage())),
//                 child: Container(
//                   decoration: BoxDecoration(
//                       color: Color(color),
//                       borderRadius: BorderRadius.circular(10)),
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: <Widget>[
//                       Image.asset(
//                         data.img,
//                         width: 42,
//                       ),
//                       SizedBox(
//                         height: 14,
//                       ),
//                       Text(
//                         data.title,
//                         style: GoogleFonts.openSans(
//                             textStyle: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 16,
//                                 fontWeight: FontWeight.w600)),
//                       ),
//                       SizedBox(
//                         height: 8,
//                       ),
//                       Text(
//                         data.subtitle,
//                         style: GoogleFonts.openSans(
//                             textStyle: TextStyle(
//                                 color: Colors.white38,
//                                 fontSize: 10,
//                                 fontWeight: FontWeight.w600)),
//                       ),
//                       SizedBox(
//                         height: 14,
//                       ),
//                       Text(
//                         data.event,
//                         style: GoogleFonts.openSans(
//                             textStyle: TextStyle(
//                                 color: Colors.white70,
//                                 fontSize: 11,
//                                 fontWeight: FontWeight.w600)),
//                       ),
//                     ],
//                   ),
//                 ));
//           }).toList()),
//     );
//   }
// }
//
// class Items {
//   String title;
//   String subtitle;
//   String event;
//   String img;
//   Items({this.title, this.subtitle, this.event, this.img});
// }
//   }
// }
//
