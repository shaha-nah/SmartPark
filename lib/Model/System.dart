import 'dart:io';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:smartpark/Model/ParkingLot.dart';
import 'package:smartpark/Model/User.dart';

class System{
  Future<bool> isEmailVerified() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    return user.isEmailVerified;
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

  Future resendEmailVerification() async{
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.sendEmailVerification();
  }

  Future validateCurrentPassword(password, context) async{
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

  Future<String> findParkingSlot(chosenDate, startTime, endTime) async{
    DateTime date = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
    startTime = startTime.subtract(new Duration(hours: 1));
    endTime = endTime.add(new Duration(hours: 1));

    var listParkingSlot = await ParkingLot().getListOfSlots();
    var listFreeSlots = await ParkingLot().getListOfSlots();

    for (int i = 0; i<listParkingSlot.length; i++){
      var reservations = await Firestore.instance.collection("reservation").where("parkingSlotID", isEqualTo: listParkingSlot[i]).where("reservationDate", isEqualTo: date).where("reservationStatus", isLessThan: 5).getDocuments();
      List<DocumentSnapshot> reservation = reservations.documents;

      if (reservation.length != 0){
        //reservation exists

        List<dynamic> listStartTime = reservation.map((DocumentSnapshot snapshot){
          return snapshot.data["reservationStartTime"].toDate();
        }).toList();
        List<dynamic> listEndTime = reservation.map((DocumentSnapshot snapshot){
          return snapshot.data["reservationEndTime"].toDate();
        }).toList();

        //check if reservation exists within time interval
        for (int j = 0; j<listStartTime.length; j++){
          
          if (!((startTime.isBefore(listStartTime[j]) && endTime.isBefore(listStartTime[j])) || ((startTime.isAfter(listEndTime[j])) && (endTime.isAfter(listEndTime[j]))))){
            listFreeSlots.remove(listParkingSlot[i]);
          }
        }
      }
    }
    if (listFreeSlots.length == 0){
      return "none";
    }
    else{
      var index= 0 + Random().nextInt(listFreeSlots.length-1 - 0);
      return listFreeSlots[index];
    }
  }

  Stream getReservations(chosenDate){
    DateTime date = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
    return Firestore.instance.collection("reservation").where("reservationDate", isEqualTo: date).where("reservationStatus", isLessThan: 5).snapshots();
  }

  Future findAllAvailableSlots(reservations, startTime, endTime) async{

    startTime = startTime.subtract(new Duration(hours: 1));
    endTime = endTime.add(new Duration(hours: 1));

    var listFreeSlots = await ParkingLot().getListOfSlots();

    for (int i = 0; i<reservations.length; i++){
      if (!((startTime.isBefore((reservations[i]["reservationStartTime"]).toDate()) && endTime.isBefore((reservations[i]["reservationStartTime"]).toDate())) || ((startTime.isAfter((reservations[i]["reservationEndTime"]).toDate())) && (endTime.isAfter((reservations[i]["reservationEndTime"]).toDate()))))){
        listFreeSlots.remove(reservations[i]["parkingSlotID"]);
      }
    }

    var listAllParkingSlot = await ParkingLot().getListOfSlots();
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

    var reservations = await Firestore.instance.collection("reservation").where("reservationDate", isEqualTo: date).where("reservationStatus", isLessThan: 5).where("parkingSlotID", isEqualTo: slot).getDocuments();
    List<DocumentSnapshot> reservation = reservations.documents;

    if (reservation.length != 0){
      List<dynamic> listStartTime = reservation.map((DocumentSnapshot snapshot){
        return snapshot.data["reservationStartTime"].toDate();
      }).toList();
      List<dynamic> listEndTime = reservation.map((DocumentSnapshot snapshot){
        return snapshot.data["reservationEndTime"].toDate();
      }).toList();

      for (int j = 0; j<listStartTime.length; j++){
        if (!((startTime.isBefore(listStartTime[j]) && endTime.isBefore(listStartTime[j])) || ((startTime.isAfter(listEndTime[j])) && (endTime.isAfter(listEndTime[j]))))){
          free = false;
          return free;
        }
        else{
          free = true;
        }
      }
    }
    return free;
  }

  Future setReservationCompleted() async{
    final String reservationID = await User().getCurrentReservation();
    return await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "reservationStatus": 5
    });
  }

  Future setReservationOngoing() async{
    final String reservationID = await User().getCurrentReservation();
    return await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "reservationStatus": 2
    });
  }

  Future<int> calculateFee(parkingLot, startTime, endTime, checkOutTime, type) async{
    var reservation= await User().getReservationDetails();
    var parkingDocument = await Firestore.instance.collection("parkingLot").document(parkingLot).get();
    var normalFee = endTime.difference(startTime).inMinutes * (parkingDocument["parkingLotNormalRate"]/60);
    if (type == "checkout"){
      if (checkOutTime.isAfter(endTime)){
        if (reservation["reservationPenalty"] == true){
          return normalFee.toInt() + checkOutTime.difference(endTime).inMinutes * (parkingDocument["parkingLotLateFee"]/60) + parkingDocument["parkingLotPenaltyFee"];
        }
        else{
          return normalFee.toInt() + checkOutTime.difference(endTime).inMinutes * (parkingDocument["parkingLotLateFee"]/60);
        }
      }
      else{
        if (reservation["reservationPenalty"] == true){
          return normalFee.toInt() + parkingDocument["parkingLotPenaltyFee"];
        }
        else{
          return normalFee.toInt();
        }
      }
    }
    else if (type == "expired"){
      return normalFee.toInt() + parkingDocument["parkingLotExpirationFee"];
    }
    else if (type == "cancellation"){
      return normalFee.toInt() + parkingDocument["parkingLotCancellationFee"];
    }
    else{
      return normalFee.toInt();
    }
  }

  Future reallocate(slot) async{
    String reservationID = await User().getCurrentReservation();
    DocumentSnapshot reservation = await User().getReservationDetails();
    int fee = await calculateFee("B", reservation["reservationStartTime"].toDate(), reservation["reservationEndTime"].toDate(), reservation["reservationEndTime"].toDate(), "normal");
    String parkingLotID = await ParkingLot().getParkingLot(slot);
    await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "parkingLotID": parkingLotID,
      "parkingSlotID": slot,
      "reservationFee": fee,
      "reservationSlotReallocation": ""
    });
  }
}