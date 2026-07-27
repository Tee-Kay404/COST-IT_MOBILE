import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/models/location_model.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/utils/location_provider.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/widgets/card_header.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/widgets/location_field.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SavedLocationCard extends ConsumerStatefulWidget {
  final List<SavedLocation> locations;

  const SavedLocationCard({super.key, required this.locations});

  @override
  ConsumerState<SavedLocationCard> createState() => _SavedLocationCardState();
}

class _SavedLocationCardState extends ConsumerState<SavedLocationCard> {
  bool _isEditing = false;
  late List<TextEditingController> _ctrls;
  final FocusNode _firstFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    _ctrls = widget.locations
        .map((loc) => TextEditingController(text: loc.address))
        .toList();
  }

  @override
  void didUpdateWidget(covariant SavedLocationCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.locations.length != oldWidget.locations.length) {
      for (var ctrl in _ctrls) {
        ctrl.dispose();
      }
      _initControllers();
    } else if (!_isEditing) {
      for (int i = 0; i < widget.locations.length; i++) {
        _ctrls[i].text = widget.locations[i].address;
      }
    }
  }

  @override
  void dispose() {
    if (_isEditing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          ref.read(activeLocationEditsProvider.notifier).state--;
        } catch (_) {}
      });
    }
    _firstFieldFocusNode.dispose();
    for (var ctrl in _ctrls) {
      ctrl.dispose();
    }
    super.dispose();
  }

  void _toggleEdit() {
    if (_isEditing) {
      _save();
    } else {
      setState(() => _isEditing = true);
      ref.read(activeLocationEditsProvider.notifier).state++;
      if (_ctrls.isNotEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _firstFieldFocusNode.requestFocus();
            _ctrls[0].selection = TextSelection.collapsed(
              offset: _ctrls[0].text.length,
            );
          }
        });
      }
    }
  }

  void _save() {
    List<SavedLocation> updatedLocs = [];
    for (int i = 0; i < widget.locations.length; i++) {
      final newAddress = _ctrls[i].text.trim();
      updatedLocs.add(widget.locations[i].copyWith(address: newAddress));
    }

    ref.read(locationsProvider.notifier).setLocations(updatedLocs);

    setState(() => _isEditing = false);
    ref.read(activeLocationEditsProvider.notifier).state--;

    ScaffoldMessenger.of(context).showSnackBar(
      ScaffoldMessage(message: 'Locations updated', context: context),
    );
  }

  void _cancelEdit() {
    for (int i = 0; i < widget.locations.length; i++) {
      _ctrls[i].text = widget.locations[i].address;
    }
    setState(() => _isEditing = false);
    ref.read(activeLocationEditsProvider.notifier).state--;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.locations.isEmpty) {
      return const SizedBox.shrink();
    }

    final hasValidAddress = widget.locations.any((loc) => loc.address.trim().isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CardHeader(
          isEditing: _isEditing,
          onToggle: _toggleEdit,
          onCancel: _cancelEdit,
        ),
        if (!_isEditing && hasValidAddress)
          Padding(
            padding: EdgeInsets.only(top: 5.h, bottom: 4.h),
            child: Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  size: 14.sp,
                  color: CostItColors.brightGrey.shade500,
                ),
                SizedBox(width: 6.w),
                Expanded(
                  child: Text(
                    'Tap on the ⭐ to select a default pickup location.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: CostItColors.brightGrey.shade500,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 18.h),
          child: Column(
            children: List.generate(widget.locations.length, (index) {
              final isFirst = index == 0;
              final isSecond = index == 1;
              final loc = widget.locations[index];
              final isDefault = ref.watch(defaultLocationIdProvider) == loc.id;
              return Padding(
                padding: EdgeInsets.only(bottom: 14.h),
                child: LocationField(
                  label:
                      'Address ${index + 1}${isFirst ? ' (Home)' : (isSecond ? ' (Work/Office/Store)' : '')}',
                  controller: _ctrls[index],
                  isEditing: _isEditing,
                  focusNode: isFirst ? _firstFieldFocusNode : null,
                  prefixIcon: isFirst
                      ? Icons.location_on_outlined
                      : (isSecond
                            ? Icons.map_outlined
                            : Icons.location_city_outlined),
                  hint: isFirst
                      ? 'e.g. Home'
                      : (isSecond
                            ? 'e.g.  Work / Office / Store'
                            : 'e.g. Location Address'),
                  maxLines: 1,
                  isDefault: isDefault,
                  onDefaultTap: !_isEditing && loc.address.isNotEmpty
                      ? () {
                          final isCurrentlyDefault = ref.read(defaultLocationIdProvider) == loc.id;
                          if (isCurrentlyDefault) {
                            ref.read(defaultLocationIdProvider.notifier).setDefaultLocation(null);
                            ScaffoldMessenger.of(context).showSnackBar(
                              ScaffoldMessage(
                                message: 'Removed as default pickup location',
                                context: context,
                              ),
                            );
                          } else {
                            ref.read(defaultLocationIdProvider.notifier).setDefaultLocation(loc.id);
                            ScaffoldMessenger.of(context).showSnackBar(
                              ScaffoldMessage(
                                message: 'Address ${index + 1} set as default pickup area',
                                context: context,
                              ),
                            );
                          }
                        }
                      : null,
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
