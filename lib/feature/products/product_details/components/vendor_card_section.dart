// lib/feature/products/product_details/components/vendor_card_section.dart

import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VendorCardSection extends StatelessWidget {
  final Product product;

  const VendorCardSection({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.surface,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: context.color.primary,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    product.vendor.name.isNotEmpty
                        ? product.vendor.name[0].toUpperCase()
                        : 'V',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.vendor.name,
                      style: context.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    if (product.vendor.isVerified)
                      Row(
                        children: [
                          Icon(
                            Icons.verified_rounded,
                            size: 12.sp,
                            color: context.color.primary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Verified Vendor',
                            style: context.bodySmall?.copyWith(
                              color: context.color.primary,
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 2.h),
                    Text(
                      '1+ years on CostIt  •  online 5 min ago',
                      style: context.bodySmall?.copyWith(
                        color: Colors.grey.shade500,
                        fontSize: 11.sp,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View all >',
                  style: context.bodySmall?.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_outlined,
                  size: 12.sp,
                  color: Colors.grey.shade600,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Typically replies within minutes',
                  style: context.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Feedback about vendor',
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  'View all (17) >',
                  style: context.bodySmall?.copyWith(
                    color: context.color.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 12.sp,
                  ),
                ),
              ),
            ],
          ),
          _ReviewCard(
            name: 'Emeka Okonkwo',
            date: '12/04/26',
            rating: 5,
            text:
                'Delivered on time. Quality was top-notch. Will order again for my next phase.',
            avatarColor: Colors.teal,
          ),
          SizedBox(height: 10.h),
          _ReviewCard(
            name: 'Fatima Bello',
            date: '03/03/26',
            rating: 4,
            text:
                'Good experience overall. Pricing was fair and the specs were correct.',
            avatarColor: Colors.purple,
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  final String name;
  final String date;
  final int rating;
  final String text;
  final Color avatarColor;

  const _ReviewCard({
    required this.name,
    required this.date,
    required this.rating,
    required this.text,
    required this.avatarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16.r,
                backgroundColor: avatarColor,
                child: Text(
                  name[0],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: context.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (i) => Icon(
                          i < rating
                              ? Icons.star_rounded
                              : Icons.star_outline_rounded,
                          size: 13.sp,
                          color: const Color(0xFFFFAB40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                date,
                style: context.bodySmall?.copyWith(
                  color: Colors.grey.shade400,
                  fontSize: 11.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            text,
            style: context.bodySmall?.copyWith(
              color: Colors.grey.shade700,
              height: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              _ReviewAction(icon: Icons.thumb_up_outlined, label: 'Like'),
              SizedBox(width: 16.w),
              _ReviewAction(icon: Icons.reply_rounded, label: 'Comment'),
              const Spacer(),
              Icon(Icons.more_horiz, size: 16.sp, color: Colors.grey.shade400),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReviewAction extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ReviewAction({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: Colors.grey.shade500),
        SizedBox(width: 4.w),
        Text(
          label,
          style: context.bodySmall?.copyWith(
            color: Colors.grey.shade500,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }
}