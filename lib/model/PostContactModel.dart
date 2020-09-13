class PostModelContact {
  final String id;
  final String last_name;
  final String first_name;
  final String email;
  final String gender;
  final String date_of_birth;
  final String phone_no;

  PostModelContact(
      {this.id,
      this.last_name,
      this.first_name,
      this.email,
      this.gender,
      this.date_of_birth,
      this.phone_no});

  factory PostModelContact.fromJson(Map<String, dynamic> json) {
    return PostModelContact(
      id: json['id'],
      last_name: json['last_name'],
      first_name: json['first_name'],
      email: json['email'],
      gender: json['gender'],
      date_of_birth: json['date_of_birth'],
      phone_no: json['phone_no'],
    );
  }

  Map toMap() {
    var map = new Map<String, String>();
    map["id"] = this.id;
    map["last_name"] = last_name;
    map["first_name"] = first_name;
    map["email"] = email;
    map["gender"] = gender;
    map["date_of_birth"] = date_of_birth;
    map["phone_no"] = phone_no;

    return map;
  }
}
