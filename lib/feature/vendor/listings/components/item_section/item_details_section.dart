import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/auth/utils/formfield.dart';
import 'package:cost_it_mobile/feature/vendor/listings/components/item_section/category_dropdown.dart';
import 'package:cost_it_mobile/feature/vendor/listings/components/item_section/condition_dropdown.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';

import '../../models/sell.dart';

class ItemDetailsSection extends ConsumerStatefulWidget {
  final TextEditingController titleCtrl;
  final TextEditingController descCtrl;
  final TextEditingController brandCtrl;
  final VoidCallback onPickLocation;
  final String? categoryError;
  final String? locationError;
  final bool collapsed;

  const ItemDetailsSection({
    super.key,
    required this.titleCtrl,
    required this.descCtrl,
    required this.brandCtrl,
    required this.onPickLocation,
    this.categoryError,
    this.locationError,
    this.collapsed = false,
  });

  @override
  ConsumerState<ItemDetailsSection> createState() => _ItemDetailsSectionState();
}

class _ItemDetailsSectionState extends ConsumerState<ItemDetailsSection> {
  String? _titleError;
  late final FocusNode _titleFocusNode;

  String? _descError;
  late final FocusNode _descFocusNode;

  @override
  void initState() {
    super.initState();
    _titleFocusNode = FocusNode()..addListener(_onTitleFocusChanged);
    _descFocusNode = FocusNode()..addListener(_onDescFocusChanged);
  }

  void _onTitleFocusChanged() {
    if (!_titleFocusNode.hasFocus) {
      final trimmed = widget.titleCtrl.text.trim();
      setState(() {
        if (trimmed.isEmpty) {
          _titleError = null; // Silent — don't scold an empty untouched field
        } else if (trimmed.length < 4) {
          _titleError = 'Title must be at least 4 characters';
        } else {
          _titleError = null;
        }
      });
    }
  }

  void _onDescFocusChanged() {
    if (!_descFocusNode.hasFocus) {
      final trimmed = widget.descCtrl.text.trim();
      setState(() {
        if (trimmed.isEmpty) {
          _descError = null;
        } else if (trimmed.length < 20) {
          _descError = 'Description must be at least 20 characters';
        } else {
          _descError = null;
        }
      });
    }
  }

  @override
  void dispose() {
    _titleFocusNode
      ..removeListener(_onTitleFocusChanged)
      ..dispose();
    _descFocusNode
      ..removeListener(_onDescFocusChanged)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellFormProvider);
    final notifier = ref.read(sellFormProvider.notifier);
    final charCount = ref.watch(titleCharCountProvider);
    final collapsed = widget.collapsed;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const FormSectionHeader(
            title: 'Item details',
            subtitle: "Tell buyers what you're selling",
            icon: Icons.inventory_2_outlined,
          ),
          Gap(16.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CostItFormfield(
                  controller: widget.titleCtrl,
                  focusNode: _titleFocusNode,
                  labelText: 'Listing title *',
                  hintText: 'e.g. 50kg bags of Dangote cement',
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.disabled,
                  errorText: _titleError,
                  onChanged: (v) {
                    notifier.setTitle(v);
                    if (_titleError != null && v.trim().length >= 4) {
                      setState(() => _titleError = null);
                    }
                  },
                  validator: (v) {
                    final trimmed = v?.trim() ?? '';
                    if (trimmed.isEmpty) return 'This field is required';
                    if (trimmed.length < 4) {
                      return 'Title must be at least 4 characters';
                    }
                    return null;
                  },
                ),
                if (charCount > 0)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(top: 4.h),
                      child: Text(
                        '$charCount / 70',
                        style: context.bodySmall?.copyWith(
                          fontSize: 11.sp,
                          color: charCount < 4
                              ? context.color.error
                              : Colors.grey.shade500,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                Gap(14.h),

                CategoryDropdown(
                  value: state.category,
                  onChanged: notifier.setCategory,
                ),
                Gap(14.h),

                CostItFormfield(
                  controller: widget.descCtrl,
                  focusNode: _descFocusNode,
                  labelText: 'Description *',
                  hintText: 'Describe condition, quantity, brand, specs…',
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                  autovalidateMode: AutovalidateMode.disabled,
                  enabled: !collapsed,
                  errorText: _descError,
                  onChanged: (v) {
                    notifier.setDescription(v);
                    if (_descError != null && v.trim().length >= 20) {
                      setState(() => _descError = null);
                    }
                  },
                  validator: (v) {
                    final trimmed = v?.trim() ?? '';
                    if (trimmed.isEmpty) return 'This field is required';
                    if (trimmed.length < 20) {
                      return 'Description must be at least 20 characters';
                    }
                    return null;
                  },
                ),
                if (!collapsed) ...[
                  Gap(6.h),
                  Text(
                    '${state.description.length} / 850 · Be specific to attract serious buyers',
                    style: context.bodySmall?.copyWith(
                      fontSize: 11.sp,
                      color: Colors.grey.shade500,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
                Gap(14.h),

                AnimatedSize(
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeInOutCubic,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: collapsed ? 0.0 : 1.0,
                    child: collapsed
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Gap(14.h),

                              ConditionDropdown(
                                value: state.condition,
                                onChanged: notifier.setCondition,
                              ),
                              Gap(14.h),
                              CostItFormfield(
                                controller: widget.brandCtrl,
                                label: RichText(
                                  text: TextSpan(
                                    text: 'Brand',
                                    style: context.bodySmall?.copyWith(
                                      color: context.color.inverseSurface,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: ' (optional)',
                                        style: context.bodySmall?.copyWith(
                                          color: context.color.inverseSurface,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                hintText: 'e.g. Dangote, BUA, Lafarge',
                                keyboardType: TextInputType.text,
                                onChanged: notifier.setBrand,
                              ),
                              Gap(14.h),
                              SelectorTile(
                                label: 'Delivery / pickup area',
                                value: state.location,
                                leadingIcon: Icons.location_on_outlined,
                                onTap: widget.onPickLocation,
                                errorText: widget.locationError,
                              ),
                              Gap(16.h),
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
