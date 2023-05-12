class PackageModel {
  String? packageId,
      packageName,
      agencyId,
      agencyName,
      imageOfPlace,
      cost,
      description,
      days;
  PackageModel({
    this.packageId,
    this.agencyName,
    this.imageOfPlace,
    this.cost,
    this.description,
    this.days,
    this.agencyId,
    this.packageName,
  });
  factory PackageModel.fromMap(Map<String, dynamic> map) {
    return PackageModel(
        packageId: map["packageId"],
        agencyName: map["agencyName"],
        imageOfPlace: map["imageOfPlace"],
        cost: map["cost"],
        description: map["description"],
        days: map["days"],
        agencyId: map["agencyId"],
        packageName: map["packageName"]);
  }
  Map<String, dynamic> toMap() {
    return {
      "packageId": packageId,
      "packageName": packageName,
      "agencyName": agencyName,
      "imageOfPlace": imageOfPlace,
      "cost": cost,
      "description": description,
      "days": days,
      "agencyId": agencyId,
    };
  }
}
