import 'package:cost_it_mobile/app/global/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/auth/providers/providers.dart';
import 'package:cost_it_mobile/feature/auth/shared/button.dart';
import 'package:cost_it_mobile/app/global/errors/error_handler.dart';
import 'package:cost_it_mobile/feature/auth/shared/loaders.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/feature/auth/shared/validators.dart';
import 'package:cost_it_mobile/feature/auth/utils/auth_header.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/auth/utils/socials/social_buttons.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/widgets/progress_loaders.dart';
import 'package:cost_it_mobile/widgets/text_span.dart';
import 'package:exui/exui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class FieldLabel extends StatelessWidget {
  const FieldLabel(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 5.w, bottom: 6.h),
          child: Text(
            label,
            style: context.bodySmall?.copyWith(
              color: CostItColors.primary2,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }
}

// SignUpView
class SignUpView extends ConsumerStatefulWidget {
  const SignUpView({super.key});

  @override
  ConsumerState<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends ConsumerState<SignUpView>
    with SingleTickerProviderStateMixin {
  // Controllers
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  // State
  int _currentStep = 0;
  bool _obscured = true;
  bool _obscuredConfirm = true;
  bool _isTapped = false;
  bool _termAccepted = false;
  bool _step1Submitted = false;
  bool _step2Submitted = false;

  // Server errors

  String? emailError, passwordError, phoneError, firstNameError, lastNameError;

  void _clearErrorIfExists(String? error, void Function() clearFn) {
    if (error != null) {
      setState(clearFn);
    }
  }

  // Animation — only for the form section
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
    _phoneController.addListener(_rebuild);
    _passwordController.addListener(_rebuild);
    _confirmPasswordController.addListener(_rebuild);
  }

  void _rebuild() => setState(() {});

  @override
  void dispose() {
    _slideController.dispose();
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
        // Track whether any step-1 errors were set
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

        // If any step-1 field has an error, go back so the user sees it
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
      // await showDialogMessage(context);
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
  } //  Header

