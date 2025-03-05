import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            Text(
              "Myntra",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Spacer(),
            Text(
              "BECOME INSIDER >",
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
        actions: [
          Icon(Icons.notifications_none, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.favorite_border, color: Colors.black),
          SizedBox(width: 16),
          Icon(Icons.account_circle, color: Colors.black),
          SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for brands and products",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),

            // HIM / HER Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  "assets/images/1.png",
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            SizedBox(height: 16),

            // Price Store Section
            _buildPriceStore(),

            // All-Time Faves Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "ALL-TIME FAVES\nCurated For You",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            _buildFavesGrid(),

            SizedBox(height: 16),

            // 🔹 Explore Button
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/product'); // ✅ Navigates to Product Page
                },
                child: Text(
                  "Explore More",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            SizedBox(height: 20),
          ],
        ),
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.pink,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: "Categories",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
        onTap: (index) {
          String currentRoute = ModalRoute.of(context)?.settings.name ?? "";
          String newRoute = "";

          switch (index) {
            case 0:
              newRoute = '/home';
              break;
            case 1:
              newRoute = '/categories';
              break;
            case 2:
              newRoute = '/profile';
              break;
          }

          if (currentRoute != newRoute) {
            Navigator.pushNamed(context, newRoute);
          }
        },
      ),
    );
  }

  Widget _buildPriceStore() {
    return Container(
      color: Colors.orange.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "PRICE STORE",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
                fontSize: 16,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPriceTile("Under ₹99"),
              _buildPriceTile("Under ₹199"),
              _buildPriceTile("Under ₹299"),
              _buildPriceTile("Under ₹399"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceTile(String text) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange, width: 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.orange,
          ),
        ),
      ),
    );
  }

  Widget _buildFavesGrid() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.count(
        shrinkWrap: true,
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.75,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildFaveItem("Under ₹799", "assets/images/item1.png"),
          _buildFaveItem("Under ₹699", "assets/images/item2.png"),
          _buildFaveItem("Under ₹599", "assets/images/item3.png"),
          _buildFaveItem("Under ₹499", "assets/images/item4.png"),
        ],
      ),
    );
  }

  Widget _buildFaveItem(String price, String imagePath) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imagePath,
            height: 140,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(height: 8),
        Text(
          price,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
