import 'package:dealsdray/models/product.dart';
import 'package:dealsdray/screens/home/widgets/product_widget.dart';
import 'package:flutter/material.dart';

class DecoratedContainer extends StatelessWidget {
  const DecoratedContainer({super.key, required this.productList});

  final List<Product> productList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color.fromARGB(255, 51, 131, 168),
                  Color.fromARGB(255, 89, 191, 239),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: -120,
            child: Container(
              width: 300,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
          ),
          Positioned(
            bottom: -20,
            left: -40,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.18),
              ),
            ),
          ),

          //  Heading text (optional)
          const Positioned(
            top: 10,
            left: 16,
            child: Text(
              "EXCLUSIVE FOR YOU",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),

          //  Horizontal product list
          Positioned.fill(
            top: 48,
            bottom: 20,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: productList.length,
              itemBuilder: (context, index) {
                final product = productList[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: ProductCard(product: product),
                );
              },
            ),
          ),

          //  Top right icon button
          Positioned(
            top: 0,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.arrow_forward, color: Colors.white),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
