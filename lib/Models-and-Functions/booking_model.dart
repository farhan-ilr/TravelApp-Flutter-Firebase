class BookingModel {
  String? bookId,packageId,userId,agencyId,packageName,userName,agencyName,
      personCount,bookingdate,bookedDate;
  BookingModel({
    this.bookId,this.agencyId,this.packageId,this.agencyName,this.packageName,
    this.userId,this.userName,this.personCount,this.bookingdate,this.bookedDate,});
  BookingModel.fromMap(Map<String, dynamic> map) {
    bookId = map["bookId"];
    agencyId = map["agencyId"];
    userId = map["userId"];
    packageId = map["packageId"];
    agencyName = map["agencyName"];
    packageName = map["packageName"];
    userName = map["userName"];
    personCount = map["personCount"];
    bookingdate = map["bookingdate"];
    bookedDate = map["bookedDate"];}
  Map<String, dynamic> toMap() {
    return {
      "bookId": bookId,
      "agencyId": agencyId,
      "userId": userId,
      "packageId": packageId,
      "agencyName": agencyName,
      "packageName": packageName,
      "userName": userName,
      "personCount": personCount,
      "bookingdate": bookingdate,
      "bookedDate": bookedDate};}}
