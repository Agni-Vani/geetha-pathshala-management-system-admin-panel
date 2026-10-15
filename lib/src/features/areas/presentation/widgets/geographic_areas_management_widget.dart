import 'package:flutter/material.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';
import '../../../../di/di.dart';
import '../../domain/areas_domain.dart';
import '../controller/geographic_areas_controller.dart';
import 'division_filter_dropdown.dart';

class GeographicAreasManagementWidget extends StatefulWidget {
  const GeographicAreasManagementWidget({super.key});

  @override
  State<GeographicAreasManagementWidget> createState() =>
      _GeographicAreasManagementWidgetState();
}

class _GeographicAreasManagementWidgetState
    extends State<GeographicAreasManagementWidget> {
  late final GeographicAreasController _controller;
  late final SnackbarNotifier _snackbarNotifier;
  final TextEditingController _districtSearchCtrl = TextEditingController();
  final TextEditingController _upazilaSearchCtrl = TextEditingController();
  String _upazilaQuery = '';
  bool _showUpazilaSearch = false;
  String? _lastSelectedDistrictId;
  // Stacked (mobile) layout only: true lists every district and hides the
  // upazilas; picking one collapses the list to it and shows its upazilas.
  bool _showAllDistricts = true;
  // Stacked layout only: the district search hides behind an icon in the
  // district list's header.
  bool _showDistrictSearch = false;

  Color get _cardSurfaceColor => Theme.of(context).brightness == Brightness.dark
      ? const Color(0xFF13201F)
      : Colors.white;

  @override
  void initState() {
    super.initState();
    _controller = sl.get<GeographicAreasController>();
    _controller.addListener(_onDistrictSelectionChanged);
    _snackbarNotifier = SnackbarNotifier(context: context);
    _controller.load(snackbarNotifier: _snackbarNotifier);
  }

  void _onDistrictSelectionChanged() {
    final districtId = _controller.selectedDistrict?.id;
    if (districtId == _lastSelectedDistrictId) return;
    _lastSelectedDistrictId = districtId;
    _upazilaSearchCtrl.clear();
    setState(() {
      _upazilaQuery = '';
      _showUpazilaSearch = false;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_onDistrictSelectionChanged);
    _districtSearchCtrl.dispose();
    _upazilaSearchCtrl.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _showAddDivisionDialog() {
    final nameCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.context(ctx);
        return _areaDialog(
          ctx,
          title: Text(
            'নতুন বিভাগ যোগ করুন (Add Division)',
            style: TextStyle(
              color: colors.textColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            width: 400,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'বিভাগের নাম (Division Name)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: colors.textColor,
                  ),
                ),
                const SizedBox(height: 6),
                TextField(
                  controller: nameCtrl,
                  autofocus: true,
                  decoration: _fieldDecoration(
                    ctx,
                    hint: 'যেমন: Dhaka, Chattogram, Rangpur',
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            OutlinedButton(
              style: _buttonStyle(ctx),
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('বাতিল', style: TextStyle(color: colors.hintColor)),
            ),
            ElevatedButton(
              style: _buttonStyle(ctx, primary: true).copyWith(
                backgroundColor: WidgetStatePropertyAll(colors.primaryColor),
                foregroundColor: WidgetStatePropertyAll(
                  colors.buttonContentColor,
                ),
              ),
              onPressed: () async {
                final name = nameCtrl.text.trim();
                if (name.isEmpty) return;
                Navigator.of(ctx).pop();
                await _controller.addNewDivision(
                  name: name,
                  snackbarNotifier: _snackbarNotifier,
                );
              },
              child: const Text('সংরক্ষণ করুন'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDistrictDialog() {
    final nameCtrl = TextEditingController();
    final divisionCtrl = TextEditingController(
      text: _controller.divisions.firstOrNull ?? '',
    );
    String selectedDivision = _controller.divisions.firstOrNull ?? '';

    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.context(ctx);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return _areaDialog(
              ctx,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'নতুন জেলা যোগ করুন',
                    style: TextStyle(
                      color: colors.textColor,
                      fontSize: 18,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'বিভাগ নির্বাচন করে জেলার নাম লিখুন।',
                    style: TextStyle(
                      color: colors.hintColor,
                      fontSize: 12,
                      height: 1.5,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'বিভাগ (Division)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_controller.divisions.isNotEmpty) ...[
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        icon: Icon(
                          Icons.expand_more_rounded,
                          size: 20,
                          color: colors.hintColor,
                        ),
                        borderRadius: BorderRadius.circular(12),
                        dropdownColor: colors.dialogBackgroundColor,
                        initialValue: selectedDivision.isNotEmpty
                            ? selectedDivision
                            : _controller.divisions.first,
                        items: _controller.divisions.map((div) {
                          return DropdownMenuItem(
                            value: div,
                            child: Text(
                              div,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: colors.textColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedDivision = val;
                              divisionCtrl.text = val;
                            });
                          }
                        },
                        decoration: _fieldDecoration(
                          ctx,
                          hint: 'বিভাগ নির্বাচন করুন',
                          prefix: Icons.account_tree_outlined,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          style: TextButton.styleFrom(
                            foregroundColor: colors.maroonColor,
                            backgroundColor: colors.softAccentColor.withValues(
                              alpha: .35,
                            ),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: () {
                            Navigator.of(ctx).pop();
                            _showAddDivisionDialog();
                          },
                          icon: Icon(
                            Icons.add_rounded,
                            size: 16,
                            color: colors.primaryColor,
                          ),
                          label: Text(
                            'নতুন বিভাগ তৈরি করুন',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: colors.maroonColor,
                            ),
                          ),
                        ),
                      ),
                    ] else
                      TextField(
                        controller: divisionCtrl,
                        decoration: _fieldDecoration(
                          ctx,
                          hint: 'বিভাগের নাম লিখুন',
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                        ),
                        onChanged: (val) => selectedDivision = val.trim(),
                      ),
                    const SizedBox(height: 16),
                    Text(
                      'জেলার নাম (District Name)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: _fieldDecoration(
                        ctx,
                        hint: 'যেমন: Dhaka, Bogura, Sylhet',
                        prefix: Icons.location_city_outlined,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  style: _buttonStyle(ctx),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'বাতিল',
                    style: TextStyle(color: colors.hintColor),
                  ),
                ),
                ElevatedButton(
                  style: _buttonStyle(ctx, primary: true).copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      colors.primaryColor,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      colors.buttonContentColor,
                    ),
                  ),
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    final div = selectedDivision.trim().isNotEmpty
                        ? selectedDivision.trim()
                        : divisionCtrl.text.trim();
                    if (name.isEmpty || div.isEmpty) return;
                    Navigator.of(ctx).pop();
                    await _controller.addNewDistrict(
                      name: name,
                      division: div,
                      snackbarNotifier: _snackbarNotifier,
                    );
                  },
                  child: const Text('সংরক্ষণ করুন'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddUpazilaDialog({String? preselectedDistrictId}) {
    final nameCtrl = TextEditingController();
    String? selectedDistrictId =
        preselectedDistrictId ?? _controller.selectedDistrict?.id;

    if (selectedDistrictId == null && _controller.districts.isNotEmpty) {
      selectedDistrictId = _controller.districts.first.id;
    }

    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.context(ctx);
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return _areaDialog(
              ctx,
              title: Text(
                'নতুন উপজেলা যোগ করুন (Add Upazila)',
                style: TextStyle(
                  color: colors.textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: SizedBox(
                width: 400,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'জেলা (District)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      borderRadius: BorderRadius.circular(12),
                      dropdownColor: colors.dialogBackgroundColor,
                      initialValue: selectedDistrictId,
                      items: _controller.districts.map((d) {
                        return DropdownMenuItem(
                          value: d.id,
                          child: Text(
                            '${d.name} (${d.division})',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: colors.textColor),
                          ),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedDistrictId = val);
                        }
                      },
                      decoration: _fieldDecoration(
                        ctx,
                        hint: 'জেলা নির্বাচন করুন',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'উপজেলার নাম (Upazila Name)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: _fieldDecoration(
                        ctx,
                        hint: 'যেমন: Ramna, Mirpur, Sadar',
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                OutlinedButton(
                  style: _buttonStyle(ctx),
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text(
                    'বাতিল',
                    style: TextStyle(color: colors.hintColor),
                  ),
                ),
                ElevatedButton(
                  style: _buttonStyle(ctx, primary: true).copyWith(
                    backgroundColor: WidgetStatePropertyAll(
                      colors.primaryColor,
                    ),
                    foregroundColor: WidgetStatePropertyAll(
                      colors.buttonContentColor,
                    ),
                  ),
                  onPressed: () async {
                    final name = nameCtrl.text.trim();
                    if (name.isEmpty || selectedDistrictId == null) return;
                    Navigator.of(ctx).pop();
                    await _controller.addNewUpazila(
                      districtId: selectedDistrictId!,
                      name: name,
                      snackbarNotifier: _snackbarNotifier,
                    );
                  },
                  child: const Text('সংরক্ষণ করুন'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  InputDecoration _fieldDecoration(
    BuildContext context, {
    String? hint,
    IconData? prefix,
    EdgeInsets? padding,
  }) {
    final colors = AppColors.context(context);
    return AppFieldDecoration.build(
      context,
      hint: hint,
      prefix: prefix,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 15),
    ).copyWith(
      fillColor: colors.dialogBackgroundColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(
          color: colors.ornamentColor.withValues(alpha: .7),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: colors.primaryColor, width: 1.5),
      ),
    );
  }

  ButtonStyle _buttonStyle(BuildContext context, {bool primary = false}) {
    final colors = AppColors.context(context);
    return ElevatedButton.styleFrom(
      minimumSize: const Size(0, 48),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      elevation: 0,
      backgroundColor: primary
          ? colors.primaryColor
          : colors.dialogBackgroundColor,
      foregroundColor: primary ? colors.buttonContentColor : colors.maroonColor,
      overlayColor: primary ? Colors.white : colors.primaryColor,
      side: primary
          ? BorderSide.none
          : BorderSide(color: colors.ornamentColor.withValues(alpha: .9)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
    ).copyWith(
      shadowColor: WidgetStatePropertyAll(
        colors.primaryColor.withValues(alpha: .35),
      ),
      elevation: WidgetStateProperty.resolveWith(
        (states) => primary && states.contains(WidgetState.hovered) ? 4 : 0,
      ),
    );
  }

  Widget _action(
    String label,
    IconData icon,
    VoidCallback onPressed, {
    bool primary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      style: _buttonStyle(context, primary: primary).copyWith(
        minimumSize: const WidgetStatePropertyAll(Size(0, 44)),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        textStyle: const WidgetStatePropertyAll(
          TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ),
      icon: Icon(icon, size: 17),
      label: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _areaDialog(
    BuildContext context, {
    required Widget title,
    required Widget content,
    required List<Widget> actions,
  }) {
    final colors = AppColors.context(context);
    return AlertDialog(
      backgroundColor: colors.dialogBackgroundColor,
      surfaceTintColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: colors.ornamentColor.withValues(alpha: .6)),
      ),
      scrollable: true,
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 16, 8),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: title),
          const SizedBox(width: 8),
          IconButton(
            tooltip: 'বন্ধ করুন',
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, size: 20),
            style: IconButton.styleFrom(
              foregroundColor: colors.hintColor,
              backgroundColor: colors.softAccentColor.withValues(alpha: .55),
              minimumSize: const Size(40, 40),
              padding: const EdgeInsets.all(8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
      content: content,
      actionsPadding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      actions: [
        SizedBox(
          width: 400,
          child: MediaQuery.sizeOf(context).width < 420
              ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    actions.last,
                    const SizedBox(height: 8),
                    actions.first,
                  ],
                )
              : Row(
                  children: [
                    Expanded(child: actions.first),
                    const SizedBox(width: 12),
                    Expanded(flex: 2, child: actions.last),
                  ],
                ),
        ),
      ],
    );
  }

  Widget _countPill(String text) {
    final colors = AppColors.context(context);
    return Container(
      constraints: const BoxConstraints(minWidth: 28),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: colors.primaryColor.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: colors.maroonColor,
        ),
      ),
    );
  }

  Widget _paneDecoration({
    Key? key,
    required Widget child,
    EdgeInsets? padding,
    Color? backgroundColor,
  }) {
    return Container(
      key: key,
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      padding: padding,
      decoration: BoxDecoration(color: backgroundColor ?? _cardSurfaceColor),
      child: child,
    );
  }

  Widget _emptyState(IconData icon, String message) {
    final colors = AppColors.context(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 36),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: colors.softAccentColor.withValues(alpha: .7),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: colors.maroonColor, size: 28),
            ),
            const SizedBox(height: 14),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.hintColor,
                fontSize: 13,
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(double width) {
    final colors = AppColors.context(context);
    final compact = width < 640;

    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ভৌগোলিক এলাকা',
          style: TextStyle(
            fontSize: compact ? 20 : 24,
            fontWeight: FontWeight.w700,
            color: colors.textColor,
            height: 1.3,
          ),
        ),
        // The description is dropped on phones to save height.
        if (!compact) ...[
          const SizedBox(height: 4),
          Text(
            'সমগ্র বাংলাদেশের বিভাগ, জেলা ও উপজেলাসমূহ পরিচালনা করুন।',
            style: TextStyle(
              fontSize: 13,
              color: colors.hintColor,
              height: 1.5,
            ),
          ),
        ],
      ],
    );
    final actionsWidth = 400 * MediaQuery.textScalerOf(context).scale(13) / 13;
    if (width >= actionsWidth + 420) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: titleBlock),
          const SizedBox(width: 20),
          SizedBox(width: actionsWidth, child: _areaActions()),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [titleBlock, const SizedBox(height: 16), _areaActions()],
    );
  }

  Widget _areaActions() {
    return LayoutBuilder(
      key: const ValueKey('areas-create-actions'),
      builder: (context, constraints) {
        const gap = 8.0;
        final columns = constraints.maxWidth >= 400
            ? 3
            : constraints.maxWidth >= 260
            ? 2
            : 1;
        final buttonWidth =
            (constraints.maxWidth - (columns - 1) * gap) / columns;
        final actions = [
          _action(
            'নতুন বিভাগ',
            Icons.domain_add_outlined,
            _showAddDivisionDialog,
          ),
          _action(
            'নতুন জেলা',
            Icons.add_location_alt_outlined,
            _showAddDistrictDialog,
          ),
          _action(
            'নতুন উপজেলা',
            Icons.add_circle_outline,
            () => _showAddUpazilaDialog(
              preselectedDistrictId: _controller.selectedDistrict?.id,
            ),
            primary: true,
          ),
        ];
        // A button left alone on the last row takes the whole row.
        final loneLast = actions.length % columns == 1;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final (index, action) in actions.indexed)
              SizedBox(
                width: loneLast && index == actions.length - 1
                    ? constraints.maxWidth
                    : buttonWidth,
                child: action,
              ),
          ],
        );
      },
    );
  }

  /// Below this content width the district and upazila panes stack.
  static const double _stackedBreakpoint = 720;

  Widget _districtSearchField({bool autofocus = false}) {
    return TextField(
      key: const ValueKey('areas-district-search'),
      controller: _districtSearchCtrl,
      autofocus: autofocus,
      onChanged: (query) {
        // Results are only visible in the full list.
        setState(() => _showAllDistricts = true);
        _controller.setSearchQuery(query, snackbarNotifier: _snackbarNotifier);
      },
      decoration: _fieldDecoration(
        context,
        hint: 'জেলার নাম খুঁজুন...',
        prefix: Icons.search_rounded,
      ),
    );
  }

  void _toggleDistrictSearch() {
    final open = !_showDistrictSearch;
    setState(() => _showDistrictSearch = open);
    // A hidden field must not keep filtering the list.
    if (!open && _districtSearchCtrl.text.isNotEmpty) {
      _districtSearchCtrl.clear();
      _controller.setSearchQuery('', snackbarNotifier: _snackbarNotifier);
    }
  }

  Widget _toolbar() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final search = _districtSearchField();
        final filter = DivisionFilterDropdown(
          divisions: _controller.divisions,
          selectedDivision: _controller.selectedDivisionFilter,
          onChanged: (division) {
            setState(() => _showAllDistricts = true);
            _controller.setDivisionFilter(
              division,
              snackbarNotifier: _snackbarNotifier,
            );
          },
          decoration: _fieldDecoration(
            context,
            prefix: Icons.filter_alt_outlined,
          ),
        );
        // Stacked, the search lives in the district list's header instead.
        if (constraints.maxWidth < _stackedBreakpoint) return filter;
        return Row(
          children: [
            Expanded(child: search),
            const SizedBox(width: 12),
            SizedBox(
              width: constraints.maxWidth < 800 ? 200 : 260,
              child: filter,
            ),
          ],
        );
      },
    );
  }

  /// [collapsed] marks the lone tile of the collapsed mobile list, where a
  /// tap reopens the full list instead of reselecting the district.
  Widget _districtTile(District district, {bool collapsed = false}) {
    final colors = AppColors.context(context);
    final selected = _controller.selectedDistrict?.id == district.id;
    return Semantics(
      selected: selected,
      child: Material(
        color: selected
            ? colors.primaryColor.withValues(alpha: .09)
            : Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          hoverColor: colors.softAccentColor.withValues(alpha: .45),
          onTap: () {
            if (collapsed) {
              setState(() => _showAllDistricts = true);
              return;
            }
            _upazilaSearchCtrl.clear();
            setState(() {
              _upazilaQuery = '';
              _showUpazilaSearch = false;
              _showAllDistricts = false;
            });
            _controller.selectDistrict(
              district,
              snackbarNotifier: _snackbarNotifier,
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 12, 12, 12),
            child: Row(
              children: [
                Container(
                  width: 3,
                  height: 28,
                  decoration: BoxDecoration(
                    color: selected ? colors.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: selected ? colors.primaryColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    Icons.location_city_rounded,
                    size: 18,
                    color: selected ? Colors.white : colors.maroonColor,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        district.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: selected
                              ? colors.maroonColor
                              : colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'বিভাগ: ${district.division}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: colors.hintColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  collapsed
                      ? Icons.expand_more_rounded
                      : selected
                      ? Icons.check_circle_rounded
                      : Icons.chevron_right_rounded,
                  size: 20,
                  color: selected
                      ? colors.primaryColor
                      : colors.hintColor.withValues(alpha: .6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _areaPaneHeader({
    required IconData icon,
    required String title,
    required Widget trailing,
    double horizontalPadding = 16,
  }) {
    final colors = AppColors.context(context);
    return Container(
      constraints: const BoxConstraints(minHeight: 64),
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 8),
      decoration: BoxDecoration(
        color: Color.alphaBlend(
          colors.softAccentColor.withValues(alpha: .22),
          _cardSurfaceColor,
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 20, color: colors.maroonColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: colors.textColor,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(height: 48, child: Center(child: trailing)),
        ],
      ),
    );
  }

  /// Whether the stacked layout shows only the selected district (with its
  /// upazilas below) instead of the full district list.
  bool _districtsCollapsed(bool compact) =>
      compact && !_showAllDistricts && _controller.selectedDistrict != null;

  Widget _districtsPane(bool compact) {
    final colors = AppColors.context(context);
    final districts = _controller.districts;
    final selectedDistrict = _controller.selectedDistrict;
    final collapsed = _districtsCollapsed(compact);
    return _paneDecoration(
      key: const ValueKey('areas-districts-pane'),
      backgroundColor: Color.alphaBlend(
        colors.softAccentColor.withValues(alpha: .30),
        _cardSurfaceColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _areaPaneHeader(
            icon: Icons.location_city_outlined,
            title: 'জেলার তালিকা',
            trailing: collapsed
                ? TextButton.icon(
                    key: const ValueKey('areas-show-all-districts'),
                    onPressed: () => setState(() => _showAllDistricts = true),
                    style: TextButton.styleFrom(
                      foregroundColor: colors.maroonColor,
                      backgroundColor: colors.primaryColor.withValues(
                        alpha: .12,
                      ),
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(999),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(Icons.expand_more_rounded, size: 18),
                    label: Text('সব জেলা (${districts.length})'),
                  )
                : compact
                ? IconButton(
                    key: const ValueKey('areas-district-search-toggle'),
                    tooltip: _showDistrictSearch
                        ? 'জেলা সার্চ বন্ধ করুন'
                        : 'জেলা খুঁজুন',
                    style: IconButton.styleFrom(
                      foregroundColor: _showDistrictSearch
                          ? colors.primaryColor
                          : colors.hintColor,
                      backgroundColor: _showDistrictSearch
                          ? colors.primaryColor.withValues(alpha: .08)
                          : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: Icon(
                      _showDistrictSearch
                          ? Icons.close_rounded
                          : Icons.search_rounded,
                      size: 21,
                    ),
                    onPressed: _toggleDistrictSearch,
                  )
                : _countPill('${districts.length}'),
          ),
          if (compact && !collapsed && _showDistrictSearch)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: _districtSearchField(autofocus: true),
            ),
          if (collapsed)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: _districtTile(selectedDistrict!, collapsed: true),
            )
          else if (districts.isEmpty)
            _emptyState(Icons.search_off_rounded, 'কোন জেলা পাওয়া যায়নি।')
          else
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: compact ? 260 : 480),
              child: ListView.separated(
                primary: false,
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 12,
                ),
                itemCount: districts.length,
                separatorBuilder: (_, _) => const SizedBox(height: 4),
                itemBuilder: (context, index) =>
                    _districtTile(districts[index]),
              ),
            ),
        ],
      ),
    );
  }

  Widget _upazilaRow(String name) {
    final colors = AppColors.context(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.place_outlined, size: 19, color: colors.primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 14,
                height: 1.45,
                fontWeight: FontWeight.w500,
                color: colors.textColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _upazilasPane(bool compact) {
    final colors = AppColors.context(context);
    final district = _controller.selectedDistrict;
    final upazilas = _controller.upazilas
        .where(
          (u) =>
              _upazilaQuery.isEmpty ||
              u.name.toLowerCase().contains(_upazilaQuery),
        )
        .toList();
    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: compact ? 0 : 420),
      child: _paneDecoration(
        key: const ValueKey('areas-upazilas-pane'),
        child: district == null
            ? _emptyState(
                Icons.map_outlined,
                _controller.districts.isEmpty
                    ? 'উপজেলা দেখানোর জন্য কোনো জেলা পাওয়া যায়নি।'
                    : 'তালিকা থেকে একটি জেলা নির্বাচন করুন।',
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _areaPaneHeader(
                    icon: Icons.pin_drop_outlined,
                    title: '${district.name} জেলার উপজেলাসমূহ',
                    horizontalPadding: compact ? 16 : 20,
                    trailing: IconButton(
                      tooltip: _showUpazilaSearch
                          ? 'উপজেলা সার্চ বন্ধ করুন'
                          : 'উপজেলা খুঁজুন',
                      style: IconButton.styleFrom(
                        foregroundColor: _showUpazilaSearch
                            ? colors.primaryColor
                            : colors.hintColor,
                        backgroundColor: _showUpazilaSearch
                            ? colors.primaryColor.withValues(alpha: .08)
                            : Colors.transparent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      icon: Icon(
                        _showUpazilaSearch
                            ? Icons.close_rounded
                            : Icons.search_rounded,
                        size: 21,
                      ),
                      onPressed: () {
                        _upazilaSearchCtrl.clear();
                        setState(() {
                          _showUpazilaSearch = !_showUpazilaSearch;
                          _upazilaQuery = '';
                        });
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      compact ? 16 : 20,
                      12,
                      compact ? 16 : 20,
                      20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (_showUpazilaSearch) ...[
                          const SizedBox(height: 14),
                          TextField(
                            key: const ValueKey('areas-upazila-search'),
                            controller: _upazilaSearchCtrl,
                            autofocus: true,
                            onChanged: (q) => setState(
                              () => _upazilaQuery = q.trim().toLowerCase(),
                            ),
                            decoration: _fieldDecoration(
                              context,
                              hint: 'উপজেলা খুঁজুন...',
                              prefix: Icons.search_rounded,
                            ),
                          ),
                          const SizedBox(height: 14),
                          Divider(
                            height: 1,
                            color: colors.ornamentColor.withValues(alpha: .35),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (_controller.isLoadingUpazilas)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 32,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  SizedBox.square(
                                    dimension: 28,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: colors.primaryColor,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    'উপজেলার তথ্য লোড হচ্ছে...',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: colors.hintColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (_controller.upazilasError != null)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 32,
                            ),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.cloud_off_outlined,
                                    size: 28,
                                    color: colors.hintColor,
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    _controller.upazilasError!,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 13,
                                      height: 1.5,
                                      color: colors.hintColor,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  TextButton.icon(
                                    onPressed: () =>
                                        _controller.loadUpazilasForDistrict(
                                          district.id,
                                          snackbarNotifier: _snackbarNotifier,
                                        ),
                                    icon: const Icon(
                                      Icons.refresh_rounded,
                                      size: 18,
                                    ),
                                    label: const Text('আবার চেষ্টা করুন'),
                                    style: TextButton.styleFrom(
                                      foregroundColor: colors.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else if (upazilas.isEmpty)
                          _emptyState(
                            Icons.location_off_outlined,
                            _upazilaQuery.isEmpty
                                ? 'কোন উপজেলা যোগ করা হয়নি। নতুন উপজেলা যোগ করুন।'
                                : 'এই নামে কোন উপজেলা পাওয়া যায়নি।',
                          )
                        else
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final columns = constraints.maxWidth >= 720
                                  ? 4
                                  : constraints.maxWidth >= 520
                                  ? 3
                                  : constraints.maxWidth >= 300
                                  ? 2
                                  : 1;
                              const gap = 12.0;
                              final itemWidth =
                                  (constraints.maxWidth - (columns - 1) * gap) /
                                  columns;
                              return Wrap(
                                spacing: gap,
                                runSpacing: 4,
                                children: upazilas
                                    .map(
                                      (upazila) => SizedBox(
                                        width: itemWidth,
                                        child: _upazilaRow(upazila.name),
                                      ),
                                    )
                                    .toList(),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final compact = width < 640;
          return Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 4),
            padding: EdgeInsets.all(compact ? 16 : 28),
            decoration: BoxDecoration(
              color: _cardSurfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.ornamentColor.withValues(alpha: .6),
              ),
              boxShadow: [
                BoxShadow(
                  color: colors.shadowColor.withValues(alpha: .06),
                  blurRadius: 28,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _header(width - (compact ? 32 : 56)),
                const SizedBox(height: 18),
                Divider(
                  height: 1,
                  color: colors.ornamentColor.withValues(alpha: .5),
                ),
                const SizedBox(height: 12),
                _toolbar(),
                SizedBox(height: compact ? 16 : 20),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < _stackedBreakpoint) {
                        return Column(
                          children: [
                            _districtsPane(true),
                            // The full list stands alone; upazilas appear
                            // once a district is picked from it.
                            if (_districtsCollapsed(true)) _upazilasPane(true),
                          ],
                        );
                      }
                      return Table(
                        columnWidths: {
                          0: FixedColumnWidth(
                            constraints.maxWidth < 1000 ? 270 : 320,
                          ),
                          1: const FlexColumnWidth(),
                        },
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.intrinsicHeight,
                        children: [
                          TableRow(
                            children: [
                              _districtsPane(false),
                              _upazilasPane(false),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
