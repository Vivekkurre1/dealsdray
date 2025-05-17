class PromoBanner {
  final String id;
  final String imageUrl;
  final String title;
  final String subtitle;
  final String highlightText;
  final String highlightDescription;
  final String source;
  final String emiText;
  final double price;
  final String currency;
  final String availability;
  final String buttonText;

  PromoBanner({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.subtitle,
    required this.highlightText,
    required this.highlightDescription,
    required this.source,
    required this.emiText,
    required this.price,
    required this.currency,
    required this.availability,
    required this.buttonText,
  });

  factory PromoBanner.fromJson(Map<String, dynamic> json) {
    return PromoBanner(
      id: json['id'] as String,
      imageUrl: json['imageUrl'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      highlightText: json['highlightText'] as String,
      highlightDescription: json['highlightDescription'] as String,
      source: json['source'] as String,
      emiText: json['emiText'] as String,
      price: double.parse(json['price'] as String),
      currency: json['currency'] as String,
      availability: json['availability'] as String,
      buttonText: json['buttonText'] as String,
    );
  }
}
