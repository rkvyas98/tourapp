import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:video_player_360/video_player_360.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'photo.dart';


final List<String> imgList = [
  'assets/60-601374_home-taj-mahal-wallpapers-hd-backgrounds-images.jpg',
  'assets/320-3204035_taj-mahal-india-at-night.jpg',
  'assets/796ca0e248e0946720742ecc5e35aeda.jpg',
  'assets/420.jpg',
  'assets/69d9c6641c111fb2b46eaf3cba945792.jpg'
];


final _firestore = FirebaseFirestore.instance;
User loggedInUser;

// class ScreenArguments {
//   final String link;
//   ScreenArguments(this.link);
// }

class Places extends StatefulWidget {
  static const String id = 'places';
  final String link;
  Places({Key key,this.link}): super(key: key);
  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  String messageText='';
  String errorMess,errorMessage;

  int _current=0;
  var  _place_name='';
  var _place_video='';
  var _comment_link='';
  GeoPoint _loc;
  List<String> img = List<String>();
  List<String> content = List<String>();

  List<int> fixedList = List<int>();

  //final _firestore = FirebaseFirestore.instance;
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  Future<bool> _update;
  //User loggedInUser;

  @override
  void initState() {
    getCurrentUser();
    _update=fetch_data();
    super.initState();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print (loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> fetch_data()async {
    final fetch = await _firestore.collection("Places").doc(widget.link).get();
    content=List.from(fetch.data()['content']);
    List<String> fetch_img = List<String>();
    fetch_img.add(fetch.data()['img1']);
    fetch_img.add(fetch.data()['img2']);
    fetch_img.add(fetch.data()['img3']);
    fetch_img.add(fetch.data()['img4']);
    fetch_img.add(fetch.data()['img5']);
    setState(() {
      img = fetch_img;
      _place_name = fetch.data()['name'];
      _place_video = fetch.data()['video'];
      _comment_link=fetch.data()['comment_link'];
      _loc=fetch.data()['_location'];
      fixedList = Iterable<int>.generate(content.length).toList();
    });
    return true;
  }

  @override
  Widget build(BuildContext context)=>

      FutureBuilder(
      future: _update,
      builder: (context, snapshot) {
      if (snapshot.hasData) {

      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
          title: Text(_place_name),
          backgroundColor: Colors.black87
          ),
           backgroundColor: Colors.black87,
           body:SlidingUpPanel(
            minHeight:40,

             color: Colors.black87,
             borderRadius : BorderRadius.only(topRight: Radius.circular(20),topLeft: Radius.circular(20)),
             panel: Column(
               mainAxisAlignment: MainAxisAlignment.spaceBetween,
               crossAxisAlignment: CrossAxisAlignment.stretch,
               children: <Widget>[

                 Container(
                   margin: EdgeInsets.symmetric(vertical: 10.0),
                   child: Text(' Comment here... ',
                     textAlign: TextAlign.center,
                     style: TextStyle(
                       color: Colors.white,
                       fontWeight: FontWeight.w700,
                       fontSize: MediaQuery
                           .of(context)
                           .size
                           .height * 0.025,
                     ),
                   ),
                 ),

                 Container(
                   //decoration: kMessageContainerDecoration,
                   child: Row(
                     crossAxisAlignment: CrossAxisAlignment.center,
                     children: <Widget>[

                       Expanded(
                         child: Container(
                           height: 45.0,
                           margin: EdgeInsets.only(left: 5.0),
                           decoration: BoxDecoration(
                             color: Colors.white,
                             borderRadius: BorderRadius.circular(8),
                           ),
                          padding: EdgeInsets.symmetric(horizontal:4.0),
                           child: TextField(
                             keyboardType: TextInputType.multiline,
                             maxLines: 5,
                             decoration: InputDecoration(
                               hintText: 'Add your comment',
                             ),
                             controller: messageTextController,
                             onChanged: (value) {
                               messageText = value;
                             },
                            // decoration: kMessageTextFieldDecoration,
                           ),
                         ),
                       ),
                       FlatButton(

                         onPressed: () {
                           try {
                             assert(
                              messageText.trim() != '' ,
                             'empty comment',
                             );
                             messageTextController.clear();
                             _firestore.collection(_comment_link).add({
                               'text': messageText,
                               'sender': loggedInUser.displayName,
                               'time': Timestamp.now()
                             });
                             setState(() {
                               messageText='';
                             });
                           }catch(e){
                             if(e.toString().contains('empty comment'))
                               errorMessage='Added comment is empty';
                             else
                               errorMessage='Something went wrong';
                             setState(() {
                               errorMess=errorMessage;
                             });
                             showDialog<void>(
                               context: context,
                               barrierDismissible: true,
                               // user must tap button!
                               builder: (BuildContext context) {
                                 return AlertDialog(
                                   title: Text('Oops'),
                                   content: SingleChildScrollView(
                                     child: ListBody(
                                       children: <Widget>[
                                         Text(
                                             errorMess),
                                       ],
                                     ),
                                   ),
                                 );
                               },
                             );
                           }
                         },
                         child: Icon(Icons.send, color: Colors.blueGrey, size: 35),
                       ),
                     ],
                   ),
                 ),
                 MessagesStream(comment: _comment_link),
               ],
             ),
             body: _body(),
           ),
        // floatingActionButton: Draggable(
        //   feedback: Container(
        //   child : FloatingActionButton(heroTag:'float2',child: Icon(Icons.add), onPressed: () {})
        //   ),
        //   child: Container(
        //   child : FloatingActionButton(heroTag:'float2',child: Icon(Icons.add), onPressed: () {}),
        //   ),
        //   ),

        //   ),
         ),
      );

      }
      else{
        return Center(child: CircularProgressIndicator());
        }
       }
       );


  Widget _body(){
    return ListView(
      padding: const EdgeInsets.all(4),
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: Colors.white10,
            border: Border.all(
              color: Colors.black87,
              width: 6,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          //color: Colors.blueGrey,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                    height: 10.0
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 475.0,
                    initialPage: 0,
                    autoPlay: true,
                    reverse: false,
                    autoPlayInterval: Duration(seconds: 2),
                    autoPlayAnimationDuration: Duration(milliseconds: 200),
                    pauseAutoPlayOnTouch: true,
                    enlargeCenterPage: true,
                    onPageChanged: (index,reason){
                      setState(() {
                        _current=index;
                      });
                    },

                  ),
                  items: img.map((imgUrl) {
                    return
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SimplePhotoView(imag:imgUrl,img_tit: _place_name)));
                        },
                        child : Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.symmetric(horizontal: 0.5),
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CachedNetworkImage(
                            placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                            imageUrl: imgUrl,
                            fit:BoxFit.fill,
                          ),
                        ),
                      );
                  }).toList(),
                ),
                // SizedBox(
                //     height:15.0
                // ),
              ]
          ),
        ),
        // Container(
        //  child: Column(
        //    children:img.map((imgUrl) {
        //      return
        //        GestureDetector(
        //          onTap: () async {
        //            await VideoPlayer360.playVideoURL(
        //                "https://github.com/rkvyas98/sampleVideo/blob/main/videoplayback.mp4?raw=true");
        //          },
        //          child : Container(
        //            width: MediaQuery.of(context).size.width,
        //            margin: EdgeInsets.symmetric(horizontal: 0.5),
        //            decoration: BoxDecoration(
        //              color: Colors.cyanAccent,
        //              border: Border.all(
        //                color: Colors.white,
        //                width: 5,
        //              ),
        //              borderRadius: BorderRadius.circular(12),
        //            ),
        //            child: CachedNetworkImage(
        //              placeholder: (context, url) => Center(child: CircularProgressIndicator()),
        //              imageUrl: imgUrl,
        //              fit:BoxFit.fill,
        //            ),
        //          ),
        //        );
        //    }).toList(),
        //  ),
        // ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: 10.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Text(' Amazing Facts ',
                textAlign: TextAlign.left,
                style: GoogleFonts.mcLaren(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: MediaQuery
                    .of(context)
                    .size
                    .height * 0.030,
                ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 50.0),
                child: FloatingActionButton(
                  heroTag: 'new3',
                  onPressed:  () => MapsLauncher.launchCoordinates(_loc.latitude,_loc.longitude,_place_name),
                  backgroundColor: Colors.white,
                  tooltip: 'Watch Video',
                  child: Icon(Icons.location_pin,color: Colors.black,size: 33,),
                ),
              ),
              Container(
                margin: EdgeInsets.only(right: 8.0),
                child: FloatingActionButton(
                  heroTag: 'new4',
                    onPressed:  () async {
                 await VideoPlayer360.playVideoURL(_place_video,showPlaceholder: true);
             },
                  backgroundColor: Colors.white,
                  tooltip: 'Watch Video',
                  child: Icon(Icons.play_arrow,color: Colors.black,size: 45,),
                ),
              )

            ],
          ),
        ),
        Container(
          color: Colors.white10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: fixedList.map((index){
               if(index % 3 == 0){
                return  Container(

                  child: Text(content[index],
                    textAlign: TextAlign.left,
                    style: GoogleFonts.mcLaren(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: MediaQuery
                          .of(context)
                          .size
                          .height * 0.027,
                    ),
                  ),
                );
              }
              else if(index % 3 == 1){
                return  Container(
                  width: MediaQuery.of(context).size.width*0.98,
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.cyanAccent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child:CachedNetworkImage(
                      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                      imageUrl: content[index],
                      fit:BoxFit.fill,
                    ),
                  ),
                );
              }
              else {
                return  Column(
                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: MediaQuery.of(context).size.width* 0.96,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      padding: EdgeInsets.only(
                        bottom: 8.0,
                        left: MediaQuery.of(context).size.width* 0.004,
                        right: MediaQuery.of(context).size.width* 0.004,
                      ),
                      child: Text(content[index],
                        style: TextStyle( fontSize: 17,color: Colors.white),
                      ),
                    ),

                    Container(
                      height: 10.0,
                      color: Colors.black,

                    )
                  ],
                );
            }
            }).toList(),
          ),
        ),

        Container(
          height: 143.0,
          decoration: BoxDecoration(
            color: Colors.white10,
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ],
    );
  }

  }
class MessagesStream extends StatefulWidget {
  final String comment;
  MessagesStream({Key key,this.comment}): super(key: key);
  @override
  _MessagesStreamState createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection(widget.comment).orderBy('time').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final Timestamp times = message.data()['time'];

          final currentUser = loggedInUser.displayName;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            time:times,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

// class MessagesStream extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//
//   }
// }

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe, this.time});

  final String sender;
  final String text;
  final bool isMe;
  final Timestamp time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: [
              Text(
                sender,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.white,
                ),
              ),
              Text(' • ',style: TextStyle(
                fontSize: 12.0,
                color: Colors.white,
              ),),
              Text(
                time.toDate().toString().substring(0,19),
                style: TextStyle(
                  fontSize: 12.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: isMe ? Colors.blueGrey : Colors.white70,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 9.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black,
                  fontSize: 19.0,
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}

