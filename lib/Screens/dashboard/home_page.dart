import 'package:cost_it_mobile/feature/products/category/category_section.dart';
import 'package:cost_it_mobile/feature/products/trending/trending_section.dart';
import 'package:cost_it_mobile/feature/products/widgets/special_offers/special_offer_section.dart';
import 'package:cost_it_mobile/feature/products/for_you/for_you_section.dart';
import 'package:cost_it_mobile/widgets/costit_refresh_indicator.dart';
import 'package:cost_it_mobile/shared/appBar/app_sliver_delegate.dart';
import 'package:cost_it_mobile/shared/searchBar/fixed_search_bar.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/enums.dart';
import 'package:cost_it_mobile/feature/products/components/seeAll/see_all_page.dart';
import 'package:cost_it_mobile/widgets/section_header.dart';
import 'package:cost_it_mobile/shared/appBar/costit_app_bar.dart';
import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

class HomePage extends ConsumerStatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const HomePage({super.key, required this.scaffoldKey});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.color.primary,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          CostItAppBar(scaffoldKey: widget.scaffoldKey),
          SliverPersistentHeader(
            pinned: true,
            delegate: AppSliverAppBarDelegate(
              minHeight: 60.h,
              maxHeight: 60.h,
              child: const FixedSearchBar(),
            ),
          ),
        ];
      },
      body: CostItRefreshIndicator(
        type: RefreshType.home,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(15.h),
                  SectionHeader(section: SeeAllSection.specialOffers),
                  Gap(20.h),
                  const SpecialOffersSection(),
                  Gap(20.h),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SectionHeader(section: SeeAllSection.categories),
                  Gap(10.h),
                  const CategoriesSection(),
                  Gap(30.h),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: SectionHeader(section: SeeAllSection.trending),
              ),
            ),
            const SliverToBoxAdapter(child: TrendingSection()),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 30.h, bottom: 10.h),
                child: _ForYouSectionHeader(),
              ),
            ),
            const ForYouSection(),
            SliverToBoxAdapter(child: Gap(100.h)),
          ],
        ),
        ),
      ),))
    );
  }
}

// ── For You section header — styled like the sell-page FormSectionHeader ──────
class _ForYouSectionHeader extends StatelessWidget {
  const _ForYouSectionHeader();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 15.w),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: isDark
            ? context.color.primary.withOpacity(1)
            : CostItColors.primary.withOpacity(0.2),
        border: Border(
          left: BorderSide(color: context.color.primary, width: 3.w),
        ),
      ),
      child: Row(
        children: [
          Text(
            SeeAllSection.forYou.title,
            style: context.bodyLarge?.copyWith(
              fontSize: 18.sp,
              letterSpacing: 0.3,
              fontWeight: FontWeight.w700,
              color: context.theme.primaryColorDark,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SeeAllPage(section: SeeAllSection.forYou),
              ),
            ),
            child: Row(
              children: [
                Text(
                  'See All',
                  style: context.bodyMedium?.copyWith(
                    color: context.color.onPrimary,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.sp,
                  ),
                ),
                SizedBox(width: 2.w),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 10.sp,
                  color: context.color.onPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
