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

  Future<List<dynamic>> showAvailableSlots(chosenDate, startTime, endTime) async{
    //get list of all available parking slots
    List<String> listAvailableSlots = await findAllParkingSlots(chosenDate, startTime, endTime);
    //get list of all parking slots
    var querySnapshotParkingSlots = await Firestore.instance.collection("parkingSlot").getDocuments();
    List<DocumentSnapshot> documentParkingSlots = querySnapshotParkingSlots.documents;
    List<String> listAllParkingSlot = documentParkingSlots.map((DocumentSnapshot snapshot){
      return snapshot.documentID;
    }).toList();
    
    listAllParkingSlot.sort((a, b) => a.length.compareTo(b.length));

    List<String> listSlot = [];
    List<bool> listStatus = [];
    for (int i = 0; i < listAllParkingSlot.length; i++){
      if (listAvailableSlots.contains(listAllParkingSlot[i])){
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

  Future<String> findParkingSlot(chosenDate, startTime, endTime) async{
    List<String> freeSlots = await findAllParkingSlots(chosenDate, startTime, endTime);
    return freeSlots[freeSlots.length -1];
  }

  Future findAllParkingSlots(chosenDate, startTime, endTime) async{
    DateTime date = DateTime(chosenDate.year, chosenDate.month, chosenDate.day, 0, 0, 0);
    startTime = startTime.subtract(new Duration(hours: 1));
    endTime = endTime.add(new Duration(hours: 1));

    // var querySnapshotParkingSlots = await Firestore.instance.collection("parkingSlot").getDocuments();
    // List<DocumentSnapshot> documentParkingSlots = querySnapshotParkingSlots.documents;
    // List<String> listParkingSlot = documentParkingSlots.map((DocumentSnapshot snapshot){
    //   return snapshot.documentID;
    // }).toList();
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
    return listFreeSlots;
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

  // Future checkSlotAvailability(slot, userID, date, startTime, endTime) async{
  //   bool free;
  //   var reservations = await Firestore.instance.collection("reservation").where("parkingSlotID", isEqualTo: slot).where("reservationDate", isEqualTo: date).where("reservationStatus", isLessThan: 4).getDocuments();
  //   List<DocumentSnapshot> reservation = reservations.documents;
  //   if (reservation.length != 0){
  //     //reservation exists
  //     List<dynamic> listStartTime = reservation.map((DocumentSnapshot snapshot){
  //       if (snapshot.data["userID"] != userID){
  //         return snapshot.data["reservationStartTime"].toDate();
  //       }
  //     }).toList();
  //     List<dynamic> listEndTime = reservation.map((DocumentSnapshot snapshot){
  //       if (snapshot.data["userID"] != userID){
  //         return snapshot.data["reservationEndTime"].toDate();
  //       }
  //     }).toList();

  //     //check if reservation exists within that time interval

      
  //   }
  // }

   Future<int> calculateFee(parkingLot, startTime, endTime, checkOutTime, type) async{
    var parkingDocument = await Firestore.instance.collection("parkingLot").document(parkingLot).get();
    var normalFee = endTime.difference(startTime).inMinutes * (parkingDocument["parkingLotNormalRate"]/60);
    print(parkingDocument["parkingLotNormalRate"]/30);
    if (type == "checkout"){
      if (checkOutTime.isAfter(endTime)){
        //late
        return normalFee + checkOutTime.difference(endTime).inMinutes * (parkingDocument["parkingLotLateFee"]/60);
      }
      else{
        //normal
        return normalFee.toInt();
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