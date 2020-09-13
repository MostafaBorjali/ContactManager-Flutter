import 'package:flutter/material.dart';
import 'package:flutterapp/model/GetContactModel.dart';
import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/pages/addContact.dart';
import 'package:hive/hive.dart';

class DetailPage extends StatefulWidget {
  final Box _contactBox;
  contact contactTemp;
  DetailPage(this._contactBox, this.contactTemp);

  @override
  _DetailPage createState() => _DetailPage();
}

class _DetailPage extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Contact"),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('images/ceo.png'),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.contactTemp.firstName +
                    " " +
                    widget.contactTemp.lastName,
                style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 23,
                ),
              ),
            ),
            Text(
              widget.contactTemp.gender,
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'SourceSansPro',
                color: Colors.red[400],
                letterSpacing: 2.5,
              ),
            ),
             Text(
             " ",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'SourceSansPro',
                color: Colors.red[400],
                letterSpacing: 2.5,
              ),
            ),
            SizedBox(
              height: 20.0,
              width: 200,
              child: Divider(
                color: Colors.teal[100],
              ),
            ),
            
            Card(
                color: Colors.white,
                margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                child: ListTile(
                  leading: Icon(
                    Icons.phone,
                    color: Colors.teal[900],
                  ),
                  title: Text(
                    widget.contactTemp.phoneNo,
                    style: TextStyle(fontFamily: 'BalooBhai', fontSize: 20.0),
                  ),
                )),
            Card(
              color: Colors.white,
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                leading: Icon(
                  Icons.email,
                  color: Colors.teal[900],
                ),
                title: Text(
                  widget.contactTemp.email,
                  style: TextStyle(fontSize: 16.0, fontFamily: 'Neucha'),
                ),
              ),
            ),
            Card(
              color: Colors.teal[300],
              margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
              child: ListTile(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                     return ADDContact(widget._contactBox,false,widget.contactTemp);
                    
                  }));
                },
                title: Center(
                  child: Text(
                    'EDIT',
                    style: TextStyle(fontSize: 20.0, fontFamily: 'SourceSansPro'),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
