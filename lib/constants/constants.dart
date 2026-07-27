import 'package:flutter/material.dart';

class AppSVG {
  static const String birthday = 'assets/svgs/more_icons/birthday.svg';
  static const String discover = 'assets/svgs/more_icons/discover.svg';
  static const String channel = 'assets/svgs/more_icons/channel.svg';
  static const String outlineCheckCircle = "assets/icons/check-circle.svg";
  static const String receive = "assets/icons/receive.svg";
  static const String send = "assets/icons/send.svg";
  static const String swap = "assets/icons/swap.png";
  static const String swapWhite = "assets/icons/swap_white.png";
  static const String buy = "assets/icons/buy.svg";
  static const String deposit = "assets/icons/deposit.svg";
  static const String withdraw = "assets/icons/withdraw.svg";

  static const String qrScan = "assets/icons/qrScan.svg";
  static const String qrScanAlt = "assets/icons/qrScanAlt.svg";
  static const String walletAlt = "assets/icons/wallet.svg";
  static const String search = "assets/icons/search.svg";
  static const String cog = "assets/icons/cog.svg";
  static const String newChat = "assets/icons/newChat.svg";

  static const String paymentSummary = "assets/icons/paymentSummary.svg";
  static const String shield = "assets/icons/shield.png";
  static const String tick = "assets/icons/tick-blue.svg";

  static const String camera = "assets/icons/camera.svg";
  static const String photo = "assets/icons/photo.svg";
  static const String phone = "assets/icons/phone.svg";
  static const String fileAttach = "assets/icons/file-attach.svg";
  static const String messageChat = "assets/icons/message-chat.svg";
  static const String imageAvatar = "assets/icons/image-avatar.svg";
  static const String copy = "assets/icons/copy.svg";

  static const String pay = "assets/icons/pay.svg";
  static const String pay2 = "assets/icons/pay2.svg";
  static const String nft = "assets/icons/nft.svg";
  static const String deposit2 = "assets/icons/deposit.svg";
  static const String editProfile = "assets/icons/edit_profile.svg";
  static const String invite = "assets/icons/invite.svg";
  static const String airdrop = "assets/icons/airdrop.svg";
  static const String card = "assets/icons/card.svg";
  static const String plan = "assets/icons/plan.svg";
  static const String qrCode = "assets/icons/qr_code.svg";
  static const String rewards = "assets/icons/rewards.svg";
  static const String support = "assets/icons/support.svg";
}

class AppImages {
  static String avatar = 'assets/images/logos/icon_logo.png';
  static String avatar2 = 'assets/images/logos/icon_logo.png';
  static String avatar3 = 'assets/images/logos/icon_logo.png';
  static String btc = 'assets/images/other/wallet.png';
  static String getKey = 'assets/images/logos/cost-it.png';

  static String moneySent = 'assets/images/other/success.png';

  static const iconWhite = "assets/images/logos/icon_logo.png";
  static const iconWhiteSvg = "assets/images/logos/icon_logo.png";
  static const textIconWhite = "assets/images/logos/cost-it.png";
  static const logoWhite = "assets/images/logos/cost-it_logo.png";
  static const logoBlueOutlined = "assets/images/logos/logos.png";

  // Onboarding images 
  static const onboarding1 = "assets/images/onBoarding/onboarding1.png";
  static const onboarding2 = "assets/images/onBoarding/onboarding2.png";
  static const onboarding3 = "assets/images/onBoarding/onboarding3.png";
  static const onboarding4 = "assets/images/onBoarding/onboarding4.png";
  static const onboarding5 = "assets/images/onBoarding/onboarding5.png";
  static const getStarted = 'assets/images/onBoarding/getStarted.jpg';


  static const logo = "assets/images/logos/cost-it_logo.png";
  static const String visible = "assets/images/other/visible.png";
  static const String invisible = "assets/images/other/invisible.png";
  static const String verifyEmail = 'assets/images/other/verify_email.jpg';

  static const createWallet = "assets/images/other/wallet.png";

  static const String facebookLogo = 'assets/images/socials/facebook_logo.png';
  static const String google = 'assets/images/socials/Google_logo.png';
  static const String whatsapp = 'assets/images/socials/whatsapp.png';
  static const String apple = 'assets/icons/apple.png';
  static const String applePayLogo = 'assets/images/socials/Apple_logo.png';
  static const String paypalLogo = 'assets/images/other/paypal_logo.png';
  static const String venmoLogo = 'assets/images/venmo_logo.png';
  static const String coinbaseLogo = 'assets/images/coinbase_logo.png';
  static const String moonpayLogo = 'assets/images/other/moonpay_logo.png';
  static const String stripeLogo = 'assets/images/stripe_logo.png';
  static const String x = 'assets/images/logos/x_logo.png';
  static const String logo2 = "assets/images/logos/logs1.png";
  static const String success = "assets/images/other/success.png";
  static const String chip = "assets/images/chip.png";
  static const String floatLogo = 'assets/images/logos/logo!.png';

  // categories
  static const String materials = 'assets/images/category/materials.jpg';
  static const String electrical = 'assets/images/category/electrical.jpg';
  static const String plumbing = 'assets/images/category/plumbing.jpg';
  static const String services = 'assets/images/category/services.jpg';
  static const String logistics = 'assets/images/category/logistics.jpg';
  static const String tools = 'assets/images/category/tools.jpg';
  static const String finishing = 'assets/images/category/finishing.jpg';
  static const String machinery = 'assets/images/category/machinery.jpg';
  static const String safety = 'assets/images/category/safety.jpg';
  static const String chat = 'assets/images/chat/chat.png';

  // google maps
  static const String map = 'assets/images/location/google_map.png';
  static const String map1 = 'assets/images/location/google_maps.png';
  static const String darkmap = 'assets/images/location/google_map_dark.png';

}

extension SafeSpacing on BuildContext {
  double get safeTop => MediaQuery.of(this).padding.top;
  double get safeBottom => MediaQuery.of(this).padding.bottom;
}
