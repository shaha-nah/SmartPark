import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/Reservation.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';

class PageReservationExpired extends StatefulWidget {
  @override
  _PageReservationExpiredState createState() => _PageReservationExpiredState();
}

class _PageReservationExpiredState extends State<PageReservationExpired> {
  final User _user = User();
  final Reservation _reservation = Reservation();
  final System _system = System();

  DateFormat dateFormat = DateFormat("MMM d, yyyy");
  DateFormat timeFormat = DateFormat("HH: mm");

  final _logo = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 75.0,
      child: Image.asset('assets/sad.png'),
    ),
  );

  Widget _lblTitle(){
    return Text(
      "Reservation Expired",
      style: TextStyle(
        fontSize: 30
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _lbl(){
    return Text(
      "Please pay the fees due!",
      textAlign: TextAlign.center,
    );
  }

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
          onPressed: () => Navigator.pushAndRemoveUntil(context, RouteTransition(page: WidgetBottomNavigation()), (route) => false),
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
                    Text(
                      "DATE",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    ),
                    Text(
                      "TIME",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.black54,
                      ),
                    )
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
                        Text(
                          "AMOUNT",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Colors.black54,
                          ),
                        ),
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
                Navigator.pushAndRemoveUntil(context, RouteTransition(page: WidgetBottomNavigation()), (route) => false);
              },
            ),
          ],
        );
      }
    );
  }

  void _dialogMakePayment(fee){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return FutureBuilder<dynamic>(
          future: _reservation.getExpiredReservation(),
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
                            Text("Rs" + fee.toString()),
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
                      Navigator.of(context).pop();
                      var result = await _user.makePayment(fee, "expired");
                      if (result){
                        _dialogPaymentSuccessful(fee);
                      }
                      else{
                        _dialogPaymentFailed();
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

  Widget _btnMakePayment(){
    return Padding(
      padding: EdgeInsets.fromLTRB(80, 70, 80, 0),
      child: Container(
        width: MediaQuery.of(context).size.width,
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
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
          onPressed: () async {
            var reservation = await _user.getReservationDetails();
            var fee = await _system.calculateFee(reservation["parkingLotID"], reservation["reservationStartTime"].toDate(), reservation["reservationEndTime"].toDate(), reservation["reservationEndTime"].toDate(), "expired");
            _dialogMakePayment(fee);
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _logo,
          _lblTitle(),
          _lbl(),
          _btnMakePayment(),
        ],
      ),
    ); 
  }
}