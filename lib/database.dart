
import 'package:bank_app/Users.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:io' as io;



class DBProvider{
  DBProvider._();
  static final DBProvider db = DBProvider._();
  static Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    //example database
    final List users = [Users(username:"Jhon Wick",email:"jhon@gmail.com",balance: 5000),
      Users(username:"Sam Wain",email:"swain@gmail.com",balance: 10000),
      Users(username:"Jack Ryan",email:"jkryan@gmail.com",balance: 9000),
      Users(username:"Humo Puros",email:"humo@gmail.com",balance: 5000),
      Users(username:"Jonathan Pam",email:"jpam@gmail.com",balance: 3000),
      Users(username:"Richard Jackson",email:"rjackson@gmail.com",balance: 7000),
      Users(username:"Bruce Wein",email:"brucewein@gmail.com",balance: 6000),
      Users(username:"Lamar Wildfred",email:"lamar@gmail.com",balance: 12000),
      Users(username:"John Rambo",email:"jrambo@gmail.com",balance: 18000),
      Users(username:"Miles Morales",email:"miles@gmail.com",balance: 25000)];

    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();

    return await openDatabase(join(documentsDirectory.path, 'banking.db'),
        onCreate: (Database db,int version) async {
          await db.execute('''CREATE TABLE users(username TEXT PRIMARY KEY, 
      email TEXT, balance INTEGER)''');
          print(join(await getDatabasesPath(), 'banking.db'));
          for(int index=0; index<users.length; index++){
            newUser(users[index]);
          }
        },
        version: 1
    );

  }

  Future newUser(Users newUser) async{
    final db =await database;
    var res = await db.rawInsert('''INSERT INTO users(username, email, balance)
    VALUES(?,?,?)''', [newUser.username, newUser.email, newUser.balance]);
    return res;
  }

  Future<List<Users>> getAllUsers() async{
    final db = await database;
    List<Map> res = await db.query('users', columns: ['username', 'email', 'balance']);
    List<Users> userlist = new List();
    res.forEach((element) {
      Users user = Users.fromMap(element);
      userlist.add(user);
    });
    return userlist;
  }


  Future<int> updateBalance(int balance, username) async{
    final db =await database;
    int res = await db.rawUpdate('UPDATE users SET balance = $balance WHERE username = "$username"');
    print("updated balance on $res");
    return res;
  }


  Future<List<Map<String, dynamic>>> getUser(String username) async {
  final db = await database;
  var res = await db.rawQuery('SELECT * FROM "users" WHERE username = "$username"');
  return res;
}
}
