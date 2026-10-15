import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';

class DivisionFilterDropdown extends StatefulWidget {
  const DivisionFilterDropdown({
    super.key,
    required this.divisions,
    required this.selectedDivision,
    required this.onChanged,
    required this.decoration,
  });

  final List<String> divisions;
  final String? selectedDivision;
  final ValueChanged<String?> onChanged;
  final InputDecoration decoration;

  @override
  State<DivisionFilterDropdown> createState() => _DivisionFilterDropdownState();
}

class _DivisionFilterDropdownState extends State<DivisionFilterDropdown> {
  final _menuController = MenuController();
  final _buttonFocus = FocusNode();
  int _menuSession = 0;

  @override
  void dispose() {
    _buttonFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    return MenuAnchor(
      controller: _menuController,
      childFocusNode: _buttonFocus,
      consumeOutsideTap: true,
      onOpen: () => setState(() => _menuSession++),
      alignmentOffset: const Offset(0, 6),
      style: MenuStyle(
        alignment: AlignmentDirectional.bottomStart,
        backgroundColor: WidgetStatePropertyAll(colors.dialogBackgroundColor),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        padding: const WidgetStatePropertyAll(EdgeInsets.zero),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
      menuChildren: [
        _DivisionFilterPopup(
          key: ValueKey(_menuSession),
          divisions: widget.divisions,
          selectedDivision: widget.selectedDivision,
          onSelected: (division) {
            _menuController.close();
            widget.onChanged(division);
          },
        ),
      ],
      builder: (context, controller, child) => InkWell(
        key: const ValueKey('division-filter-button'),
        focusNode: _buttonFocus,
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.isOpen ? controller.close() : controller.open(),
        child: InputDecorator(
          decoration: widget.decoration,
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.selectedDivision ?? 'বিভাগ সমূহ',
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13, color: colors.textColor),
                ),
              ),
              Icon(Icons.keyboard_arrow_down_rounded, color: colors.hintColor),
            ],
          ),
        ),
      ),
    );
  }
}

class _DivisionFilterPopup extends StatefulWidget {
  const _DivisionFilterPopup({
    super.key,
    required this.divisions,
    required this.selectedDivision,
    required this.onSelected,
  });

  final List<String> divisions;
  final String? selectedDivision;
  final ValueChanged<String?> onSelected;

  @override
  State<_DivisionFilterPopup> createState() => _DivisionFilterPopupState();
}

class _DivisionFilterPopupState extends State<_DivisionFilterPopup> {
  bool _showSearch = false;
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final media = MediaQuery.of(context);
    final divisions = widget.divisions
        .where((division) => division.toLowerCase().contains(_query))
        .toList();
    return SizedBox(
      width: (media.size.width - 32).clamp(0.0, 300.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: (media.size.height - media.viewInsets.bottom - 48).clamp(
            120.0,
            480.0,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 6, 8, 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => widget.onSelected(null),
                      style: TextButton.styleFrom(
                        alignment: Alignment.centerLeft,
                        foregroundColor: colors.textColor,
                        minimumSize: const Size(0, 44),
                        overlayColor: Colors.transparent,
                        splashFactory: NoSplash.splashFactory,
                      ),
                      child: const Text('বিভাগ সমূহ'),
                    ),
                  ),
                  IconButton(
                    tooltip: _showSearch ? 'সার্চ বন্ধ করুন' : 'বিভাগ খুঁজুন',
                    color: _showSearch ? colors.primaryColor : colors.hintColor,
                    icon: Icon(
                      _showSearch ? Icons.close_rounded : Icons.search_rounded,
                    ),
                    onPressed: () => setState(() {
                      _showSearch = !_showSearch;
                      _query = '';
                    }),
                  ),
                ],
              ),
            ),
            if (_showSearch)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: TextField(
                  key: const ValueKey('division-filter-search'),
                  autofocus: true,
                  onChanged: (value) =>
                      setState(() => _query = value.trim().toLowerCase()),
                  decoration: AppFieldDecoration.build(
                    context,
                    hint: 'বিভাগের নাম খুঁজুন...',
                    prefix: Icons.search_rounded,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            Divider(
              height: 1,
              color: colors.ornamentColor.withValues(alpha: .4),
            ),
            Flexible(
              child: divisions.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'কোন বিভাগ পাওয়া যায়নি।',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 13, color: colors.hintColor),
                      ),
                    )
                  : SingleChildScrollView(
                      primary: false,
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: divisions.map((division) {
                          final selected = division == widget.selectedDivision;
                          return MenuItemButton(
                            onPressed: () => widget.onSelected(division),
                            style: MenuItemButton.styleFrom(
                              minimumSize: const Size(double.infinity, 48),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              foregroundColor: colors.textColor,
                              backgroundColor: selected
                                  ? colors.primaryColor.withValues(alpha: .1)
                                  : Colors.transparent,
                            ),
                            trailingIcon: selected
                                ? Icon(
                                    Icons.check_rounded,
                                    size: 18,
                                    color: colors.primaryColor,
                                  )
                                : null,
                            child: Text(
                              division,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
