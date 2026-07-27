import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/components/textfields/costit_textfield.dart';
import 'package:cost_it_mobile/constants/constants.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/models/location_model.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/widgets/location_add_button.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/utils/location_map_preview.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/utils/location_provider.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/widgets/saved_location_card.dart';
import 'package:cost_it_mobile/feature/auth/shared/reusable_button.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LocationEditPage extends ConsumerWidget {
  const LocationEditPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locations = ref.watch(locationsProvider);
    final activeEdits = ref.watch(activeLocationEditsProvider);
    final isEditing = activeEdits > 0;

    return PopScope(
      canPop: !isEditing,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldDiscard = await showDiscardChangesDialog(context);
        if (shouldDiscard == true) {
          if (context.mounted) {
            Navigator.pop(context);
          }
        }
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocationMapPreview(imagePath: AppImages.map),

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),

                        if (locations.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: SavedLocationCard(locations: locations),
                          ),

                        SizedBox(height: 8.h),

                        if (!isEditing)
                          AddLocationButton(
                            onTap: () => _showAddLocationSheet(context, ref),
                          ),

                        SizedBox(height: 32.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: MediaQuery.paddingOf(context).top + 12.h,
              left: 16.w,
              child: GestureDetector(
                onTap: () => Navigator.maybePop(context),
                child: Container(
                  width: 38.r,
                  height: 38.r,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(5.r),
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddLocationSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddLocationSheet(
        onConfirm: (address) {
          ref
              .read(locationsProvider.notifier)
              .addLocation(
                SavedLocation(
                  id: 'loc_${DateTime.now().millisecondsSinceEpoch}',
                  address: address,
                ),
              );
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _AddLocationSheet extends StatefulWidget {
  final void Function(String address) onConfirm;

  const _AddLocationSheet({required this.onConfirm});

  @override
  State<_AddLocationSheet> createState() => _AddLocationSheetState();
}

class _AddLocationSheetState extends State<_AddLocationSheet> {
  final _addressCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final color = context.color;

    return Padding(
      padding: EdgeInsets.only(bottom: mq.viewInsets.bottom),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 24.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: color.onSurface.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Align(
                alignment: Alignment.centerLeft,
                child: Text('Add location', style: context.titleSmall),
              ),
              SizedBox(height: 16.h),
              CostItTextfield(
                controller: _addressCtrl,
                hintText: 'e.g. 14 Admiralty Way, Lekki Phase 1',
                maxLines: 1,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              SizedBox(height: 20.h),
              SharedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    widget.onConfirm(_addressCtrl.text.trim());
                  }
                },
                text: 'Save location',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
