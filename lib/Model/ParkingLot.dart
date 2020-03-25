import 'package:cloud_firestore/cloud_firestore.dart';

class ParkingLot{
  Future<String> getParkingLot(String parkingSlot) async{
    DocumentSnapshot result = await Firestore.instance.collection("parkingSlot").document(parkingSlot).get();
    return result.data["parkingLotID"];
  }

  Future<List<DocumentSnapshot>> reservationParkingSlot() async{
    QuerySnapshot result = await Firestore.instance.collection("parkingLot").where("reserve", isEqualTo: true).getDocuments();
    List<DocumentSnapshot> parkingDocs = result.documents;
    return parkingDocs;
  }

  Future<List<String>> getListOfSlots() async{
    List<DocumentSnapshot> reserveLots = await reservationParkingSlot();
    QuerySnapshot querySnapshotParkingSlots = await Firestore.instance.collection("parkingSlot").where("parkingLotID", arrayContains: reserveLots).getDocuments();
    List<DocumentSnapshot> documentParkingSlots = querySnapshotParkingSlots.documents;
    List<String> listParkingSlot = documentParkingSlots.map((DocumentSnapshot snapshot){
      return snapshot.documentID;
    }).toList();
    return listParkingSlot;
  }
}