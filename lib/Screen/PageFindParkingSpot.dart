import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/ParkingLot.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Model/Vehicle.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Screen/PageSelectSlot.dart';
import 'package:smartpark/Screen/PageVehicleForm.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class PageFindParkingSpot extends StatefulWidget {
  @override
  _PageFindParkingSpotState createState() => _PageFindParkingSpotState();
}

class _PageFindParkingSpotState extends State<PageFindParkingSpot> {
  final Vehicle _vehicle = Vehicle();
  final User _user = User();
  final ParkingLot _parkingLot = ParkingLot();
  final System _system = System();

  String _chosenVehicle = "";

  String _date = "Date";
  String _startTime = "Start Time";
  String _endTime = "End Time";
  DateTime _dtDate;
  DateTime _tempDate;
  DateTime _dtStartTime;
  DateTime _dtEndTime;

  DateFormat timeFormat = DateFormat("HH: mm");

  void _dialogError(error, val){
    Alert(
      context: context,
      type: AlertType.error,
      title: "OH NO!",
      desc: error,
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
            for (int i = 0; i<val; i++){
              Navigator.of(context).pop();
            }
          },
          width: 120,
        )
      ],
    ).show();
  }

  void _dialogConfirmReservation(){
    bool _btnDisabled = false;
    showDialog(
      context: context,
      builder: (BuildContext context){
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
                if (!_btnDisabled){
                  setState(() {
                    _btnDisabled = !_btnDisabled;
                  });
                  String _parkingSlot = await _system.findParkingSlot(_dtDate, _dtStartTime, _dtEndTime);
                  if (_parkingSlot == "none"){
                    _dialogError("It seems like the parking is full.", 2);
                  }
                  else{
                    String _parkingLotID = await _parkingLot.getParkingLot(_parkingSlot);
                    await _user.makeReservation(_dtDate, _dtStartTime, _dtEndTime, _parkingLotID, _parkingSlot, _chosenVehicle);
                    Navigator.pushAndRemoveUntil(context, RouteTransition(page: WidgetBottomNavigation()), (route) => false);
                  }
                }
              },
            ),
          ],
        );
      }
    );
  }

  Widget _lblRide(){
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
        child: Text(
          "Select a vehicle",
          style: TextStyle(
            color: Colors.black54,
            fontWeight: FontWeight.bold
          ),
        ),
      ),
    );
  }

  Widget _addVehicle(){
    return GestureDetector(
      onTap: (){
        Navigator.push(context, RouteTransition(page: PageVehicleForm()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 12),
        height: 80,
        width: 80,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          // border: Border.all(
          //   color: hex("#84ceeb"),
          //   width: 2
          // )
        ),
        child: Icon(
          Icons.add,
          color: hex("#5680e9"),
        )
      ),
    );
  }

  Widget _chkboxVehicle(){
    final providerUser = Provider.of<User>(context);
    return StreamBuilder<dynamic>(
      stream: _vehicle.getVehicles(providerUser.uid),
      builder: (context, snap){
        if (snap.hasData){
          if (snap.data.documents.length == 0){
            print("oo");
            return GestureDetector(
              onTap: (){
                Navigator.push(context, RouteTransition(page: PageVehicleForm()));
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                    color: hex("#84ceeb"),
                    width: 2
                  )
                ),
                child: Icon(
                  Icons.add,
                  color: hex("#5680e9"),
                )
              ),
            );
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snap.data.documents.length,
            itemBuilder: (context, index){
              if (index == 0){
                _chosenVehicle = snap.data.documents[index]["vehiclePlateNumber"];
              }
              if (index == snap.data.documents.length -1){
                return Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => setState(() => _chosenVehicle=snap.data.documents[index]["vehiclePlateNumber"]),
                      child: Container(
                        width: 100,
                        margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                        decoration: _chosenVehicle == snap.data.documents[index]["vehiclePlateNumber"] ?  BoxDecoration(
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: hex("#84ceeb"),
                            width: 2
                          )
                        ) : BoxDecoration(
                          border: Border.all(color: Colors.white)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.directions_car,
                              color: hex("#5680e9"),
                            ),
                            Text(
                              snap.data.documents[index]["vehiclePlateNumber"]
                            ),
                          ],
                        ),
                      ),
                    ),
                    _addVehicle(),
                  ],
                );
              }
              else{
                return GestureDetector(
                  onTap: () => setState(() => _chosenVehicle=snap.data.documents[index]["vehiclePlateNumber"]),
                  child: Container(
                    width: 100,
                    margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
                    decoration: _chosenVehicle == snap.data.documents[index]["vehiclePlateNumber"] ?  BoxDecoration(
                      borderRadius: BorderRadius.circular(25.0),
                      border: Border.all(
                        color: hex("#84ceeb"),
                        width: 2
                      )
                    ) : BoxDecoration(
                      border: Border.all(color: Colors.white)
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.directions_car,
                          color: hex("#5680e9"),
                        ),
                        Text(
                          snap.data.documents[index]["vehiclePlateNumber"]
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        }
        return Container();
      }
    );
  }

  Widget _pickerDate(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        elevation: 4.0,
        onPressed: () {
          DatePicker.showDatePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true,
            minTime: DateTime.now(),
            onConfirm: (chosenDate) {
            DateFormat dateFormat = DateFormat("MMM d, yyyy");
            setState(() {
              _tempDate = chosenDate;
              _dtDate = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
              _date = dateFormat.format(_dtDate);
            });
          }, 
          currentTime: DateTime.now(), locale: LocaleType.en);
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.date_range,
                          size: 18.0,
                          color: hex("#8860d0")
                        ),
                        SizedBox(width:10.0),
                        Text(
                          " $_date",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Icon(
                Icons.edit,
                size: 18.0,
                color: hex("#34ceeb"),
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  Widget _pickerStartTime(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        elevation: 4.0,
        onPressed: () {
          DatePicker.showTimePicker(
            context, showSecondsColumn: false,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, onConfirm: (starttime) {
              setState(() {
                _startTime = timeFormat.format(starttime);
                _dtStartTime = starttime;
              });
            }, 
            currentTime: _tempDate, locale: LocaleType.en
          );
          setState(() {});
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 18.0,
                          color: hex("#8860d0")
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          " $_startTime",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Icon(
                Icons.edit,
                size: 18.0,
                color: hex("#34ceeb"),
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  Widget _pickerEndTime(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0)
        ),
        elevation: 4.0,
        onPressed: () {
          DatePicker.showTimePicker(
            context,
            showSecondsColumn: false,
            theme: DatePickerTheme(
              containerHeight: 210.0,
          ),
          showTitleActions: true, onConfirm: (endtime) {
            if (endtime.isBefore(_dtStartTime)){
              _dialogError("End time cannot be before start time", 1);
            }
            else{
              setState(() {
                _endTime = timeFormat.format(endtime);
                _dtEndTime = endtime;});
            }
          }, 
          currentTime: _dtStartTime, locale: LocaleType.en);
          setState(() { });
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.access_time,
                          size: 18.0,
                          color: hex("#8860d0")
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          " $_endTime",
                          style: TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Icon(
                Icons.edit,
                size: 18.0,
                color: hex("#34ceeb"),
              ),
            ],
          ),
        ),
        color: Colors.white,
      ),
    );
  }

  Widget _btnReserve(){
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12),
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
            "Reserve",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 18
            ),
          ),
          onPressed: () async {
            var listener = DataConnectionChecker().onStatusChange.listen((status) {
              switch (status) {
                case DataConnectionStatus.connected:
                  if (_dtDate != null && _dtStartTime != null && _dtEndTime != null && _chosenVehicle != ""){
                    if (_dtStartTime.isAfter(DateTime.now()) && _dtEndTime.isAfter(DateTime.now())){
                      if(_dtEndTime.difference(_dtStartTime).inMinutes > 29){
                        _dialogConfirmReservation();
                      }
                      else{
                        _dialogError("Please make a reservation of at least half an hour", 1);
                      }
                    }
                    else{
                      _dialogError("Please choose a time in the future", 1);
                    }
                  }
                  else{
                    _dialogError("Please fill in all the required fields", 1);
                  }
                  break;
                case DataConnectionStatus.disconnected:
                  _dialogError("Please make sure you have an active internet connection", 1);
                  break;
              }
            });
            await Future.delayed(Duration(seconds: 5));
            await listener.cancel();
          },
        ),
      )
    );
  }

  Widget _btnManualReserve(){
    return FlatButton(
      child: Text(
        'Select Slot',
        style: TextStyle(
          color: hex("#5680e9")
        ),
      ),
      onPressed: () {
        if (_chosenVehicle == "" || _dtDate == null || _dtStartTime == null || _dtEndTime == null){
          _dialogError("Please enter all the details", 1);
        }
        else{
          Navigator.push(context, RouteTransition(page: PageSelectSlot(vehicle: _chosenVehicle, date: _dtDate, startTime: _dtStartTime, endTime: _dtEndTime)));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final contentStyle = (BuildContext context) => ParentStyle()
      ..overflow.scrollable()
      ..padding(vertical: 30, horizontal: 20)
      ..minHeight(MediaQuery.of(context).size.height - (2 * 30));

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Make a Reservation",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: Parent(
        style: contentStyle(context),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                _lblRide(),
                Container(
                  height: 120,
                  child: _chkboxVehicle()
                ),
                _pickerDate(),
                _pickerStartTime(),
                _pickerEndTime(),
                _btnReserve(),
                _btnManualReserve(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}