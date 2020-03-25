import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingLot{
  Future<String> getParkingLot(String parkingSlot) async{
    var result = await Firestore.instance.collection("parkingSlot").document(parkingSlot).get();
    return result.data["parkingLotID"];
  }

  Future<List<String>> getListOfSlots() async{
    var querySnapshotParkingSlots = await Firestore.instance.collection("parkingSlot").getDocuments();
    List<DocumentSnapshot> documentParkingSlots = querySnapshotParkingSlots.documents;
    List<String> listParkingSlot = documentParkingSlots.map((DocumentSnapshot snapshot){
      return snapshot.documentID;
    }).toList();
    return listParkingSlot;
  }
}