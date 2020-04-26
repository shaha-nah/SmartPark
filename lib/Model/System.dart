import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartpark/Model/ParkingLot.dart';
import 'package:smartpark/Model/User.dart';
import 'package:smartpark/Model/Vehicle.dart';

class System{
  Future<bool> isEmailVerified() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.isEmailVerified;
  }

  Future<void> resendEmailVerification() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.sendEmailVerification();
  }

  Future<bool> sendPasswordResetMail(String email) async {
    var emails = await Firestore.instance.collection("user").where("userEmail", isEqualTo: email).getDocuments();
    List<DocumentSnapshot> emailDocuments = emails.documents;
    if (emailDocuments.length == 0){
      return false;
    }
    else{
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return true;
    }
  }

  Future<bool> validateCurrentPassword(password) async{
    var userDetails = await User().getUserDetails();
    var email = userDetails["userEmail"];
    var result = await User().signIn(email, password);
    if (result != null){
      return true;
    }
    else{
      return false;
    }
  }

  List shuffle(List items) {
    var random = new Random();

    // Go through all elements.
    for (var i = items.length - 1; i > 0; i--) {

      // Pick a pseudorandom number according to the list length
      var n = random.nextInt(i + 1);

      var temp = items[i];
      items[i] = items[n];
      items[n] = temp;
    }

    return items;
  }

  Future<String> findParkingSlot(chosenDate, startTime, endTime, vehicleType) async{
    DateTime date = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
    startTime = startTime.subtract(new Duration(hours: 1));
    endTime = endTime.add(new Duration(hours: 1));

    List listParkingSlot = await ParkingLot().getListOfSlots(vehicleType);

    listParkingSlot = shuffle(listParkingSlot);

    for (int i = 0; i<listParkingSlot.length; i++){
      QuerySnapshot reservations = await Firestore.instance.collection("reservation").where("parkingSlotID", isEqualTo: listParkingSlot[i]).where("reservationDate", isEqualTo: date).where("reservationStatus", isLessThan: 5).getDocuments();
      List<DocumentSnapshot> reservation = reservations.documents;

      if (reservation.length != 0){
        //reservation exists
        bool free = true;
        List<dynamic> listStartTime = reservation.map((DocumentSnapshot snapshot){
          return snapshot.data["reservationStartTime"].toDate();
        }).toList();
        List<dynamic> listEndTime = reservation.map((DocumentSnapshot snapshot){
          return snapshot.data["reservationEndTime"].toDate();
        }).toList();

        //check if reservation exists within time interval
        for (int j = 0; j<listStartTime.length; j++){
          
          if (!((startTime.isBefore(listStartTime[j]) && endTime.isBefore(listStartTime[j])) || ((startTime.isAfter(listEndTime[j])) && (endTime.isAfter(listEndTime[j]))))){
            free = false;
            break;
          }
        }
        if (free){
          return listParkingSlot[i];
        }
      }
      else{
        return listParkingSlot[i];
      }
    }
    return "none";
  }

  Stream getReservations(chosenDate){
    DateTime date = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
    return Firestore.instance.collection("reservation").where("reservationDate", isEqualTo: date).where("reservationStatus", isLessThan: 5).snapshots();
  }

  Future<List<dynamic>> findAllAvailableSlots(reservations, startTime, endTime, vehicleType) async{
    startTime = startTime.subtract(new Duration(hours: 1));
    endTime = endTime.add(new Duration(hours: 1));

    var listFreeSlots = await ParkingLot().getListOfSlots(vehicleType);

    for (int i = 0; i<reservations.length; i++){
      if (!((startTime.isBefore((reservations[i]["reservationStartTime"]).toDate()) && endTime.isBefore((reservations[i]["reservationStartTime"]).toDate())) || ((startTime.isAfter((reservations[i]["reservationEndTime"]).toDate())) && (endTime.isAfter((reservations[i]["reservationEndTime"]).toDate()))))){
        listFreeSlots.remove(reservations[i]["parkingSlotID"]);
      }
    }

    var listAllParkingSlot = await ParkingLot().getListOfSlots(vehicleType);
    listAllParkingSlot.sort((a, b) => a.length.compareTo(b.length));

    List<String> listSlot = [];
    List<bool> listStatus = [];
    for (int i = 0; i < listAllParkingSlot.length; i++){
      if (listFreeSlots.contains(listAllParkingSlot[i])){
        listSlot.add(listAllParkingSlot[i]);
        listStatus.add(true);
      }
      else{
        listSlot.add(listAllParkingSlot[i]);
        listStatus.add(false);
      }
    }
    
    List<dynamic> result = [];
    listSlot.forEach((slot) {
      result.add(slot);
    });
    listStatus.forEach((status) {
      result.add(status);
    });
    return result;
  }

  Future<bool> checkSlotAvailability(chosenDate, startTime, endTime, slot) async{
    DateTime date = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
    startTime = startTime.subtract(new Duration(hours: 1));
    endTime = endTime.add(new Duration(hours: 1));
    bool free = true;
    String userID = await User().getCurrentUser();
    QuerySnapshot reservations = await Firestore.instance.collection("reservation").where("reservationDate", isEqualTo: date).where("reservationStatus", isLessThan: 5).where("parkingSlotID", isEqualTo: slot).getDocuments();
    List<DocumentSnapshot> reservation = reservations.documents;

    if (reservation.length != 0){
      List<dynamic> listStartTime = reservation.map((DocumentSnapshot snapshot){
        return snapshot.data["reservationStartTime"].toDate();
      }).toList();
      List<dynamic> listEndTime = reservation.map((DocumentSnapshot snapshot){
        return snapshot.data["reservationEndTime"].toDate();
      }).toList();
      List<dynamic> listUser = reservation.map((DocumentSnapshot snapshot){
        return snapshot.data["userID"];
      }).toList();

      for (int j = 0; j<listStartTime.length; j++){
        if (listUser[j] != userID){
          if (!((startTime.isBefore(listStartTime[j]) && endTime.isBefore(listStartTime[j])) || ((startTime.isAfter(listEndTime[j])) && (endTime.isAfter(listEndTime[j]))))){
            free = false;
            return free;
          }
          else{
            free = true;
          }
        }
      }
    }
    return free;
  }

  Future<void> setReservationOngoing() async{
    final String reservationID = await User().getCurrentReservation();
    return await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "reservationStatus": 2
    });
  }

  Future<void> calculateFee(parkingLot, startTime, endTime, checkOutTime, type) async{
    DocumentSnapshot reservation = await User().getReservationDetails();
    String reservationID = await User().getCurrentReservation();
    DocumentSnapshot parkingDocument = await Firestore.instance.collection("parkingLot").document(parkingLot).get();

    int normalFee = (endTime.difference(startTime).inMinutes * (parkingDocument["parkingLotNormalRate"]/60)).toInt();

    await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "reservationFee": normalFee,
      "reservationPenaltyFee": 0
    });

    if (type == "checkout"){
      if (checkOutTime.isAfter(endTime)){
        await Firestore.instance.collection("reservation").document(reservationID).updateData({
          "reservationPenaltyFee": FieldValue.increment((checkOutTime.difference(endTime).inMinutes * (parkingDocument["parkingLotLateFee"]/60)).toInt())
        });
      }
      if (reservation["reservationPenalty"]){
        await Firestore.instance.collection("reservation").document(reservationID).updateData({
          "reservationPenaltyFee": FieldValue.increment(parkingDocument["parkingLotPenaltyFee"])
        });
      }
      if (reservation["reservationDiscount"]){
        await Firestore.instance.collection("reservation").document(reservationID).updateData({
          "reservationFee": (normalFee * 0.9).toInt()
        });
      }
    }
    else if (type == "expired"){
      await Firestore.instance.collection("reservation").document(reservationID).updateData({
        "reservationPenaltyFee": parkingDocument["parkingLotExpirationFee"]
      });
    }
    else if (type == "cancellation"){
      await Firestore.instance.collection("reservation").document(reservationID).updateData({
        "reservationPenaltyFee": parkingDocument["parkingLotCancellationFee"]
      });
    }
  }

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
          if (userReservations[i].data["reservationSlotReallocation"] == true){
            return "reallocation";
          }
          else{
            return "ongoing";
          }
        }
        else if (userReservations[i].data["reservationStatus"] == 3){
          return "checkedin";
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

  Future<void> setReservationExpired() async{
    final reservation = await getExpiredReservation();
    final String reservationID = reservation.documentID;
    return await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "reservationStatus": 6
    });
  }

  Future<String> slotReallocation(type, endTime) async{
    final reservation = await User().getReservationDetails();
    final vehicleType = await Vehicle().getVehicleType(reservation["vehicleID"]);
    String slot;
    if (type == "checkin"){
      bool available = false;
      while (!available){
        slot =  await findParkingSlot(DateTime.now(), DateTime.now(), reservation["reservationEndTime"].toDate(), vehicleType);
        DocumentSnapshot parkingSlot = await Firestore.instance.collection("parkingSlot").document(slot).get();
        if (parkingSlot["available"]){
          available = true;
        }
      }
    }
    else if (type == "modify"){
      slot =  await findParkingSlot(DateTime.now(), DateTime.now(), reservation["reservationEndTime"].toDate(), vehicleType);
    }
    return slot;
  }

  Future canModifyReservation(endTime) async{
    DocumentSnapshot reservation = await User().getReservationDetails();
    if (endTime.isBefore(reservation["reservationEndTime"].toDate())){
      return "";
    }
    else{
      bool available = await checkSlotAvailability(reservation["reservationDate"].toDate(), reservation["reservationStartTime"].toDate(), endTime, reservation["parkingSlotID"]);
      if (available){
        return "";
      }
      else{
        return slotReallocation("modify", endTime);
      }
    }
  }
}