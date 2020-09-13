import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterapp/model/GetContactModel.dart';

class ContactItem extends StatelessWidget {
  final Data contactModel;

  ContactItem({this.contactModel});

  @override
  Widget build(BuildContext context) {
    Color _iconColor = Colors.redAccent;

    return Card(
      child: Column(
        children: <Widget>[
           
          ListTile(
            leading: CircleAvatar(
               radius: 25.0,
              backgroundImage:  AssetImage('images/ceo.png'),
            ),
            title: Text(contactModel.firstName + " "+ contactModel.lastName),
            subtitle: Text(contactModel.email),
            trailing: IconButton(icon: Icon(Icons.favorite_border),color: Colors.red, onPressed: (){
              print("object");
              
            })
          )
        ],
      ),
    );
  }
}