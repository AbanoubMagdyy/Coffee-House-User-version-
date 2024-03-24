class UserModel{
  late String name;
  late String image;
  late String email;
  late String phoneNumber;
  late String theDateOfJoin;
  late bool doYouRateUs;
  late List<dynamic> favoriteDrinks;
  late List<dynamic> addresses;

  UserModel(
      {
       required this.image,
        required this.name,
        required  this.email,
        required this.favoriteDrinks,
        required  this.phoneNumber,
        required  this.theDateOfJoin,
        required  this.addresses,
        required  this.doYouRateUs,
      });

  UserModel.fromJson(Map<String, dynamic> json){
    name = json['Name'];
    email = json['Email'];
    image = json['Image'];
    addresses = json['Addresses'];
    doYouRateUs = json['Do you rate us'];
    theDateOfJoin = json['The date of join'];
    phoneNumber = json['Phone number'];
  }

  Map<String, dynamic> toMap(){
    return {
      'Name' : name,
      'Image' : image,
      'Email' : email,
      'Do you rate us' : doYouRateUs,
      'Addresses' : addresses,
      'The date of join' : theDateOfJoin,
      'Phone number' : phoneNumber,
    };
  }
}