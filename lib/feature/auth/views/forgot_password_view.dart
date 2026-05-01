import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/button.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/dark_round_button.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class ForgotPasswordView extends ConsumerStatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ConsumerState<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends ConsumerState<ForgotPasswordView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Separate controllers for each tab
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool _submitted = false;

  // Separate filled-state trackers per tab
  bool _emailFilled = false;
  bool _phoneFilled = false;

  String? _emailError;
  String? _phoneError;

  // Convenience getter: active identifier based on current tab
  String get _activeIdentifier {
    if (_tabController.index == 0) {
      return _emailController.text.trim();
    }
    return _phoneController.text.trim();
  }

  bool get _isFilled =>
      _tabController.index == 0 ? _emailFilled : _phoneFilled;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Rebuild when the tab changes so _isFilled re-evaluates
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        // Reset submitted state when switching tabs so validations don't
        // immediately fire on the newly visible (possibly empty) field.
        setState(() {
          _submitted = false;
        });
      }
    });
  }

  AutovalidateMode get _autovalidateMode => _submitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  void _onEmailChanged(String value) {
    setState(() {
      _emailFilled = value.trim().isNotEmpty;
      if (_emailError != null) _emailError = null;
    });
  }

  void _onPhoneChanged(String value) {
    setState(() {
      _phoneFilled = value.trim().isNotEmpty;
      if (_phoneError != null) _phoneError = null;
    });
  }

  Future<void> _next() async {
    setState(() {
      _submitted = true;
      // Clear the error only for the active tab
      if (_tabController.index == 0) {
        _emailError = null;
      } else {
        _phoneError = null;
      }
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final identifier = _activeIdentifier;
    final payload = {"identifier": identifier};

    final result = await futureProgressCaller(
      loaderType: LoaderType.none,
      context,
      computation: () =>
          ref.read(generateForgotPasswordOTPProvider(payload).future),
      onError: (error) {
        ErrorHandler.handle(
          context,
          error,
          fieldErrors: {
            'identifier': (msg) => setState(() {
                  // Route the server error to the correct tab's error field
                  if (_tabController.index == 0) {
                    _emailError = msg;
                  } else {
                    _phoneError = msg;
                  }
                }),
          },
        );
        return null;
      },
    );

    if (result != null && context.mounted) {
      Navigator.pushNamed(
        context,
        PageRoutes.otpResetPassword.name,
        arguments: (
          identifier: identifier,
          nextRoute: PageRoutes.login,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 10.sp),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gap(20.h),

              BackArrowButton(),
              Gap(20.h),

              Text(
                'Reset Password?',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 25.sp,
                  color: context.color.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Gap(20.h),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your privacy is our priority.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                      color: CostItColors.brightGrey.shade600,
                    ),
                  ),
                  Gap(5.h),
                  Text(
                    "Cost-It ensures your account stays protected. ",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CostItColors.brightGrey.shade600,
                    ),
                  ),
                  Text(
                    "Ensure you conceal account details from anyone.",
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: CostItColors.brightGrey.shade600,
                    ),
                  ),
                  Gap(20.h),
                  Text(
                    "Choose a method to verify your identity:",
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),

              Gap(20.h),

              TabBar(
                controller: _tabController,
                indicatorColor: context.color.primary,
                labelColor: context.color.primary,
                unselectedLabelColor: Colors.grey,
                tabs: const [
                  Tab(text: "Email"),
                  Tab(text: "Phone"),
                ],
              ),

              Gap(20.h),

              Expanded(
                child: Form(
                  key: _formKey,
                  autovalidateMode: _autovalidateMode,
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // EMAIL TAB
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              "Enter your email address",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          Gap(10.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: CostItFormfield(
                              controller: _emailController,
                              hintText: 'Enter Email...',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                size: 17,
                              ),
                              validator: Validators.validateEmail,
                              onChanged: _onEmailChanged,
                              errorText: _emailError,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            "Please input your registered email for transparency. "
                            "We'll send you a mail. Check your mail box and follow "
                            "the instructions sent to you to reset your password.",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: CostItColors.brightGrey.shade600,
                            ),
                          ),
                        ],
                      ),

                      //  PHONE TAB
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: Text(
                              "Enter your phone number",
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                          Gap(10.h),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 5.0,
                            ),
                            child: CostItFormfield(
                              controller: _phoneController,
                              hintText: 'Enter phone number',
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icon(
                                Icons.phone_rounded,
                                size: 17.sp,
                              ),
                              validator: Validators.validatePhone,
                              onChanged: _onPhoneChanged,
                              errorText: _phoneError,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            "Please input your registered phone number for transparency. "
                            "An OTP will be sent to you. Do not let anyone see it. "
                            "Check your SMS box and use the OTP to reset your password.",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: CostItColors.brightGrey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              Gap(20.h),

              LoadingButton(
                onTap: _isFilled ? _next : null,
                text: 'Next',
              ),

              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}