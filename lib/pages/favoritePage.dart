import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/pages/detailPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:toast/toast.dart';

class FavPage extends StatefulWidget {
  final Box _contactsBox;
  FavPage(this._contactsBox);

  @override
  _FavPageState createState() => _FavPageState();
}

class _FavPageState extends State<FavPage> {
  List<contact> _favoriteResult = [];
  @override
  Widget build(BuildContext context) {
    print(widget._contactsBox.length);
    return Scaffold(
      body: Column(
        children: <Widget>[
          widget._contactsBox == null
              ? Text("Box is not initialized")
              : Expanded(
                  child: WatchBoxBuilder(
                    box: widget._contactsBox,
                    builder: (context, box) {
                      contact con;
                      Map<dynamic, dynamic> raw = box.toMap();
                      List list = raw.values.toList();
                      _favoriteResult.clear();
                      list.forEach((contactTemp) {
                        if (contactTemp.favorite == true) {
                          _favoriteResult.add(contactTemp);
                        }
                      });
                      return ListView.builder(
                        itemBuilder: (context, i) {
                          return Slidable(
                            key: ValueKey(i),
                            actionPane: SlidableDrawerActionPane(),
                            secondaryActions: <Widget>[
                              IconSlideAction(
                                caption: 'edit',
                                color: Colors.blue,
                                icon: Icons.edit,
                                onTap: () {
                                  con = contact(
                                      _favoriteResult[i].id,
                                      _favoriteResult[i].firstName,
                                      _favoriteResult[i].lastName,
                                      _favoriteResult[i].email,
                                      _favoriteResult[i].gender,
                                      _favoriteResult[i].dateofBrith,
                                      _favoriteResult[i].phoneNo,
                                      _favoriteResult[i].favorite,
                                      _favoriteResult[i].index);
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) {
                                    return DetailPage(widget._contactsBox, con);
                                  }));
                                },
                              ),
                              IconSlideAction(
                                caption: 'Delete',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () {
                                  deleteContact(_favoriteResult[i].id,
                                      _favoriteResult[i].index);
                                  String message = list[i].firstName +
                                      " " +
                                      list[i].lastName +
                                      " " +
                                      'is deleted';
                                  Toast.show(message, context);
                                  _favoriteResult.removeAt(i);
                                  setState(() {});
                                },
                              ),
                            ],
                            dismissal: SlidableDismissal(
                              child: SlidableDrawerDismissal(),
                              onDismissed: (SlideActionType) {
                                String message = _favoriteResult[i].firstName +
                                    " " +
                                    _favoriteResult[i].lastName +
                                    " " +
                                    'is deleted';
                                Toast.show(message, context);
                              },
                            ),
                            child: ListTile(
                              title: Text(_favoriteResult[i].firstName +
                                  " " +
                                  _favoriteResult[i].lastName),
                              subtitle: Text(_favoriteResult[i].email),
                              leading: CircleAvatar(
                                radius: 25.0,
                                backgroundImage: AssetImage('images/ceo.png'),
                              ),
                              trailing: IconButton(
                                  icon: (_favoriteResult[i].favorite == true)
                                      ? Icon(Icons.favorite)
                                      : Icon(Icons.favorite_border),
                                  color: Colors.red,
                                  onPressed: () {
                                    setState(() {
                                      if (_favoriteResult[i].favorite == false) {
                                        con = contact(
                                            _favoriteResult[i].id,
                                            _favoriteResult[i].firstName,
                                            _favoriteResult[i].lastName,
                                            _favoriteResult[i].email,
                                            _favoriteResult[i].gender,
                                            _favoriteResult[i].dateofBrith,
                                            _favoriteResult[i].phoneNo,
                                            true,
                                            _favoriteResult[i].index);
                                      } else {
                                        con = contact(
                                            _favoriteResult[i].id,
                                            _favoriteResult[i].firstName,
                                            _favoriteResult[i].lastName,
                                            _favoriteResult[i].email,
                                            _favoriteResult[i].gender,
                                            _favoriteResult[i].dateofBrith,
                                            _favoriteResult[i].phoneNo,
                                            false,
                                            _favoriteResult[i].index);
                                      }
                                      print(_favoriteResult[i].index);
                                      widget._contactsBox
                                          .put(_favoriteResult[i].index, con);
                                    });
                                  }),
                            ),
                          );
                        },
                        itemCount: _favoriteResult.length,
                      );
                    },
                  ),
                )
        ],
      ),
    );
  }

  Future<Response> deleteContact(String id, int index) async {
    final http.Response response = await http.delete(
      'https://mock-rest-api-server.herokuapp.com/api/v1/user/$id',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    widget._contactsBox.deleteAt(index);
    setState(() {});
    print(response.body);
    return response;
  }
}
