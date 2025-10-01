import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/book_model.dart';

class BookService {
  final CollectionReference bookCollection =
  FirebaseFirestore.instance.collection("books");

  /// Create Book
  Future<void> createBook(BookModel model) async {
    final doc = bookCollection.doc();
    final newmodel = BookModel(
      bookId: doc.id,
      userId: model.userId,
      imageUrl: model.imageUrl,
      name: model.name,
      description: model.description,
      price: model.price,
    );
    await doc.set(newmodel.toJson());
  }

  /// Get Books by User
  Future<List<BookModel>> getUserBooks(String userId) async {
    final snapshot =
    await bookCollection.where("userId", isEqualTo: userId).get();

    return snapshot.docs
        .map((doc) => BookModel.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  /// ✅ Update Existing Book
  Future<void> updateBook(BookModel book) async {
    await bookCollection.doc(book.bookId).update(book.toJson());
  }

  /// ✅ Delete Book
  Future<void> deleteBook(String bookId) async {
    try {
      await bookCollection.doc(bookId).delete();
    } catch (e) {
      throw Exception("Failed to delete book: $e");
    }
  }
}