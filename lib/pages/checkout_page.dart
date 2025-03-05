import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> product;

  CheckoutPage({required this.product});

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  double totalCost = 0.0; // Store total cost after applying reward points
  int rewardPoints = 0;
  int userPoints = 0;
  bool useRewards = false;
  String? _selectedPaymentMethod;
  final List<String> paymentMethods = ["Credit/Debit Card", "UPI / Wallet", "Cash on Delivery"];

  @override
  void initState() {
    super.initState();
    _fetchUserPoints();
    totalCost = widget.product['price']?.toDouble() ?? 0.0; // Ensure price is treated as double
  }

  /// Fetches the user's current reward points from Firestore
  void _fetchUserPoints() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      setState(() {
        userPoints = userDoc.exists ? (userDoc.data()?['rewardPoints'] ?? 0) : 0;
      });
    }
  }

  /// Updates the user's reward points in Firestore
  Future<void> _updateUserPoints(int earnedPoints) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

      await FirebaseFirestore.instance.runTransaction((transaction) async {
        final userDoc = await transaction.get(userRef);
        int currentPoints = userDoc.exists ? (userDoc.data()?['rewardPoints'] ?? 0) : 0;

        int newPoints = currentPoints + earnedPoints;
        transaction.update(userRef, {'rewardPoints': newPoints});
      });

      // Refresh user points after updating
      _fetchUserPoints();
    }
  }

  /// Places an order and updates reward points
  void _placeOrder() async {
    try {
      if (nameController.text.isEmpty || addressController.text.isEmpty || phoneController.text.isEmpty) {
        throw Exception("Please fill in all required fields.");
      }
      if (_selectedPaymentMethod == null) {
        throw Exception("Please select a payment method.");
      }

      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
        final userDoc = await userRef.get();

        int currentPoints = userDoc.exists ? (userDoc.data()?['rewardPoints'] ?? 0) : 0;
        int earnedPoints = ((widget.product['price'] ~/ 100) * 10); // 10 points per ₹100 spent
        int newPoints = currentPoints + earnedPoints;

        if (useRewards) {
          newPoints -= userPoints;
          if (newPoints < 0) newPoints = 0; // Prevent negative points
        }

        await userRef.update({'rewardPoints': newPoints});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Order Placed! 🎉 You earned $earnedPoints points.")),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(context, '/home');
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Checkout"),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputField("Full Name", nameController),
            _buildInputField("Shipping Address", addressController),
            _buildInputField("Phone Number", phoneController, keyboardType: TextInputType.phone),
            SizedBox(height: 20),

            // Earned Rewards Section
            Text("💎 Earn Rewards", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("You will earn **$rewardPoints points** on this purchase.", style: TextStyle(fontSize: 16, color: Colors.blue)),
            SizedBox(height: 10),

            // Display Total Cost
            Text(
              "Total Cost: ₹$totalCost",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            SizedBox(height: 10),

            // Checkbox for redeeming points
            CheckboxListTile(
              title: Text("Redeem $userPoints points for discount"),
              value: useRewards,
              onChanged: (bool? value) {
                setState(() {
                  useRewards = value ?? false;
                  totalCost = useRewards
                      ? (widget.product['price'] - userPoints).clamp(0, widget.product['price']).toDouble()
                      : widget.product['price'].toDouble();
                });
              },
            ),

            SizedBox(height: 20),

            // Select Payment Method
            Text("💳 Select Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: _selectedPaymentMethod,
              items: paymentMethods.map((method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Choose payment method",
              ),
            ),
            SizedBox(height: 20),

            // Confirm Order Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: _placeOrder,
                child: Text("Confirm Order", style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      ),
    );
  }
}
