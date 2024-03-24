class RatingModel{
  late String name;
  late String comment;
  late String email;
  late String phoneNumber;
  late int rate;
  late List<dynamic> goodThings;

  RatingModel(
      {
        required this.comment,
        required this.name,
        required  this.email,
        required  this.rate,
        required  this.phoneNumber,
        required  this.goodThings,
      });

  RatingModel.fromJson(Map<String, dynamic> json){
    name = json['Name'];
    email = json['Email'];
    rate = json['Rate'];
    comment = json['Comment'];
    goodThings = json['Good things'];
    phoneNumber = json['Phone number'];
  }

  Map<String, dynamic> toMap(){
    return {
      'Name' : name,
      'Comment' : comment,
      'Email' : email,
      'Good things' : goodThings,
      'Phone number' : phoneNumber,
      'Rate' : rate,
    };
  }
}