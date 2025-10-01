// providers/book_provider.dart
import 'package:flutter/material.dart';
import '../model/book_model.dart';
import '../services/book_services.dart';

class BookProvider extends ChangeNotifier {
  final BookService _bookService = BookService();
  List<BookModel> _books = [];

  List<BookModel> get books => _books;

  Future<void> fetchUserBooks(String userId) async {
    _books = await _bookService.getUserBooks(userId);
    notifyListeners();
  }

  Future<void> addBook(BookModel model) async {
    await _bookService.createBook(model);
    await fetchUserBooks(model.userId!);
  }
  Future<void> deleteBook(String bookId) async {
    await _bookService.deleteBook(bookId);
    _books.removeWhere((book) => book.bookId == bookId);
    notifyListeners();
  }
}