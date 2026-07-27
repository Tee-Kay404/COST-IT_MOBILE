import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:cost_it_mobile/app/global/utils/text_links.dart';
import 'package:cost_it_mobile/widgets/text_span.dart';

import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:cost_it_mobile/constants/constants.dart';

import '../models/billing_models.dart';

class BillingScreen extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;

  const BillingScreen({super.key, this.onSuccess});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Handle errors and success events.
    ref.listen(billingProvider, (prev, next) {
      if (next.error != null && next.error != prev?.error) {
        showErrorExceptionToast(context, next.error!);
        ref.read(billingProvider.notifier).clearError();
      }
      if (next.purchaseState == PurchaseState.success &&
          prev?.purchaseState != PurchaseState.success) {
        showSuccessToast(context, 'Subscription activated 🎉');
        widget.onSuccess?.call();
        ref.read(billingProvider.notifier).resetPurchaseState();
      }
    });

    final state = ref.watch(billingProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: (isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark).copyWith(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset(AppImages.getStarted, fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: const [0.0, 0.45, 1.0],
                    colors: [
                      context.theme.scaffoldBackgroundColor.withOpacity(0.4),
                      context.theme.scaffoldBackgroundColor.withOpacity(0.95),
                      context.theme.scaffoldBackgroundColor,
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  _TopBar(),
                  Expanded(
                    child: state.isLoadingPlans
                        ? const _LoadingView()
                        : _BillingBody(state: state),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Align(
        alignment: Alignment.centerLeft,
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 34.r,
            height: 34.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: context.color.surface,
              border: Border.all(
                color: context.color.inverseSurface.withOpacity(0.09),
              ),
            ),
            child: Icon(
              Icons.close_rounded,
              size: 17.sp,
              color: context.color.inverseSurface.withOpacity(0.6),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) => Center(
    child: CircularProgressIndicator(
      color: context.color.primary,
      strokeWidth: 2.2,
    ),
  );
}

class _BillingBody extends ConsumerWidget {
  final BillingState state;
  const _BillingBody({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(billingProvider.notifier);
    final plan = state.selectedPlanData;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BillingHeader(),
                Gap(22.h),
                PlanToggle(
                  selected: state.selectedPlan,
                  onChanged: notifier.selectPlan,
                ),
                Gap(22.h),
                if (plan != null)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 340),
                      switchInCurve: Curves.easeOutCubic,
                      switchOutCurve: Curves.easeInCubic,
                      transitionBuilder: (child, animation) => FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.05),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      ),
                      child: FeatureList(
                        key: ValueKey(state.selectedPlan),
                        features: plan.features,
                        planType: state.selectedPlan,
                      ),
                    ),
                  ),
                Gap(28.h),
              ],
            ),
          ),
        ),
        _BottomPanel(state: state),
      ],
    );
  }
}

class _BottomPanel extends ConsumerWidget {
  final BillingState state;
  const _BottomPanel({required this.state});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(billingProvider.notifier);
    final plan = state.selectedPlanData;
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h + bottomPad),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(16.r),
            decoration: BoxDecoration(
              color: context.theme.cardColor,
              borderRadius: BorderRadius.circular(22.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.12),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Pricing cards — animate when plan switches
                if (plan != null)
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 280),
                    child: Row(
                      key: ValueKey(state.selectedPlan),
                      children: [
                        Expanded(
                          child: PricingCard(
                            cycle: BillingCycle.monthly,
                            plan: plan,
                            isSelected:
                                state.selectedCycle == BillingCycle.monthly,
                            onTap: () =>
                                notifier.selectCycle(BillingCycle.monthly),
                          ),
                        ),
                        Gap(12.w),
                        Expanded(
                          child: PricingCard(
                            cycle: BillingCycle.yearly,
                            plan: plan,
                            isSelected:
                                state.selectedCycle == BillingCycle.yearly,
                            onTap: () =>
                                notifier.selectCycle(BillingCycle.yearly),
                          ),
                        ),
                      ],
                    ),
                  ),
                Gap(14.h),
                SubscriptionButton(
                  selectedPlan: state.selectedPlan,
                  activeSubscription: state.activeSubscription,
                  isLoading: state.purchaseState == PurchaseState.loading,
                  isCurrentPlan: state.isCurrentPlan,
                  onSubscribe: notifier.subscribe,
                ),
              ],
            ),
          ),
          Gap(18.h),
          if (state.activeSubscription != null) ...[
            GestureDetector(
              onTap: notifier.cancelSubscription,
              child: Text(
                'Cancel subscription',
                style: context.bodySmall?.copyWith(
                  color: context.color.inverseSurface.withOpacity(0.5),
                  decoration: TextDecoration.underline,
                  decorationColor: context.color.inverseSurface.withOpacity(
                    0.3,
                  ),
                ),
              ),
            ),
            Gap(12.h),
          ],
          TextSpanWithLink(
            textAlign: TextAlign.center,
            style: context.bodySmall?.copyWith(
              fontSize: 12.sp,
              color: context.color.onPrimary,
              fontWeight: FontWeight.w500,
            ),
            linkColor: context.color.onPrimary,
            autoUnderlined: true,
            textSpanList: [
              TextLink.privacyPolicy.model,
              TextWithLinkModel(text: ' · '),
              TextLink.termsOfService.model,
            ],
          ),
        ],
      ),
    );
  }
}
