import 'package:flutter/material.dart';
import '../model/book_model.dart';
import '../services/priority_service.dart';

class PriorityProvider extends ChangeNotifier {
  final PriorityService _priorityService = PriorityService();

  List<BookModel> _priorityBooks = [];
  List<BookModel> get priorityBooks => _priorityBooks;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  PriorityProvider() {
    loadPriorityBooks();
  }

  Future<void> loadPriorityBooks() async {
    _isLoading = true;
    notifyListeners();

    _priorityBooks = await _priorityService.getPriorityBooks();

    _isLoading = false;
    notifyListeners();
  }
}