
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
part 'contact.g.dart';

@HiveType(typeId: 1)
class contact extends HiveObject{
  @HiveField(0)
  String id;
  @HiveField(1)
  String firstName;
    @HiveField(2)
  String lastName;
    @HiveField(3)
  String email;
    @HiveField(4)
  String gender;
    @HiveField(5)
  String dateofBrith;
    @HiveField(6)
  String phoneNo;
  @HiveField(7)
  bool favorite = false;
   @HiveField(8)
  int index = -1;
  contact(this.id, this.firstName, this.lastName,this.email,this.gender,this.dateofBrith,this.phoneNo,this.favorite,this.index);

    
  
}