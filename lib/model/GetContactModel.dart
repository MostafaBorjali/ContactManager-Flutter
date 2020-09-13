class ContactModel {
  List<Data> data;
  int page;
  int row;
  int totalRow;

  ContactModel({this.data, this.page, this.row, this.totalRow});

  ContactModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
    page = json['page'];
    row = json['row'];
    totalRow = json['total_row'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    data['page'] = this.page;
    data['row'] = this.row;
    data['total_row'] = this.totalRow;
    return data;
  }
}

class Data {
  String id;
  String firstName;
  String lastName;
  String email;
  String gender;
  String dateOfBirth;
  String phoneNo;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.dateOfBirth,
      this.phoneNo});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    email = json['email'];
    gender = json['gender'];
    dateOfBirth = json['date_of_birth'];
    phoneNo = json['phone_no'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['email'] = this.email;
    data['gender'] = this.gender;
    data['date_of_birth'] = this.dateOfBirth;
    data['phone_no'] = this.phoneNo;
    return data;
  }
}