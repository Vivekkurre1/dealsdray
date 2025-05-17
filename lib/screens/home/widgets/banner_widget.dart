import 'package:dealsdray/helpers/price_helpers.dart';
import 'package:dealsdray/models/promo_banner.dart';
import 'package:flutter/material.dart';

class PromoBannerCard extends StatelessWidget {
  final PromoBanner banner;

  const PromoBannerCard({super.key, required this.banner});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      // height: 160,
      margin: const EdgeInsets.only(right: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2C0E4A), Color(0xFF6D1A51)],
        ),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            right: 8,
            child: ClipRect(
              child: Container(
                color: Colors.transparent,
                height: 120,
                width: 100,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 4,
                  child: Transform.scale(
                    scale: 1.2,
                    child: Image.asset(
                      banner.imageUrl,
                      height: 120,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  banner.title,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  banner.subtitle,
                  style: const TextStyle(fontSize: 7, color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  banner.highlightText,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyanAccent,
                  ),
                ),
                Text(
                  banner.highlightDescription,
                  style: const TextStyle(
                    fontSize: 7,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  banner.source,
                  style: const TextStyle(fontSize: 6, color: Colors.white60),
                ),
                const SizedBox(height: 6),
                Text(
                  banner.emiText,
                  style: const TextStyle(
                    fontSize: 8,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "from ${currencyFormat(banner.currency)}${formatPrice(banner.price)}",
                  style: const TextStyle(fontSize: 8, color: Colors.white),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      height: 18,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Text(
                        banner.buttonText,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 2,
                        horizontal: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        banner.availability,
                        style: const TextStyle(
                          fontSize: 7,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
