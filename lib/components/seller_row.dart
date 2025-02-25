import 'package:flutter/cupertino.dart';

class SellerRow extends StatelessWidget {
  final String sellerName;
  final int price;
  final String condition;
  final VoidCallback onPurchase;

  const SellerRow({
    Key? key,
    required this.sellerName,
    required this.price,
    required this.condition,
    required this.onPurchase,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CupertinoColors.systemGrey6,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 판매자 프로필 아이콘
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: CupertinoColors.systemGrey,
            ),
            child: const Icon(
              CupertinoIcons.person_solid,
              color: CupertinoColors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sellerName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      '$price원',
                      style: const TextStyle(
                        fontSize: 14,
                        color: CupertinoColors.activeBlue,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      '•',
                      style: TextStyle(color: CupertinoColors.systemGrey),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: CupertinoColors.systemGrey6,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        condition,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: CupertinoColors.activeBlue,
            borderRadius: BorderRadius.circular(8),
            onPressed: onPurchase,
            child: const Text(
              '구매',
              style: TextStyle(color: CupertinoColors.white),
            ),
          ),
        ],
      ),
    );
  }
}
