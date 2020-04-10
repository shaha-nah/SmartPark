import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class PageMap extends StatefulWidget {
  PageMap({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _PageMap createState() => _PageMap();
}

class _PageMap extends State<PageMap> {
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

      if (coordinates == "source"){
        location = currentLocation;
      }
      else if (coordinates == "destination"){
        location = destination;
      }

      
      if (_controller != null) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
            bearing: 192.8334901395799,
            target: LatLng(location.latitude, location.longitude),
            tilt: 20,
            zoom: 18.00)));
        updateMarkerAndCircle(currentLocation, destination, imageData);
      }

    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
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
      markers: Set.from((markers) != null? markers : []),
      circles: Set.of((circle != null) ? [circle] : []),
      onMapCreated: (GoogleMapController controller) {
        _controller = controller;
      },
    );
  }

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
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Location",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: Stack(
        children: <Widget>[
          map(),
          btnCurrentLocation()
        ],
      ),
    );
  }
}