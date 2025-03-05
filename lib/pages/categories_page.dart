import 'package:flutter/material.dart';

class CategoriesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Categories",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.8,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return _buildCategoryTile(
              categories[index]['name']!,
              categories[index]['image']!,
            );
          },
        ),
      ),
    );
  }

  Widget _buildCategoryTile(String name, String imagePath) {
    return GestureDetector(
      onTap: () {
        print("$name category clicked");
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imagePath,
              height: 120,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  width: double.infinity,
                  color: Colors.grey[300],
                  child: Icon(Icons.image, size: 50, color: Colors.grey[600]),
                );
              },
            ),
          ),
          SizedBox(height: 8),
          Text(
            name,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// Category List with Names and Image Paths
final List<Map<String, String>> categories = [
  {"name": "Men", "image": "assets/images/men.png"},
  {"name": "Women", "image": "assets/images/women.png"},
  {"name": "Kids", "image": "assets/images/kids.png"},
  {"name": "Footwear", "image": "assets/images/footwear.png"},
  {"name": "Accessories", "image": "assets/images/accessories.png"},
  {"name": "Beauty", "image": "assets/images/beauty.png"},
];
