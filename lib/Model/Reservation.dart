class Reservation{
  final String parkingLotID;
  final String parkingSlotID;
  final DateTime reservationCheckInTime;
  final DateTime reservationCheckOutTime;
  final DateTime reservationDate;
  final bool reservationDiscount;
  final DateTime reservationEndTime;
  final int reservationFee;
  final DateTime reservationStartTime;
  final int reservationStatus;
  final bool reservationSlotReallocation;
  final bool reservationPenalty;
  final int reservationPenaltyFee;
  final String userID;
  final String vehiclePlateNumber;

  Reservation({this.parkingLotID, this.parkingSlotID, this.reservationCheckInTime, this.reservationCheckOutTime, this.reservationDate, this.reservationDiscount, this.reservationEndTime,this.reservationFee, this.reservationPenalty, this.reservationPenaltyFee, this.reservationSlotReallocation, this.reservationStartTime, this.reservationStatus, this.userID, this.vehiclePlateNumber});
}