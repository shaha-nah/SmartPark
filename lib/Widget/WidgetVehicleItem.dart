import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class WidgetVehicleItem extends StatelessWidget{
  final String vehiclePlateNumber;
  final String vehicleType;
  final Function(String) onEdit;
  final Function(String) onDelete;
  const WidgetVehicleItem({Key key, @required this.vehiclePlateNumber, @required this.vehicleType, this.onEdit, @required this.onDelete}) : super(key: key);

  @override 
  Widget build(BuildContext context){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
      child: Slidable(
        actions: <Widget>[],
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.25,
        secondaryActions: <Widget>[
          IconSlideAction(
            foregroundColor: Colors.red,
            caption: "Delete",
            color: Colors.white,
            icon: Icons.delete_outline,
            onTap: () => onDelete(vehiclePlateNumber),
          ),
        ],
        child: Card(
          margin: EdgeInsets.all(8.0),
          color: Colors.white,
            child: ListTile(
              leading: vehicleType=="4-Wheeler" ? Icon(
                Icons.directions_car,
                color: hex("#5680e9"),
              ): Icon(
                Icons.motorcycle,
                color: hex("#5680e9"),
              ),
              title: Text(
                vehiclePlateNumber,
                style: TextStyle(
                ),
              ),
            ),
        ),
      ),
    );
  }
}