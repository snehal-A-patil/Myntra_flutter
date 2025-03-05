import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int rewardPoints = 0;
  String userName = "Guest";

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Fetch user data (name and reward points) from Firestore
 void _fetchUserData() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user != null) {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
    if (userDoc.exists) {
      setState(() {
        rewardPoints = userDoc.data()?['rewardPoints'] ?? 0;
        userName = userDoc.data()?['name'] ?? user.email!.split('@')[0]; // Show email username if no name is set
      });
    }
  }
}



  /// Update reward points after a purchase
  void updateRewardPoints(double amountSpent) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDocRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final userDoc = await userDocRef.get();

      if (userDoc.exists) {
        int currentPoints = userDoc.data()?['rewardPoints'] ?? 0;
        int newPoints = (amountSpent ~/ 100) * 10; // 10 points per ₹100 spent
        int updatedPoints = currentPoints + newPoints;

        await userDocRef.update({'rewardPoints': updatedPoints});

        setState(() {
          rewardPoints = updatedPoints; // Update UI
        });
      }
    }
  }

  /// Call this function after a purchase is completed
  void completePurchase(double totalAmount) {
    updateRewardPoints(totalAmount); // Update reward points based on purchase amount
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          "Profile",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 50, color: Colors.grey[600]),
                ),
                SizedBox(height: 10),
               Text(
  "Welcome, $userName",
  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
),

              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.star, color: Colors.amber),
            title: Text("Reward Points"),
            subtitle: Text("You have $rewardPoints points"),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildMenuItem(Icons.shopping_bag, "Orders", "Check your order status"),
                _buildMenuItem(Icons.help_outline, "Help Center", "Help regarding your purchases"),
                _buildMenuItem(Icons.favorite_border, "Wishlist", "Your most loved styles"),
                _buildMenuItem(Icons.qr_code, "Scan for coupon", ""),
                Divider(thickness: 10, color: Colors.grey[200]),
                _buildFooterItem("FAQs"),
                _buildFooterItem("ABOUT US"),
                _buildFooterItem("TERMS OF USE"),
                _buildFooterItem("PRIVACY POLICY"),
                _buildFooterItem("GRIEVANCE REDRESSAL"),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "APP VERSION 4.2501.13",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle) {
    return ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: subtitle.isNotEmpty ? Text(subtitle, style: TextStyle(color: Colors.grey)) : null,
      trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {
        // Handle navigation
      },
    );
  }

  Widget _buildFooterItem(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title,
        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
      ),
    );
  }
}
