import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Screen/PageExtendReservation.dart';
import 'package:smartpark/Screen/PageSlotDirection.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';
import 'package:smartpark/Widget/WidgetCountDownTimer.dart';

class WidgetOngoingReservation extends StatefulWidget {
  @override
  _WidgetOngoingReservation createState() => _WidgetOngoingReservation();
}

class _WidgetOngoingReservation extends State<WidgetOngoingReservation> {
  final User _user = User();
  
  DateFormat dateFormat = DateFormat("MMM d, yyyy");
  DateFormat timeFormat = DateFormat("HH: mm");

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