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

  final _identifierController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _submitted = false;
  bool _isFilled = false;

  String? identifierError;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    _tabController.addListener(() {
      setState(() {
        _isFilled = _identifierController.text.trim().isNotEmpty;
      });
    });
  }

  AutovalidateMode get _autovalidateMode => _submitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  void _checkFields(String value) {
    setState(() {
      _isFilled = value.trim().isNotEmpty;

      if (identifierError != null) {
        identifierError = null;
      }
    });
  }

  Future<void> _next() async {
    setState(() {
      _submitted = true;
      identifierError = null;
    });

    if (!(_formKey.currentState?.validate() ?? false)) return;

    final identifier = _identifierController.text.trim();

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
            'identifier': (msg) => setState(() => identifierError = msg),
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
          identifier: _identifierController.text,
          nextRoute: PageRoutes.login,
        ),
      );
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _identifierController.dispose();
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
                      // EMAIL
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
                              controller: _identifierController,
                              hintText: 'Enter Email...',
                              keyboardType: TextInputType.emailAddress,
                              prefixIcon: const Icon(
                                Icons.email_outlined,
                                size: 17,
                              ),
                              validator: Validators.validateEmail,
                              onChanged: _checkFields,
                              errorText: identifierError,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            '''Please input your registered email for transparency. We'll send you a mail. Check your mail box and Follow the instructions sent to you to reset password''',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: CostItColors.brightGrey.shade600,
                            ),
                          ),
                        ],
                      ),

                      // PHONE
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
                              controller: _identifierController,
                              hintText: 'Enter phone number',
                              keyboardType: TextInputType.phone,
                              prefixIcon: Icon(
                                Icons.phone_rounded,
                                size: 17.sp,
                              ),
                              validator: Validators.validatePhone,
                              onChanged: _checkFields,
                              errorText: identifierError,
                            ),
                          ),
                          Gap(20.h),
                          Text(
                            '''Please input your registered phoneNo for transparency. An OTP will be sent to you. Do not let anyone see it. Check your SMS box and use OTP to reset password.''',
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
                // disabled: CostItColors.disabled,
              ),

              Gap(20.h),
            ],
          ),
        ),
      ),
    );
  }
}
