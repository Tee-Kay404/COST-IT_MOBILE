import 'package:cost_it_mobile/app/global/dialog/app_message_dialog.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/custom_clipper.dart';
import 'package:cost_it_mobile/feature/account/view/manage_profile/utils/edit_profile_form.dart';
import 'package:cost_it_mobile/feature/account/widgets/profile_header_card.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/arrow_back_button.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/service/auth_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cost_it_mobile/feature/account/services/profile_photo_service.dart';
import 'package:cost_it_mobile/feature/products/product_details/components/image_viewer_overlay.dart';
import 'package:cost_it_mobile/feature/account/widgets/modals.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends ConsumerState<EditProfileView> {
  bool isEditing = false;

  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  final _firstNameFocusNode = FocusNode();

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
          debugPrint('[EditProfileView] Profile photo updated → $newUrl');
        }
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            ScaffoldMessage(
              message: 'Profile photo updated!',
              context: context,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('[EditProfileView] Profile photo upload failed: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          ScaffoldMessage(
            message: 'Upload failed, Please try again!',
            context: context,
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

  Future<void> _showPhotoOptionsSheet(String? photoUrl) async {
    if (photoUrl == null || photoUrl.isEmpty) {
      _onAvatarTap();
      return;
    }

    final result = await ModalOptionsSheet.show(
      context,
      title: 'Profile Photo',
      options: viewOrEditPhotoOptions,
    );

    if (!mounted) return;

    if (result == 'view') {
      ImageViewerOverlay.show(context, images: [photoUrl]);
    } else if (result == 'edit') {
      _onAvatarTap();
    }
  }

  @override
  void initState() {
    super.initState();
    final user = ref.read(appStateProvider).user;
    _firstNameController.text = user?.firstName ?? '';
    _lastNameController.text = user?.lastName ?? '';
    _emailController.text = user?.email ?? '';
    _phoneController.text = user?.phoneNumber ?? '';
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _firstNameFocusNode.dispose();
    super.dispose();
  }

  Future<void> _toggleEdit() async {
    final user = ref.read(appStateProvider).user;

    if (isEditing) {
      final oldEmail = user?.email ?? '';
      final newEmail = _emailController.text.trim();

      if (oldEmail.isNotEmpty && newEmail != oldEmail) {
        // Email has changed, trigger OTP flow
        final shouldVerify = await showAppMessageDialog(
          context,
          'Verify New Email',
          Icons.mark_email_unread_outlined,
          'You need to verify your new email address before we can save it.',
          'Verify',
        );

        if (shouldVerify == true && mounted) {
          final authService = ref.read(authServiceProvider);
          final result = await futureProgressCaller<String>(
            context,
            loaderType: LoaderType.snack,
            loadingMessage: 'Sending OTP...',
            computation: () =>
                authService.sendUpdateEmailOtp({'newEmail': newEmail}),
            onError: (error) {
              ErrorHandler.handle(context, error);
              return null;
            },
          );

          if (result != null && mounted) {
            Navigator.pushNamed(
              context,
              PageRoutes.emailVerification.name,
              arguments: newEmail,
            );
            return; // Don't exit edit mode o
          }
        } else {
          return; // They cancelled verification, stay in edit mode
        }
      } else {
        // Just save other fields
        // In production, dispatch an update to the backend/provider here
        showSuccessToast(context, 'Profile updated successfully!');
      }
    }

    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _firstNameFocusNode.requestFocus();
        });
      }
    });
  }

  Future<void> _handleBack() async {
    if (!isEditing) {
      Navigator.pop(context);
      return;
    }

    final shouldDiscard = await showDiscardChangesDialog(context);

    if (shouldDiscard == true) {
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final user = ref.watch(appStateProvider).user;
    final photoUrl = user?.photoUrl;
    final emailStr = user?.email ?? '';
    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final fullName = [firstName, lastName].where((s) => s.isNotEmpty).join(' ');

    return PopScope(
      canPop: !isEditing,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldDiscard = await showDiscardChangesDialog(context);
        if (shouldDiscard == true) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: CurvedBottomClipper(),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height * 0.22,
                  color: context.color.primary,
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + 5.h, 
                    left: 10.w, 
                    right: 10.w,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ArrowBackButton(
                            color: CostItColors.white,
                            size: 28.sp,
                            onPressed: _handleBack,
                          ),
                          TextButton(
                            onPressed: _toggleEdit,
                            child: Text(
                              isEditing ? 'Save' : 'Edit',
                              style: context.titleMedium?.copyWith(
                                color: context.color.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Transform.translate(
                offset: Offset(0, -110.r),
                child: Column(
                  children: [
                    ProfileHeaderCard(
                      fullName: fullName,
                      email: emailStr,
                      photoUrl: photoUrl,
                      avatarRadius: 80,
                      onEditTap: _onAvatarTap,
                      onAvatarTap: () => _showPhotoOptionsSheet(photoUrl),
                      titleStyle: context.titleLarge?.copyWith(fontSize: 28.sp),
                      subtitleStyle: context.bodyMedium?.copyWith(
                        color: context.color.onSurface.withValues(alpha: 0.6),
                        fontSize: 16.sp,
                      ),
                      backgroundColor: isDark
                          ? Color(0xFF3D4F8A)
                          : CostItColors.brightGrey.shade200,
                    ),
                    if (_isUploading) ...[
                      Gap(12.h),
                      Center(
                        child: Column(
                          children: [
                            SizedBox(
                              width: 140.w,
                              child: LinearProgressIndicator(
                                value: _uploadProgress,
                                backgroundColor: context.color.primary
                                    .withValues(alpha: 0.1),
                                color: context.color.primary,
                                borderRadius: BorderRadius.circular(4.r),
                              ),
                            ),
                            Gap(6.h),
                            Text(
                              'Uploading... ${(_uploadProgress * 100).toInt()}%',
                              style: context.bodySmall?.copyWith(
                                color: CostItColors.brightGrey.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              Transform.translate(
                offset: Offset(0, -110.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    children: [
                      Gap(40.h),
                      EditProfileForm(
                        firstNameController: _firstNameController,
                        lastNameController: _lastNameController,
                        emailController: _emailController,
                        phoneController: _phoneController,
                        firstNameFocusNode: _firstNameFocusNode,
                        isEditing: isEditing,
                        isEmailVerified: user?.isVerified ?? false,
                        isPhoneVerified: user?.isPhoneVerified ?? false,
                        onVerifyPhone: () async {
                          final authService = ref.read(authServiceProvider);
                          final result = await futureProgressCaller<String>(
                            context,
                            loaderType: LoaderType.snack,
                            loadingMessage: 'Sending OTP...',
                            computation: () =>
                                authService.sendPhoneVerificationOtp(),
                            onError: (error) {
                              ErrorHandler.handle(context, error);
                              return null;
                            },
                          );
                          if (result != null && context.mounted) {
                            Navigator.pushNamed(
                              context,
                              PageRoutes.phoneVerification.name,
                              arguments: user?.phoneNumber ?? '',
                            );
                          }
                        },
                      ),
                      Gap(40.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
