import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class LoginSettingsPage extends StatefulWidget {
  const LoginSettingsPage({super.key});

  @override
  State<LoginSettingsPage> createState() => _LoginSettingsPageState();
}

class _LoginSettingsPageState extends State<LoginSettingsPage> {
  bool _useFingerprint = true;

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    final passwordTiles = [
      'Change Password',
      'Forgot Password',
      'Auto-logout Setting',
    ];

    return Scaffold(
      backgroundColor: context.color.surface,
      appBar: const CostItBackAppBar(title: 'Login Settings'),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader('Password'),
            Gap(8.h),
            ...passwordTiles.map(
              (title) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _buildTileContainer(_buildNavTile(title), isDark),
              ),
            ),
            Gap(16.h),
            _buildSectionHeader('Pattern'),
            Gap(8.h),
            _buildTileContainer(_buildNavTile('Set Up Pattern'), isDark),
            Gap(24.h),
            _buildSectionHeader('Biometrics'),
            Gap(8.h),
            _buildTileContainer(
              _buildSwitchTile(
                context,
                'Log in with Fingerprint',
                _useFingerprint,
                (val) => setState(() => _useFingerprint = val),
              ),
              isDark,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTileContainer(Widget child, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? CostItColors.brightGrey.shade800 : CostItColors.white,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: child,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: context.bodyMedium?.copyWith(
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: context.color.inverseSurface,
      ),
    );
  }

  Widget _buildNavTile(String title) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      title: Text(
        title,
        style: context.bodySmall?.copyWith(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: context.color.inverseSurface,
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Colors.grey.shade400,
        size: 24.w,
      ),
      onTap: () {
        // TODO: Navigate to specific settings
      },
    );
  }

  Widget _buildSwitchTile(
    BuildContext context,
    String title,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      dense: true,
      minVerticalPadding: 0,
      contentPadding: EdgeInsets.fromLTRB(16.w, 0, 2.w, 0),
      title: Text(
        title,
        style: context.bodySmall?.copyWith(
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
          color: context.color.inverseSurface,
        ),
      ),
      trailing: Transform.scale(
        scale: 0.7,
        child: Switch(
          value: value,
          onChanged: onChanged,
          activeThumbColor: context.color.surface,
          activeTrackColor: isDark
              ? context.color.secondary
              : const Color(0xFF00B074),
          inactiveThumbColor: Colors.white,
          inactiveTrackColor: Colors.grey.shade300,
        ),
      ),
    );
  }
}
