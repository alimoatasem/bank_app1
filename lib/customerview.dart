import 'package:bank_app/Users.dart';
import 'package:bank_app/database.dart';
import 'package:bank_app/main.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CustomerView extends StatefulWidget {

  @override
  _CustomerViewState createState() => _CustomerViewState();
}

class _CustomerViewState extends State<CustomerView> {
  TextEditingController _controller;
  int _transfer;
  List<Users> newusers;
  var maxAmount;


  void initState(){
    super.initState();
    refreshList();
    _controller = TextEditingController();
  }

  refreshList() async{
    var res = await DBProvider.db.getAllUsers();
    setState(() {
      newusers = res;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List user = ModalRoute.of(context).settings.arguments;
    String username = user[0];
    int balance = user[1];

    return Material(
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [SizedBox(height: MediaQuery.of(context).padding.top+5,),
              Text("Enter amount: ", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                color: Colors.white,)),
              Row(
                  children: [Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(hintText: "Enter amount here", hintStyle: TextStyle(color: Colors.white,)),
                      onSubmitted: (value) async {
                        _transfer= int.parse(value);
                        print("MaxAmount is: $maxAmount");
                      },
                    ),

                  ),]
              ),
              SizedBox(height: 30,),
              Text("Transfer to account: ", style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                color: Colors.white,
              ),),
              Expanded(child: FutureBuilder(
                  future: DBProvider.db.getAllUsers(),
                  builder: (context,AsyncSnapshot<List<Users>> snapshot){
                    if(snapshot.hasData){
                      return ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            var project = snapshot.data[index];
                            // if (snapshot.data[index].username!= username){
                            return Card(
                              color: Colors.grey[900],
                              elevation: 0,
                              child: InkWell(
                                onTap:(){

                                  if(_transfer!=null){
                                    DBProvider.db.updateBalance((project.balance + _transfer), project.username);
                                    DBProvider.db.updateBalance((balance - _transfer), username);
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));}
                                  else{
                                    showDialog(context: context,builder: (context){
                                      return Center(child:Material(
                                          type: MaterialType.transparency,
                                          child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Colors.white,
                                              ),
                                              padding: EdgeInsets.all(20),
                                              height: 150,
                                              width: MediaQuery.of(context).size.width*0.7,
                                              child:Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Center(child: Text("Please enter amount to be transferred",
                                                    style: TextStyle(
                                                      fontSize: 20,
                                                    ),)),
                                                  FlatButton(onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MyHomePage()));}, child: Text("OK"))
                                                ],
                                              ))));});}},
                                child: Padding(
                                  padding: EdgeInsets.all(20),
                                  child: Text(project.username,
                                    style: TextStyle(
                                      fontSize: 23,
                                      color: Colors.white,
                                    ),),
                                ),
                              ),
                            );}
                      );
                    }
                    return CircularProgressIndicator();
                  }

              ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


