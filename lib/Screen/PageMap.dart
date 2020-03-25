import 'dart:async';
import 'dart:typed_data';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:smartpark/Model/Reservation.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';
import 'package:smartpark/Widget/WidgetCountDownTimer.dart';

class PageMap extends StatefulWidget {
  PageMap({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _PageMap createState() => _PageMap();
}

class _PageMap extends State<PageMap> {
  final User _user = User();
  final Reservation _reservation = Reservation();
  int _reservationStatus;

  StreamSubscription _locationSubscription;
  Location _locationTracker = Location();
  Marker markerSource;
  Marker markerDestination;
  Set<Marker> markers;
  Circle circle;
  GoogleMapController _controller;

  @override
  void initState(){
    super.initState();
    getLocations("destination");
  }

  static CameraPosition initialLocation = CameraPosition(
    target: LatLng(-20.2354463, 57.4968057),
    zoom: 10,
  );

  Future<Uint8List> getMarker() async {
    ByteData byteData = await DefaultAssetBundle.of(context).load("assets/driving_pin.png");
    return byteData.buffer.asUint8List();
  }

  Set<Marker> _createMarker(source, destination, imageData){
    return <Marker>[
      Marker(
        markerId: MarkerId("Current position"),
        position: source,
        icon: BitmapDescriptor.fromBytes(imageData),
        infoWindow: InfoWindow(title: "Current position",),
      ),
      Marker(
        markerId: MarkerId("Destination"),
        position: destination,
        icon: BitmapDescriptor.defaultMarker,
        infoWindow: InfoWindow(title: "Destination",),
      ),
    ].toSet();
  }

  void updateMarkerAndCircle(LocationData newLocalData, destination, Uint8List imageData){
    LatLng currentLatLng = LatLng(newLocalData.latitude, newLocalData.longitude);
    this.setState(() {
      markers = _createMarker(currentLatLng, destination, imageData);
    });
  }

  void getLocations(coordinates) async {
    try {
      Uint8List imageData = await getMarker();
      var currentLocation = await _locationTracker.getLocation();
      var destination = LatLng(-20.2338, 57.4985);
      var location;
      updateMarkerAndCircle(currentLocation, destination, imageData);

      // if (_locationSubscription != null) {
      //   _locationSubscription.cancel();
      // }

      if (coordinates == "source"){
        location = currentLocation;
      }
      else if (coordinates == "destination"){
        location = destination;
      }

      // _locationSubscription = _locationTracker.onLocationChanged().listen((newLocalData) {
        if (_controller != null) {
          _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
              bearing: 192.8334901395799,
              target: LatLng(location.latitude, location.longitude),
              tilt: 0,
              zoom: 18.00)));
          updateMarkerAndCircle(currentLocation, destination, imageData);
          // _controller = null;
        }
      // });

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        debugPrint("Permission Denied");
      }
    }
  }

  @override
  void dispose() {
    if (_locationSubscription != null) {
      _locationSubscription.cancel();
    }
    super.dispose();
  }

  Widget map(){
    return GoogleMap(
      mapType: MapType.hybrid,
      initialCameraPosition: initialLocation,
      // markers: Set.from((markerSource != null) ? [markerSource] : []),
      markers: Set.from((markers) != null? markers : []),
      circles: Set.of((circle != null) ? [circle] : []),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

  void _dialogReservation(text){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          // title:
          content: new Text(text),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.red
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

  void _dialogCancelReservation(){
    showDialog(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          // title:
          content: new Text("Are you sure you want to cancel your reservation?"),
          actions: <Widget>[
            FlatButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Colors.red
                ),
              ),
              onPressed: (){
                _user.cancelReservation();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WidgetBottomNavigation()),
                  (Route<dynamic> route) => true,
                );
              },
            ),
            FlatButton(
              child: Text("Dismiss"),
              onPressed: (){
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }

  Widget _timer(int status, DateTime startTime, DateTime endTime){
    if (status == 1){
      //not started
      return _startTimeCountdown(startTime, endTime);
    }
    else if (status == 2){
      //started
      return _countdownTimer(endTime);
    }
    else{
      return _countdownTimer(DateTime.now());
    }
  }

  Widget _startTimeCountdown(DateTime startTime, DateTime endTime){
    final currentTime = DateTime.now();
    if (currentTime.isBefore(startTime)){
      //not expired
      return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              // margin: EdgeInsets.only(top: 20),
              child: Center(
                child: WidgetCountDownTimer(
                  secondsRemaining: startTime.difference(currentTime).inSeconds,
                  whenTimeExpires: () {
                    return _startTimeCountdown(startTime, endTime);
                  },
                  countDownTimerStyle: TextStyle(
                    color: hex("#5ab9ea"),
                    fontSize: 40,
                    
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
    else{
      //expired
      return Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0),
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.white,
              // margin: EdgeInsets.only(top: 20),
              child: Center(
                child: WidgetCountDownTimer(
                  secondsRemaining: endTime.difference(currentTime).inSeconds,
                  whenTimeExpires: () {

                    setState(() {
                      
                    });
                  },
                  countDownTimerStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 40,
                    
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _countdownTimer(DateTime time){
    final currentTime = DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(top: 0, bottom: 0),
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            // margin: EdgeInsets.only(top: 20),
            child: Center(
              child: WidgetCountDownTimer(
                secondsRemaining: time.difference(currentTime).inSeconds,
                whenTimeExpires: () {
                  setState(() {
                    
                  });
                },
                countDownTimerStyle: TextStyle(
                  color: hex("#5ab9ea"),
                  fontSize: 40,
                  
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _btnAction(status){
  //   if(status == 1){
  //     return _btnCheckIn();
  //   }
  //   else if(status == 2){
  //     return _btnCheckOut();
  //   }
  //   else{
  //     return Container();
  //   }
  // }

  // Widget _btnCheckIn(){
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 32,vertical: 7),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(100)),
  //         // color: 
  //         gradient: LinearGradient(
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
  //           "Check In",
  //           style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w500,
  //               fontSize: 18),
  //         ),
  //         onPressed: () async {
  //           var checkInStatus = await _user.checkIn();
  //           if (checkInStatus == 0){
  //             //waiting for recognition
  //             var validationStatus = await _user.checkInValidation();
  //             if (validationStatus == 0){
  //               //check in successful
  //               _user.confirmCheckIn();
  //               _dialogReservation("Check in successful");
  //               Navigator.of(context).pop();
  //             }
  //             else{
  //               //check in failed
  //               _dialogReservation("Check in failed. Please try again");
  //             }
  //           }
  //           else if (checkInStatus == 1){
  //             //no reservation
  //             _dialogReservation("Your reservation does not exist");
  //           }
  //           else if (checkInStatus == 2){
  //             //check details again
  //             _dialogReservation("Please make sure your details are correct");
  //           }
  //           else if(checkInStatus == 3){
  //             _dialogReservation("Please make sure you are using the correct vehicle");
  //           }
  //         },
  //       ),
  //     )
  //   );
  // }

  // Widget _btnCheckOut(){
  //   return Padding(
  //     padding: EdgeInsets.symmetric(horizontal: 32,vertical: 3),
  //     child: Container(
  //       decoration: BoxDecoration(
  //         borderRadius: BorderRadius.all(Radius.circular(100)),
  //         // color: 
  //         gradient: LinearGradient(
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
  //               fontWeight: FontWeight.w500,
  //               fontSize: 18),
  //         ),
  //         onPressed: () async {
  //           _user.checkOut();
  //         },
  //       ),
  //     )
  //   );
  // }  

  // void _settingModalBottomSheet(context){
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext context){
  //       return FutureBuilder<dynamic>(
  //         future: _user.getReservationDetails(),
  //         builder: (BuildContext context, AsyncSnapshot snapshot){
  //           if (snapshot.connectionState == ConnectionState.done){
  //             _reservationStatus = snapshot.data["reservationStatus"];

  //             DateFormat dateFormat = DateFormat("MMM d, yyyy");
  //             DateTime dtDate = snapshot.data["reservationDate"].toDate();
  //             String date = dateFormat.format(dtDate);

  //             DateFormat timeFormat = DateFormat("HH: mm");
  //             DateTime dtStartTime = snapshot.data["reservationStartTime"].toDate();
  //             String startTime = timeFormat.format(dtStartTime);
  //             DateTime dtEndTime = snapshot.data["reservationEndTime"].toDate();
  //             String endTime = timeFormat.format(dtEndTime);

  //             return Container(
  //               alignment: Alignment.bottomCenter,
  //               height: 800,
  //               child: Card(
  //                 color: Colors.white,
  //                 child: Padding(
  //                   padding: const EdgeInsets.all(8),
  //                   child: ListView(
  //                     children: <Widget>[
  //                       _timer(_reservationStatus, dtStartTime, dtEndTime),
  //                       Card(
  //                         child: ListTile(
  //                           leading: Icon(
  //                             Icons.directions_car,
  //                             color: hex("#5680e9"),
  //                           ),
  //                           title: Text(snapshot.data["vehicleID"]),
  //                           trailing: Icon(
  //                             Icons.edit,
  //                             color: hex("#34ceeb"),
  //                           ),
  //                           onTap: (){

  //                           },
  //                         ),
  //                       ),
  //                       Card(
  //                         child: ListTile(
  //                           leading: Icon(
  //                             Icons.access_time,
  //                             color: hex("#5680e9"),
  //                           ),
  //                           title: Text(startTime + " - " + endTime),
  //                           subtitle: Text(date),
  //                           trailing: Icon(
  //                             Icons.edit,
  //                             color: hex("#34ceeb"),
  //                           ),
  //                           onTap: (){

  //                           },
  //                         ),
  //                       ),
  //                       Card(
  //                         child: ListTile(
  //                           leading: Icon(
  //                             Icons.local_parking,
  //                             color: hex("#5680e9"),
  //                           ),
  //                           title: Text("Slot " + snapshot.data["parkingSlotID"]),
  //                           subtitle: Text("Lot " + snapshot.data["parkingLotID"]),
  //                           trailing: Icon(
  //                             Icons.edit,
  //                             color: hex("#34ceeb"),
  //                           ),
  //                           onTap: (){

  //                           },
  //                         ),
  //                       ),
  //                       _btnAction(_reservationStatus),
  //                       _btnCancelReservation(),
  //                     ],
  //                   ),
  //                 ),
  //               ),
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

  Widget _btnCancelReservation(){
    return FlatButton(
      padding: EdgeInsets.symmetric(vertical: 0),
      child: Text(
        'Cancel Reservation?',
        style: TextStyle(color: hex("#5680e9")),
      ),
      onPressed: () {
        _dialogCancelReservation();
        
        // Navigator.push(context, RouteTransition(page: PageForgotPassword()));
      },
    );
  }

  // Widget btnDetails(){
  //   return Align(
  //     alignment: Alignment.bottomRight,
  //     child: Padding(
  //       padding: const EdgeInsets.symmetric(vertical: 80),
  //       child: FloatingActionButton(
  //         backgroundColor: hex("#f172a1"),
  //         onPressed: (){
  //           _settingModalBottomSheet(context);
  //         },
  //         child: Icon(Icons.more_horiz),
  //       ),
  //     ),
  //   );
  // }

  Widget btnCurrentLocation(){
    return Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
        child: FloatingActionButton(
          child: Icon(Icons.location_searching),
          onPressed: () {
            getLocations("source");
          }
        ),
      ),
    );
  }
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          map(),
          // btnDetails(),
          btnCurrentLocation()
        ],
      ),
    );
  }
}