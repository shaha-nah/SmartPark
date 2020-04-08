import 'package:division/division.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/Model/User.dart';
import 'package:intl/intl.dart';

class PageParkingHistory extends StatefulWidget {
  @override
  _PageParkingHistoryState createState() => _PageParkingHistoryState();
}

class _PageParkingHistoryState extends State<PageParkingHistory> {
final User _user = User();

  Widget widgetHistory(){
    return FutureBuilder<dynamic>(
      future: _user.getParkingHistory(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.done) {
          if (snap.data.length == 0){
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
              child: Text("You have no parking history"),
            );
          }
          DateFormat dateFormat = DateFormat("MMM d, yyyy");
          DateFormat timeFormat = DateFormat("HH: mm");
          
          return ListView.builder(
            itemCount: snap.data.length,
            itemBuilder: (context, index) {
              String date = dateFormat.format(snap.data[index]["reservationDate"].toDate());
              String startTime = timeFormat.format(snap.data[index]["reservationStartTime"].toDate());
              String endTime = timeFormat.format(snap.data[index]["reservationEndTime"].toDate());
              String paymentFee = snap.data[index]["reservationFee"].toString();
              String parkingSlot = snap.data[index]["parkingSlotID"];
              int status = snap.data[index]["reservationStatus"];
              if (status == 4){
                String checkInTime;
                String checkOutTime;
                var checkin = snap.data[index]["reservationCheckInTime"];
                var checkout = snap.data[index]["reservationCheckOutTime"];
                if (checkin == null){
                  checkInTime = "boo";
                }
                else{
                  checkInTime = timeFormat.format(checkin.toDate());
                }
                if (checkout == null){
                  checkOutTime = "boo";
                }
                else{
                  checkOutTime = timeFormat.format(checkout.toDate());
                }
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.check_circle_outline,
                                            color: Colors.green,
                                            size: 50,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Parking Completed",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              Text(
                                                date
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Rs" + paymentFee
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Reserved Time: " + startTime + " - " + endTime,
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                  Text(
                                    "Actual Time: " + checkInTime + " - " + checkOutTime,
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                    textAlign: TextAlign.left,
                                  ),  
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: hex("#5680e9")
                                    ),
                                    Text(
                                      parkingSlot
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              else if (status == 5){
                //expired
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.block,
                                            color: Colors.red,
                                            size: 50,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Reservation Expired",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              Text(
                                                date
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Rs" + paymentFee
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Reserved Time: " + startTime + " - " + endTime,
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: hex("#5680e9")
                                    ),
                                    Text(
                                      parkingSlot
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              else{
                //cancelled
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.cancel,
                                            color: Colors.red,
                                            size: 50,
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "Reservation Cancelled",
                                                style: TextStyle(
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w400
                                                ),
                                              ),
                                              Text(
                                                date
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Text(
                                  "Rs" + paymentFee
                                ),
                              ],
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    "Reserved Time: " + startTime + " - " + endTime,
                                    style: TextStyle(
                                      fontSize: 16
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.location_on,
                                      color: hex("#5680e9")
                                    ),
                                    Text(
                                      parkingSlot
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
            },
          );
        } 
        else {
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
        title: Text("Parking History", style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: widgetHistory()
    );
  }
}