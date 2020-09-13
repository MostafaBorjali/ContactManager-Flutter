import 'package:flutter/material.dart';
import 'package:flutterapp/model/GetContactModel.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutterapp/model/contact.dart';
import 'package:flutterapp/pages/detailPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:toast/toast.dart';

class AllPage extends StatefulWidget {
  final Box _contactsBox;

  AllPage(this._contactsBox);

  @override
  _AllPageState createState() => _AllPageState();
}

class _AllPageState extends State<AllPage> {
  String textHolder;
  List<contact> _searchResult = [];
  TextEditingController controller = new TextEditingController();
  int _iconColor = -1;
  @override
  Widget build(BuildContext context) {
    contact con;
    return Scaffold(
        body: new Column(
      children: <Widget>[
        new Container(
          color: Theme.of(context).primaryColor,
          child: new Padding(
            padding: const EdgeInsets.all(8.0),
            child: new Card(
              child: new ListTile(
                leading: new Icon(Icons.search),
                title: new TextField(
                  controller: controller,
                  decoration: new InputDecoration(
                      hintText: 'Search', border: InputBorder.none),
                  onChanged: onSearchTextChanged,
                ),
                trailing: new IconButton(
                  icon: new Icon(Icons.cancel),
                  onPressed: () {
                    controller.clear();
                    onSearchTextChanged('');
                  },
                ),
              ),
            ),
          ),
        ),
        new Expanded(
          child: _searchResult.length != 0 || controller.text.isNotEmpty
              ? new ListView.builder(
                  itemBuilder: (context, i) {
                    return new Slidable(
                      key: ValueKey(i),
                      actionPane: SlidableDrawerActionPane(),
                      secondaryActions: <Widget>[
                        IconSlideAction(
                          caption: 'edit',
                          color: Colors.blue,
                          icon: Icons.edit,
                          onTap: () {
                            con = contact(
                                _searchResult[i].id,
                                _searchResult[i].firstName,
                                _searchResult[i].lastName,
                                _searchResult[i].email,
                                _searchResult[i].gender,
                                _searchResult[i].dateofBrith,
                                _searchResult[i].phoneNo,
                                _searchResult[i].favorite,
                                _searchResult[i].index);
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
                            deleteContact(
                                _searchResult[i].id, _searchResult[i].index);
                            String message = _searchResult[i].firstName +
                                " " +
                                _searchResult[i].lastName +
                                " " +
                                'is deleted';
                            Toast.show(message, context);
                            _searchResult.removeAt(i);
                            setState(() {});
                          },
                        ),
                      ],
                      dismissal: SlidableDismissal(
                        child: SlidableDrawerDismissal(),
                        onDismissed: (SlideActionType) {
                          // deleteContact(_searchResult[i].id, _searchResult[i].index);
                          String message = _searchResult[i].firstName +
                              " " +
                              _searchResult[i].lastName +
                              " " +
                              'is deleted';
                          Toast.show(message, context);
                        },
                      ),
                      child: new ListTile(
                        title: Text(_searchResult[i].firstName +
                            " " +
                            _searchResult[i].lastName),
                        subtitle: Text(_searchResult[i].email),
                        leading: CircleAvatar(
                          radius: 25.0,
                          backgroundImage: AssetImage('images/ceo.png'),
                        ),
                        trailing: IconButton(
                            icon: (_iconColor == i)
                                ? Icon(Icons.favorite)
                                : Icon(Icons.favorite_border),
                            color: Colors.red,
                            onPressed: () {
                              setState(() {
                                if (_searchResult[i].favorite == false) {
                                  con = contact(
                                      _searchResult[i].id,
                                      _searchResult[i].firstName,
                                      _searchResult[i].lastName,
                                      _searchResult[i].email,
                                      _searchResult[i].gender,
                                      _searchResult[i].dateofBrith,
                                      _searchResult[i].phoneNo,
                                      true,
                                      _searchResult[i].index);
                                } else {
                                  con = contact(
                                      _searchResult[i].id,
                                      _searchResult[i].firstName,
                                      _searchResult[i].lastName,
                                      _searchResult[i].email,
                                      _searchResult[i].gender,
                                      _searchResult[i].dateofBrith,
                                      _searchResult[i].phoneNo,
                                      false,
                                      _searchResult[i].index);
                                }
                                widget._contactsBox
                                    .put(_searchResult[i].index, con);
                                _iconColor = i;
                              });
                            }),
                      ),
                    );
                  },
                  itemCount: _searchResult.length,
                )
              : WatchBoxBuilder(
                  box: widget._contactsBox,
                  builder: (context, box) {
                    Map<dynamic, dynamic> raw = box.toMap();
                    List list = raw.values.toList();
                    return ListView.builder(
                      itemBuilder: (context, index) {
                        return Slidable(
                          key: ValueKey(index),
                          actionPane: SlidableDrawerActionPane(),
                          secondaryActions: <Widget>[
                            IconSlideAction(
                              caption: 'edit',
                              color: Colors.blue,
                              icon: Icons.edit,
                              onTap: () {
                                con = contact(
                                    list[index].id,
                                    list[index].firstName,
                                    list[index].lastName,
                                    list[index].email,
                                    list[index].gender,
                                    list[index].dateofBrith,
                                    list[index].phoneNo,
                                    list[index].favorite,
                                    list[index].index);
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
                                deleteContact(list[index].id, index);
                                String message = list[index].firstName +
                                    " " +
                                    list[index].lastName +
                                    " " +
                                    'is deleted';
                                Toast.show(message, context);
                                list.removeAt(index);
                                setState(() {});
                              },
                            ),
                          ],
                          dismissal: SlidableDismissal(
                            child: SlidableDrawerDismissal(),
                            onDismissed: (SlideActionType) {
                              // deleteContact(list[index].id, index);
                              String message = list[index].firstName +
                                  " " +
                                  list[index].lastName +
                                  " " +
                                  'is deleted';
                              Toast.show(message, context);
                            },
                          ),
                          child: ListTile(
                            title: Text(list[index].firstName +
                                " " +
                                list[index].lastName),
                            subtitle: Text(list[index].email),
                            leading: CircleAvatar(
                              radius: 25.0,
                              backgroundImage: AssetImage('images/ceo.png'),
                            ),
                            trailing: IconButton(
                                icon: (list[index].favorite == true)
                                    ? Icon(Icons.favorite)
                                    : Icon(Icons.favorite_border),
                                color: Colors.red,
                                onPressed: () {
                                  setState(() {
                                    if (list[index].favorite == false) {
                                      con = contact(
                                          list[index].id,
                                          list[index].firstName,
                                          list[index].lastName,
                                          list[index].email,
                                          list[index].gender,
                                          list[index].dateofBrith,
                                          list[index].phoneNo,
                                          true,
                                          list[index].index);
                                    } else {
                                      con = contact(
                                          list[index].id,
                                          list[index].firstName,
                                          list[index].lastName,
                                          list[index].email,
                                          list[index].gender,
                                          list[index].dateofBrith,
                                          list[index].phoneNo,
                                          false,
                                          list[index].index);
                                    }
                                    print(index);
                                    widget._contactsBox
                                        .put(list[index].index, con);
                                  });
                                }),
                          ),
                        );
                      },
                      itemCount: list.length,
                    );
                  },
                ),
        ),
      ],
    ));
  }

  onSearchTextChanged(String text) async {
    textHolder = text;
    _searchResult.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }
    Map<dynamic, dynamic> raw = widget._contactsBox.toMap();
    List list = raw.values.toList();
    list.forEach((contact) {
      if (contact.firstName.contains(text) || contact.lastName.contains(text))
        _searchResult.add(contact);
    });
    setState(() {});
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
