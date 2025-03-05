import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myntra_clone/pages/login_page.dart';
// import 'package:myntra_clone/pages/productDetails_page.dart';
import 'package:myntra_clone/pages/profile_page.dart';
import 'package:myntra_clone/pages/signup_page.dart';
import 'package:myntra_clone/pages/home_page.dart';
import 'package:myntra_clone/pages/categories_page.dart';
import 'package:myntra_clone/pages/product_page.dart';
// import; 'package:myntra_clone/pages/productDetails_page.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // ✅ Ensures Flutter binding is initialized
  await Firebase.initializeApp(); // ✅ Initializes Firebase before running the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Myntra Clone',
      debugShowCheckedModeBanner: false,
      initialRoute: '/login', // ✅ Set Login Page as the default route
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/home': (context) => HomePage(),
        '/categories': (context) => CategoriesPage(),
        '/profile': (context) => ProfilePage(),
        '/product': (context) => ProductPage(),
        // '/productDetails': (context) => ProductDetailsPage(product: {},),

      },
    );
  }
}
