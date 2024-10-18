class CartItem {
  final String userId;
  final String productId;
  final int quantity;

  CartItem({
    required this.userId,
    required this.productId,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': {
        'userId': userId,
        'productId': productId,
      },
      'quantity': quantity,
    };
  }
}