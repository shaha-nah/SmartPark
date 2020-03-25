import 'package:flutter/material.dart';
import 'package:smartpark/Model/Reservation.dart';
import 'package:smartpark/Screen/PageCheckOut.dart';
import 'package:smartpark/Screen/PageReservationExpired.dart';
import 'package:smartpark/Screen/PageSlotReallocation.dart';
import 'package:smartpark/Widget/WidgetFindParkingSpot.dart';
import 'package:smartpark/Widget/WidgetOngoingReservation.dart';
import 'package:smartpark/Widget/WidgetReservation.dart';


class PageHome extends StatefulWidget {

  @override
  _PageHomeState createState() => new _PageHomeState();
}

class _PageHomeState extends State<PageHome>{
  final Reservation _reservation = Reservation();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
      future: _reservation.hasReservation(),
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if (snapshot.connectionState == ConnectionState.done){
          if (snapshot.data == null){
            return WidgetFindParkingSpot();
          }
          else{
            if (snapshot.data == "expired"){
              return PageReservationExpired();
            }
            else if (snapshot.data == "confirmed" || snapshot.data == "ongoing"){
              return WidgetReservation();
            }
            else if (snapshot.data == "checkedin"){
              return WidgetOngoingReservation();
            }
            else if (snapshot.data == "reallocation"){
              return PageSlotReallocation();
            }
            else if (snapshot.data == "checkingout"){
              return PageCheckOut();
            } 
            else{
              return Container();
            }
          }
        }
        else{
          return Container();
        }
      }
    );
  }
}