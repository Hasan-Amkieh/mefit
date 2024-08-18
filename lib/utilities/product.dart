
class Product {
  String name;
  String code;
  String brands;
  String quantity;
  Map<String, String> ingredients;
  String countriesSold;
  String categories;
  String imageURL;

  Product({required this.name, required this.code, required this.brands,
    required this.quantity, required this.ingredients, required this.categories,
    required this.countriesSold, required this.imageURL}) { // Some preprocessing:
    countriesSold = countriesSold.startsWith("en:") ? countriesSold.substring(3) : countriesSold;
  }
}
