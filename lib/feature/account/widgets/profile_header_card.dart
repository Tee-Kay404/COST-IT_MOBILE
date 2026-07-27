import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.fullName,
    required this.email,
    this.photoUrl,
    this.onEditTap,
    this.onAvatarTap,
    this.avatarRadius = 58,
    this.titleStyle,
    this.subtitleStyle,
    this.customBadge,
    this.backgroundColor,
  });

  final String fullName;
  final String email;
  final Color? backgroundColor;
  final String? photoUrl;
  final VoidCallback? onEditTap;
  final VoidCallback? onAvatarTap;
  final double avatarRadius;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final Widget? customBadge;

  @override
  Widget build(BuildContext context) {
    final initial = email.isNotEmpty ? email[0].toUpperCase() : 'G';
    final isNetworkAvatar = photoUrl != null && photoUrl!.isNotEmpty;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              GestureDetector(
                onTap: onAvatarTap,
                child: CircleAvatar(
                  radius: avatarRadius.r,
                  backgroundColor:
                      backgroundColor ??
                      CostItColors.primary.withValues(alpha: 0.10),
                  backgroundImage: isNetworkAvatar
                      ? NetworkImage(photoUrl!)
                      : null,
                  child: !isNetworkAvatar
                      ? Text(
                          initial,
                          style: context.bodyLarge?.copyWith(
                            fontSize: (avatarRadius * 0.9).sp,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).brightness == Brightness.dark
                                ? context.color.onPrimary
                                : context.color.primary,
                          ),
                        )
                      : null,
                ),
              ),
              if (customBadge != null || onEditTap != null)
                Positioned(
                  bottom: 0,
                  right: 8.r,
                  child:
                      customBadge ??
                      GestureDetector(
                        onTap: onEditTap,
                        child: Container(
                          height: 35.h,
                          width: 35.w,
                          padding: EdgeInsets.all(6.r),
                          decoration: BoxDecoration(
                            color: CostItColors.brightGrey.shade100,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.edit_outlined,
                            size: 16.sp,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ),
                ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            fullName,
            style:
                titleStyle ??
                context.bodyLarge?.copyWith(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.w700,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4.h),
          Text(
            email,
            style:
                subtitleStyle ??
                context.bodySmall?.copyWith(
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
