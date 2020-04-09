import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:smartpark/Model/User.dart';

class Reservation{
  final String parkingLotID;
  final String parkingSlotID;
  final DateTime checkInTime;
  final DateTime checkOutTime;
  final DateTime date;
  final DateTime endTime;
  final int fee;
  final String payment;
  final DateTime startTime;
  final int status;
  final String uid;
  final String vehiclePlateNumber;

  Reservation({this.parkingLotID, this.parkingSlotID,this.checkInTime, this.checkOutTime, this.date, this.endTime,this.fee, this.payment, this.startTime,this.status, this.uid, this.vehiclePlateNumber});

  Future hasReservation() async{
    var userID = await User().getCurrentUser();
    var allReservation = await Firestore.instance.collection("reservation").getDocuments();
    List<DocumentSnapshot> allReservations = allReservation.documents;
    if (allReservations.length != 0){
      //reservations exist
      var userReservation = await Firestore.instance.collection("reservation").where("userID", isEqualTo: userID).where("reservationStatus", isLessThan: 5).getDocuments();
      List<DocumentSnapshot> userReservations = userReservation.documents;
      for (int i = 0; i<userReservations.length; i++){
        if ((userReservations[i].data["reservationStartTime"].toDate()).isBefore(DateTime.now()) && (userReservations[i].data["reservationEndTime"].toDate()).isBefore(DateTime.now())){
          return "expired";
        }
        else if (userReservations[i].data["reservationStatus"] == 1){
          return "confirmed";
        }
        else if (userReservations[i].data["reservationStatus"] == 2){
          return "ongoing";
        }
        else if (userReservations[i].data["reservationStatus"] == 3){
          if (userReservations[i].data["reservationSlotReallocation"] != ""){
            return "reallocation";
          }
          else{
            return "checkedin";
          }
        }
        else if (userReservations[i].data["reservationStatus"] == 4){
          return "checkingout";
        }
      }
    }
    return null;
  }

  Future getExpiredReservation() async{
    final String userID = await User().getCurrentUser();
    var reservations = await Firestore.instance.collection("reservation").where("userID", isEqualTo: userID).where("reservationStatus", isLessThan: 5).getDocuments();
    List<DocumentSnapshot> reservation = reservations.documents;
    for (int i = 0; i < reservation.length; i++){
      if ((reservation[i].data["reservationStartTime"].toDate()).isBefore(DateTime.now()) && (reservation[i].data["reservationEndTime"].toDate()).isBefore(DateTime.now())){
        return reservation[i];
      }
    }
  }

  Future setReservationExpired() async{
    print("reservation expired");
    final reservation = await getExpiredReservation();
    final String reservationID = reservation.documentID;
    return await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "reservationStatus": 6
    });
  }
}