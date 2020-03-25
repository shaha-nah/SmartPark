import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Widget/WidgetBottomNavigation.dart';

class PageSlotReallocation extends StatefulWidget {
  @override
  _PageSlotReallocationState createState() => _PageSlotReallocationState();
}

class _PageSlotReallocationState extends State<PageSlotReallocation> {
  final User _user = User();
  final System _system = System();

  final _image = Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 100.0,
      child: Image.asset('assets/sad.png'),
    ),
  );

   Widget _btnConfirm(slot){
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 60,vertical: 12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          // color: 
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
            "I understand!",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 18),
          ),
          onPressed: () async {
            await _system.reallocate(slot);
            Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => WidgetBottomNavigation()),
                  (Route<dynamic> route) => true,
                );
          },
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<dynamic>(
        future: _user.getReservationDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if (snapshot.data != null){
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _image,
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1),
                    child: Text(
                      "Oh no! Your slot is not available...",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Text(
                      "We are deeply for the inconvenience!",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      "You have been reallocated to:",
                      style: TextStyle(
                        fontSize: 17,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      "Slot " + snapshot.data["reservationSlotReallocation"],
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      "and given a discount.",
                      textAlign: TextAlign.center,
                    ),
                  ),
                  _btnConfirm(snapshot.data["reservationSlotReallocation"])
                ],
              ),
            );
          }
          else{
            return Container();
          }
        }
      ),
    );
  }
}