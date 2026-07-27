import 'dart:ui';
import 'package:cost_it_mobile/widgets/dialogbox.dart';

import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/account/models/account_data.dart';
import 'package:cost_it_mobile/feature/account/services/profile_photo_service.dart';
import 'package:cost_it_mobile/feature/account/widgets/logout_sheet.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/shared/appBar/costit_app_bar.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/image_viewer_overlay.dart';
import 'package:cost_it_mobile/feature/account/widgets/modals.dart';
import '../models/account.dart';


class AccountView extends ConsumerStatefulWidget {
  const AccountView({super.key});

  @override
  ConsumerState<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends ConsumerState<AccountView> {
  bool _isUploading = false;
  double _uploadProgress = 0.0;

  Future<void> _onAvatarTap() async {
    final source = await _showPhotoSourceSheet();
    if (source == null) return;

    setState(() {
      _isUploading = true;
      _uploadProgress = 0.0;
    });

    try {
      final service = ref.read(profilePhotoServiceProvider);
      final newUrl = await service.pickAndUpload(
        source: source,
        onProgress: (p) {
          if (mounted) setState(() => _uploadProgress = p);
        },
      );

      if (newUrl != null) {
        // Update local app state so the UI reflects the new photo immediately
        final currentUser = ref.read(appStateProvider).user;
        if (currentUser != null) {
          ref
              .read(appStateProvider.notifier)
              .updateUser(currentUser.copyWith(photoUrl: newUrl));
          debugPrint('[AccountView] Profile photo updated → $newUrl');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo updated!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[AccountView] Profile photo upload failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed. Please try again.'),
            backgroundColor: Colors.red.shade700,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  Future<ImageSource?> _showPhotoSourceSheet() async {
    final result = await ModalOptionsSheet.show(
      context,
      title: 'Change Profile Photo',
      options: changePhotoOptions,
    );
    if (result == 'gallery') return ImageSource.gallery;
    if (result == 'camera') return ImageSource.camera;
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(appStateProvider).user;

    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final joined = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    final fullName = joined.isEmpty ? 'Guest' : joined;
    final userEmail = user?.email ?? '';
    final photoUrl = user?.photoUrl;

    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: CostItBackAppBar(
        title: 'My Profile',
        showBackButton: false,
        leadingWidth: 60.w,
        leading: PopupMenuButton<void>(
          tooltip: '',
          offset: Offset(0, 48.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          itemBuilder: (context) => [
            PopupMenuItem<void>(
              enabled: false,
              child: Text(
                userEmail.isEmpty ? 'Guest' : userEmail,
                style: context.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: context.color.onSurface,
                ),
              ),
            ),
          ],
          child: Padding(
            padding: EdgeInsets.only(left: 15.w),
            child: Center(child: const AvatarThumb()),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, PageRoutes.settings.name);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    child: Container(
                      width: 38.w,
                      height: 38.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(40),
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: Colors.white.withAlpha(60),
                          width: 1,
                        ),
                      ),
                      child: Icon(
                        Icons.settings_outlined,
                        color: Colors.white,
                        size: 24.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(10.h),
                ProfileHeaderCard(
                  fullName: fullName,
                  email: userEmail,
                  photoUrl: photoUrl,
                  onAvatarTap: (photoUrl != null && photoUrl.isNotEmpty) 
                      ? () => ImageViewerOverlay.show(context, images: [photoUrl]) 
                      : _onAvatarTap,
                  // ── Tappable camera badge instead of edit icon ──────
                  customBadge: (photoUrl != null && photoUrl.isNotEmpty) || _isUploading
                      ? null
                      : GestureDetector(
                          onTap: _onAvatarTap,
                          child: Container(
                            height: 36.h,
                            width: 36.w,
                            decoration: BoxDecoration(
                              color: context.color.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.18),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.camera_alt,
                              size: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ),
                ),

                // ── Upload progress bar (shown below avatar during upload) ──
                if (_isUploading) ...[
                  Gap(12.h),
                  Center(
                    child: SizedBox(
                      width: 200.w,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.r),
                            child: LinearProgressIndicator(
                              value: _uploadProgress > 0 ? _uploadProgress : null,
                              minHeight: 6.h,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                context.color.primary,
                              ),
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            _uploadProgress > 0
                                ? 'Uploading... ${(_uploadProgress * 100).toStringAsFixed(0)}%'
                                : 'Preparing...',
                            style: context.bodySmall?.copyWith(
                              color: Colors.grey.shade500,
                              fontSize: 11.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                Gap(20.h),

                ...accountSections.expand(
                  (section) => [
                    AccountSection(
                      title: section['sectionTitle'] as String,
                      tiles: (section['tiles'] as List<Map<String, dynamic>>).map((
                        tile,
                      ) {
                        final title = tile['title'] as String;
                        return AccountTileModel(
                          title: title,
                          icon: tile['icon'] as IconData,
                          route: tile['route'] as String?,
                          valueLabel: tile['valueLabel'] as String?,
                          badgeCount: tile['badgeCount'] as int?,
                          hasNotificationDot:
                              tile['hasNotificationDot'] as bool? ?? false,
                          iconColor:
                              title == 'Vendor Dashboard' ||
                                  title == 'My Listings' ||
                                  title == 'Payouts & Earnings'
                              ? context.color.secondary
                              : null,
                          customTrailing: title == 'Vendor Dashboard'
                              ? const TilePillBadge(label: 'Manage')
                              : null,
                          onTap: title == 'Rate the App'
                              ? () => _launchStoreReview(context)
                              : null,
                        );
                      }).toList(),
                    ),
                    Gap(32.h),
                  ],
                ),

                Gap(40.h),

                LogoutButton(onTap: () => _confirmLogout(context, ref)),

                Gap(100.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, WidgetRef ref) {
    showLogoutSheet(context);
  }

  void _launchStoreReview(BuildContext context) {
    showFeatureNotEnabledDialog(context);
  }
}
