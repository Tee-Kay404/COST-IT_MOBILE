import 'package:cost_it_mobile/app/global/styles/colors.dart';
import 'package:cost_it_mobile/app/global/utils/providers.dart';
import 'package:cost_it_mobile/app/theme/theme.dart';
import 'package:cost_it_mobile/feature/vendor/listings/models/sell_form_state.dart';
import 'package:cost_it_mobile/feature/vendor/listings/providers/sell_provider.dart';
import 'package:cost_it_mobile/feature/products/providers/prod_provider.dart';
import 'package:cost_it_mobile/feature/location/utils/providers.dart';
import 'package:cost_it_mobile/route/routes.dart';
import 'package:cost_it_mobile/shared/appBar/costit_back_app_bar.dart';
import 'package:cost_it_mobile/shared/bottomNavBar/bott_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cost_it_mobile/app/global/dialog/scaffold_message.dart';
import 'package:cost_it_mobile/widgets/toasts.dart';
import 'package:cost_it_mobile/widgets/dialogbox.dart';
import 'package:cost_it_mobile/feature/vendor/listings/components/choose_location_sheet.dart';
import 'package:cost_it_mobile/feature/account/view/my_address/utils/location_provider.dart';
import 'package:cost_it_mobile/feature/vendor/listings/components/upload_overlay.dart';
import 'package:gap/gap.dart';

import 'package:cost_it_mobile/feature/products/models/products.dart';
import '../models/listing_section.dart';
import '../models/sell.dart';

class SellFormView extends ConsumerStatefulWidget {
  const SellFormView({super.key});

  @override
  ConsumerState<SellFormView> createState() => _SellFormViewState();
}

