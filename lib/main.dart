import 'package:flutter/material.dart';
import 'carousel.dart';
import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'places.dart';
import 'tf_test.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'about.dart';
import 'register.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TourApp',
      theme: ThemeData(
        primaryColor: Colors.black,
        primaryColorLight: Colors.grey,
        accentColor: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
        initialRoute:  (_auth.currentUser != null) ? ImageSliderDemoo.id : LoginScreen.id,
        routes: {
         Places.id:(context)=>Places(),
          RegisterScreen.id:(context)=>RegisterScreen(),
          AboutScreen.id:(context)=>AboutScreen(),
          ImageSearch.id: (context)=> ImageSearch(),
          ImageSliderDemoo.id: (context) => ImageSliderDemoo(),
          LoginScreen.id:(context)=>LoginScreen()
        },
      //MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
