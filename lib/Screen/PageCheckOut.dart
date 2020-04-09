import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';

class PageCheckOut extends StatefulWidget {
  @override
  _PageCheckOutState createState() => _PageCheckOutState();
}

class _PageCheckOutState extends State<PageCheckOut> {
  final User _user = User();
  
  DateFormat dateFormat = DateFormat("MMM d, yyyy");
  DateFormat timeFormat = DateFormat("HH: mm");

  final _image = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 100.0,
      child: Image.asset('assets/happy.jpg'),
    ),
  );

  void _dialogPaymentFailed(){
    Alert(
      context: context,
      type: AlertType.error,
      title: "OH NO!",
      desc: "You do not have enough credits.",
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "OK",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20
            ),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }   
   
  void _dialogPaymentSuccessful(price){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return  AlertDialog(
          content: new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),Text("Thank You!",style: TextStyle(color: Colors.green),),
              Text("Your transaction was successful"),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text("DATE"),
                  Text("FROM")
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(dateFormat.format(DateTime.now())),
                  Text(timeFormat.format(DateTime.now())),
                ],
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("AMOUNT"),
                      Text(price.toString()),
                    ],
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () async {
                Navigator.push(context, RouteTransition(page: WidgetBottomNavigation()));
              },
            ),
          ],
        );
      }
    );
  }

  void _dialogMakePayment(){
    bool _btnDisabled = false;
    showDialog(
      context: context,
      builder: (BuildContext context){
        return FutureBuilder<dynamic>(
          future: _user.getReservationDetails(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              return  AlertDialog(
                content: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      "Make Payment",
                      style: TextStyle(
                        fontWeight: FontWeight.w700
                      ),
                    ),
                    Divider(),
                    SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "DATE",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            ),
                            Text(
                              dateFormat.format(snapshot.data["reservationDate"].toDate()),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "TIME",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            ),
                            Text(timeFormat.format(snapshot.data["reservationStartTime"].toDate()) + " - " + timeFormat.format(snapshot.data["reservationEndTime"].toDate())),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "AMOUNT",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: Colors.black54,
                              ),
                            ),
                            Text("Rs " + snapshot.data["reservationFee"].toString()),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text(
                      "Cancel",
                      style: TextStyle(
                        color: Colors.red
                      ),
                    ),
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                  ),
                  new RaisedButton(
                    color: hex("#8860d0"),
                    child: new Text("OK"),
                    onPressed: () async {
                      if (!_btnDisabled){
                        setState(() {
                          _btnDisabled = !_btnDisabled;
                        });
                        Navigator.of(context).pop();
                        bool result = await _user.makePayment(snapshot.data["reservationFee"].toInt(), "normal");
                        if (result){
                          _dialogPaymentSuccessful(snapshot.data["reservationFee"]);
                        }
                        else{
                          _dialogPaymentFailed();
                        }
                      }
                    },
                  ),
                ],
              );
            }
            else{
              return Container();
            }
          }
        );
      }
    );
  }

  Widget _btnCheckOut(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 60),
      child: Container(
        width: 800,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.1, 1.0],
            colors: [
              hex("#8860d0"),
              hex("#5ab9ea")
            ]
          )
        ),
        child: FlatButton(
          child: Text(
            "Make Payment",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          onPressed: () async {
            await _user.checkOut();
            return _dialogMakePayment();
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: _user.getReservationDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.data != null){
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      "Thank you for using SmartPark!",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                    "We hope to see you again soon",
                    style: TextStyle(
                      fontSize: 17,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  _btnCheckOut(),
                ],
              ),
            );
          }
          else{
            return Container();
          }
        }
      ),
    );
  }
}