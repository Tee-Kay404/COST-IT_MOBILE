import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DescriptionSection extends StatelessWidget {
  final Product product;
  final bool isExpanded;
  final VoidCallback onToggle;

  const DescriptionSection({
    super.key,
    required this.product,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final fullText =
        product.description != null && product.description!.isNotEmpty
        ? product.description!
        : 'No description available.';

    final displayText = isExpanded
        ? fullText
        : fullText.substring(0, fullText.length > 120 ? 120 : fullText.length);

    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: context.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.color.onPrimary,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isExpanded ? displayText : '$displayText...',
            style: context.bodySmall?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.grey.shade300
                  : Colors.grey.shade700,
              height: 1.6,
            ),
          ),
          SizedBox(height: 6.h),
          GestureDetector(
            onTap: onToggle,
            child: Text(
              isExpanded ? 'Show less' : 'Read more',
              style: context.bodySmall?.copyWith(
                color: context.color.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
