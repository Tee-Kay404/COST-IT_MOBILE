import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/utils/socials/social_buttons.dart';
import 'package:cost_it_mobile/feature/auth/widgets/auth_divider.dart';
import 'package:cost_it_mobile/feature/auth/widgets/signUp/sign_in_row.dart';
import 'package:cost_it_mobile/feature/auth/widgets/signUp/signup_header.dart';
import 'package:cost_it_mobile/feature/auth/widgets/signUp/signup_step_label.dart';
import 'package:cost_it_mobile/feature/auth/widgets/signUp/signup_step_one.dart';
import 'package:cost_it_mobile/feature/auth/widgets/signUp/signup_step_two.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

// SignUpView
class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView>
    with SingleTickerProviderStateMixin {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  int _currentStep = 0;
  bool _obscured = true;
  bool _obscuredConfirm = true;
  bool _termAccepted = false;
  bool _step1Submitted = false;
  bool _step2Submitted = false;

  String? emailError, passwordError, phoneError, firstNameError, lastNameError;

  void _clearErrorIfExists(String? error, void Function() clearFn) {
    if (error != null) {
      setState(clearFn);
    }
  }

  late AnimationController _slideController;
  late Animation<Offset> _slideAnim;
  late Animation<double> _fadeAnim;

  bool get _isStep2Complete {
    return _phoneController.text.isNotEmpty &&
        _passwordController.text.isNotEmpty &&
        _confirmPasswordController.text.isNotEmpty &&
        _termAccepted;
  }

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 360),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0.06, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _fadeAnim = CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOut,
    );
    _slideController.forward();
    _firstNameController.addListener(_rebuild);
    _lastNameController.addListener(_rebuild);
    _emailController.addListener(_rebuild);
    _phoneController.addListener(_rebuild);
    _passwordController.addListener(_rebuild);
    _confirmPasswordController.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _slideController.dispose();
    _firstNameController.removeListener(_rebuild);
    _lastNameController.removeListener(_rebuild);
    _emailController.removeListener(_rebuild);
    _phoneController.removeListener(_rebuild);
    _passwordController.removeListener(_rebuild);
    _confirmPasswordController.removeListener(_rebuild);
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    setState(() {
      _step1Submitted = true;

      firstNameError = null;
      lastNameError = null;
      emailError = null;
    });

    if (_step1Key.currentState!.validate()) {
      setState(() => _currentStep = 1);
      _slideController
        ..reset()
        ..forward();
    }
  }

  void _goBack() {
    setState(() => _currentStep = 0);
    _slideController
      ..reset()
      ..forward();
  }

  AutovalidateMode get _step1AutoValidate => _step1Submitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  AutovalidateMode get _step2AutoValidate => _step2Submitted
      ? AutovalidateMode.onUserInteraction
      : AutovalidateMode.disabled;

  Future<void> signUp() async {
    setState(() => _step2Submitted = true);

    if (!_step2Key.currentState!.validate()) return;

    setState(() {
      emailError = null;
      passwordError = null;
      phoneError = null;
    });

    final user = await futureProgressCaller(
      loaderType: LoaderType.none,
      context,
      computation: () => ref.read(
        signUpFutureProvider({
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phoneNumber': _phoneController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        }).future,
      ),
      onError: (error) {
        bool hasStep1Error = false;

        ErrorHandler.handle(
          context,
          error,
          fieldErrors: {
            'firstName': (msg) {
              setState(() => firstNameError = msg);
              hasStep1Error = true;
            },
            'lastName': (msg) {
              setState(() => lastNameError = msg);
              hasStep1Error = true;
            },
            'email': (msg) {
              setState(() => emailError = msg);
              hasStep1Error = true;
            },
            'phone_number': (msg) => setState(() => phoneError = msg),
            'password': (msg) => setState(() => passwordError = msg),
          },
        );

        if (hasStep1Error) {
          setState(() => _currentStep = 0);
          _slideController
            ..reset()
            ..forward();
        }

        return null;
      },
    );

    if (user != null) {
      Navigator.pushNamed(
        context,
        PageRoutes.otpVerification.name,
        arguments: (
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          phoneNumber: _phoneController.text,
          password: _passwordController.text,
          nextRoute: PageRoutes.accountSuccess,
        ),
      );
    }
  }

  // Step 1: Personal info form
  Widget _buildStep1() {
    return SignupStepOne(
      formKey: _step1Key,
      autovalidateMode: _step1AutoValidate,
      firstNameController: _firstNameController,
      lastNameController: _lastNameController,
      emailController: _emailController,
      firstNameError: firstNameError,
      lastNameError: lastNameError,
      emailError: emailError,
      onClearFirstNameError: () =>
          _clearErrorIfExists(firstNameError, () => firstNameError = null),
      onClearLastNameError: () =>
          _clearErrorIfExists(lastNameError, () => lastNameError = null),
      onClearEmailError: () =>
          _clearErrorIfExists(emailError, () => emailError = null),
      onNext: _goToStep2,
    );
  }

  // Step 2: Security form
  Widget _buildStep2() {
    return SignupStepTwo(
      formKey: _step2Key,
      autovalidateMode: _step2AutoValidate,
      phoneController: _phoneController,
      passwordController: _passwordController,
      confirmPasswordController: _confirmPasswordController,
      phoneError: phoneError,
      passwordError: passwordError,
      obscured: _obscured,
      obscuredConfirm: _obscuredConfirm,
      termAccepted: _termAccepted,
      isStep2Submitted: _step2Submitted,
      isStep2Complete: _isStep2Complete,
      onToggleObscured: () => setState(() => _obscured = !_obscured),
      onToggleObscuredConfirm: () =>
          setState(() => _obscuredConfirm = !_obscuredConfirm),
      onTermAcceptedChanged: (val) => setState(() => _termAccepted = val),
      onClearPhoneError: () =>
          _clearErrorIfExists(phoneError, () => phoneError = null),
      onClearPasswordError: () =>
          _clearErrorIfExists(passwordError, () => passwordError = null),
      onRebuildRequested: () => setState(() {}),
      onSignUp: signUp,
    );
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SignupHeader(currentStep: _currentStep),
              SignupStepLabel(currentStep: _currentStep, onBack: _goBack),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 22.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnim,
                        child: SlideTransition(
                          position: _slideAnim,
                          child: _currentStep == 0
                              ? _buildStep1()
                              : _buildStep2(),
                        ),
                      ),

                      Gap(15.h),

                      const SignInRow(),
                      Gap(20.h),
                      const AuthDivider(),
                      Gap(18.h),
                      const SocialButtons(),
                      Gap(24.h),
                      Container(),
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
