import 'package:flutter/material.dart';

class MyHeader extends StatelessWidget {
  const MyHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Builder(
          builder:
              (ctx) => IconButton(
                icon: Icon(Icons.menu, color: Colors.black87),
                onPressed: () {
                  // Handle menu button press
                },
              ),
        ),
        SizedBox(width: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            'assets/logo_placeholder.png',
            width: 38,
            height: 38,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 11),
        Expanded(
          child: Container(
            height: 38,
            decoration: BoxDecoration(
              color: Color(0xfff5f5f5),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey[600]),
                SizedBox(width: 7),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search here",
                      hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.notifications_none, size: 28, color: Colors.black),
          onPressed: () {
            // Handle notification button press
          },
        ),
      ],
    );
  }
}