  Widget _buildHeader() {
    return AuthHeader(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Gap(10.h),
          // Logo
          SizedBox(
            height: 60.h,
            child: Align(
              alignment: Alignment.topLeft,
              child: Image.asset(
                AppImages.logo2,
                height: 120.h,
                width: 140.h,
                color: context.color.secondary,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Gap(10.h),

          // Animated Text Section
          Flexible(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              transitionBuilder: (child, anim) => FadeTransition(
                opacity: anim,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(anim),
                  child: child,
                ),
              ),
              child: Column(
                key: ValueKey(_currentStep),
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _currentStep == 0
                        ? 'Create An Account! 👋'
                        : 'Almost There! 🔐',
                    style: context.bodyLarge?.copyWith(
                      fontSize: 25.sp,
                      fontFamily: 'Titillium Web',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Gap(6.h),
                  Text(
                    _currentStep == 0
                        ? 'Sign up for free and let us be your trusted companion in construction.'
                        : '''Set up your password to secure your account.\nAvoid disclosing your password to anyone. ''',
                    style: context.bodySmall?.copyWith(
                      color: Colors.white.withOpacity(0.76),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  //  Step label
  Widget _buildStepLabel() {
    return Padding(
      padding: EdgeInsets.fromLTRB(22.w, 14.h, 22.w, 10.h),
      child: Row(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, anim) => FadeTransition(
              opacity: anim,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(-0.2, 0),
                  end: Offset.zero,
                ).animate(anim),
                child: child,
              ),
            ),
            child: _currentStep == 1
                ? GestureDetector(
                    key: const ValueKey('back'),
                    onTap: _goBack,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 13.sp,
                          color: Colors.black,
                          // color: CostItColors.primary2,
                        ),
                        Gap(4.w),
                        Text(
                          'Back',
                          style: context.bodySmall?.copyWith(
                            // color: CostItColors.primary,
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  )
                : Text(
                    '-Let’s get started-',
                    key: const ValueKey('start'),
                    style: context.bodySmall?.copyWith(
                      // color: context.color.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.sp,
                    ),
                  ),
          ),
          const Spacer(),
          Row(
            children: List.generate(2, (i) {
              final isActive = i == _currentStep;
              final isPast = i < _currentStep;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                margin: EdgeInsets.only(left: 5.w),
                width: isActive ? 22.w : 8.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: isActive || isPast
                      ? CostItColors.primary2
                      : CostItColors.primary2.withOpacity(0.20),
                  borderRadius: BorderRadius.circular(6.r),
                ),
              );
            }),
          ),
          Gap(10.w),
          Text(
            'Step ${_currentStep + 1} of 2',
            style: context.bodySmall?.copyWith(
              color: CostItColors.primary2,
              fontWeight: FontWeight.w700,
              fontSize: 12.sp,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  // Step 1: Personal info form
  Widget _buildStep1() {
    return Form(
      key: _step1Key,
      autovalidateMode: _step1AutoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FieldLabel('First name*'),
          CostItFormfield(
            onChanged: (_) => _clearErrorIfExists(
              firstNameError,
              () => firstNameError = null,
            ),
            hintText: 'Enter first name',
            controller: _firstNameController,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.user(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            validator: Validators.userName,
            errorText: firstNameError,
          ),

          Gap(16.h),
          FieldLabel('Last name*'),

          CostItFormfield(
            onChanged: (_) =>
                _clearErrorIfExists(lastNameError, () => lastNameError = null),
            hintText: 'Enter last name',
            controller: _lastNameController,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.user(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            validator: Validators.userName,
            errorText: lastNameError,
          ),

          Gap(16.h),
          FieldLabel('Email*'),

          CostItFormfield(
            onChanged: (_) =>
                _clearErrorIfExists(emailError, () => emailError = null),
            hintText: 'john@example.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: PhosphorIcon(
              PhosphorIcons.envelope(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            errorText: emailError,
            validator: Validators.validateEmail,
          ),

          Gap(20.h),

          SharedButton(
            color: context.color.primary,
            text: 'Next',
            onPressed: _goToStep2,
            icon: Icons.arrow_forward_outlined,
          ),
        ],
      ),
    );
  }

  // Step 2: Security form
  Widget _buildStep2() {
    return Form(
      key: _step2Key,
      autovalidateMode: _step2AutoValidate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FieldLabel('Phone Number *'),

          CostItFormfield(
            controller: _phoneController,
            hintText: '080 000 000 00',
            onChanged: (_) =>
                _clearErrorIfExists(phoneError, () => phoneError = null),
            prefixIcon: Icon(Icons.phone_outlined, size: 20.sp),
            validator: Validators.validatePhone,
            errorText: phoneError,
            keyboardType: TextInputType.phone,
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
            onChanged: (_) =>
                _clearErrorIfExists(passwordError, () => passwordError = null),
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscured = !_obscured),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    _obscured ? AppImages.invisible : AppImages.visible,
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
            prefixIcon: PhosphorIcon(
              PhosphorIcons.lock(PhosphorIconsStyle.bold),
              size: 20.sp,
            ),
            onChanged: (_) {
              if (_step2Submitted) {
                setState(() {});
              }
            },
            suffixIcon: GestureDetector(
              onTap: () => setState(() => _obscuredConfirm = !_obscuredConfirm),
              child: Padding(
                padding: EdgeInsets.all(12.w),
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Image.asset(
                    _obscuredConfirm ? AppImages.invisible : AppImages.visible,
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

          Gap(12.h),

          FormField<bool>(
            initialValue: _termAccepted,
            validator: (value) =>
                value != true ? ' Agree to the Terms of Service' : null,
            builder: (state) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    state.didChange(!(state.value ?? false));
                    setState(() => _termAccepted = state.value ?? false);
                  },
                  child: Row(
                    children: [
                      Checkbox(
                        checkColor: context.color.surface,
                        activeColor: context.color.secondary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        side: BorderSide(
                          color: state.hasError
                              ? CostItColors.error
                              : context.color.secondary,
                          width: 1.5,
                        ),
                        value: state.value ?? false,
                        onChanged: (val) {
                          state.didChange(val);
                          setState(() => _termAccepted = val ?? false);
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                      ),
                      Gap(6.w),
                      Expanded(
                        child: TextSpanWithLink(
                          style: context.bodySmall!.copyWith(height: 1.4),
                          height: 1.4,
                          autoUnderlined: true,
                          linkColor: state.hasError
                              ? CostItColors.error
                              : CostItColors.primary2,
                          textSpanList: [
                            TextWithLinkModel(text: 'I agree to the  '),
                            TextWithLinkModel(
                              text: 'Terms of Service',
                              link: 'https://cost-it-j1z9.onrender.com/cost-it',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (state.hasError) ...[
                  Gap(4.h),
                  Padding(
                    padding: EdgeInsets.only(left: 4.w),
                    child: state.errorText!.text().styled(
                      color: CostItColors.error,
                      fontSize: 13.sp,
                    ),
                  ),
                ],
              ],
            ),
          ),

          Gap(15.h),

          LoadingButton(
            onTap: _isStep2Complete ? signUp : null,
            text: 'Create Account',
            disabled: _isStep2Complete ? context.color.primary : Colors.grey,
          ),
        ],
      ),
    );
  }

  //  Sign-in row
  Widget _buildSignInRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account?',
          style: context.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            fontSize: 15.sp,
          ),
        ),
        Gap(4.w),
        GestureDetector(
          onTap: () {
            setState(() => _isTapped = !_isTapped);
            Navigator.pushNamed(context, PageRoutes.login.name);
          },
          child: Text(
            'Sign In',
            style: context.bodySmall?.copyWith(
              decoration: _isTapped ? TextDecoration.underline : null,
              decorationColor: context.color.secondary,
              decorationThickness: 1.sp,
              color: context.color.secondary,
              fontWeight: FontWeight.w700,
              fontSize: 15.sp,
            ),
          ),
        ),
      ],
    );
  }

  //  Divider
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(
            thickness: 0.5,
            color: CostItColors.brightGrey.shade800,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Text(
            '0r',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),

            _buildStepLabel(),

            // 3. Scrollable content
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 22.w, vertical: 16.h),
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

                    _buildSignInRow(),
                    Gap(20.h),
                    _buildDivider(),
                    Gap(18.h),
                    SocialButtons(),
                    Gap(24.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
