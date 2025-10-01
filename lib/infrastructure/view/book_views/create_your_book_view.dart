import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../model/book_model.dart';
import '../../../provider/user_provider.dart';
import '../../../services/book_services.dart';

class CreateYourBookView extends StatefulWidget {
  const CreateYourBookView({super.key});

  @override
  State<CreateYourBookView> createState() => _CreateYourBookViewState();
}

class _CreateYourBookViewState extends State<CreateYourBookView> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final BookService _bookService = BookService();

  Future<void> _submitBook() async {
    if (!_formKey.currentState!.validate()) return;

    final user = Provider.of<UserProvider>(context, listen: false).currentUser;
    if (user == null) return;

    final book = BookModel(
      bookId: null,
      userId: user.docId,
      imageUrl: _imageUrlController.text.trim(),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      price: _priceController.text.trim(),
    );

    await _bookService.createBook(book);
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
        title: const Text("Create Your Book",
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
                validator: (value) =>
                value!.isEmpty ? "Book name is required" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _descriptionController,
                label: "Description",
                icon: Icons.description,
                maxLines: 4,
                validator: (value) =>
                value!.isEmpty ? "Description cannot be empty" : null,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _priceController,
                label: "Price",
                icon: Icons.attach_money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a price";
                  }
                  if (double.tryParse(value) == null) {
                    return "Enter a valid number";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _imageUrlController,
                label: "Image URL",
                icon: Icons.image,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Image URL is required";
                  }
                  if (!Uri.parse(value).isAbsolute) {
                    return "Enter a valid URL";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _submitBook,
                icon: const Icon(Icons.save_alt_rounded, color: Colors.white),
                label: const Text("Save Book",
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