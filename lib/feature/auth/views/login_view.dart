import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/app/global/providers.dart';
import 'package:cost_it_mobile/app/storage/app_storage.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/button.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/auth_header.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/auth/utils/socials/social_buttons.dart';
import 'package:cost_it_mobile/feature/auth/views/sign_up_view.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _identifierController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  AutovalidateMode get _autovalidateMode => _submitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  bool _obscured = true;
  bool _isTapped = false;
  bool _identifierHasText = false;
  bool _passwordHasText = false;
  bool _submitted = false;

  bool _rememberMe = false;

  String? identifierError;
  String? passwordError;

  void checkIdentifierHasText() {
    setState(() {
      _identifierHasText = _identifierController.text.isNotEmpty;
      if (identifierError != null) identifierError = null;
    });
  }

  void checkPasswordHasText() {
    setState(() {
      _passwordHasText = _passwordController.text.isNotEmpty;
      if (passwordError != null) passwordError = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _identifierController.addListener(checkIdentifierHasText);
    _passwordController.addListener(checkPasswordHasText);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _restoreRememberMe();
    });
  }

  Future<void> _restoreRememberMe() async {
    final service = ref.read(rememberMeServiceProvider);
    final savedId = await service.getSavedIdentifier();
    final isEnabled = await service.isEnabled();

    if (!mounted) return;

    setState(() {
      _rememberMe = isEnabled;
      if (savedId != null) {
        _identifierController.text = savedId;
        _identifierHasText = savedId.isNotEmpty;
      }
    });
  }

  @override
  void dispose() {
    _identifierController.removeListener(checkIdentifierHasText);
    _passwordController.removeListener(checkPasswordHasText);
    _identifierController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> login() async {
    setState(() => _submitted = true);

    if (_formKey.currentState?.validate() != true) return;

    setState(() {
      identifierError = null;
      passwordError = null;
    });

    final service = ref.read(rememberMeServiceProvider);
    if (_rememberMe) {
      await service.save(_identifierController.text.trim());
    } else {
      await service.clear();
    }

    final user = await futureProgressCaller(
      context,
      loaderType: LoaderType.none,
      computation: () => ref.read(
        loginFutureProvider({
          'identifier': _identifierController.text.trim(),
          'password': _passwordController.text,
        }).future,
      ),
      onError: (error) {
        ErrorHandler.handle(
          context,
          error,
          fieldErrors: {
            'identifier': (msg) => setState(() => identifierError = msg),
            'password': (msg) => setState(() => passwordError = msg),
          },
        );
        return null;
      },
    );

    if (user != null && context.mounted) {
      showCustomToast('Login Successful', CostItColors.success, context);
      ref
          .read(appStateProvider.notifier)
          .updateAppState((s) => s.copyWith(user: user));
      Navigator.of(context).pushReplacementNamed(PageRoutes.dashBoard.name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            AuthHeader(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(10.h),
                  SizedBox(
                    height: 60.h,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Image.asset(
                        AppImages.logo2,
                        height: 120.h,
                        width: 140.h,
                        color: Colors.yellow.shade600,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  Gap(10.h),
                  Text.rich(
                    textAlign: TextAlign.start,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Welcome Back! 👋\n',
                          style: context.bodyMedium?.copyWith(
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                            color: context.color.surface,
                          ),
                        ),
                        WidgetSpan(
                          child: Padding(padding: EdgeInsets.only(top: 30.h)),
                        ),
                        TextSpan(
                          text:
                              'Let\'s continue the journey smarter, faster and stronger!',
                          style: context.bodySmall?.copyWith(
                            color: context.color.surface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                child: AutofillGroup(
                  onDisposeAction: AutofillContextAction.commit,
                  child: Form(
                    key: _formKey,
                    autovalidateMode: _autovalidateMode,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.sp),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Login with your details below 👇',
                              style: context.bodySmall?.copyWith(
                                fontStyle: FontStyle.italic,
                                color: context.theme.primaryColorDark,
                              ),
                            ),
                          ),

                          SizedBox(height: 20.h),
                          FieldLabel('Username*'),

                          CostItFormfield(
                            borderRadius: BorderRadius.circular(
                              _identifierHasText ? 30 : 10,
                            ),
                            hintText: 'Enter email or phone number',
                            controller: _identifierController,
                            autofillHint: const [
                              AutofillHints.username,
                              AutofillHints.email,
                            ],
                            prefixIcon: PhosphorIcon(
                              PhosphorIcons.user(PhosphorIconsStyle.bold),
                              size: 17.sp,
                            ),
                            validator: Validators.isNotEmpty,
                            errorText: identifierError,
                          ),

                          SizedBox(height: 15.h),
                          FieldLabel('Password*'),

                          CostItFormfield(
                            borderRadius: BorderRadius.circular(
                              _passwordHasText ? 30 : 10,
                            ),
                            hintText: 'Enter Password',
                            controller: _passwordController,
                            autofillHint: const [AutofillHints.password],
                            prefixIcon: PhosphorIcon(
                              PhosphorIcons.lock(PhosphorIconsStyle.bold),
                              size: 18.sp,
                            ),
                            errorText: passwordError,
                            suffixIcon: GestureDetector(
                              onTap: () =>
                                  setState(() => _obscured = !_obscured),
                              child: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 200),
                                  child: Image.asset(
                                    _obscured
                                        ? AppImages.invisible
                                        : AppImages.visible,
                                    key: ValueKey(_obscured),
                                    width: 24.w,
                                    height: 22.h,
                                    color: context.theme.primaryColorDark,
                                  ),
                                ),
                              ),
                            ),
                            obscureText: _obscured,
                            validator: Validators.isNotEmpty,
                          ),

                          const SizedBox(height: 10),

                          // Remember me + Forgot password row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () =>
                                    setState(() => _rememberMe = !_rememberMe),
                                child: Row(
                                  children: [
                                    Checkbox(
                                      value: _rememberMe,
                                      onChanged: (val) => setState(
                                        () => _rememberMe = val ?? false,
                                      ),
                                      checkColor:
                                          context.theme.scaffoldBackgroundColor,
                                      activeColor: context.color.secondary,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(3),
                                        side: BorderSide(
                                          color: context.color.secondary,
                                        ),
                                      ),
                                      side: BorderSide(
                                        color: context.color.secondary,
                                      ),
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    Gap(4.w),
                                    Text(
                                      'Remember me',
                                      style: context.bodySmall?.copyWith(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  PageRoutes.forgotPassword.name,
                                ),
                                child: Text(
                                  'Forgot Password?',
                                  style: context.bodySmall?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FontStyle.italic,
                                    color: context.color.secondary,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 15.h),
                          LoadingButton(onTap: login, text: 'Login'),
                          const SizedBox(height: 10),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Don\'t have an account?',
                                style: context.bodySmall?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.sp,
                                ),
                              ),
                              SizedBox(width: 5.w),
                              GestureDetector(
                                onTap: () {
                                  setState(() => _isTapped = !_isTapped);
                                  Navigator.pushNamed(
                                    context,
                                    PageRoutes.signUp.name,
                                  );
                                },
                                child: Text(
                                  'Create now',
                                  style: context.bodySmall?.copyWith(
                                    decoration: _isTapped
                                        ? TextDecoration.underline
                                        : null,
                                    decorationColor: context.color.secondary,
                                    decorationThickness: 1.sp,
                                    color: context.color.secondary,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: CostItColors.brightGrey.shade800,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0,
                                  ),
                                  child: Text(
                                    'Or',
                                    style: context.bodySmall?.copyWith(
                                      color: CostItColors.brightGrey.shade800,
                                      fontSize: 15.sp,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    thickness: 0.5,
                                    color: CostItColors.brightGrey.shade800,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 5.h),
                          SocialButtons(),
                          SizedBox(height: 20.h),
                          SizedBox(height: context.safeBottom + 20.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
