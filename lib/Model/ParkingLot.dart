import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpark/Model/User.dart';

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
    QuerySnapshot querySnapshotParkingSlots = await Firestore.instance.collection("parkingSlot").where("parkingLotID", whereIn: reserveLots).getDocuments();
    List<DocumentSnapshot> documentParkingSlots = querySnapshotParkingSlots.documents;
    List<String> listParkingSlot = documentParkingSlots.map((DocumentSnapshot snapshot){
      return snapshot.documentID;
    }).toList();
    listParkingSlot.sort((a, b) => a.length.compareTo(b.length));
    return listParkingSlot;
  }

  Future<List<String>> getReservedLot() async{
    DocumentSnapshot reservation = await User().getReservationDetails();
    QuerySnapshot qsParkingLot = await Firestore.instance.collection("parkingSlot").where("parkingLotID", isEqualTo: reservation["parkingLotID"]).getDocuments();
    List<DocumentSnapshot> docParkingLot = qsParkingLot.documents;
    List<String> listParkingSlot = docParkingLot.map((DocumentSnapshot snapshot){
      return snapshot.documentID;
    }).toList();
    listParkingSlot.sort((a, b) => a.length.compareTo(b.length));
    return listParkingSlot;
  }
}