import 'package:cost_it_mobile/feature/products/components/seeAll/enums.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/see_all_page.dart';
import 'package:cost_it_mobile/Screens/dashboard/dashboard.dart';
import 'package:cost_it_mobile/Screens/onBoarding/get_started.dart';
import 'package:cost_it_mobile/app/theme/page/theme_page.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/views/location_edit_view.dart';
import 'package:cost_it_mobile/feature/auth/views/phone_verification_view.dart';
import 'package:cost_it_mobile/feature/auth/views/email_verification_view.dart';
import 'package:cost_it_mobile/feature/billing/views/billing_view.dart';
import 'package:cost_it_mobile/feature/chat/pages/chat_page.dart';
import 'package:cost_it_mobile/feature/location/views/location_view.dart';
import 'package:cost_it_mobile/feature/auth/pages/account_success_page.dart';
import 'package:cost_it_mobile/feature/auth/pages/complete_profile_page.dart';
import 'package:cost_it_mobile/feature/auth/pages/forgot_password.dart';
import 'package:cost_it_mobile/feature/auth/pages/login.dart';
import 'package:cost_it_mobile/feature/auth/pages/otp_reset_page.dart';
import 'package:cost_it_mobile/feature/auth/pages/otp_verification.dart';
import 'package:cost_it_mobile/feature/auth/pages/reset_password.dart';
import 'package:cost_it_mobile/feature/auth/pages/reset_password_success.dart';
import 'package:cost_it_mobile/feature/auth/pages/sign_up.dart';
import 'package:cost_it_mobile/feature/auth/views/otp_reset_password_view.dart';
import 'package:cost_it_mobile/feature/auth/views/otp_user_verification_view.dart';
import 'package:cost_it_mobile/Screens/onBoarding/onboarding_pages.dart';
import 'package:cost_it_mobile/feature/auth/views/reset_password_view.dart';
import 'package:cost_it_mobile/feature/products/models/products.dart';
import 'package:cost_it_mobile/feature/products/orders/view/orders_view.dart';
import 'package:cost_it_mobile/feature/products/product_details/views/prod_details_view.dart';
import 'package:cost_it_mobile/feature/products/savedProduct/views/saved_product.dart';
import 'package:cost_it_mobile/feature/settings/page/settings_page.dart';
import 'package:cost_it_mobile/feature/vendor/listings/pages/listing_page.dart';
import 'package:cost_it_mobile/shared/searchBar/search_page.dart';
import 'package:cost_it_mobile/feature/products/category/views/category_page.dart';
import 'package:cost_it_mobile/feature/settings/view/login_settings_page.dart';
import 'package:cost_it_mobile/feature/settings/view/feedback_suggestions_page.dart';
import 'package:cost_it_mobile/feature/notifications/views/notification_page.dart';
import 'package:cost_it_mobile/feature/account/view/manage_profile/views/edit_profile_view.dart';
import 'package:cost_it_mobile/feature/vendor/listings/my_listings/view/my_listings_page.dart';
import 'package:cost_it_mobile/feature/vendor/listings/venPDP/view/vendor_product_detail_page.dart';
import 'package:flutter/material.dart';

enum PageRoutes {
  splash,
  onBoarding,
  login,
  signUp,
  forgotPassword,
  otpVerification,
  getStarted,
  accountSuccess,
  otpResetPassword,
  resetPassword,
  resetPasswordSuccess,
  completeProfile,
  phoneVerification,
  emailVerification,

  dashBoard,
  chat,
  sell,
  settings,

  location,
  search,
  productDetails,
  categories,
  saved,
  orders,

