import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/global/errors/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/global/exception.dart';
import 'package:cost_it_mobile/app/global/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/auth/views/sign_up_view.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class CompleteProfileView extends ConsumerStatefulWidget {
  const CompleteProfileView({super.key});

  @override
  ConsumerState<CompleteProfileView> createState() =>
      _CompleteProfileViewState();
}

class _CompleteProfileViewState extends ConsumerState<CompleteProfileView> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _submitted = false;
  bool _obscured = true;
  bool _obscuredConfirm = true;
  String? passwordError;
  // Pre-fill from Google data
  @override
  void initState() {
    super.initState();
    final user = ref.read(appStateProvider).user;
    if (user != null) {
      _firstNameController.text = user.firstName;
      _lastNameController.text = user.lastName;
    }
  }

  Future<void> _complete() async {
    setState(() => _submitted = true);
    if (!_formKey.currentState!.validate()) return;

    final payload = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phoneNumber': _phoneController.text,
      'password': _passwordController.text,
    };

    final result = await futureProgressCaller(
      context,
      loaderType: LoaderType.popup,
      loadingMessage: 'Saving profile...',
      computation: () => ref.read(completeProfileProvider(payload).future),
      onError: (error) {
        final ex = error is GlobalException ? error : null;
        showErrorExceptionToast(
          context,
          ex?.message ?? 'Failed to save profile',
        );
        return null;
      },
    );

    if (result != null && context.mounted) {
      // Update state with completed profile
      ref
          .read(appStateProvider.notifier)
          .updateAppState((s) => s.copyWith(user: result));
      Navigator.pushReplacementNamed(context, PageRoutes.dashBoard.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // don't let them skip this
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.sp),
            child: Form(
              key: _formKey,
              autovalidateMode: _submitted
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(30.h),
                    Text(
                      'Complete Your Profile',
                      style: context.bodyLarge?.copyWith(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: context.color.primary,
                      ),
                    ),
                    Gap(8.h),
                    Text(
                      'Just a few more details to get you started.',
                      style: context.bodySmall?.copyWith(
                        color: CostItColors.brightGrey.shade500,
                      ),
                    ),
                    Gap(30.h),
                    FieldLabel('First Name *'),
                    CostItFormfield(
                      controller: _firstNameController,
                      hintText: 'First name',
                      validator: Validators.isNotEmpty,
                    ),
                    Gap(16.h),
                    FieldLabel('Last Name *'),
                    CostItFormfield(
                      controller: _lastNameController,
                      hintText: 'Last name',
                      validator: Validators.isNotEmpty,
                    ),
                    Gap(16.h),
                    FieldLabel('Phone Number *'),
                    CostItFormfield(
                      controller: _phoneController,
                      hintText: '080 000 000 00',
                      keyboardType: TextInputType.phone,
                      validator: Validators.validatePhone,
                    ),
                    Gap(16.h),
                    const FieldLabel('Password *'),

                    CostItFormfield(
                      hintText: 'Create a strong password',
                      controller: _passwordController,
                      obscureText: _obscured,
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.lock(PhosphorIconsStyle.bold),
                        size: 20.sp,
                      ),
                      
                      suffixIcon: GestureDetector(
                        onTap: () => setState(() => _obscured = !_obscured),
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Image.asset(
                              _obscured
                                  ? AppImages.invisible
                                  : AppImages.visible,
                              key: ValueKey(_obscured),
                              width: 22.w,
                              height: 22.h,
                              color: CostItColors.brightGrey.shade800,
                            ),
                          ),
                        ),
                      ),
                      errorText: passwordError,
                      validator: Validators.validatePassword,
                    ),

                    Gap(16.h),
                    const FieldLabel('Confirm Password *'),

                    CostItFormfield(
                      hintText: 'Re-enter your password',
                      controller: _confirmPasswordController,
                      obscureText: _obscuredConfirm,
                      onChanged: (_) => setState(() => passwordError = null),
                      prefixIcon: PhosphorIcon(
                        PhosphorIcons.lock(PhosphorIconsStyle.bold),
                        size: 20.sp,
                      ),
                                suffixIcon: GestureDetector(
                        onTap: () => setState(
                          () => _obscuredConfirm = !_obscuredConfirm,
                        ),
                        
                        child: Padding(
                          padding: EdgeInsets.all(12.w),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: Image.asset(
                              _obscuredConfirm
                                  ? AppImages.invisible
                                  : AppImages.visible,
                              key: ValueKey(_obscuredConfirm),
                              width: 22.w,
                              height: 22.h,
                              color: CostItColors.brightGrey.shade800,
                            ),
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return Validators.isNotEmpty(value);
                        }
                        return Validators.isEqualTo(
                          value,
                          compareValue: _passwordController.text,
                          errorMessage: 'Passwords do not match',
                        );
                      },
                    ),
                    Gap(30.h),
                    SharedButton(text: 'Continue', onPressed: _complete),
                    Gap(20.h),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
