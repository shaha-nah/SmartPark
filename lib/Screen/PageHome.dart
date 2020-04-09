import 'package:flutter/material.dart';
import 'package:smartpark/Model/Reservation.dart';
import 'package:smartpark/Screen/PageCheckOut.dart';
import 'package:smartpark/Screen/PageReservationExpired.dart';
import 'package:smartpark/Screen/PageSlotReallocation.dart';
import 'package:smartpark/Screen/PageFindParkingSpot.dart';
import 'package:smartpark/Screen/PageOngoingReservation.dart';
import 'package:smartpark/Screen/PageReservation.dart';


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
            return PageFindParkingSpot();
          }
          else{
            if (snapshot.data == "expired"){
              return PageReservationExpired();
            }
            else if (snapshot.data == "confirmed" || snapshot.data == "ongoing"){
              return PageReservation();
            }
            else if (snapshot.data == "checkedin"){
              return PageOngoingReservation();
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