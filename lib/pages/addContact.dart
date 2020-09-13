import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutterapp/model/GetContactModel.dart';
import 'package:flutterapp/model/PostContactModel.dart';
import 'package:flutterapp/model/contact.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toast/toast.dart';
import 'package:http/http.dart' as http;

class ADDContact extends StatefulWidget {
  final Box _contactBox;
  contact contactTemp;
  bool add;
  ADDContact(this._contactBox, this.add, this.contactTemp);
  @override
  _ADDContact createState() => _ADDContact();
}

class _ADDContact extends State<ADDContact> {
  File imageURI;
  contact newContact;
  static final CREATE_POST_URL =
      'https://mock-rest-api-server.herokuapp.com/api/v1/user';
  var txtFirstName = TextEditingController();
  var txtLastName = TextEditingController();
  var txtEmail = TextEditingController();
  var txtPhone = TextEditingController();
  String firstName = '';
  String lastName = '';
  String email = '';
  String phone = '';
  String id = '';

  @override
  void initState() {
    super.initState();
    if (!widget.add) {
      txtPhone.text = widget.contactTemp.phoneNo;
      txtFirstName.text = widget.contactTemp.firstName;
      txtLastName.text = widget.contactTemp.lastName;
      txtEmail.text = widget.contactTemp.email;
      id = widget.contactTemp.id;
    }
  }

  Future getImageFromGallery() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      imageURI = image;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: 32.0),
              imageURI == null
                  ? GestureDetector(
                      onTap: () {
                        getImageFromGallery();
                      },
                      child: CircleAvatar(
                        radius: 70.0,
                        backgroundImage: ExactAssetImage('images/ceo.png'),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        getImageFromGallery();
                      },
                      child: CircleAvatar(
                        radius: 70.0,
                        backgroundImage: FileImage(imageURI),
                      ),
                    ),
              SizedBox(
                height: 60.0,
                width: 300,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                      labelText: 'enter first name',
                    ),
                    onChanged: (Text) {
                      setState(() {
                        firstName = Text;
                      });
                    },
                    controller: txtFirstName,
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
                width: 300,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.title),
                      border: OutlineInputBorder(),
                      labelText: 'enter LastName ',
                    ),
                    onChanged: (Text) {
                      setState(() {
                        lastName = Text;
                      });
                    },
                    controller: txtLastName,
                  ),
                ),
              ),
              SizedBox(
                height: 50.0,
                width: 300,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      border: OutlineInputBorder(),
                      labelText: 'enter email',
                    ),
                    onChanged: (Text) {
                      setState(() {
                        email = Text;
                      });
                    },
                    controller: txtEmail,
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
                width: 200,
                child: Divider(
                  color: Colors.teal[100],
                ),
              ),
              SizedBox(
                height: 50.0,
                width: 300,
                child: Card(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
                  color: Colors.white,
                  child: TextField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      border: OutlineInputBorder(),
                      labelText: 'enter phone number',
                    ),
                    onChanged: (Text) {
                      setState(() {
                        phone = Text;
                      });
                    },
                    controller: txtPhone,
                  ),
                ),
              ),
              Card(
                color: Colors.teal[300],
                margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 28.0),
                child: ListTile(
                  onTap: () async {
                    if (txtFirstName.text.isEmpty &&
                        txtEmail.text.isEmpty & txtPhone.text.isEmpty) {
                      Toast.show("please complete all required fields", context,
                          duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
                    } else {
                      if (widget.add) {
                        PostModelContact newPostModel = new PostModelContact(
                            id: new Random().nextInt(5000).toString(),
                            last_name: txtLastName.text,
                            first_name: txtFirstName.text,
                            gender: "male",
                            email: txtEmail.text,
                            date_of_birth: "1563665",
                            phone_no: txtPhone.text);

                        PostModelContact addcontact = await createRequst(
                            CREATE_POST_URL,
                            model: jsonEncode(newPostModel.toMap()));
                        Toast.show(" contact Added", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                        newContact = contact(
                            Random().nextInt(50000).toString(),
                            txtFirstName.text,
                            txtLastName.text,
                            txtEmail.text,
                            "male",
                            "13680330",
                            txtPhone.text,
                            false,
                            widget._contactBox.length);
                        widget._contactBox.add(newContact);
                        Navigator.pop(context);
                      } else {
                        PostModelContact editModel = new PostModelContact(
                            id: id,
                            last_name: txtLastName.text,
                            first_name: txtFirstName.text,
                            email: txtEmail.text,
                            gender: widget.contactTemp.gender,
                            date_of_birth: widget.contactTemp.dateofBrith,
                            phone_no: txtPhone.text);
                        PostModelContact editContact = await createRequst(
                            CREATE_POST_URL + '/' + id,
                            model: jsonEncode(editModel.toMap()));
                        Toast.show("edited contact ", context,
                            duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                        newContact = contact(
                            widget.contactTemp.id,
                            txtFirstName.text,
                            txtLastName.text,
                            txtEmail.text,
                            widget.contactTemp.gender,
                            widget.contactTemp.dateofBrith,
                            txtPhone.text,
                            widget.contactTemp.favorite,
                            widget.contactTemp.index);
                        widget._contactBox
                            .put(widget.contactTemp.index, newContact);
                        int count = 0;
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      }
                    }
                  },
                  title: Center(
                    child: (widget.add)
                        ? Text(
                            'Save Contact',
                            style: TextStyle(
                                fontSize: 25.0, fontFamily: 'SourceSansPro'),
                          )
                        : Text(
                            'Save Edited',
                            style: TextStyle(
                                fontSize: 25.0, fontFamily: 'SourceSansPro'),
                          ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<PostModelContact> createRequst(String url, {String model}) async {

try {
  final result = await InternetAddress.lookup('google.com');
  if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
    Map<String, String> headers = {"Content-type": "application/json"};
    return (widget.add)
        ? http
            .post(url, headers: headers, body: model)
            .then((http.Response response) {
            final int statusCode = response.statusCode;

            if (statusCode < 200 || statusCode > 400 || json == null) {
              Toast.show("Error while fetching data ", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            }
            print(response.body);
            return PostModelContact.fromJson(json.decode(response.body));
          })
        : http
            .put(url, headers: headers, body: model)
            .then((http.Response response) {
            final int statusCode = response.statusCode;

            if (statusCode < 200 || statusCode > 400 || json == null) {
              Toast.show("Error while fetching data ", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
            }
            print(response.body);
            return PostModelContact.fromJson(json.decode(response.body));
          });
  }
} on SocketException catch (_) {
  Toast.show("can not access internet on device ", context);
}

   
  }
}
