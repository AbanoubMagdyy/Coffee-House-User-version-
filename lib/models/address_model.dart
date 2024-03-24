class AddressModel {
    String title;
   String address;

  AddressModel({required this.title, required this.address});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      title: json['Title'],
      address: json['Address'],
    );
  }


    Map<String, dynamic> toJson() {
      return {
        'Title': title,
        'Address': address,
      };
    }

}