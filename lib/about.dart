import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
class AboutScreen extends StatefulWidget {
   static const String id='about';
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      appBar: AppBar(
        title: Text('About'),
        backgroundColor: Colors.black
    ),
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          color:Colors.black87,
          child: ListView(
            children: [

              Container(

              child: Center(
                child: Text('About us',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.042,
                  ),
                ),
              ),
            ),
              Container(
                height: 6.0,
                color: Colors.black,

              ),
              Container(

                child: Text(' Developers',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.026,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Container(
                        width:MediaQuery
                              .of(context)
                              .size
                              .width * 0.30,
                        height:MediaQuery
                            .of(context)
                            .size
                            .height * 0.20,
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child:Image.asset('assets/rakshit.jpeg',fit: BoxFit.fill,),
                        ),
                      ),
                        Text('Rakshit Vyas',
                          style: TextStyle( fontSize: 17,color: Colors.white),
                        ),
                    ]
                  ),
                  Column(
                      children: [
                        Container(
                          width:MediaQuery
                              .of(context)
                              .size
                              .width * 0.30,
                          height:MediaQuery
                              .of(context)
                              .size
                              .height * 0.20,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child:Image.asset('assets/rishabh.jpeg',fit: BoxFit.fill,),
                          ),
                        ),
                        Text('Rishabh Rai',
                          style: TextStyle( fontSize: 17,color: Colors.white),
                        ),
                      ]
                  ),
                  Column(
                      children: [
                        Container(
                          width:MediaQuery
                              .of(context)
                              .size
                              .width * 0.30,
                          height:MediaQuery
                              .of(context)
                              .size
                              .height * 0.20,
                          margin: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.cyanAccent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child:Image.asset('assets/rishit.jpeg',fit: BoxFit.fill,),
                          ),
                        ),
                        Text('Rishit Kumar',
                          style: TextStyle( fontSize: 17,color: Colors.white),
                        ),
                      ]
                  ),
                ],
              ),
              Container(
                height: 4.0,
              ),

              Container(
                height: 6.0,
                color: Colors.black,
              ),
              Container(
                child: Text(' About Application',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.026,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width* 0.96,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(10),
                child: Text("TourApp will make the user to have a virtual tour of different tourist destination in the world via mobile application . It will be composed of a sequence of videos or still images. It will also use other multimedia elements such as sound effects, music, narration, and text." +

                    "\n\nUsing this application user can have virtual tour :\n" +

                    "\n◾ With the help of images of that place." +
                    "\n◾ 360 View of that place." +
                    "\n◾ Videos related to the place." +
                    "\n◾ Amazing facts related to that destination in written as well as audio format." +
                    "\n◾ Application will you to navigate the place via default Map application in your device." +
                    "\n◾ Public comments section will be there for the user to share anything regarding the place.",
                  style: TextStyle( fontSize: 17,color: Colors.white),
                ),
              ),
              Container(
                child: Text(' Contact us',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.mcLaren(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: MediaQuery
                        .of(context)
                        .size
                        .height * 0.026,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(5),
                width: MediaQuery.of(context).size.width* 0.96,
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.all(10),
                child: Text('◾ rkvyas98@gmail.com\n' +
                    '◾ smartrishu331@gmail.com\n' +
                    '◾ rishitsinha001@gmail.com' ,
                  style: TextStyle( fontSize: 17,color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
     )
    );
  }
}
