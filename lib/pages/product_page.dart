import 'package:flutter/material.dart';
import 'product_details_page.dart';

class ProductPage extends StatelessWidget {
  final List<Map<String, dynamic>> products = [
    {
      "image": "assets/images/product1.png",
      "name": "Elegant Blue Maxi Dress",
      "rating": 4.5,
      "price": 2500,
      "description": "A stunning blue maxi dress perfect for evening occasions.",
      "sizes": ["S", "M", "L", "XL"],
      "material": "Silk",
      "brand": "Zara",
      "care": "Dry Clean Only",
      "color": "Blue",
      "pattern": "Solid",
      "deliveryDate": "Feb 20, 2025",
    },
    {
      "image": "assets/images/product2.png",
      "name": "Classic Red Evening Gown",
      "rating": 4.7,
      "price": 5000,
      "description": "A classic red gown with a sleek design for a stylish look.",
      "sizes": ["S", "M", "L"],
      "material": "Velvet",
      "brand": "Gucci",
      "care": "Hand Wash",
      "color": "Red",
      "pattern": "Solid",
      "deliveryDate": "Feb 22, 2025",
    },
    {
      "image": "assets/images/product3.png",
      "name": "Floral Summer Dress",
      "rating": 4.6,
      "price": 3200,
      "description": "A beautiful floral summer dress for a fresh and stylish look.",
      "sizes": ["XS", "S", "M", "L"],
      "material": "Cotton",
      "brand": "H&M",
      "care": "Machine Wash",
      "color": "White",
      "pattern": "Floral",
      "deliveryDate": "Feb 25, 2025",
    },
    {
      "image": "assets/images/product4.png",
      "name": "Black Bodycon Dress",
      "rating": 4.8,
      "price": 4200,
      "description": "A chic black bodycon dress to enhance your evening elegance.",
      "sizes": ["S", "M", "L"],
      "material": "Polyester",
      "brand": "Versace",
      "care": "Hand Wash",
      "color": "Black",
      "pattern": "Solid",
      "deliveryDate": "Feb 28, 2025",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dresses Collection", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: GridView.builder(
          itemCount: products.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final product = products[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailPage(product: product),
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Expanded(child: Image.asset(product["image"], fit: BoxFit.cover)),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text(product["name"], 
                              textAlign: TextAlign.center, 
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("₹${product["price"]}", 
                              style: TextStyle(color: Colors.red, fontSize: 16)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