class _SellFormViewState extends ConsumerState<SellFormView> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _brandCtrl;
  late final TextEditingController _offerLabelCtrl;
  late final TextEditingController _offerBadgeCtrl;

  bool _validated = false;
  String? _categoryError;
  String? _locationError;
  String? _photoError;
  String? _expiryError;

  // Keys used to scroll the first errored section into view
  final _itemSectionKey = GlobalKey();
  final _photoSectionKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();

  bool _isInit = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) return;
    _isInit = true;

    // Check if we received a Product to edit via route arguments
    final routeArgs = ModalRoute.of(context)?.settings.arguments;
    final editProduct = routeArgs is Product ? routeArgs : null;

    if (editProduct != null) {
      // Load the product into the form provider first
      Future.microtask(
        () => ref
            .read(sellFormProvider.notifier)
            .initializeWithProduct(editProduct),
      );
    }

    // Use the product data for controllers if editing, else use existing state
    final s = ref.read(sellFormProvider);
    final user = ref.read(appStateProvider).user;

    _titleCtrl = TextEditingController(text: editProduct?.title ?? s.title);
    _descCtrl = TextEditingController(
      text: editProduct?.description ?? s.description,
    );
    _priceCtrl = TextEditingController(
      text: editProduct != null
          ? editProduct.price.toStringAsFixed(
              editProduct.price.truncateToDouble() == editProduct.price ? 0 : 2,
            )
          : s.price,
    );
    _brandCtrl = TextEditingController(text: s.brand ?? '');
    _offerLabelCtrl = TextEditingController(
      text: editProduct?.specialOffer?.discountLabel ?? s.offerLabel,
    );
    _offerBadgeCtrl = TextEditingController(
      text: editProduct?.specialOffer?.badgeText ?? s.offerBadge,
    );

    final initialName = s.contactName.isNotEmpty
        ? s.contactName
        : (user?.displayName ?? '');
    final initialPhone = s.contactPhone.isNotEmpty
        ? s.contactPhone
        : (user?.phoneNumber ?? '');

    _nameCtrl = TextEditingController(text: initialName);
    _phoneCtrl = TextEditingController(text: initialPhone);

    if (s.contactName.isEmpty && initialName.isNotEmpty) {
      Future.microtask(
        () => ref.read(sellFormProvider.notifier).setContactName(initialName),
      );
    }
    if (s.contactPhone.isEmpty && initialPhone.isNotEmpty) {
      Future.microtask(
        () => ref.read(sellFormProvider.notifier).setContactPhone(initialPhone),
      );
    }

    // Only apply default location when creating a new listing
    if (editProduct == null) {
      final defaultLocationId = ref.read(defaultLocationIdProvider);
      final savedLocations = ref.read(locationsProvider);
      String? defaultAddress;

      if (defaultLocationId != null) {
        try {
          defaultAddress = savedLocations
              .firstWhere((loc) => loc.id == defaultLocationId)
              .address;
        } catch (_) {}
      }

      if (s.location == null &&
          defaultAddress != null &&
          defaultAddress.isNotEmpty) {
        Future.microtask(
          () =>
              ref.read(sellFormProvider.notifier).setLocation(defaultAddress!),
        );
      }
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _priceCtrl.dispose();
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _brandCtrl.dispose();
    _offerLabelCtrl.dispose();
    _offerBadgeCtrl.dispose();
    super.dispose();
  }

  void _syncControllers() {
    final s = ref.read(sellFormProvider);
    _titleCtrl.text = s.title;
    _descCtrl.text = s.description;
    _priceCtrl.text = s.price;
    _nameCtrl.text = s.contactName;
    _phoneCtrl.text = s.contactPhone;
    _brandCtrl.text = s.brand ?? '';
    _offerLabelCtrl.text = s.offerLabel;
    _offerBadgeCtrl.text = s.offerBadge;
  }

  bool _validateExtras(SellFormState s) {
    setState(() {
      _categoryError = s.category == null ? 'Please select a category' : null;
      _locationError = s.location == null
          ? 'Please select your location'
          : null;
      _photoError = s.photos.length < 2 ? 'Add at least 2 photos' : null;
      _expiryError = s.hasSpecialOffer && s.offerExpiresAt == null
          ? 'Please select an expiry date'
          : null;
    });
    return _categoryError == null &&
        _locationError == null &&
        _photoError == null &&
        _expiryError == null;
  }

  Future<void> _onClearTapped() async {
    final s = ref.read(sellFormProvider);
    if (!s.hasAnyInput) return;
    final confirmed = await showClearFormSheet(context);
    if (confirmed == true && mounted) {
      ref.read(sellFormProvider.notifier).clearAll();
      _syncControllers();
      setState(() {
        _validated = false;
        _categoryError = null;
        _locationError = null;
        _photoError = null;
        _expiryError = null;
      });
    }
  }

  Future<void> _onSubmit() async {
    setState(() => _validated = true);
    final s = ref.read(sellFormProvider);
    final formOk = _formKey.currentState?.validate() ?? false;
    final extrasOk = _validateExtras(s);
    if (!formOk || !extrasOk) {
      // Scroll the first field with an error into view
      _scrollToFirstError(formOk);
      return;
    }

    _formKey.currentState!.save();
    await ref.read(sellFormProvider.notifier).submit();
    if (!mounted) return;

    final updatedState = ref.read(sellFormProvider);
    if (updatedState.submitError != null) {
      showErrorExceptionToast(context, updatedState.submitError!);
      return;
    }

    showSuccessToast(context, 'Product successfully uploaded');
    ref.read(sellFormProvider.notifier).clearAll();
    ref.invalidate(myListingsProvider);

    Navigator.pushReplacementNamed(context, PageRoutes.myListings.name);
  }

  Future<void> _onSaveDraft() async {
    final notifier = ref.read(sellFormProvider.notifier);
    final state = ref.read(sellFormProvider);

    if (state.editingProductId != null) {
      if (!notifier.hasChanges()) {
        showInfoToast(context, 'No changes made');
        return;
      }
    }

    await notifier.saveAsDraft(context);
    if (!mounted) return;

    final updatedState = ref.read(sellFormProvider);
    if (updatedState.submitError != null) {
      showErrorExceptionToast(context, updatedState.submitError!);
      return;
    }

    showSuccessToast(
      context,
      'Draft saved! Resume it anytime from My Listings.',
    );
    ref.read(sellFormProvider.notifier).clearAll();
    ref.invalidate(myListingsProvider);
    Navigator.pushReplacementNamed(context, PageRoutes.myListings.name);
  }

  Future<void> _pickLocation() async {
    final currentLocation = ref.read(sellFormProvider).location;
    await ChooseLocationSheet.show(
      context,
      currentLocation: currentLocation,
      onLocationSelected: (loc) {
        ref.read(sellFormProvider.notifier).setLocation(loc);
      },
      onChooseOther: () async {
        await Navigator.pushNamed(context, PageRoutes.location.name);
        if (!mounted) return;
        final loc = ref.read(selectedLocationProvider);
        if (loc != null && loc != 'All Nigeria') {
          ref.read(sellFormProvider.notifier).setLocation(loc);
        }
      },
    );
  }

  Future<void> _pickPhoto() async {
    await ref.read(sellFormProvider.notifier).pickPhotos();
  }

  /// Scrolls the first section with an active error into the visible area.
  void _scrollToFirstError(bool formOk) {
    GlobalKey? targetKey;

    if (!formOk || _categoryError != null || _locationError != null) {
      targetKey = _itemSectionKey;
    } else if (_photoError != null) {
      targetKey = _photoSectionKey;
    } else if (_expiryError != null) {
      targetKey = _pricingKey;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOut,
        alignment: 0.0,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(sellFormProvider);
    final notifier = ref.read(sellFormProvider.notifier);
    final isExpanded = state.title.isNotEmpty && state.category != null;
    final collapsed = !isExpanded;

    return PopScope(
      canPop: !state.hasAnyInput,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        if (state.hasAnyInput) {
          final confirm = await showDiscardChangesDialog(context);
          if (confirm == true && mounted) {
            ref.read(sellFormProvider.notifier).clearAll();
            if (ModalRoute.of(context)?.settings.name == PageRoutes.sell.name) {
              Navigator.pop(context);
            } else {
              ref.read(selectedTabProvider.notifier).state = 0;
            }
          }
        }
      },
      child: Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        appBar: CostItBackAppBar(
          title: state.editingProductId != null
              ? 'Edit Listing'
              : 'List an item',
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: CostItColors.white),
            onPressed: () async {
              if (state.hasAnyInput) {
                final confirm = await showDiscardChangesDialog(context);
                if (confirm != true) return;
              }
              if (!mounted) return;

              ref.read(sellFormProvider.notifier).clearAll();

              if (ModalRoute.of(context)?.settings.name ==
                  PageRoutes.sell.name) {
                Navigator.pop(context);
              } else {
                ref.read(selectedTabProvider.notifier).state = 0;
              }
            },
          ),
          actions: [
            if (state.hasAnyInput)
              TextButton(
                onPressed: _onClearTapped,
                child: Text(
                  'Reset',
                  style: context.bodySmall?.copyWith(
                    color: context.color.secondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 14.sp,
                  ),
                ),
              ),
          ],
        ),
        body: Stack(
          children: [
            Form(
              key: _formKey,
              autovalidateMode: _validated
                  ? AutovalidateMode.onUserInteraction
                  : AutovalidateMode.disabled,
              child: CustomScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Gap(10.h),

                        ItemDetailsSection(
                          key: _itemSectionKey,
                          titleCtrl: _titleCtrl,
                          descCtrl: _descCtrl,
                          brandCtrl: _brandCtrl,
                          onPickLocation: _pickLocation,
                          categoryError: _categoryError,
                          locationError: _locationError,
                          collapsed: collapsed,
                        ),

                        ImageSection(
                          key: _photoSectionKey,
                          state: state,
                          notifier: notifier,
                          onAddPhoto: _pickPhoto,
                          photoError: _photoError,
                        ),

                        AnimatedSize(
                          duration: const Duration(milliseconds: 420),
                          curve: Curves.easeInOutCubic,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 320),
                            opacity: isExpanded ? 1.0 : 0.0,
                            child: isExpanded
                                ? Column(
                                    children: [
                                      PricingSection(
                                        key: _pricingKey,
                                        state: state,
                                        notifier: notifier,
                                        priceCtrl: _priceCtrl,
                                      ),
                                      ContactSection(
                                        key: _contactKey,
                                        state: state,
                                        notifier: notifier,
                                        nameCtrl: _nameCtrl,
                                        phoneCtrl: _phoneCtrl,
                                      ),
                                      ActivePlanSection(),
                                      SpecialOfferSection(
                                        offerLabelCtrl: _offerLabelCtrl,
                                        offerBadgeCtrl: _offerBadgeCtrl,
                                        expiryError: _expiryError,
                                      ),
                                    ],
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ),

                        // ── Always visible: Post Ad button
                        ListingSubmitArea(
                          state: state,
                          canPost: true,
                          isExpanded: isExpanded,
                          onSubmit: isExpanded ? _onSubmit : () {},
                          onSaveDraft: isExpanded ? _onSaveDraft : () {},
                        ),

                        Gap(120.h),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Upload / Submit progress overlay ─────────────────────────────
            if (state.isUploading || state.isSubmitting)
              UploadOverlay(
                isUploading: state.isUploading,
                uploadProgress: state.uploadProgress,
              ),
          ],
        ),
      ),
    );
  }
}
