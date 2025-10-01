// services/priority_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/book_model.dart';

class PriorityService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<BookModel>> getPriorityBooks() async {
    try {
      final snapshot = await _firestore.collection('books').get();

    /// Group books by userId
      Map<String, List<BookModel>> userBooks = {};
      for (var doc in snapshot.docs) {
        final book = BookModel.fromJson(doc.data());
        if (book.userId != null) {
          userBooks.putIfAbsent(book.userId!, () => []).add(book);
        }
      }

      // Interleave books by index
      List<BookModel> priorityList = [];
      int index = 0;
      bool moreBooks = true;

      while (moreBooks) {
        moreBooks = false;

        for (var userId in userBooks.keys) {
          final books = userBooks[userId]!;
          if (index < books.length) {
            priorityList.add(books[index]);
            moreBooks = true;
          }
        }

        index++;
      }

      return priorityList;
    } catch (e) {
      print('Error fetching priority books: $e');
      return [];
    }
  }
}