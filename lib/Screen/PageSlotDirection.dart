import 'package:flutter/material.dart';
import 'package:smartpark/Model/ParkingLot.dart';

class PageSlotDirection extends StatefulWidget {
  final String parkingSlotID;

  PageSlotDirection({Key key, @required this.parkingSlotID}): super(key:key);

  @override
  _PageSlotDirectionState createState() => _PageSlotDirectionState();
}

class _PageSlotDirectionState extends State<PageSlotDirection>{
  final ParkingLot _parkingLot = ParkingLot();

  Widget parkingLot(){
    return FutureBuilder<dynamic>(
          future: _parkingLot.getReservedLot(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.connectionState == ConnectionState.done){
              return CustomScrollView(
                slivers: <Widget>[
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 200.0,
                      mainAxisSpacing: 30.0,
                      crossAxisSpacing: 50.0,
                      childAspectRatio: 4.0,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        if (snapshot.data[index] != widget.parkingSlotID){
                          return Container(
                            padding: EdgeInsets.only(bottom: 22),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 3.0
                                ),
                              )
                            ),
                            child: Text(
                              snapshot.data[index],
                              style: TextStyle(
                                color: Colors.black
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                        else{
                          return Container(
                            padding: EdgeInsets.only(bottom: 22),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Colors.black,
                                  width: 3.0
                                ),
                              )
                            ),
                            child: Text(
                              snapshot.data[index],
                              style: TextStyle(
                                color: Colors.green
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }
                      },
                      childCount: snapshot.data.length,
                    ),
                  )
                ],
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
        title: Text("Directions", style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: Column(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.black,
                  width: 3.0
                ),
              )
            ),
            width: MediaQuery.of(context).size.width,
          ),
          SizedBox(height: 25,),
          Flexible(
            flex: 1,
            child: Container(
              height: (MediaQuery.of(context).size.width /15)* 14,
              child: parkingLot()
            ),
          ),
          Text("Entrance"),
        ],
      )
    );
  }
}