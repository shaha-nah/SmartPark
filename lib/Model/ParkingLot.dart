import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingLot{
  Future<String> getParkingLot(String parkingSlot) async{
    DocumentSnapshot result = await Firestore.instance.collection("parkingSlot").document(parkingSlot).get();
    return result.data["parkingLotID"];
  }

  Future<List<String>> reservationParkingSlot() async{
    QuerySnapshot result = await Firestore.instance.collection("parkingLot").where("reserve", isEqualTo: true).getDocuments();
    List<DocumentSnapshot> parkingDocs = result.documents;
    List<String> listParkingSlots = parkingDocs.map((DocumentSnapshot snapshot){
      return snapshot.documentID;
    }).toList();
    return listParkingSlots;
  }

  Future<List<String>> getListOfSlots() async{
    List<String> reserveLots = await reservationParkingSlot();
    QuerySnapshot querySnapshotParkingSlots = await Firestore.instance.collection("parkingSlot").where("parkingLotID", isEqualTo: "A").getDocuments();
    List<DocumentSnapshot> documentParkingSlots = querySnapshotParkingSlots.documents;
    List<String> listParkingSlot = documentParkingSlots.map((DocumentSnapshot snapshot){
      return snapshot.documentID;
    }).toList();
    return listParkingSlot;
  }
}