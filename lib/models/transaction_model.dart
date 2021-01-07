class TransactionModel {
  String id;
  String name;
  int price;
  String from;
  String to;
  int date;
  String productId;

  TransactionModel(
      {this.id,
      this.name,
      this.price,
      this.from,
      this.to,
      this.date,
      this.productId});

  factory TransactionModel.fromJson(Map json) {
    return TransactionModel(
      id: json['_id'],
      name: json['name'],
      price: json['price'],
      from: json['from'],
      to: json['to'],
      date: json['date'],
      productId: json['productId'],
    );
  }

  Map toMap() {
    var map = new Map();
    map["_id"] = id;
    map["name"] = name;
    map["price"] = price;
    map["from"] = from;
    map["to"] = to;
    map["date"] = date;
    map["productId"] = productId;

    return map;
  }
}
