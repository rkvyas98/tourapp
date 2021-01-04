import 'package:flutter/material.dart';
import 'package:tour_app/about.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'places.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'login.dart';
import 'tf_test.dart';

final List<String> imgList = [
  'assets/60-601374_home-taj-mahal-wallpapers-hd-backgrounds-images.jpg',
  'assets/320-3204035_taj-mahal-india-at-night.jpg',
  'assets/796ca0e248e0946720742ecc5e35aeda.jpg',
  'assets/420.jpg',
  'assets/69d9c6641c111fb2b46eaf3cba945792.jpg'
];

final List<String> list = ["TAJ MAHAL","MACHU PICHU","STONE HENGE","EIFFEL TOWER"];
List<String> carousel_image=List<String>();
List<String> carousel_link=List<String>();
List<String> india=List<String>();
List<String> india_link=List<String>();
List<String> abroad=List<String>();
List<String> abroad_link=List<String>();
List<int> fixedList = List<int>();
List<int> fixedList_abroad = List<int>();
List<String> name_list=List<String>();
List<String> place_id=List<String>();
User _user;





class ImageSliderDemoo extends StatefulWidget {
  static const String id = 'carousel';
  int h=5;

  @override
  _ImageSliderDemooState createState() => _ImageSliderDemooState();
}

class _ImageSliderDemooState extends State<ImageSliderDemoo> {

  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  Future<bool> _update;

  int _current = 0;

  @override
  void initState() {
    _update=carousel_update();
    super.initState();
  }


  Future<bool> carousel_update() async {
    final carousel = await _firestore.collection("home_carousel").get();
    final fetch = await _firestore.collection("Places").get();

    List<String> carousel_imgg = List<String>();
    List<String> carousel_linkk = List<String>();

    for (var img in carousel.docs) {
      carousel_imgg.add(img.data()['url']);
      carousel_linkk.add(img.data()['link']);
    }
    List<String> india1=List<String>();
    List<String> india_link1=List<String>();
    List<String> abroad1=List<String>();
    List<String> abroad_link1=List<String>();
    List<String> name=List<String>();
    List<String> name_id=List<String>();

    for (var img in fetch.docs) {
      name.add(img.data()['name']);
      name_id.add(img.id);
      if(img.data()['country']=='India'){
        india1.add(img.data()['img1']);
        india_link1.add(img.id.toString());
      }
      else{
        abroad1.add(img.data()['img1']);
        abroad_link1.add(img.id.toString());
      }
    }

    setState(() {
      _user=_auth.currentUser;
      carousel_image = carousel_imgg;
      carousel_link = carousel_linkk;
      india=india1;
      india_link=india_link1;
      abroad=abroad1;
      abroad_link=abroad_link1;
      name_list=name;
      place_id=name_id;
      fixedList = Iterable<int>.generate(india_link.length).toList();
      fixedList_abroad=Iterable<int>.generate(abroad_link.length).toList();
    });
    print(name_list);
    return true;
  }



  // void placement() async {
  //   final places = await _firestore.collection("Places").doc('place3').get();
  //
  //   print(places.data()['video']);
  //   print(widget.h);
  //
  //   await VideoPlayer360.playVideoURL(places.data()["video"],
  //       showPlaceholder: true
  //   );
  // }


