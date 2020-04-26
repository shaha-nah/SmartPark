import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Model/Vehicle.dart';
import 'package:smartpark/Screen/PageVehicleForm.dart';
import 'package:smartpark/Widget/WidgetVehicleItem.dart';

class PageVehicleList extends StatefulWidget {
  @override
  _PageVehicleListState createState() => _PageVehicleListState();
}

class _PageVehicleListState extends State<PageVehicleList> {
  final Vehicle _vehicle = Vehicle();
  final User _user = User();

  void _dialogConfirmDelete(vehicle){
    Alert(
      context: context,
      type: AlertType.warning,
      title: "",
      desc: "Are you sure you want to delete this vehicle?",
      buttons: [
        DialogButton(
          color: Colors.white,
          child: Text(
            "Dismiss",
            style: TextStyle(
              color: Colors.red, 
              fontSize: 20
            ),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        ),
        DialogButton(
          color: Colors.red,
          child: Text(
            "Confirm",
            style: TextStyle(
              color: Colors.white, 
              fontSize: 20
            ),
          ),
          onPressed: () async{
            _user.deleteVehicle(vehicle);
            Navigator.pop(context);
          },
          width: 120,
        )
      ],
    ).show();
  }  

  Widget widgetVehicle(){
    final user = Provider.of<User>(context);

    return StreamBuilder<dynamic>(
      stream: _vehicle.getVehicles(user.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData){
          if (snapshot.data.documents.length == 0){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Text("You have no vehicles"),
            );
          }
          return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context, index){
              DocumentSnapshot vehicleDocument  =snapshot.data.documents[index];
              return WidgetVehicleItem(
                vehiclePlateNumber: vehicleDocument.data["vehiclePlateNumber"],
                vehicleType: vehicleDocument.data["type"],
                onDelete: (vehicle) async{
                  _dialogConfirmDelete(vehicle);
                },
              );
            },
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
        title: Text(
          "Vehicles",
          style: TextStyle(
            color: Colors.black
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: widgetVehicle(),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PageVehicleForm()));
        },
        tooltip: 'Add',
        child: Icon(Icons.add),
        backgroundColor: hex("#f172a1"),
      ),
    );
  }
}