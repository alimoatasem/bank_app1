class Users{
  String username;
  String email;
  int balance;

  Users({this.username, this.email, this.balance});

  Map<String,dynamic> toMap() { // used when inserting data to the database
    var map = <String,dynamic> {
      "username" : username,
      "email" : email,
      "balance" : balance
    };
    return map;
  }

  Users.fromMap(Map<String, dynamic> map) {
    username = map['username'];
    email = map['email'];
    balance = map['balance'];
  }
}