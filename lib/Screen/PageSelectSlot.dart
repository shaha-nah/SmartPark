import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/ParkingLot.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';

class PageSelectSlot extends StatefulWidget {
  final String vehicle;
  final DateTime date;
  final DateTime startTime;
  final DateTime endTime;

  PageSelectSlot({Key key, @required this.vehicle, @required this.date, @required this.startTime, @required this.endTime}): super(key:key);

  @override
  _PageSelectSlotState createState() => _PageSelectSlotState();
}

class _PageSelectSlotState extends State<PageSelectSlot>{
  final User _user = User();
  final ParkingLot _parkingLot = ParkingLot();
  final System _system = System();
  
  DateFormat dateFormat = DateFormat("MMM d, yyyy");
  DateFormat timeFormat = DateFormat("HH: mm");

  void _dialogError(){
    Alert(
      context: context,
      type: AlertType.error,
      title: "OH NO!",
      desc: "It seems like someone got to that slot first.",
      buttons: [
        DialogButton(
          color: Colors.red,
          child: Text(
            "Try Again",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20
            ),
          ),
          onPressed: (){
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          width: 120,
        )
      ],
    ).show();
  }

  void _dialogConfirmReservation(_parkingSlot, _chosenVehicle, _dtDate, _dtStartTime, _dtEndTime){
    showDialog(
      context: context,
      builder: (BuildContext context){
        String _date = dateFormat.format(_dtDate);
        String _startTime = timeFormat.format(_dtStartTime);
        String _endTime = timeFormat.format(_dtEndTime);
        return AlertDialog(
          title: Text("Confirm Your Reservation"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(
                    Icons.directions_car,
                    color: hex("#8860d0"),
                  ),
                  SizedBox(width: 10,),
                  Text(_chosenVehicle),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.calendar_today,
                    color: hex("#8860d0"),
                  ),
                  SizedBox(width: 10,),
                  Text(_date),
                ],
              ),
              SizedBox(height: 10,),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.access_time,
                    color: hex("#8860d0"),
                  ),
                  SizedBox(width: 10,),
                  Text(_startTime + " - " + _endTime)
                ],
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
            RaisedButton(
              color: hex("#8860d0"),
              child: Text(
                "OK",
              ),
              onPressed: () async{
                String _parkingLotID = await _parkingLot.getParkingLot(_parkingSlot);
                var result = await _user.makeReservation(_dtDate, _dtStartTime, _dtEndTime, _parkingLotID, _parkingSlot, _chosenVehicle);
                if (result){
                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => WidgetBottomNavigation()), (Route<dynamic> route) => false,);
                }
                else{
                  _dialogError();
                }
              },
            ),
          ],
        );
      }
    );
  }

  Widget parkingLot(){
    return StreamBuilder<dynamic>(
      stream: _system.getReservations(widget.date),
      builder: (BuildContext context, AsyncSnapshot streamSnapshot){
        if (streamSnapshot.hasData) {
          return FutureBuilder<dynamic>(
            future: _system.findAllAvailableSlots(streamSnapshot.data.documents, widget.startTime, widget.endTime),
            builder: (BuildContext context, AsyncSnapshot futureSnapshot){
              if (futureSnapshot.connectionState == ConnectionState.done){
                return CustomScrollView(
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 30.0,
                      crossAxisSpacing: 50.0,
                      childAspectRatio: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (futureSnapshot.data[index+10]){
                          return Container(
                            padding: EdgeInsets.only(bottom: 22),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 3.0
                                ),
                              )
                            ),
                            child: FlatButton(
                              child: Text(
                                futureSnapshot.data[index],
                                style: TextStyle(
                                  color: Colors.green
                                ),
                              ),
                              onPressed: (){
                                return _dialogConfirmReservation(futureSnapshot.data[index], widget.vehicle, widget.date, widget.startTime, widget.endTime);
                              },
                            ),
                          );
                        }
                        else{
                          return Container(
                            padding: EdgeInsets.only(bottom: 22),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 3.0
                                ),
                              )
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: Icon(
                                Icons.directions_car,
                                color: Colors.red,
                              )
                            ),
                          );
                        }
                      },
                      childCount: ((futureSnapshot.data.length/2).toInt()),
                    ),
                  )
                ],
              );
              }
              else{
                return Container();
              }
            }
          );
        }
        else{
          return Container();
        }
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("Select a slot", style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 3.0
                ),
              )
            ),
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 25,),
          Flexible(
            flex: 1,
            child: Container(
              height: (MediaQuery.of(context).size.width /15)* 14,
              child: parkingLot()
            ),
          ),
          Text("Entrance"),
        ],
      )
    );
  }
}