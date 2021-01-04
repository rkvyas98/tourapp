import 'package:flutter/material.dart';
import 'places.dart';

class Search extends SearchDelegate {

  @override
  ThemeData appBarTheme(BuildContext context) {

    final ThemeData theme = ThemeData(

     primaryColor:Colors.black87,
      primaryIconTheme: IconThemeData(color: Colors.white),
      primaryColorBrightness: Brightness.light,
      textTheme: TextTheme(headline6: TextStyle(color:Colors.white)),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color:Colors.white)
      ),
      cursorColor: Colors.white,
      backgroundColor: Colors.black54
    );
    return theme;
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () {
          query = "";
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }

  String selectedResult = "";

  @override
  Widget buildResults(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(selectedResult),
      ),
    );
  }

  final List<String> listExample;
  final List<String> nameList;
  Search(this.listExample,this.nameList);

  List<String> recentList = [];

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestionList = [];
    query.isEmpty
        ? suggestionList = recentList //In the true case
        : suggestionList.addAll(listExample.where(
      // In the false case
          (element) => element.contains(query.toUpperCase()),
    ));

    return suggestionList.isEmpty? Container(
        height:150,
        child:Center(child:Text('No result found'))) : ListView.builder(
      itemCount: suggestionList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(
            suggestionList[index],
            style:TextStyle(color: Colors.black) ,
          ),
          leading: query.isEmpty ? Icon(Icons.access_time) : SizedBox(),
          onTap: (){
            selectedResult = suggestionList[index];
            if (recentList.indexOf(selectedResult) == -1)
              recentList.add(selectedResult);
            Navigator.of(context).push(MaterialPageRoute(builder: (context) => Places(link:nameList[listExample.indexOf(selectedResult)])));

          },
        );
      },
    );
  }
}

