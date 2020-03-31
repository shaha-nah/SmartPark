import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';

class PageExtendReservation extends StatefulWidget {

  DateTime originalStartTime;
  DateTime originalEndTime;

  PageExtendReservation({Key key, @required this.originalStartTime, @required this.originalEndTime}): super(key:key);
  @override
  _PageExtendReservationState createState() => _PageExtendReservationState();
}

class _PageExtendReservationState extends State<PageExtendReservation> {
  final User _user = User();

  String _endTime = "End Time";
  DateTime _dtEndTime;


  DateFormat timeFormat = DateFormat("HH: mm");

  void _dialogError(error){
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
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
  }

  Widget _lblStartTime(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Text("Your reservation started at: " + timeFormat.format(widget.originalStartTime)),
    );
  }

  Widget _lblEndTime(){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      child: Text("Enter the time at which you wish to check out!"),
    );
  }

  Widget _pickerEndTime(){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
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
            if (endtime.isBefore(widget.originalStartTime)){
              _dialogError("End time cannot be before start time");
            }
            else{
              setState(() {
                _endTime = '${endtime.hour}: ${endtime.minute}';
                _dtEndTime = endtime;});
            }
            
          }, 
          currentTime: widget.originalStartTime, locale: LocaleType.en);
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
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
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
            "Extend",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18),
          ),
          onPressed: () async {
            
            if (_dtEndTime != null){
              var listener = DataConnectionChecker().onStatusChange.listen((status) async{
                switch (status) {
                  case DataConnectionStatus.connected:
                    if (_dtEndTime.isAfter(DateTime.now())){
                      if(_dtEndTime.difference(widget.originalStartTime).inMinutes > 29){
                        _user.extendReservation(_dtEndTime);
                        Navigator.of(context).pop();

                      }
                      else{
                        _dialogError("A reservation of less than half an hour cannot be made");
                      }
                    }
                    else{
                      _dialogError("Please choose a time in the future");
                    }
                    break;
                  case DataConnectionStatus.disconnected:
                    _dialogError("Please make sure you have an active internet connection");
                    break;
                }
              });
              await Future.delayed(Duration(seconds: 5));
              await listener.cancel();
            }
            else{
              Navigator.of(context).pop();
            }
          },
        ),
      )
    );
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Extend reservation",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: <Widget>[
            _lblStartTime(),
            _lblEndTime(),
            _pickerEndTime(),
            _btnReserve(),
          ],
        ),
      ),
    );
  }
}