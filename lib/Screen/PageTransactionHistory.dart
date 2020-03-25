import 'package:flutter/material.dart';

class PageTransactionHistory extends StatefulWidget {
  @override
  _PageTransactionHistoryState createState() => _PageTransactionHistoryState();
}

class _PageTransactionHistoryState extends State<PageTransactionHistory> {

  final titles = ["November 12, 2019", "November 10, 2019", "November 1, 2019"];

  final icons = [Icons.call_made, Icons.call_made, Icons.call_received];

  final subtitles = ['9:20', "13:46", "9:21"];

  final fee = ["- 100", "-200", "+1000"];

  final amount = ["700", "800", "1000"];

  final color = [Colors.green, Colors.green, Colors.red];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text("History", style: TextStyle(color: Colors.black),
        ),
        // centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 5.0,
      ),
      body: ListView.builder(
        itemCount: titles.length,
        itemBuilder: (context, index) {
          return Card( //                           <-- Card widget
            child: ListTile(
              leading: Icon(
                icons[index],
                color: color[index],
              ),
              title: Text(
                titles[index],
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black54
                ),
              ),
              subtitle: Text(subtitles[index]),
              trailing: Column(
                children: <Widget>[
                  Text(
                    fee[index], 
                    style: TextStyle(
                      color: color[index]
                    )
                  ),
                  Text(
                    amount[index],
                    style: TextStyle(
                      color: Colors.black54
                    ),
                  ),
                ],
              ),
              onTap: (){

              },
            ),
              
          );
        },
      ),
    );
  }
}