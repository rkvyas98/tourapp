import 'package:flutter/material.dart';
import 'decorate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'login.dart';


class RegisterScreen extends StatefulWidget {
  static const String id ='register';

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final messageTextController1 = TextEditingController();
  final messageTextController2 = TextEditingController();
  final messageTextController3= TextEditingController();
  bool showSpinner = false;

  final _auth = FirebaseAuth.instance;
  String name=' ';
  String email;
  String password;
  String errormess;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          ShaderMask(
            shaderCallback: (rect) => LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.center,
              colors: [Colors.black, Colors.transparent],
            ).createShader(rect),
            blendMode: BlendMode.darken,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/420.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black54, BlendMode.darken),
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            body: ModalProgressHUD(
              inAsyncCall: showSpinner,
              child: Column(
                children: [
                  Flexible(
                    child: Center(
                      child: Text(
                        'TourApp',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 60,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width:MediaQuery.of(context). size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: TextField(
                              onChanged: (value) {
                                name = value;
                              },
                              controller: messageTextController1,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    Icons.person_outline,
                                    size: 28,
                                    color: kWhite,
                                  ),
                                ),
                                hintText: 'Name',
                                hintStyle: kBodyText,
                              ),
                              style: kBodyText,
                              keyboardType: TextInputType.name,
                              //textInputAction: inputAction,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width:MediaQuery.of(context). size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: TextField(
                              onChanged: (value) {
                                email = value;
                              },
                              controller: messageTextController2,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    Icons.email_outlined,
                                    size: 28,
                                    color: kWhite,
                                  ),
                                ),
                                hintText: 'Email',
                                hintStyle: kBodyText,
                              ),
                              style: kBodyText,
                              keyboardType: TextInputType.emailAddress,
                              //textInputAction: inputAction,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.08,
                          width:MediaQuery.of(context). size.width * 0.8,
                          decoration: BoxDecoration(
                            color: Colors.grey[500].withOpacity(0.5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Center(
                            child: TextField(
                              onChanged: (value) {
                                password = value;
                              },
                              controller: messageTextController3,
                              obscureText: true,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Icon(
                                    Icons.lock_rounded,
                                    size: 28,
                                    color: kWhite,
                                  ),
                                ),
                                hintText: 'Password',
                                hintStyle: kBodyText,
                              ),
                              style: kBodyText,
                              //textInputAction: inputAction,
                            ),
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.08,
                        width:MediaQuery.of(context). size.width * 0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: kBlue,
                        ),
                        child: FlatButton(
                          onPressed: () async{
                            if(name.trim().isEmpty){
                              showDialog<void>(
                                context: context,
                                barrierDismissible: true, // user must tap button!
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Mandatory'),
                                    content: SingleChildScrollView(
                                      child: ListBody(
                                        children: <Widget>[
                                          Text('Name is required'),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                            else {
                              setState(() {
                                showSpinner = true;
                              });
                              messageTextController1.clear();
                              messageTextController2.clear();
                              messageTextController3.clear();
                              try {
                                final user = await _auth
                                    .createUserWithEmailAndPassword(
                                    email: email, password: password);
                                await _auth.currentUser.updateProfile(
                                  displayName: name,
                                );
                                setState(() {
                                  name=' ';
                                  email='';
                                  password='';
                                });

                                if (user != null) {
                                  print('jaiho');
                                  print(_auth.currentUser);
                                  try {
                                    await _auth.currentUser
                                        .sendEmailVerification();
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: true, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Success'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text('Verification link sent'),
                                                Text('\nVerify and login'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                  catch(e){
                                    setState(() {
                                      showSpinner = false;
                                    });
                                    showDialog<void>(
                                      context: context,
                                      barrierDismissible: true, // user must tap button!
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: Text('Oops'),
                                          content: SingleChildScrollView(
                                            child: ListBody(
                                              children: <Widget>[
                                                Text('Couldn\'t send verification link'),
                                                Text('\nTry login'),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                }
                              }
                              catch (e) {
                                setState(() {
                                  name=' ';
                                  email='';
                                  password='';
                                  showSpinner = false;
                                });
                                String errorMessage;
                                print(e.toString());
                                if(e.toString().contains('email != null') || e.toString().contains('password != null') ||
                                e.toString().contains('Given String is empty or null')){
                                  errorMessage='Fill all the fields.';
                                }
                                else if(e.toString().contains('The email address is badly formatted')){
                                  errorMessage='The email address is badly formatted';
                                }
                                else if(e.toString().contains('email-already-in-use')){
                                  errorMessage='Email is already registered';
                                }
                                else{
                                  errorMessage='Something went wrong';
                                }
                                setState(() {
                                  errormess=errorMessage;
                                });

                                showDialog<void>(
                                  context: context,
                                  barrierDismissible: true,
                                  // user must tap button!
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text('Oops !!!'),
                                      content: SingleChildScrollView(
                                        child: ListBody(
                                          children: <Widget>[
                                            Text(errormess),
                                            Text(
                                                'Please try again'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Okay'),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          },

                          child: Text(
                            'SignUp',
                            style: kBodyText.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context,LoginScreen.id,(Route<dynamic> route) => false),
                    child: Container(
                      child: Text(
                        'Already a User? Signin ',
                        style: kBodyText,
                      ),
                      decoration: BoxDecoration(
                          border:
                          Border(bottom: BorderSide(width: 1, color: kWhite))),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          )
        ],
      );
  }
}


