import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpark/Model/User.dart';

class Vehicle{
  final String vehicleID;
  final String vehiclePlateNumber;

  Vehicle({this.vehicleID, this.vehiclePlateNumber});

  Future<List<dynamic>> getVehiclePlateNumbers() async{
    String userID = await User().getCurrentUser();
    var result = await Firestore.instance.collection('vehicle').where("userID", isEqualTo: userID).where("markAsDeleted", isEqualTo: false).getDocuments();
    List<DocumentSnapshot> templist = result.documents;
    List<dynamic> list = templist.map((DocumentSnapshot snapshot){
      return snapshot.data["vehiclePlateNumber"];
    }).toList();
    return list;
  }

  Stream<void> getVehicles(userID){
    return Firestore.instance.collection("vehicle").where("userID", isEqualTo: userID).where("markAsDeleted", isEqualTo: false).snapshots();
  }
}