  @override
  Widget build(BuildContext context) =>
      FutureBuilder(
          future: _update,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              // print(imgList);
              // print('helooooooooooooooo');
              // print(carousel_image);
              return SafeArea(
                child: Scaffold(
                  appBar: AppBar(
                    title: Text('TourApp',
                      textAlign: TextAlign.left,
                      style: GoogleFonts.lato(
                        color: Colors.white,
                        fontSize: MediaQuery
                            .of(context)
                            .size
                            .height * 0.025,
                      ),
                    ),
                    backgroundColor: Colors.white10,
                    actions: [
                      IconButton(
                        onPressed: () {
                          showSearch(context: context, delegate: Search(name_list,place_id));
                        },
                        icon: Icon(Icons.search),
                      ),
                      IconButton(icon:Icon(Icons.image_search_sharp),
                          onPressed: (){Navigator.pushNamed(context, ImageSearch.id);})
                    ],

                  ),
                  drawer: Drawer(
                    child: SafeArea(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black,
                        ),
                        child:Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            SizedBox(height: 20,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Icon(Icons.person_outline_outlined,size: 120,color: Colors.white60,),
                                ),
                                Expanded(
                                  child: Column(
                                    children: [Text('Hi',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.021,
                                      ),
                                    ),
                                    Text(_user.displayName,
                                      style: GoogleFonts.pacifico(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: MediaQuery
                                            .of(context)
                                            .size
                                            .height * 0.028,
                                      ),
                                    ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            FlatButton(onPressed: (){
                              Navigator.pushNamed(context, AboutScreen.id);
                            },
                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 1,
                              color: Colors.white60,
                              child: Container(
                                child: Text('About',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.023,
                                  ),
                                ),
                              ),
                            ),

                            FlatButton(onPressed: ()async{
                              await _auth.signOut();
                              Navigator.pushNamedAndRemoveUntil(context,LoginScreen.id,(Route<dynamic> route) => false);
                            },
                              minWidth: MediaQuery
                                  .of(context)
                                  .size
                                  .width * 1,
                              color: Colors.white60,
                              hoverColor: Colors.white,
                              child: Container(

                                child: Text('Logout',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: MediaQuery
                                        .of(context)
                                        .size
                                        .height * 0.023,
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Align(
                                  alignment: Alignment.bottomCenter,
                                child: Container(
                                  color: Colors.white60,
                                  padding: EdgeInsets.symmetric(horizontal:10.0),
                                  child: Row(
                                    children: [
                                      Text(' TourApp ',
                                          style:TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                            fontSize: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.030,
                                          ),),
                                      Text(' - Your Virtual Guide',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: MediaQuery
                                                .of(context)
                                                .size
                                                .height * 0.022,
                                          ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ),
                  ),
                  backgroundColor: Colors.black45,
                  body: ListView(
                    children: <Widget>[
                      Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.005,
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.06,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1.00,
                          child: Text('Trending Hot Places ',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.pacifico(
                                color: Colors.white,
                                fontSize: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.03,
                              )
                          ),
                        ),

                        Container(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.35,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1.00,


                          child: Carousel(
                              onImageTap: (curr) {
                               Navigator.of(context).push(MaterialPageRoute(builder: (context) => Places(link:carousel_link[curr])));
                              },
                              autoplay: true,
                              animationCurve: Curves.fastOutSlowIn,
                              animationDuration: Duration(milliseconds: 1200),
                              dotSize: 6.0,
                              dotIncreasedColor: Colors.black87,
                              dotBgColor: Colors.transparent,
                              dotPosition: DotPosition.bottomCenter,
                              dotVerticalPadding: 10.0,
                              showIndicator: true,
                              indicatorBgPadding: 7.0,

                              images: carousel_image.map((imgurl) {
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: CachedNetworkImage(
                                    placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    imageUrl: imgurl,
                                    fit:BoxFit.fill,
                                  ),
                                );
                              }
                              ).toList()

                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.06,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1.00,
                          child: Text(' Incredible India ',
                              textAlign: TextAlign.left,
                              style: GoogleFonts.mcLaren(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 0.029,
                              ),
                          ),
                        ),
                        Container(
                          height: 175,
                          child: ListView(
                            // This next line does the trick.
                            scrollDirection: Axis.horizontal,
                            children: fixedList.map((index) {
                              return
                                GestureDetector(
                                  onTap: ()  {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Places(link:india_link[index])));
                                  },
                                  child : Container(
                                    width: 200,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child:CachedNetworkImage(
                                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                      imageUrl: india[index],
                                      fit:BoxFit.fill,
                                    ),
                                    ),
                                  ),
                                );
                            }).toList(),
                          ),
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        SizedBox(
                          height: MediaQuery
                              .of(context)
                              .size
                              .height * 0.06,
                          width: MediaQuery
                              .of(context)
                              .size
                              .width * 1.00,
                          child: Text(' Explore the world ',
                            textAlign: TextAlign.left,
                            style: GoogleFonts.mcLaren(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: MediaQuery
                                  .of(context)
                                  .size
                                  .height * 0.029,
                            ),
                          ),
                        ),
                        Container(
                          height: 175,
                          child: ListView(
                            // This next line does the trick.
                            scrollDirection: Axis.horizontal,
                            children:fixedList_abroad.map((index) {
                              return
                                GestureDetector(
                                  onTap: ()  {
                                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Places(link:abroad_link[index])));
                                  },
                                  child : Container(
                                    width: 200,
                                    margin: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      color: Colors.cyanAccent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child:CachedNetworkImage(
                                        placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                        imageUrl: abroad[index],
                                        fit:BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                            }).toList(),
                          ),
                        ),

                      ],
                    ),
                  ]
                  ),
                  // bottomNavigationBar: BottomAppBar(
                  //   color: Colors.white12,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     children: [
                  //       Container(
                  //         child: Row(
                  //           children: [
                  //             Text('TourApp ',
                  //                 style: Theme
                  //                     .of(context)
                  //                     .textTheme
                  //                     .headline5
                  //                     .copyWith(color: Colors.white)),
                  //             Text(' - Your Virtual Guide',
                  //                 style: Theme
                  //                     .of(context)
                  //                     .textTheme
                  //                     .headline6
                  //                     .copyWith(color: Colors.white)),
                  //           ],
                  //         ),
                  //       )
                  //     ],
                  //   ),
                  // ),
                ),
              );
            }
            else{
              return Center(child: CircularProgressIndicator());
            }
          }
      );
}