  editProfile,
  security,
  notifications,
  language,
  recentlyViewed,
  vendorDashboard,
  myListings,
  payouts,
  theme,
  currency,
  unitSystem,
  helpCenter,
  contactUs,
  loginSettings,
  feedbackAndSuggestions,
  privacy,
  clearCache,
  deleteAccount,
  pushNotifications,
  emailAlerts,
  smsAlerts,
  loginActivity,
  twoFactor,
  locationEdit,
  billing,
  vendorProductDetail,
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  WidgetBuilder builder;
  switch (PageRoutesExtension.fromString(settings.name)) {
    case PageRoutes.onBoarding:
      builder = (ctx) => OnBoardingPage();
      break;
    case PageRoutes.login:
      builder = (ctx) => LoginPage();
      break;
    case PageRoutes.signUp:
      builder = (ctx) => SignUpPage();
      break;
    case PageRoutes.dashBoard:
      builder = (ctx) => DashBoard();
      break;
    case PageRoutes.otpVerification:
      builder = (ctx) =>
          OTPVerificationPage(info: settings.arguments as VerificationInfo);
      break;
    case PageRoutes.forgotPassword:
      builder = (ctx) => ForgotPasswordPage();
    case PageRoutes.getStarted:
      builder = (ctx) => GetStarted();
      break;
    case PageRoutes.accountSuccess:
      builder = (ctx) => AccountSuccessPage();
      break;
    case PageRoutes.otpResetPassword:
      builder = (ctx) => OTPResetPasswordPage(
        args: settings.arguments as OTPResetPasswordViewArguments,
      );
      break;
    case PageRoutes.resetPassword:
      builder = (ctx) => ResetPasswordPage(
        args: settings.arguments as ResetPasswordViewArguments,
      );
      break;
    case PageRoutes.resetPasswordSuccess:
      builder = (ctx) => ResetPasswordSuccessPage();
      break;
    case PageRoutes.completeProfile:
      builder = (ctx) => CompleteProfilePage();
      break;
    case PageRoutes.chat:
      builder = (ctx) => ChatPage();
      break;
    case PageRoutes.sell:
      builder = (ctx) => ListingPage();
      break;
    case PageRoutes.settings:
      builder = (ctx) => SettingsPage();
      break;
    case PageRoutes.location:
      builder = (ctx) => LocationView();
      break;
    case PageRoutes.productDetails:
      builder = (ctx) =>
          ProdDetailsView(product: settings.arguments as Product);
      break;
    case PageRoutes.categories:
      final initialCategoryId = settings.arguments as String?;
      builder = (ctx) => CategoryPage(initialCategoryId: initialCategoryId);
      break;
    case PageRoutes.search:
      builder = (ctx) => SearchPage();
      break;
    case PageRoutes.saved:
      builder = (ctx) => SavedProductPage();
      break;
    case PageRoutes.recentlyViewed:
      builder = (ctx) =>
          const SeeAllPage(section: SeeAllSection.recentlyViewed);
      break;
    case PageRoutes.orders:
      builder = (ctx) => OrdersPage();
      break;
    case PageRoutes.editProfile:
      builder = (ctx) => const EditProfileView();
      break;
    case PageRoutes.theme:
      builder = (ctx) => const ThemesPage();
      break;
    case PageRoutes.loginSettings:
      builder = (ctx) => const LoginSettingsPage();
      break;
    case PageRoutes.feedbackAndSuggestions:
      builder = (ctx) => const FeedbackSuggestionsPage();
      break;
    case PageRoutes.notifications:
      builder = (ctx) => const NotificationPage();
      break;
    case PageRoutes.locationEdit:
      builder = (ctx) => const LocationEditPage();
      break;
    case PageRoutes.billing:
      builder = (ctx) => const BillingScreen();
      break;
    case PageRoutes.phoneVerification:
      builder = (ctx) =>
          PhoneVerificationView(phoneNumber: settings.arguments as String);
      break;
    case PageRoutes.emailVerification:
      builder = (ctx) =>
          EmailVerificationView(email: settings.arguments as String);
      break;
    case PageRoutes.myListings:
      builder = (ctx) => const MyListingsPage();
      break;
    case PageRoutes.vendorProductDetail:
      builder = (ctx) =>
          VendorProductDetailPage(product: settings.arguments as Product);
      break;
    default:
      builder = (ctx) => OnBoardingPage();
  }
  return MaterialPageRoute(builder: builder, settings: settings);
}

extension PageRoutesExtension on PageRoutes {
  static PageRoutes? fromString(String? value) {
    var route = PageRoutes.values.where((route) => route.name == value);
    if (route.isNotEmpty) {
      return route.first;
    } else {
      return null;
    }
  }
}
