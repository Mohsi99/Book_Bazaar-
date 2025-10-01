import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/book_model.dart';
import '../../../provider/user_provider.dart';
import '../../../services/book_services.dart';

class UpdateYourBookView extends StatefulWidget {
  final BookModel book;

  const UpdateYourBookView({super.key, required this.book});

  @override
  State<UpdateYourBookView> createState() => _UpdateYourBookViewState();
}

class _UpdateYourBookViewState extends State<UpdateYourBookView> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _imageUrlController;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  final BookService _bookService = BookService();

  @override
  void initState() {
    super.initState();
    _imageUrlController = TextEditingController(text: widget.book.imageUrl);
    _nameController = TextEditingController(text: widget.book.name);
    _descriptionController = TextEditingController(text: widget.book.description);
    _priceController = TextEditingController(text: widget.book.price);
  }

  Future<void> _updateBook() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user == null) return;

    final updatedBook = BookModel(
      bookId: widget.book.bookId,
      userId: user.docId,
      imageUrl: _imageUrlController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: _priceController.text.trim(),
    );
    await _bookService.updateBook(updatedBook);
    if (!mounted) return;
    Navigator.pop(context);
  }

  Future<void> _deleteBook() async {
    if (widget.book.bookId == null) return;
    await _bookService.deleteBook(widget.book.bookId!);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5F5),
        elevation: 0,
        title: const Text("Update Your Book",
            style: TextStyle(color: Color(0xFF6C63FF))),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(
                controller: _nameController,
                label: "Book Name",
                icon: Icons.book,
                validator: (v) =>
                v!.isEmpty ? "Book name cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                icon: Icons.description,
                maxLines: 4,
                validator: (v) =>
                v!.isEmpty ? "Description cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: "Price",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (v) =>
                double.tryParse(v ?? '') == null ? "Invalid price" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: "Image URL",
                icon: Icons.image,
                validator: (v) =>
                Uri.tryParse(v ?? '')?.isAbsolute != true
                    ? "Enter valid URL"
                    : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _updateBook,
                icon: const Icon(Icons.update_rounded, color: Colors.white),
                label: const Text("Update Book",
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: _deleteBook,
                child: const Text(
                  "Delete Book",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.underline,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF6C63FF)),
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}