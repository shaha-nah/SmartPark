import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smartpark/Model/ParkingLot.dart';
import 'package:smartpark/Model/Reservation.dart';
import 'package:smartpark/Model/System.dart';
import 'package:smartpark/Model/Vehicle.dart';
import 'package:smartpark/RouteTransition.dart';
import 'package:smartpark/Wrapper.dart';

class User {
  final String uid;
  final String userName;
  final String userPhoneNumber;
  final String userEmail;
  final String userPassword;
  final String userCredit;
  final String userRole;

  User({this.uid, this.userName, this.userPhoneNumber, this.userEmail, this.userPassword, this.userCredit, this.userRole});

  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  Future<String> getCurrentUser() async {
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    return uid;
  }

  Stream<User> get user {
    return FirebaseAuth.instance.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future<void> updateUserData(String userName, String userEmail, String userPhoneNumber, int userCredit)async {
    return await Firestore.instance.collection("user").document(uid).setData({
      'userName': userName,
      'userEmail': userEmail,
      'userPhoneNumber': userPhoneNumber,
      'userCredit': userCredit,
      'userRole': "normal"
    });
  }

  Future signUp(String name, String email, String phoneNumber, String password, context) async {
    try {
      AuthResult result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      //create a new document for the user with the uid
      await User(uid: user.uid)
          .updateUserData(name, email, phoneNumber, 1000)
          .then((_) {
          user.sendEmailVerification();
        Navigator.push(context, RouteTransition(page: Wrapper()));
      });
      // return _userFromFirebaseUser(user);
      return null;
    } catch (e) {
      print(e.toString());
      if (e.toString() ==
          "PlatformException(error, Given String is empty or null, null)") {
        return "Please fill in all the fields";
      }
      if (e.toString() ==
          "PlatformException(ERROR_INVALID_EMAIL, The email address is badly formatted., null)") {
        return "Please enter a valid email";
      }
      if (e.toString() ==
          "PlatformException(ERROR_WEAK_PASSWORD, The given password is invalid. [ Password should be at least 6 characters ], null)") {
        return "Please enter a password with at least 6 characters";
      }
      if (e.toString() ==
          "PlatformException(ERROR_EMAIL_ALREADY_IN_USE, The email address is already in use by another account., null)") {
        return "This email address is already in use by another account";
      }
    }
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

      return user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future signOut(context) async {
    try {
      await FirebaseAuth.instance.signOut().then((_) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Wrapper()));
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future<bool> changePassword(String password) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    bool change = true;
    await user.updatePassword(password).then((_) {
      print("Password changed");
      change = true;
    }).catchError((error) {
      print("error" + error.toString());
      print("1");
      change = false;
    });
    return change;
  }

  Future<void> deleteAccount() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    user.delete().then((_){
      print("User deleted");
    }).catchError((error) {
      print("User can't be deleted: " + error.toString());
    });
    return null;
  }

  Future<DocumentSnapshot> getUserDetails() async {
    final String uid = await getCurrentUser();
    DocumentSnapshot result = await Firestore.instance.collection('user').document(uid).get();
    return result;
  }

  Stream userData() async*{
    final String uid = await getCurrentUser();
    yield* Firestore.instance.collection("user").document(uid).snapshots();
  }

  Future addVehicle(String vehiclePlateNumber) async {
    String userID = await getCurrentUser();
    List<dynamic> vehicles = await Vehicle().getVehiclePlateNumbers();
    print(vehicles);
    if (vehicles.contains(vehiclePlateNumber)){
      return false;
    }
    else{
      await Firestore.instance.collection("vehicle").document().setData({
        'vehiclePlateNumber': vehiclePlateNumber,
        'userID': userID,
        'markAsDeleted': false
      });
      return true;
    }
  }

  Future<bool> makeReservation(DateTime date, DateTime startTime, DateTime endTime, String parkingLot, String parkingSlot, String vehiclePlateNumber) async{
    var userID = await getCurrentUser();
  
    var fee = await System().calculateFee(parkingLot, startTime, endTime, endTime, "normal");

    var result = await System().checkSlotAvailability(date, startTime, endTime, parkingSlot);
    
    if (result){
      await Firestore.instance.collection("reservation").document().setData({
        "parkingLotID": parkingLot,
        "parkingSlotID": parkingSlot,
        "reservationDate": date,
        "reservationEndTime": endTime,
        "reservationFee": fee,
        "reservationStartTime": startTime,
        "reservationStatus": 1,
        "reservationSlotReallocation": "",
        "userID": userID,
        "vehicleID": vehiclePlateNumber
      });
      return true;
    }
    else{
      return false;
    }
  }

  Future<String> getCurrentReservation() async{
    final String userID = await getCurrentUser();
    var reservations = await Firestore.instance.collection("reservation").where("userID", isEqualTo: userID).getDocuments();
    List<DocumentSnapshot> reservation = reservations.documents;
    for (int i = 0; i< reservation.length; i++){
      if (reservation[i].data["reservationStatus"] < 5){
        return reservation[i].documentID;
      }
    }
    return "none";
  }

  Future<DocumentSnapshot> getReservationDetails() async{
    final reservationID = await getCurrentReservation();
    var reservationDocument = await Firestore.instance.collection("reservation").document(reservationID).get();
    return reservationDocument;
  }

  Stream getReservationData() async*{
    final reservationID = await getCurrentReservation();
    yield* Firestore.instance.collection("reservation").document(reservationID).snapshots();
  }

  Future<List<dynamic>> getParkingHistory() async{
    String userID = await getCurrentUser();
    var result = await Firestore.instance.collection('reservation').where("userID", isEqualTo: userID).orderBy("reservationDate", descending: true).getDocuments();
    List<DocumentSnapshot> templist = result.documents;
    List<dynamic> list = templist.map((DocumentSnapshot snapshot){
      return snapshot.data;
    }).toList();
    return list;
  }

  Future cancelReservation() async{
    String currentReservation = await getCurrentReservation();
    await Firestore.instance.collection("reservation").document(currentReservation).updateData({
      "reservationStatus": 7
    });
  }

  Future checkOut() async{
    var currentReservationID = await getCurrentReservation();
    var currentReservation = await getReservationDetails();
    var fee;
    
    fee = await System().calculateFee(currentReservation["parkingLotID"], currentReservation["reservationStartTime"].toDate(), currentReservation["reservationEndTime"].toDate(), currentReservation["reservationCheckOutTime"].toDate(), "checkout");
    
    await Firestore.instance.collection("reservation").document(currentReservationID).updateData({
      "reservationFee": fee
    });
  }

  Future makePayment(price, type) async{
    final String userID = await getCurrentUser();
    final String reservationID = await getCurrentReservation();
    final Reservation _reservation = Reservation();

    DocumentSnapshot userDocument = await Firestore.instance.collection("user").document(userID).get();
    var credit = userDocument["userCredit"];
    if (credit < price){
      return false;
    }
    else{
      await Firestore.instance.collection("user").document(userID).updateData({
        "userCredit": FieldValue.increment(-price)
      }).then((value)async {
        if (type == "expired"){
          await _reservation.setReservationExpired();
        }
        else if (type == "cancelled"){
          print("boo");
          await cancelReservation();
        }
        else{
          await Firestore.instance.collection("reservation").document(reservationID).updateData({
            "reservationPayment": "Completed",
            "reservationStatus": FieldValue.increment(1)
          });
        }
      });
      return true;
    }
  }

  Future changeVehicle(vehicle) async{
    final String reservationID = await getCurrentReservation();

    await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "vehicleID": vehicle
    });
  }

  Future deleteVehicle(vehicle) async{
    var querySnapshotVehicle = await Firestore.instance.collection("vehicle").where("vehiclePlateNumber", isEqualTo: vehicle).getDocuments();
    List<DocumentSnapshot> documentSnapshotVehicle = querySnapshotVehicle.documents;
    documentSnapshotVehicle.forEach((vehicle) async{ 
      var vehicleID = vehicle.documentID;
      await Firestore.instance.collection("vehicle").document(vehicleID).updateData({
        "markAsDeleted": true
      });
    });
  }

  Future editProfile(name, phoneNumber) async{
    final String userID = await getCurrentUser();
    await Firestore.instance.collection("user").document(userID).updateData({
      "userName": name,
      "userPhoneNumber": phoneNumber
    });
  }

  Future changeReservation(date, startTime, endTime) async{
    String parkingSlot = await  System().findParkingSlot(date, startTime, endTime);
    String parkingLot = await ParkingLot().getParkingLot(parkingSlot);

    String reservation = await getCurrentReservation();

    var fee = await System().calculateFee(parkingLot, startTime, endTime, endTime, "normal");

    return await Firestore.instance.collection("reservation").document(reservation).updateData({
      "reservationDate": date,
      "reservationStartTime": startTime,
      "reservationEndTime": endTime,
      "parkingLotID": parkingLot,
      "parkingSlotID": parkingSlot,
      "reservationStatus": 1,
      "reservationFee": fee,
      "reservationPenalty": false
    });
  }

  Future extendReservation(endTime) async{
    String reservationID = await getCurrentReservation();
    DocumentSnapshot reservation = await getReservationDetails();

    var fee = await System().calculateFee(reservation["parkingLotID"], reservation["reservationStartTime"].toDate(), endTime, endTime, "normal");

    return await Firestore.instance.collection("reservation").document(reservationID).updateData({
      "reservationEndTime": endTime,
      "reservationFee": fee
    });
  }

  Future<void> recharge(amount) async{
    String userID = await getCurrentUser();
    await Firestore.instance.collection("user").document(userID).updateData({
      "userCredit": FieldValue.increment(int.parse(amount))
    });
  }
}
