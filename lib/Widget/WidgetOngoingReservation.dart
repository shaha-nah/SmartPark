import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Screen/PageExtendReservation.dart';
import 'package:smartpark/Screen/PageSlotDirection.dart';
import 'package:smartpark/Screen/PageSlotReallocation.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';
import 'package:smartpark/Widget/WidgetCountDownTimer.dart';

class WidgetOngoingReservation extends StatefulWidget {
  @override
  _WidgetOngoingReservation createState() => _WidgetOngoingReservation();
}

class _WidgetOngoingReservation extends State<WidgetOngoingReservation> {
  final User _user = User();
  // final System _system = System();
  
  DateFormat dateFormat = DateFormat("MMM d, yyyy");
  DateFormat timeFormat = DateFormat("HH: mm");

  // void _dialogPaymentFailed(){
  //   Alert(
  //     context: context,
  //     type: AlertType.error,
  //     title: "OH NO!",
  //     desc: "You do not have enough credits.",
  //     buttons: [
  //       DialogButton(
  //         color: Colors.red,
  //         child: Text(
  //           "OK",
  //           style: TextStyle(
  //             color: Colors.white, 
  //             fontSize: 20
  //           ),
  //         ),
  //         onPressed: () => Navigator.pop(context),
  //         width: 120,
  //       )
  //     ],
  //   ).show();
  // }   
   
