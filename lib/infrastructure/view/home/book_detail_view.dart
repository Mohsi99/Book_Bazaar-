import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../model/book_model.dart';

class BookDetailView extends StatelessWidget {
  final BookModel book;

  const BookDetailView({super.key, required this.book});

  String _safe(String? v, String fallback) =>
      (v == null || v.isEmpty) ? fallback : v;

  String _pages() {
    return book.description != null && book.description!.length > 10
        ? ((book.description!.length * 2) % 500 + 50).toString()
        : '250';
  }

  String _rating() {
    final base = (book.name?.length ?? 4) % 5;
    final r = (3.5 + base * 0.3);
    return r.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF6C63FF);
    const Color bgColor = Color(0xFFF5F5F5);

    final cover = _safe(book.imageUrl, 'https://picsum.photos/600/900');
    final title = _safe(book.name, 'Untitled Book');
    final author = _safe(null, 'Unknown Author');
    final priceText = book.price != null && book.price!.isNotEmpty
        ? 'PKR ${book.price}'
        : 'Free';
    final rating = _rating();
    final pages = _pages();
    final language = 'Eng';
    final synopsis = _safe(book.description,
        'No synopsis available. This book provides an engaging read with thoughtful insights and compelling storytelling.');

    const double buyBarHeight = 76.0;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.only(bottom: buyBarHeight + 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Hero(
                    tag: book.bookId ?? title,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.42,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: NetworkImage(cover),
                          fit: BoxFit.cover,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          author,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _StatItem(
                              icon: Icons.star,
                              title: rating,
                              subtitle: 'Rating',
                              color: Colors.amber[700]!),
                          _StatItem(
                              icon: Icons.menu_book,
                              title: pages,
                              subtitle: 'Pages',
                              color: primaryColor),
                          _StatItem(
                              icon: Icons.language,
                              title: language,
                              subtitle: 'Lang',
                              color: Colors.teal),
                          _StatItem(
                              icon: Icons.monetization_on,
                              title: priceText,
                              subtitle: 'Price',
                              color: Colors.green),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      'Synopsis',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[900],
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Synopsis text card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        synopsis,
                        style: TextStyle(
                            fontSize: 15, color: Colors.grey[800], height: 1.5),
                      ),
                    ),
                  ),

                  const SizedBox(height: 22),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _InfoChip(
                              icon: Icons.category, label: 'Category: Fiction'),
                          const SizedBox(width: 8),
                          _InfoChip(
                              icon: Icons.calendar_today,
                              label: 'Published: 2023'),
                          const SizedBox(width: 8),
                          _InfoChip(
                              icon: Icons.person, label: 'Publisher: ABC'),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Top-left back button (floating)
            Positioned(
              top: 18,
              left: 12,
              child: CircleAvatar(
                backgroundColor: Colors.black.withOpacity(0.55),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          color: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                // TODO: buy action
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Buy tapped')));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                  const SizedBox(width: 12),
                  Text(
                    'Buy Now • ${priceText}',
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  const _StatItem(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.color,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: color.withOpacity(0.12),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(height: 6),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(subtitle,
              style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey[700]),
          const SizedBox(width: 8),
          Text(label, style: TextStyle(color: Colors.grey[800], fontSize: 13)),
        ],
      ),
    );
  }
}
