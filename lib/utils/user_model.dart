class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? name;

  UserModel({this.uid, this.email, this.firstName, this.name});

  // receiving data from server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      email: map['email'],
      firstName: map['firstName'],
      name: map['Name'],
    );
  }

  // sending data to our server
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'secondName': name,
    };
  }
}