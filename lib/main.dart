import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/pages/addContact.dart';
import 'package:flutterapp/pages/allPage.dart';
import 'package:flutterapp/pages/favoritePage.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:flutterapp/model/GetContactModel.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  Box _contactsBox;
  Future<ContactModel> futureUser;
  String url = "https://mock-rest-api-server.herokuapp.com/api/v1/user";
  ContactModel obj;
  var loading = false;

  @override
  void initState() {
    super.initState();
    Hive.registerAdapter(ContactAdapter());
    _openBox();
  }

  Future _openBox() async {
    var dir = await getApplicationDocumentsDirectory();
    Hive.init(dir.path);
    _contactsBox = await Hive.openBox('contactBox');
    if (_contactsBox.length == 0) {
      futureUser = fetchUser();
    }
    setState(() {});
    return;
  }

  Widget setPage(int currentpage) {
    switch (currentpage) {
      case 0:
        return AllPage(_contactsBox);
      case 1:
        return FavPage(_contactsBox);
    }
  }

  Future<ContactModel> fetchUser() async {
    final response = await http.get(url);
    if (response.statusCode == 200) {
      obj = ContactModel.fromJson(json.decode(response.body));
      for (var i = 0; i < obj.data.length; i++) {
        _contactsBox.add(contact(
            obj.data[i].id,
            obj.data[i].firstName,
            obj.data[i].lastName,
            obj.data[i].email,
            obj.data[i].gender,
            obj.data[i].dateOfBirth,
            obj.data[i].phoneNo,
            false,
            i));
      }

      print(_contactsBox.length);
      setState(() {});

      return obj;
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Contact Manager"),
      ),
      body: (_contactsBox == null)
          ? Center(child: CircularProgressIndicator())
          : setPage(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (value) {
            _currentIndex = value;
            setState(() {});
          },
          items: [
            BottomNavigationBarItem(title: Text("all"), icon: Icon(Icons.home)),
            BottomNavigationBarItem(
                title: Text("favorite"), icon: Icon(Icons.favorite))
          ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return ADDContact(_contactsBox, true, null);
          }));
        },
        tooltip: 'add contact',
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    Hive.box("contactBox").compact();
    Hive.close();
    super.dispose();
  }
}
