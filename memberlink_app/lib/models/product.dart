class ProductList {
  List<Product>? data;

  ProductList(this.data);

  ProductList.fromJson(List<dynamic> json) {
    data = json.map((productJson) => Product.fromJson(productJson)).toList();
  }
}

class Product {
  String? productId;
  String? productName;
  String? productDesc;
  int? productQuantity;
  double? productPrice;
  String? productFilename;
  String? productDate;

  Product(
      {this.productId,
      this.productName,
      this.productDesc,
      this.productQuantity,
      this.productPrice,
      this.productFilename,
      this.productDate});

  Product.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    productName = json['product_name'];
    productDesc = json['product_desc'];
    productQuantity = json['product_quantity'] != null
        ? int.tryParse(json['product_quantity'].toString())
        : null; // Parse as int

    productPrice = json['product_price'] != null
        ? double.tryParse(json['product_price'].toString())
        : null;
    productFilename = json['product_filename'];
    productDate = json['product_date'];
  }

  // get id => null;

  // get price => null;

  // get title => null;

  // Null get imagePath => null;

  //String get image => null;

  //String get image => null;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['product_name'] = productName;
    data['product_desc'] = productDesc;
    data['product_quantity'] = productQuantity?.toString();
    data['product_price'] = productPrice?.toString();
    data['product_filename'] = productFilename;
    data['product_date'] = productDate;
    return data;
  }
}
