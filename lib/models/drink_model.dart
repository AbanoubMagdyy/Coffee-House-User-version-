class DrinkModel{
  late String drinkName;
  late String image;
  late String category;
  late String description;
  late bool isNew;
  late bool isRecommendation;
  late dynamic price;
  late dynamic rate;
  late dynamic numberOfTimesSold;

  DrinkModel({required this.drinkName});

  DrinkModel.fromJson(Map<String, dynamic> json){
    drinkName = json['Name'];
    price = json['Price'];
    image = json['Image'];
    description = json['Description'];
    category = json['Category'];
    rate = json['Rate'];
    isNew = json['New'];
    isRecommendation = json['Recommendation'];
    numberOfTimesSold = json['Number of times sold'];
  }

  DrinkModel.fromJsonForFavoriteAndPastOrders(Map<String, dynamic> json){
    drinkName = json['Name'];
    price = json['Price'];
    image = json['Image'];
    description = json['Description'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'Name': drinkName,
      'Price': price,
      'Image': image,
      'Description': description,
      'Rate': rate,
    };
  }

}