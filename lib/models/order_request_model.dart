class OrderRequestModel{
  late String drink;
  late dynamic numberOfDrinks;
  late dynamic priceOfDrinks;
  late dynamic totalPriceOfDrinks;

  OrderRequestModel({
    required this.drink,
    required this.numberOfDrinks,
    required this.priceOfDrinks,
    required this.totalPriceOfDrinks,
  });

  Map<String, dynamic> toMap() {
    return {
      'Drink': drink,
      'Number of drinks': numberOfDrinks,
      'Price of drinks': priceOfDrinks,
      'Total price of drinks': totalPriceOfDrinks,
    };
  }

}