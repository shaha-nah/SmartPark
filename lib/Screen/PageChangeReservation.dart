import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:smartpark/Model/ParkingLot.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';

class PageChangeReservation extends StatefulWidget {

  String date;
  String startTime;
  String endTime;

  PageChangeReservation({Key key, @required this.date, @required this.startTime, @required this.endTime}): super(key:key);
  @override
  _PageChangeReservationState createState() => _PageChangeReservationState();
}

class _PageChangeReservationState extends State<PageChangeReservation> {
  
  String _date = "Date";
  String _startTime = "Start Time";
  String _endTime = "End Time";
  DateTime _dtDate;
  DateTime _tempDate;
  DateTime _dtStartTime;
  DateTime _dtEndTime;

  void _dialogError(String error){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          //title:
          content: new Text(error),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  void _dialogConfirmReservation(){
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
                User().changeReservation(_dtDate, _dtStartTime, _dtEndTime);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
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

  Widget _pickerDate(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0)),
        elevation: 4.0,
        onPressed: () {
          DatePicker.showDatePicker(context,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true,
            minTime: DateTime.now(),
            // maxTime: DateTime(2020, 02, 20), 
            onConfirm: (chosenDate) {
            DateFormat dateFormat = DateFormat("MMM d, yyyy");
            setState(() {
              _tempDate = chosenDate;
              _dtDate = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
              _date = dateFormat.format(_dtDate);
              print(_dtDate);
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
                              fontSize: 18.0),
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
            borderRadius: BorderRadius.circular(30.0)),
        elevation: 4.0,
        onPressed: () {
          DatePicker.showTimePicker(
            context, showSecondsColumn: false,
            theme: DatePickerTheme(
              containerHeight: 210.0,
            ),
            showTitleActions: true, onConfirm: (starttime) {
              setState(() {
                _startTime = '${starttime.hour}: ${starttime.minute}';
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
                              fontSize: 18.0),
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
            borderRadius: BorderRadius.circular(30.0)),
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
              _dialogError("End time cannot be before start time");
            }
            else{
              setState(() {
                _endTime = '${endtime.hour}: ${endtime.minute}';
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
                              fontSize: 18.0),
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
            // color: Colors.deepPurple,
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
                fontSize: 18),
          ),
          onPressed: () async {
            if (_dtDate != null && _dtStartTime != null && _dtEndTime != null){
              if (_dtStartTime.isAfter(DateTime.now()) && _dtEndTime.isAfter(DateTime.now())){
                if(_dtEndTime.difference(_dtStartTime).inHours > 0.5){
                  _dialogConfirmReservation();
                }
                else{
                  _dialogError("Please make a reservation of at least half an hour");
                }
              }
              else{
                _dialogError("Please choose a time in the future");
              }
            }
            else{
              _dialogError("Please fill in all the required fields");
            }
          },
        ),
      )
    );
  }

  Widget _btnCancel(){
    return FlatButton(
      child: Text(
        'Cancel',
        style: TextStyle(color: hex("#5680e9")),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        title: Text("Change Reservation", style: TextStyle(color: Colors.black),
        ),
        // centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            SizedBox(height: 40,),
            _pickerDate(),
            _pickerStartTime(),
            _pickerEndTime(),
            _btnReserve(),
            _btnCancel(),
          ],
        ),
      ),
    );
  }
}