  // void _dialogPaymentSuccessful(price){
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context){
  //       return  AlertDialog(
  //         //title:
  //           content: new Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: <Widget>[
  //               Divider(),Text("Thank You!",style: TextStyle(color: Colors.green),),
  //               Text("Your transaction was successful"),
  //               Divider(),
  //               Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Text("DATE"),
  //                     Text("FROM")
  //                   ],
  //                 ),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Text(dateFormat.format(DateTime.now())),
  //                     Text(timeFormat.format(DateTime.now())),
  //                   ],
  //                 ),
  //                 SizedBox(height: 20.0),
  //                 Row(
  //                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                   children: <Widget>[
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: <Widget>[
  //                         Text("AMOUNT"),
  //                         Text(price.toString()),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //             ],
  //           ),
  //           actions: <Widget>[
  //             new FlatButton(
  //               child: new Text("OK"),
  //               onPressed: () async {
  //                 Navigator.push(context, RouteTransition(page: WidgetBottomNavigation()));
  //               },
  //             ),
  //           ],
  //         );
  //     }
  //   );
  // }

  // void _dialogMakePayment(){
  //   bool _btnDisabled = false;
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context){
  //       return FutureBuilder<dynamic>(
  //         future: _user.getReservationDetails(),
  //         builder: (BuildContext context, AsyncSnapshot snapshot){
  //           if (snapshot.connectionState == ConnectionState.done){
  //             return  AlertDialog(
  //             //title:
  //               content: new Column(
  //                 mainAxisSize: MainAxisSize.min,
  //                 children: <Widget>[
  //                   Text("Make Payment"),
  //                   Divider(),
  //                   Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         Text("DATE"),
  //                         Text("TIME")
  //                       ],
  //                     ),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         Text(dateFormat.format(snapshot.data["reservationDate"].toDate())),
  //                         Column(
  //                           children: <Widget>[
  //                             Text(timeFormat.format(snapshot.data["reservationStartTime"].toDate())),
  //                             Text("TO"),
  //                             Text(timeFormat.format(snapshot.data["reservationCheckOutTime"].toDate()))
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     SizedBox(height: 20.0),
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: <Widget>[
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: <Widget>[
  //                             Text("AMOUNT"),
  //                             Text(snapshot.data["reservationFee"].toString()),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                 ],
  //               ),
  //               actions: <Widget>[
  //                 new FlatButton(
  //                   child: new Text(
  //                     "Cancel",
  //                     style: TextStyle(
  //                       color: Colors.red
  //                     ),
  //                   ),
  //                   onPressed: (){
  //                     Navigator.of(context).pop();
  //                   },
  //                 ),
  //                 new RaisedButton(
  //                   color: hex("#8860d0"),
  //                   child: new Text("OK"),
  //                   onPressed: () async {
  //                     if (!_btnDisabled){
  //                       setState(() {
  //                         _btnDisabled = !_btnDisabled;
  //                       });
  //                       Navigator.of(context).pop();
  //                       bool result = await _user.makePayment(snapshot.data["reservationFee"].toInt(), "normal");
  //                       if (result){
  //                         _dialogPaymentSuccessful(snapshot.data["reservationFee"]);
  //                       }
  //                       else{
  //                         _dialogPaymentFailed();
  //                       }
  //                     }
  //                   },
  //                 ),
  //               ],
  //             );
  //           }
  //           else{
  //             return Container();
  //           }
  //         }
  //       );
  //     }
  //   );
  // }

  Widget _countdownTo(DateTime time){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        color: Colors.white,
        child: Center(
          child: WidgetCountDownTimer(
            secondsRemaining: time.difference(DateTime.now()).inSeconds,
            whenTimeExpires: (){ },
            countDownTimerStyle: TextStyle(
              color: hex("#5ab9ea"),
              fontSize: 50
            ),
          ),
        ),
      ),
    );
  }

  // Widget _btnCheckOut(){
  //   return Padding(
  //     padding: EdgeInsets.symmetric(vertical: 12),
  //     child: Container(
  //       width: 800,
  //       decoration: BoxDecoration(
  //           borderRadius: BorderRadius.all(Radius.circular(100)),
  //           // color: Colors.deepPurple,
  //           gradient: LinearGradient(
  //           begin: Alignment.topLeft,
  //           end: Alignment.bottomRight,
  //           stops: [0.1, 1.0],
  //           colors: [
  //             hex("#8860d0"),
  //             hex("#5ab9ea")
  //           ]
  //         )
  //       ),
  //       child: FlatButton(
  //         child: Text(
  //           "Check Out",
  //           style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w700,
  //               fontSize: 18),
  //         ),
  //         onPressed: () async {
  //           await _user.checkOut();
  //           return _dialogMakePayment();
  //         },
  //       ),
  //     )
  //   );
  // }

  void _dialogReallocation(){
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

  Widget _reservationDetails(){
    return FutureBuilder<dynamic>(
      future: _user.getReservationDetails(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.data != null){
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: ListView(
                children: <Widget>[
                  _countdownTo(snapshot.data["reservationEndTime"].toDate()),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.directions_car,
                        color: hex("#5680e9")
                      ),
                      title: Text(snapshot.data["vehicleID"]),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.calendar_today,
                        color: hex("#5680e9")
                      ),
                      title: Text(timeFormat.format(snapshot.data["reservationStartTime"].toDate()) + " - " + timeFormat.format(snapshot.data["reservationEndTime"].toDate())),
                      subtitle: Text(dateFormat.format(snapshot.data["reservationDate"].toDate())),
                      trailing: Icon(
                        Icons.edit,
                        color: hex("#f172a1"),
                      ),
                      onTap: (){
                        Navigator.push(context, RouteTransition(page: PageExtendReservation(originalStartTime: snapshot.data["reservationStartTime"].toDate(), originalEndTime: snapshot.data["reservationEndTime"].toDate(),)));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.local_parking,
                        color: hex("#5680e9")
                      ),
                      title: Text("Slot " + snapshot.data["parkingSlotID"]),
                      subtitle: Text("Lot " + snapshot.data["parkingLotID"]),
                      trailing: Icon(
                        Icons.location_on,
                        color: hex("#f172a1"),
                      ),
                      onTap: (){
                        Navigator.push(context, RouteTransition(page: PageSlotDirection(parkingSlotID: snapshot.data["parkingSlotID"],)));
                      },
                    ),
                  ),
                  Card(
                    child: ListTile(
                      leading: Icon(
                        Icons.attach_money,
                        color: hex("#5680e9")
                      ),
                      title: Text("Rs " + snapshot.data["reservationFee"].toString()),
                    ),
                  ),
                  // _btnCheckOut(),
                  // _btnLotLocation(snapshot.data["parkingSlotID"]),
                ],
              ),
            ),
          );
        }
        else{
          return Container();
        }
      },

    );
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh(){
    Navigator.pushAndRemoveUntil(context, RouteTransition(page: WidgetBottomNavigation()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Your reservation",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      // body: Stack(
      //   children: <Widget>[
      //     _reservationDetails(),
      //   ],
      // ),
      body: SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        child: _reservationDetails(),
      ),
    );
  }
}