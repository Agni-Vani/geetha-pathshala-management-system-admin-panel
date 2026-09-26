import 'package:flutter/material.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';
import '../../../../di/di.dart';
import '../controller/geographic_areas_controller.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = sl.get<GeographicAreasController>();
    _snackbarNotifier = SnackbarNotifier(context: context);
    _controller.load(snackbarNotifier: _snackbarNotifier);
  }

  @override
  void dispose() {
    _districtSearchCtrl.dispose();
    _upazilaSearchCtrl.dispose();
    _controller.dispose();
    super.dispose();
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
            return AlertDialog(
              backgroundColor: colors.backgroundColor,
              title: Text(
                'নতুন জেলা যোগ করুন (Add District)',
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
                      'বিভাগ (Division)',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: colors.textColor,
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (_controller.divisions.isNotEmpty)
                      DropdownButtonFormField<String>(
                        initialValue: selectedDivision.isNotEmpty
                            ? selectedDivision
                            : _controller.divisions.first,
                        items: _controller.divisions.map((div) {
                          return DropdownMenuItem(
                            value: div,
                            child: Text(div, style: TextStyle(color: colors.textColor)),
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
                        decoration: AppFieldDecoration.build(
                          ctx,
                          hint: 'বিভাগ নির্বাচন করুন',
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                      )
                    else
                      TextField(
                        controller: divisionCtrl,
                        decoration: AppFieldDecoration.build(
                          ctx,
                          hint: 'বিভাগের নাম লিখুন',
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      decoration: AppFieldDecoration.build(
                        ctx,
                        hint: 'যেমন: Dhaka, Bogura, Sylhet',
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('বাতিল', style: TextStyle(color: colors.hintColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryColor,
                    foregroundColor: Colors.white,
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
            return AlertDialog(
              backgroundColor: colors.backgroundColor,
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
                      initialValue: selectedDistrictId,
                      items: _controller.districts.map((d) {
                        return DropdownMenuItem(
                          value: d.id,
                          child: Text('${d.name} (${d.division})',
                              style: TextStyle(color: colors.textColor)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setDialogState(() => selectedDistrictId = val);
                        }
                      },
                      decoration: AppFieldDecoration.build(
                        ctx,
                        hint: 'জেলা নির্বাচন করুন',
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
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
                      decoration: AppFieldDecoration.build(
                        ctx,
                        hint: 'যেমন: Ramna, Mirpur, Sadar',
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  child: Text('বাতিল', style: TextStyle(color: colors.hintColor)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primaryColor,
                    foregroundColor: Colors.white,
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return ListenableBuilder(
      listenable: _controller,
      builder: (context, _) {
        final districts = _controller.districts;
        final selectedDistrict = _controller.selectedDistrict;
        final upazilas = _controller.upazilas.where((u) {
          if (_upazilaQuery.isEmpty) return true;
          return u.name.toLowerCase().contains(_upazilaQuery);
        }).toList();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: colors.shadowColor,
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header & Actions
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 850;
                  final headerText = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          Icon(Icons.map_outlined, color: colors.primaryColor, size: 22),
                          Text(
                            'ভৌগোলিক এলাকা',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: colors.primaryColor.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${_controller.districts.length} Districts',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: colors.primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'সমগ্র বাংলাদেশের জেলা ও উপজেলাসমূহ পরিচালনা করুন।',
                        style: TextStyle(fontSize: 13, color: colors.hintColor),
                      ),
                    ],
                  );

                  final buttons = Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      CustomButton.outlined(
                        label: '+ নতুন জেলা',
                        icon: Icons.add_location_alt_outlined,
                        onPressed: _showAddDistrictDialog,
                      ),
                      CustomButton(
                        label: '+ নতুন উপজেলা',
                        icon: Icons.add_circle_outline,
                        onPressed: () => _showAddUpazilaDialog(),
                      ),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: headerText),
                        const SizedBox(width: 16),
                        buttons,
                      ],
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [headerText, const SizedBox(height: 16), buttons],
                  );
                },
              ),

              const SizedBox(height: 20),
              Divider(color: colors.dividerColor),
              const SizedBox(height: 16),

              // Filter & Search bar for Districts
              Wrap(
                spacing: 12,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 240,
                    child: TextField(
                      controller: _districtSearchCtrl,
                      onChanged: _controller.setSearchQuery,
                      decoration: AppFieldDecoration.build(
                        context,
                        hint: 'জেলা খুঁজুন (Search District)...',
                        prefix: Icons.search,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 200,
                    child: DropdownButtonFormField<String?>(
                      initialValue: _controller.selectedDivisionFilter,
                      isExpanded: true,
                      items: [
                        DropdownMenuItem<String?>(
                          value: null,
                          child: Text('সকল বিভাগ (All Divisions)',
                              style: TextStyle(fontSize: 13, color: colors.textColor)),
                        ),
                        ..._controller.divisions.map((div) => DropdownMenuItem<String?>(
                              value: div,
                              child: Text(div,
                                  style: TextStyle(fontSize: 13, color: colors.textColor)),
                            )),
                      ],
                      onChanged: _controller.setDivisionFilter,
                      decoration: AppFieldDecoration.build(
                        context,
                        hint: 'বিভাগ ফিল্টার',
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Two-pane Master-Detail Layout
              LayoutBuilder(
                builder: (context, constraints) {
                  final isCompact = constraints.maxWidth < 800;

                  final districtsListPane = Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: colors.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    constraints: const BoxConstraints(maxHeight: 520),
                    child: districts.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Text('কোন জেলা পাওয়া যায়নি।',
                                  style: TextStyle(color: colors.hintColor)),
                            ),
                          )
                        : ListView.separated(
                            itemCount: districts.length,
                            separatorBuilder: (_, __) =>
                                Divider(height: 1, color: colors.dividerColor),
                            itemBuilder: (context, index) {
                              final district = districts[index];
                              final isSelected =
                                  selectedDistrict?.id == district.id;

                              return ListTile(
                                dense: true,
                                selected: isSelected,
                                selectedTileColor:
                                    colors.primaryColor.withValues(alpha: 0.12),
                                leading: Icon(
                                  Icons.location_city_outlined,
                                  color: isSelected
                                      ? colors.primaryColor
                                      : colors.hintColor,
                                  size: 20,
                                ),
                                title: Text(
                                  district.name,
                                  style: TextStyle(
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? colors.primaryColor
                                        : colors.textColor,
                                  ),
                                ),
                                subtitle: Text(
                                  'Division: ${district.division}',
                                  style: TextStyle(
                                      fontSize: 11, color: colors.hintColor),
                                ),
                                trailing: isSelected
                                    ? Icon(Icons.arrow_forward_ios,
                                        size: 14, color: colors.primaryColor)
                                    : null,
                                onTap: () => _controller.selectDistrict(
                                  district,
                                  snackbarNotifier: _snackbarNotifier,
                                ),
                              );
                            },
                          ),
                  );

                  final upazilasPane = Container(
                    decoration: BoxDecoration(
                      color: colors.tileColor.withValues(alpha: 0.35),
                      border: Border.all(color: colors.dividerColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.all(16),
                    constraints: isCompact
                        ? const BoxConstraints(minHeight: 250)
                        : const BoxConstraints(minHeight: 300, maxHeight: 520),
                    child: selectedDistrict == null
                        ? Center(
                            child: Text(
                              'বাম পাশ থেকে একটি জেলা নির্বাচন করুন।',
                              style: TextStyle(color: colors.hintColor),
                            ),
                          )
                        : SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 12,
                                  runSpacing: 8,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${selectedDistrict.name} জেলার উপজেলাসমূহ',
                                          style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: colors.textColor,
                                          ),
                                        ),
                                        Text(
                                          'বিভাগ: ${selectedDistrict.division} • মোট উপজেলা: ${_controller.upazilas.length}',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: colors.hintColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: colors.primaryColor,
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                      ),
                                      onPressed: () => _showAddUpazilaDialog(
                                          preselectedDistrictId: selectedDistrict.id),
                                      icon: const Icon(Icons.add, size: 16),
                                      label: const Text('উপজেলা যোগ করুন',
                                          style: TextStyle(fontSize: 12)),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextField(
                                  controller: _upazilaSearchCtrl,
                                  onChanged: (q) =>
                                      setState(() => _upazilaQuery = q.trim().toLowerCase()),
                                  decoration: AppFieldDecoration.build(
                                    context,
                                    hint: '${selectedDistrict.name} এর উপজেলা খুঁজুন...',
                                    prefix: Icons.search,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                if (_controller.isLoadingUpazilas)
                                  const Padding(
                                    padding: EdgeInsets.all(24.0),
                                    child: Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                  )
                                else if (upazilas.isEmpty)
                                  Padding(
                                    padding: const EdgeInsets.all(24.0),
                                    child: Center(
                                      child: Text(
                                        'কোন উপজেলা যোগ করা হয়নি। নতুন উপজেলা যোগ করুন।',
                                        style: TextStyle(
                                            color: colors.hintColor,
                                            fontSize: 13),
                                      ),
                                    ),
                                  )
                                else
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: upazilas.map((upz) {
                                      return Chip(
                                        avatar: Icon(
                                          Icons.place_outlined,
                                          size: 16,
                                          color: colors.primaryColor,
                                        ),
                                        label: Text(
                                          upz.name,
                                          style: TextStyle(
                                            fontSize: 13,
                                            color: colors.textColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        backgroundColor:
                                            colors.backgroundColor,
                                        side: BorderSide(
                                            color: colors.dividerColor),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6, vertical: 2),
                                      );
                                    }).toList(),
                                  ),
                              ],
                            ),
                          ),
                  );

                  if (isCompact) {
                    return Column(
                      children: [
                        districtsListPane,
                        const SizedBox(height: 16),
                        upazilasPane,
                      ],
                    );
                  }

                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 300, child: districtsListPane),
                      const SizedBox(width: 16),
                      Expanded(child: upazilasPane),
                    ],
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
