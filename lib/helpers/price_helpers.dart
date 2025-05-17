String formatPrice(double price) {
  if (price.truncateToDouble() == price) {
    return price.truncate().toString();
  }
  return price.toStringAsFixed(2);
}

String currencyFormat(String currency) {
  switch (currency) {
    case 'INR':
      return '₹';
    case 'USD':
      return '\$';
    case 'EUR':
      return '€';
    case 'GBP':
      return '£';
    default:
      return currency;
  }
}

String formatDiscount(double discount) {
  if (discount.truncateToDouble() == discount) {
    return discount.truncate().toString();
  }
  return discount.toStringAsFixed(2);
}
