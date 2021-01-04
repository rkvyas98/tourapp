import 'package:flutter/material.dart';
import 'package:tour_app/register.dart';
import 'decorate.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'carousel.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id='login';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showSpinner = false;

  final messageTextController1 = TextEditingController();
  final messageTextController2 = TextEditingController();
  final messageTextController3 = TextEditingController();


  final _auth = FirebaseAuth.instance;
  String name;
  String email;
  String password;
  String pass_reset;
  String errorMess;

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
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[500].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: TextField(
                            onChanged: (value) {
                              email = value;
                            },
                            controller: messageTextController1,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
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
                        width: MediaQuery.of(context).size.width * 0.8,
                        decoration: BoxDecoration(
                          color: Colors.grey[500].withOpacity(0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: TextField(
                            onChanged: (value) {
                              password = value;
                            },
                            controller: messageTextController2,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
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
                    GestureDetector(
                      child: Text(
                        'Forgot Password',
                        style: kBodyText,
                      ),
                      onTap: () => {
                        showDialog<void>(
                          context: context,
                          barrierDismissible: true, // user must tap button!
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Password reset'),
                              content: SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 5.0),
                                      child: TextField(
                                        onChanged: (value) {
                                          pass_reset = value;
                                        },
                                        controller: messageTextController3,
                                        decoration: InputDecoration(
                                          hintText: 'Enter email',
                                        ),
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        //textInputAction: inputAction,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: Text('Send password-reset link'),
                                  onPressed: () async {
                                    messageTextController3.clear();

                                    setState(() {
                                      showSpinner=true;
                                    });
                                    try {
                                      await _auth.sendPasswordResetEmail(
                                          email: pass_reset);
                                      Navigator.of(context).pop();
                                      setState(() {
                                        pass_reset = '';
                                        showSpinner=false;
                                      });
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: true,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Success'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      'Password reset link sent to your email'),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } catch (e) {
                                      Navigator.of(context).pop();
                                      setState(() {
                                        showSpinner=false;
                                      });
                                      showDialog<void>(
                                        context: context,
                                        barrierDismissible: true,
                                        // user must tap button!
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: Text('Failed'),
                                            content: SingleChildScrollView(
                                              child: ListBody(
                                                children: <Widget>[
                                                  Text(
                                                      'Something went wrong. Try again'),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      },
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: kBlue,
                      ),
                      child: FlatButton(
                        onPressed: () async {
                          messageTextController1.clear();
                          messageTextController2.clear();
                          setState(() {
                            showSpinner = true;
                          });
                          try {
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {
                              if (_auth.currentUser.emailVerified) {
                                print(user);
                                setState(() {
                                  email = '';
                                  password = '';
                                });
                                Navigator.pushNamed(
                                    context, ImageSliderDemoo.id);
                              } else {

                                setState(() {
                                  showSpinner = false;
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
                                            Text('Please verify your email'),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: Text('Send verification link'),
                                          onPressed: () async {
                                            Navigator.of(context).pop();
                                            setState(() {
                                              showSpinner=true;
                                            });
                                            try {
                                              await _auth.currentUser
                                                  .sendEmailVerification();
                                              setState(() {
                                                showSpinner=false;
                                              });
                                              showDialog<void>(
                                                context: context,
                                                barrierDismissible: true,
                                                // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Success'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'Verification link sent'),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            } catch (e) {
                                              setState(() {
                                                showSpinner=false;
                                              });
                                              showDialog<void>(
                                                context: context,
                                                barrierDismissible: true,
                                                // user must tap button!
                                                builder:
                                                    (BuildContext context) {
                                                  return AlertDialog(
                                                    title: Text('Failed'),
                                                    content:
                                                        SingleChildScrollView(
                                                      child: ListBody(
                                                        children: <Widget>[
                                                          Text(
                                                              'Something went wrong. Try again'),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            }
                          } catch (e) {
                            setState(() {
                              showSpinner = false;
                            });
                            String errorMessage;
                            print(e.toString());
                            if (e.toString().contains('email != null') ||
                                e.toString().contains('password != null')) {
                              errorMessage = 'Fill all the fields.';
                            } else if (e.toString().contains(
                                'The email address is badly formatted')) {
                              errorMessage =
                                  'The email address is badly formatted';
                            } else if (e
                                    .toString()
                                    .contains('wrong-password') ||
                                e.toString().contains('user-not-found')) {
                              errorMessage = 'Invalid Email/Password';
                            } else {
                              errorMessage = 'Something went wrong';
                            }
                            // switch (e.toString().toUpperCase()) {
                            //   case "INVALID-EMAIL":
                            //     errorMessage = "Your email address appears to be malformed.";
                            //     break;
                            //   case "WRONG-PASSWORD":
                            //     errorMessage = "Your password is wrong.";
                            //     break;
                            //   case "USER-NOT-FOUND":
                            //     errorMessage = "User with this email doesn't exist.";
                            //     break;
                            //   case "USER-DISABLED":
                            //     errorMessage = "User with this email has been disabled.";
                            //     break;
                            //   case "TOO-MANY-REQUESTS":
                            //     errorMessage = "Too many requests. Try again later.";
                            //     break;
                            //   case "OPERATION-NOT-ALLOWED":
                            //     errorMessage = "Signing in with Email and Password is not enabled.";
                            //     break;
                            //   default:
                            //     errorMessage = "Something went wrong";
                            // }
                            setState(() {
                              errorMess = errorMessage;
                            });
                            showDialog<void>(
                              context: context,
                              barrierDismissible: true, // user must tap button!
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text('Oops !!!'),
                                  content: SingleChildScrollView(
                                    child: ListBody(
                                      children: <Widget>[
                                        Text(errorMess),
                                        Text('Please try again.'),
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
                        },
                        child: Text(
                          'Login',
                          style:
                              kBodyText.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, RegisterScreen.id),
                  child: Container(
                    child: Text(
                      'Create New Account',
                      style: kBodyText,
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(width: 1, color: kWhite))),
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