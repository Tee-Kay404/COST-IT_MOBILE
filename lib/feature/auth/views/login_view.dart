import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/storage/remember_me.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/utils/auth_header.dart';
import 'package:cost_it_mobile/feature/auth/widgets/login_form_section.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: context.color.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: context.color.primary,
      ),
      child: Scaffold(
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
                              color: CostItColors.white,
                            ),
                          ),
                          WidgetSpan(
                            child: Padding(padding: EdgeInsets.only(top: 30.h)),
                          ),
                          TextSpan(
                            text:
                                'Let\'s continue the journey smarter, faster and stronger!',
                            style: context.bodySmall?.copyWith(
                              color: CostItColors.white,
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
                            LoginFormSection(
                              identifierController: _identifierController,
                              passwordController: _passwordController,
                              identifierHasText: _identifierHasText,
                              passwordHasText: _passwordHasText,
                              obscured: _obscured,
                              rememberMe: _rememberMe,
                              identifierError: identifierError,
                              passwordError: passwordError,
                              onToggleObscured: () =>
                                  setState(() => _obscured = !_obscured),
                              onToggleRememberMe: (val) =>
                                  setState(() => _rememberMe = val ?? false),
                              onLogin: login,
                            ),
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
      ),
    );
  }
}
