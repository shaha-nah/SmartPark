import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smartpark/Model/ParkingLot.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';

class PageSlotDirection extends StatefulWidget {
  String parkingSlotID;

  PageSlotDirection({Key key, @required this.parkingSlotID}): super(key:key);

  @override
  _PageSlotDirectionState createState() => _PageSlotDirectionState();
}

class _PageSlotDirectionState extends State<PageSlotDirection>{
  final User _user = User();
  final ParkingLot _parkingLot = ParkingLot();
  final System _system = System();
  
  final titles = ['Slot 1', "Slot 4", "Slot 8"];

  final subtitles = ["Lot A", "Lot A", "Lot B"];
  DateFormat dateFormat = DateFormat("MMM d, yyyy");
  DateFormat timeFormat = DateFormat("HH: mm");

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
                  Text(_startTime + " - " + _endTime)
                ],
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: hex("#5680e9")
                ),
              ),
              onPressed: () async{
                // String _parkingSlot = await _user.findParkingSlot(_dtDate, _dtStartTime, _dtEndTime);
                String _parkingLotID = await _parkingLot.getParkingLot(_parkingSlot);
                await _user.confirmReservation(_dtDate, _dtStartTime, _dtEndTime, _parkingLotID, _parkingSlot, _chosenVehicle);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WidgetBottomNavigation()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
            FlatButton(
              child: Text(
                "Dismiss",
                style: TextStyle(
                  color: hex("#34ceeb")
                ),
              ),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  Widget parkingLot(){
    return FutureBuilder<dynamic>(
          future: _parkingLot.getListOfSlots(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              return CustomScrollView(
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 30.0,
                      crossAxisSpacing: 50.0,
                      childAspectRatio: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (snapshot.data[index] != widget.parkingSlotID){
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
                            child: Text(
                              snapshot.data[index],
                              style: TextStyle(
                                color: Colors.black
                              ),
                              textAlign: TextAlign.center,
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
                            child: Text(
                              snapshot.data[index],
                              style: TextStyle(
                                color: Colors.green
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      },
                      childCount: snapshot.data.length,
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
        // centerTitle: true,
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
          // Container(
          //   // decoration: BoxDecoration(
          //   //   border: Border(
          //   //     top: BorderSide(
          //   //       color: Colors.black,
          //   //       width: 3.0
          //   //     ),
          //   //   )
          //   // ),
          //   width: MediaQuery.of(context).size.width,
          //   child: Text("Entrance"),
          // ),
        ],
      )
    );
  }
}