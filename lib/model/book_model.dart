class BookModel {
  final String? bookId;
  final String? userId;
  final String? imageUrl;
  final String? name;
  final String? description;
  final String? price;

  BookModel({
    this.bookId,
    this.userId,
    this.imageUrl,
    this.name,
    this.description,
    this.price,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) => BookModel(
    bookId: json["bookId"],
    userId: json["userId"],
    imageUrl: json["imageUrl"] ?? json["imageUrl1"],
    name: json["name"],
    description: json["description"],
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "bookId": bookId,
    "userId": userId,
    "imageUrl": imageUrl,
    "name": name,
    "description": description,
    "price": price,
  };
}