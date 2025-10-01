import 'package:book_bazar/infrastructure/view/book_views/update_your_book_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/book_model.dart';
import '../../../provider/book_provider.dart';
import '../../../provider/user_provider.dart';
import '../profile_views/update_profile_view.dart';
import 'create_your_book_view.dart';

class YourBooksView extends StatefulWidget {
  const YourBooksView({super.key});

  @override
  State<YourBooksView> createState() => _YourBooksViewState();
}

class _YourBooksViewState extends State<YourBooksView> {
  @override
  void initState() {
    super.initState();
    _fetchUserBooks();
  }

  Future<void> _fetchUserBooks() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final bookProvider = Provider.of<BookProvider>(context, listen: false);
    final userId = userProvider.currentUser?.docId;
    if (userId != null) {
      await bookProvider.fetchUserBooks(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final bookProvider = Provider.of<BookProvider>(context);

    final user = userProvider.currentUser;
    final userId = user?.docId ?? '';

    final userBooks =
        bookProvider.books.where((book) => book.userId == userId).toList();

    final showViewAll = userBooks.length > 4;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFFF7F7F9),
        centerTitle: true,
        title: Row(
          children: [
            GestureDetector(
              onTap: () async{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UpdateProfileView(),
                    ));
                await _fetchUserBooks();

              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: user?.profileImageUrl != null &&
                        user!.profileImageUrl!.isNotEmpty
                    ? NetworkImage(user.profileImageUrl!)
                    : const AssetImage('assets/default_profile.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              "Your Books",
              style: TextStyle(
                color: Color(0xFF6C63FF),
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF6C63FF)),
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CreateYourBookView()),
              );

              await _fetchUserBooks();
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFF7F7F9),
        child: Column(
          children: [
            Expanded(
              child: userBooks.isEmpty
                  ? const Center(child: Text("No books found"))
                  : GridView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: userBooks.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.65,
                      ),
                      itemBuilder: (context, index) {
                        final book = userBooks[index];
                        return Card(
                          color: Colors.white,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Book Image
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: AspectRatio(
                                    aspectRatio: 4 / 4,
                                    child: Image.network(
                                      book.imageUrl ?? '',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) =>
                                          const Center(
                                              child: Icon(Icons.broken_image)),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Book Name
                                Text(
                                  book.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),

                                const SizedBox(height: 4),
                                Text(
                                  book.description ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12),
                                ),
                                const SizedBox(height: 4),

                                // Book Price and Edit Button Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'PKR ${book.price}',
                                      style: const TextStyle(
                                          color: Colors.green,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                UpdateYourBookView(book: book),
                                          ),
                                        );
                                        // 👇 Refresh book list after returning
                                        await _fetchUserBooks();
                                      },
                                      child: const CircleAvatar(
                                        radius: 14,
                                        backgroundColor: Color(0xFFDDEEFF),
                                        child: Icon(Icons.edit,
                                            size: 16, color: Colors.blue),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C63FF),
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const CreateYourBookView()),
                  );

                  await _fetchUserBooks();
                },
                child: const Text(
                  "Add New Book",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
