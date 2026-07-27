import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/location/component/lga_body.dart';
import 'package:cost_it_mobile/feature/location/component/state_body.dart';
import 'package:cost_it_mobile/feature/location/utils/providers.dart';
import 'package:cost_it_mobile/feature/location/utils/data.dart';
import 'package:cost_it_mobile/widgets/arrow_back_button.dart';
import 'package:cost_it_mobile/shared/searchBar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocationView extends ConsumerStatefulWidget {
  const LocationView({super.key});

  @override
  ConsumerState<LocationView> createState() => _LocationViewState();
}

class _LocationViewState extends ConsumerState<LocationView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  String _query = '';
  String? _selectedState;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final previousState = ref.read(selectedStateProvider);
      if (previousState != null) {
        setState(() {
          _selectedState = previousState;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  bool get _isOnLgaView => _selectedState != null;

  void _openLgas(String state) => setState(() {
    _selectedState = state;
    _query = '';
    _searchController.clear();
  });

  void _backToStates() => setState(() {
    _selectedState = null;
    _query = '';
    _searchController.clear();
  });

  void _handleBack() {
    if (_isOnLgaView) {
      _backToStates();
    } else {
      Navigator.pop(context);
    }
  }

  List<String> _filteredStates(List<String> states) {
    if (_query.isEmpty) return states;
    return states
        .where((s) => s.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  List<String> get _filteredLgas {
    final lgas = nigeriaStatesAndLgas[_selectedState] ?? [];
    if (_query.isEmpty) return lgas;
    return lgas
        .where((l) => l.toLowerCase().contains(_query.toLowerCase()))
        .toList();
  }

  Future<void> _onMyLocationTapped() async {
    await ref.read(gpsLocationProvider.notifier).detectLocation(ref);
    final gpsState = ref.read(gpsLocationProvider);
    gpsState.when(
      data: (location) {
        if (location != null && mounted) Navigator.pop(context);
      },
      error: (e, _) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          ScaffoldMessage(
            message: e.toString(),
            context: context,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
      loading: () {},
    );
  }

  void _onLgaSelected(String lga) {
    ref.read(selectedLocationProvider.notifier).state = '$lga, $_selectedState';
    ref.read(selectedStateProvider.notifier).state = _selectedState;
    ref.read(selectedLgaProvider.notifier).state = lga;
    Navigator.pop(context);
  }

  void _onSelectWholeState() {
    ref.read(selectedLocationProvider.notifier).state = _selectedState!;
    ref.read(selectedStateProvider.notifier).state = _selectedState;
    ref.read(selectedLgaProvider.notifier).state = null;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selectedLga = ref.watch(selectedLgaProvider);
    final selectedState = ref.watch(selectedStateProvider);

    return PopScope(
      canPop: !_isOnLgaView,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && _isOnLgaView) _backToStates();
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: context.color.primary,
          elevation: 0,
          leading: ArrowBackButton(
            color: CostItColors.white,
            size: 24.sp,
            onPressed: _handleBack,
          ),
          leadingWidth: 56.w,
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: SizedBox(
              height: 45.h,
              child: CostItSearchBar(
                controller: _searchController,
                focusNode: _searchFocusNode,
                hint: _isOnLgaView
                    ? 'Search in $_selectedState...'
                    : 'Search location...',
                onChanged: (v) => setState(() => _query = v),
                onCleared: () => setState(() {
                  _query = '';
                  _searchController.clear();
                }),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
                focusBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          switchInCurve: Curves.easeOut,
          switchOutCurve: Curves.easeIn,
          transitionBuilder: (child, animation) {
            final isLgaView =
                (child.key == ValueKey(_selectedState)) &&
                _selectedState != null;
            return SlideTransition(
              position: Tween<Offset>(
                begin: Offset(isLgaView ? 1.0 : -1.0, 0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
          child: _isOnLgaView
              ? LgaBody(
                  key: ValueKey(_selectedState),
                  stateName: _selectedState!,
                  query: _query,
                  filteredLgas: _filteredLgas,
                  onLgaSelected: _onLgaSelected,
                  onSelectWholeState: _onSelectWholeState,
                  activeLga: selectedLga,
                  activeState: selectedState,
                )
              : StatesBody(
                  key: const ValueKey('states'),
                  query: _query,
                  filteredPopular: _filteredStates(nigeriaPopularStates),
                  filteredOthers: _filteredStates(nigeriaOtherStates),
                  onStateSelected: _openLgas,
                  onMyLocationTapped: _onMyLocationTapped,
                  activeState: selectedState,
                ),
        ),
      ),
    );
  }
}

class StateTile extends StatelessWidget {
  final String state;
  final VoidCallback onTap;
  final bool isActive;

  const StateTile({
    required this.state,
    required this.onTap,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = isDark ? CostItColors.secondaryDark : context.color.primary;

    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    state,
                    style: context.bodyMedium?.copyWith(
                      color: isActive ? activeColor : null,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  isActive ? Icons.check_circle_rounded : Icons.chevron_right,
                  color: isActive
                      ? activeColor
                      : CostItColors.brightGrey.shade400,
                  size: 22.sp,
                ),
              ],
            ),
          ),
        ),
        const Divider(height: 1, thickness: 1),
      ],
    );
  }
}
