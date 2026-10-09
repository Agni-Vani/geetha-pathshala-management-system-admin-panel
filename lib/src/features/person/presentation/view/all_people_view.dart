import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/async_handlers/response.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/process_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import '../../domain/person_domain.dart';
import '../controller/list_people_controller.dart';

import '../../../../core/theme/app_colors.dart';
import 'add_person_view.dart';
import '../widgets/assign_teacher_dialog.dart';
import '../widgets/admit_student_dialog.dart';
import '../../../authentication/presentation/widgets/assign_pathshala_admin_dialog.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/widget/custom_widgets/custom_empty_state.dart';
import '../../../../core/shared/widget/custom_widgets/app_breadcrumbs.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_sizes.dart';

const _organizationId = AppConfig.defaultOrganizationId;

class AllPeopleView extends StatefulWidget {
  const AllPeopleView({super.key});

  @override
  State<AllPeopleView> createState() => _AllPeopleViewState();
}

class _AllPeopleViewState extends State<AllPeopleView> {
  final ListPeopleController listPeopleController =
      sl.get<ListPeopleController>();
  late final SnackbarNotifier snackbarNotifier;
  final TextEditingController _searchController = TextEditingController();

  final int _selectedIndex = 4;

  String? _searchQuery;
  PersonStatus? _statusFilter;
  String? _areaFilter;
  String? _roleFilter;
  String? _occupationFilter;
  int _currentPage = 1;
  static const int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    snackbarNotifier = SnackbarNotifier(context: context);
    _refreshList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  void _refreshList() {
    listPeopleController.load(
      organizationId: _organizationId,
      searchQuery: _searchQuery,
      snackbarNotifier: snackbarNotifier,
    );
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _currentPage = 1;
    });
    _refreshList();
  }

  void _openAddPerson() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddPersonRegistryView()))
        .then((_) => _refreshList());
  }

  void _openEditPerson(Person person) {
    Navigator.of(context)
        .push(
          MaterialPageRoute(
            builder: (_) => AddPersonRegistryView(existingPerson: person),
          ),
        )
        .then((_) => _refreshList());
  }

  Future<void> _togglePersonStatus(Person person) async {
    final newStatus = person.status == PersonStatus.active
        ? PersonStatus.inactive
        : PersonStatus.active;
    final isDeactivating = newStatus == PersonStatus.inactive;
    final colors = AppColors.context(context);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: colors.dialogBackgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          children: [
            Icon(
              isDeactivating
                  ? Icons.pause_circle_outline
                  : Icons.play_circle_outline,
              color: isDeactivating ? Colors.orange : Colors.green,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isDeactivating
                    ? 'Deactivate Person (নিষ্ক্রিয়)'
                    : 'Activate Person (সক্রিয়)',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: colors.textColor,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          isDeactivating
              ? 'Are you sure you want to mark "${person.displayName}" as Inactive? They will remain in records but marked as inactive.'
              : 'Are you sure you want to reactivate "${person.displayName}"?',
          style: TextStyle(color: colors.textColor, fontSize: 13.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text('Cancel', style: TextStyle(color: colors.hintColor)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  isDeactivating ? Colors.orange : colors.primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(
              isDeactivating ? 'Deactivate' : 'Activate',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final response = await sl<UpdatePerson>().call(
        UpdatePersonParams(personId: person.id, status: newStatus),
      );
      if (response is SuccessRepoCall) {
        snackbarNotifier.notifySuccess(
          message:
              '${person.displayName} marked as ${isDeactivating ? "inactive" : "active"}.',
        );
        _refreshList();
      } else {
        snackbarNotifier.notifyError(message: response.message);
      }
    }
  }

  String _getInitials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first)
        .toUpperCase();
  }

  int? _calculateAge(DateTime? dob) {
    if (dob == null) return null;
    final now = DateTime.now();
    var years = now.year - dob.year;
    final hadBirthday = now.month > dob.month ||
        (now.month == dob.month && now.day >= dob.day);
    if (!hadBirthday) years -= 1;
    return years < 0 ? null : years;
  }

  String? _displayGender(String? gender) {
    final val = gender?.trim();
    if (val == null || val.isEmpty) return null;
    return val[0].toUpperCase() + val.substring(1).toLowerCase();
  }

  Widget _buildTopBar(
    BuildContext context,
    AppColors colors,
    List<Person> allPeople,
    bool isNarrow,
  ) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBreadcrumbs(
          items: [
            BreadcrumbItem.home(context),
            const BreadcrumbItem(
              label: 'ব্যক্তি রেজিস্ট্রি',
              icon: Icons.person_outline,
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "ব্যক্তি রেজিস্ট্রি",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: colors.textColor,
            letterSpacing: -0.3,
          ),
        ),
      ],
    );

    final totalCount = allPeople.length;
    final activeCount =
        allPeople.where((p) => p.status == PersonStatus.active).length;
    final inactiveCount =
        allPeople.where((p) => p.status == PersonStatus.inactive).length;

    Widget filterTab({
      required String label,
      required int count,
      required bool isSelected,
      required VoidCallback onTap,
      Color? activeColor,
    }) {
      final color = activeColor ?? colors.primaryColor;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color:
                isSelected ? color.withValues(alpha: 0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: isSelected
                  ? color.withValues(alpha: 0.35)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? color : colors.hintColor,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                '($count)',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? color : colors.hintColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final searchBox = Container(
      height: 38,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD0D5DD)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 10),
          Icon(Icons.search, size: 17, color: colors.hintColor),
          const SizedBox(width: 6),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: _onSearchChanged,
              style: TextStyle(fontSize: 13, color: colors.textColor),
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(fontSize: 13, color: colors.hintColor),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 8),
              ),
            ),
          ),
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.close, size: 15),
              padding: EdgeInsets.zero,
              color: colors.hintColor,
              onPressed: () {
                _searchController.clear();
                _onSearchChanged('');
              },
            )
          else
            const SizedBox(width: 8),
        ],
      ),
    );

    final addButton = InkWell(
      onTap: _openAddPerson,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: colors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.add, size: 16, color: Colors.white),
            SizedBox(width: 6),
            Text(
              'Add New Person',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );

    final availableAreas = allPeople
        .map((p) => p.area)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    final availableOccupations = allPeople
        .map((p) => p.occupation)
        .whereType<String>()
        .toSet()
        .toList()
      ..sort();

    final statusFilters = SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          filterTab(
            label: 'All',
            count: totalCount,
            isSelected: _statusFilter == null,
            onTap: () => setState(() {
              _statusFilter = null;
              _currentPage = 1;
            }),
          ),
          const SizedBox(width: 4),
          filterTab(
            label: 'Active',
            count: activeCount,
            isSelected: _statusFilter == PersonStatus.active,
            activeColor: const Color(0xFF16A34A),
            onTap: () => setState(() {
              _statusFilter = PersonStatus.active;
              _currentPage = 1;
            }),
          ),
          const SizedBox(width: 4),
          filterTab(
            label: 'Inactive',
            count: inactiveCount,
            isSelected: _statusFilter == PersonStatus.inactive,
            activeColor: const Color(0xFFEA580C),
            onTap: () => setState(() {
              _statusFilter = PersonStatus.inactive;
              _currentPage = 1;
            }),
          ),
        ],
      ),
    );

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: [
              titleBlock,
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 10,
                children: [
                  searchBox,
                  addButton,
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 10,
            runSpacing: 10,
            children: [
              statusFilters,
              _buildDropdownFilter(
                context: context,
                colors: colors,
                label: 'Area',
                value: _areaFilter,
                items: availableAreas,
                icon: Icons.location_on_outlined,
                onChanged: (val) => setState(() {
                  _areaFilter = val;
                  _currentPage = 1;
                }),
              ),
              _buildDropdownFilter(
                context: context,
                colors: colors,
                label: 'Role',
                value: _roleFilter,
                items: const ['Teacher', 'Student', 'Unassigned'],
                icon: Icons.badge_outlined,
                onChanged: (val) => setState(() {
                  _roleFilter = val;
                  _currentPage = 1;
                }),
              ),
              _buildDropdownFilter(
                context: context,
                colors: colors,
                label: 'Occupation',
                value: _occupationFilter,
                items: availableOccupations,
                icon: Icons.work_outline,
                onChanged: (val) => setState(() {
                  _occupationFilter = val;
                  _currentPage = 1;
                }),
              ),
              if (_areaFilter != null || _roleFilter != null || _occupationFilter != null)
                TextButton.icon(
                  onPressed: () => setState(() {
                    _areaFilter = null;
                    _roleFilter = null;
                    _occupationFilter = null;
                    _currentPage = 1;
                  }),
                  icon: const Icon(Icons.clear_all, size: 16),
                  label: const Text('Reset Filters', style: TextStyle(fontSize: 12)),
                  style: TextButton.styleFrom(
                    foregroundColor: colors.hintColor,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 0.8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildDropdownFilter({
    required BuildContext context,
    required AppColors colors,
    required String label,
    required String? value,
    required List<String> items,
    required IconData icon,
    required ValueChanged<String?> onChanged,
  }) {
    final isSelected = value != null;
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? colors.primaryColor : const Color(0xFFD0D5DD),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String?>(
          value: value,
          isDense: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            size: 17,
            color: isSelected ? colors.primaryColor : colors.hintColor,
          ),
          style: TextStyle(
            fontSize: 12.5,
            color: isSelected ? colors.primaryColor : colors.textColor,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          ),
          hint: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 14, color: colors.hintColor),
              const SizedBox(width: 6),
              Text(label, style: TextStyle(fontSize: 12.5, color: colors.hintColor)),
            ],
          ),
          items: [
            DropdownMenuItem<String?>(
              value: null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 14, color: colors.hintColor),
                  const SizedBox(width: 6),
                  Text('All $label', style: TextStyle(color: colors.textColor)),
                ],
              ),
            ),
            for (final item in items)
              DropdownMenuItem<String?>(
                value: item,
                child: Text(item, style: TextStyle(color: colors.textColor)),
              ),
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    final bg = isActive ? const Color(0xFFECFDF3) : const Color(0xFFFEF3F2);
    final border =
        isActive ? const Color(0xFFA6F4C5) : const Color(0xFFFECDCA);
    final text = isActive ? const Color(0xFF027A48) : const Color(0xFFB42318);
    final dotColor =
        isActive ? const Color(0xFF12B76A) : const Color(0xFFF04438);
    final label = isActive ? 'Active' : 'Inactive';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: border, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionMenu(Person person, AppColors colors) {
    final isActive = person.status == PersonStatus.active;

    return Theme(
      data: Theme.of(context).copyWith(
        cardColor: Colors.white,
      ),
      child: PopupMenuButton<String>(
        tooltip: 'Actions',
        offset: const Offset(0, 36),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFFEAECF0)),
        ),
        elevation: 4,
        onSelected: (action) {
          if (action == 'edit') {
            _openEditPerson(person);
          } else if (action == 'assign_teacher') {
            AssignTeacherDialog.show(
              context,
              person: person,
              onSuccess: _refreshList,
            );
          } else if (action == 'admit_student') {
            AdmitStudentDialog.show(
              context,
              person: person,
              onSuccess: _refreshList,
            );
          } else if (action == 'assign_admin') {
            AssignPathshalaAdminDialog.show(
              context,
              initialPerson: person,
              onSuccess: _refreshList,
            );
          } else if (action == 'toggle') {
            _togglePersonStatus(person);
          }
        },
        itemBuilder: (ctx) => [
          PopupMenuItem<String>(
            value: 'edit',
            height: 38,
            child: Row(
              children: const [
                Icon(Icons.edit_outlined, size: 16, color: Color(0xFF344054)),
                SizedBox(width: 8),
                Text(
                  'Edit',
                  style: TextStyle(fontSize: 13, color: Color(0xFF344054)),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'assign_admin',
            height: 38,
            child: Row(
              children: [
                Icon(Icons.admin_panel_settings_outlined, size: 16, color: colors.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Assign as Pathshala Admin',
                  style: TextStyle(fontSize: 13, color: Color(0xFF344054)),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'assign_teacher',
            height: 38,
            child: Row(
              children: [
                Icon(Icons.school_outlined, size: 16, color: colors.primaryColor),
                const SizedBox(width: 8),
                const Text(
                  'Assign as Teacher',
                  style: TextStyle(fontSize: 13, color: Color(0xFF344054)),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'admit_student',
            height: 38,
            child: Row(
              children: const [
                Icon(Icons.person_add_alt_1_outlined, size: 16, color: Color(0xFF2563EB)),
                SizedBox(width: 8),
                Text(
                  'Admit as Student',
                  style: TextStyle(fontSize: 13, color: Color(0xFF344054)),
                ),
              ],
            ),
          ),
          const PopupMenuDivider(height: 1),
          PopupMenuItem<String>(
            value: 'toggle',
            height: 38,
            child: Row(
              children: [
                Icon(
                  isActive
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline,
                  size: 16,
                  color: isActive ? Colors.orange[800] : Colors.green[700],
                ),
                const SizedBox(width: 8),
                Text(
                  isActive ? 'Deactivate' : 'Activate',
                  style: TextStyle(
                    fontSize: 13,
                    color: isActive ? Colors.orange[800] : Colors.green[700],
                  ),
                ),
              ],
            ),
          ),
        ],
        child: Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFFD0D5DD)),
          ),
          child: const Icon(
            Icons.more_horiz,
            size: 18,
            color: Color(0xFF667085),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(
    BuildContext context,
    AppColors colors,
    List<Person> people,
    List<Person> allPeople,
  ) {
    final status = listPeopleController.processStatusNotifier.status;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tableBg = isDark ? const Color(0xFF13201F) : Colors.white;
    final headerBg = isDark ? const Color(0xFF192A2A) : const Color(0xFFF9FAFB);
    final borderColor =
        isDark ? colors.dividerColor : const Color(0xFFEAECF0);
    final rowDividerColor =
        isDark ? colors.dividerColor : const Color(0xFFF2F4F7);
    final textMuted =
        isDark ? colors.hintColor : const Color(0xFF475467);

    if (status is ProcessLoading && allPeople.isEmpty) {
      return Container(
        height: 260,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tableBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: SizedBox(
          width: 28,
          height: 28,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: colors.primaryColor,
          ),
        ),
      );
    }

    if (people.isEmpty) {
      final isSearching =
          _searchQuery != null && _searchQuery!.trim().isNotEmpty;
      final isFiltering = _statusFilter != null;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: tableBg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: borderColor),
        ),
        child: CustomEmptyState(
          icon: isSearching || isFiltering
              ? Icons.search_off
              : Icons.person_add_alt_1_outlined,
          title: isSearching
              ? 'No matching person found'
              : (isFiltering
                  ? 'No people in this category'
                  : 'No one registered yet'),
          message: isSearching
              ? 'No person matches "${_searchQuery!.trim()}". Try a different name.'
              : (isFiltering
                  ? 'No ${_statusFilter == PersonStatus.active ? "active" : "inactive"} people found.'
                  : 'The community directory is empty. Register the first person to get started.'),
          actionLabel: isSearching || isFiltering ? null : 'Add New Person',
          onAction: isSearching || isFiltering ? null : _openAddPerson,
        ),
      );
    }

    // Pagination calculations
    final totalEntries = people.length;
    final totalPages = (totalEntries / _pageSize).ceil().clamp(1, 9999);
    final currentPage = _currentPage.clamp(1, totalPages);
    final startIndex = (currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, totalEntries);
    final pageItems = people.sublist(startIndex, endIndex);

    Widget buildTableHeader() {
      return Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: headerBg,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
          border: Border(bottom: BorderSide(color: borderColor)),
        ),
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: Text(
                '#',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: Text(
                'Person',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Area & Occupation',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Gender & Age',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                'Status',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: textMuted,
                ),
              ),
            ),
            SizedBox(
              width: 60,
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Actions',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget buildTableRow(Person person, int index) {
      final globalIndex = startIndex + index + 1;
      final initials = _getInitials(person.displayName);
      final age = _calculateAge(person.dateOfBirth);
      final gender = _displayGender(person.gender);
      final isActive = person.status == PersonStatus.active;

      final genderAgeText = [
        if (gender != null) gender,
        if (age != null) '$age yrs',
      ].join(' • ');

      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _openEditPerson(person),
          hoverColor: colors.softAccentColor.withValues(alpha: 0.08),
          child: Container(
            height: 60,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: rowDividerColor)),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 44,
                  child: Text(
                    '$globalIndex',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: colors.hintColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Row(
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: colors.softAccentColor.withValues(alpha: 0.6),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: colors.primaryColor.withValues(alpha: 0.2),
                          ),
                        ),
                        child: ClipOval(
                          child: (person.photoUrl != null &&
                                  person.photoUrl!.trim().isNotEmpty)
                              ? Image.network(
                                  person.photoUrl!,
                                  width: 36,
                                  height: 36,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Center(
                                    child: Text(
                                      initials,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w700,
                                        color: colors.primaryColor,
                                      ),
                                    ),
                                  ),
                                )
                              : Center(
                                  child: Text(
                                    initials,
                                    style: TextStyle(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: colors.primaryColor,
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    person.displayName,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w600,
                                      color: colors.textColor,
                                    ),
                                  ),
                                ),
                                if (person.roles.contains('Teacher')) ...[
                                  const SizedBox(width: 6),
                                  _buildRoleBadge('Teacher', const Color(0xFF16A34A)),
                                ] else if (person.roles.contains('Student')) ...[
                                  const SizedBox(width: 6),
                                  _buildRoleBadge('Student', const Color(0xFF2563EB)),
                                ],
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              person.primaryEmail ?? person.legalName,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 12,
                                color: colors.hintColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.location_on_outlined, size: 13, color: colors.hintColor),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              person.area ?? '—',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: colors.textColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        person.occupation ?? '—',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          color: colors.hintColor,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    person.primaryPhone ?? '—',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: colors.textColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    genderAgeText.isEmpty ? '—' : genderAgeText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: colors.hintColor,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _buildStatusBadge(isActive),
                  ),
                ),
                SizedBox(
                  width: 60,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _buildActionMenu(person, colors),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    Widget buildTableFooter() {
      final canPrev = currentPage > 1;
      final canNext = currentPage < totalPages;

      return Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: tableBg,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(10)),
        ),
        child: Row(
          children: [
            Text(
              'Showing result ${totalEntries == 0 ? 0 : startIndex + 1}-$endIndex of $totalEntries Entries',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: colors.hintColor,
              ),
            ),
            const Spacer(),
            OutlinedButton(
              onPressed: canPrev
                  ? () => setState(() => _currentPage = currentPage - 1)
                  : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                side: BorderSide(
                  color: canPrev ? const Color(0xFFD0D5DD) : const Color(0xFFEAECF0),
                ),
              ),
              child: Text(
                'Previous',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: canPrev ? colors.textColor : colors.hintColor,
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton(
              onPressed: canNext
                  ? () => setState(() => _currentPage = currentPage + 1)
                  : null,
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                side: BorderSide(
                  color: canNext ? const Color(0xFFD0D5DD) : const Color(0xFFEAECF0),
                ),
              ),
              child: Text(
                'Next',
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: canNext ? colors.textColor : colors.hintColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final content = Column(
          children: [
            buildTableHeader(),
            for (int i = 0; i < pageItems.length; i++)
              buildTableRow(pageItems[i], i),
            buildTableFooter(),
          ],
        );

        final tableWidth = math.max(constraints.maxWidth, 940.0);

        final card = Container(
          decoration: BoxDecoration(
            color: tableBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: tableWidth,
              child: content,
            ),
          ),
        );

        return card;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return ResponsiveAppShell(
      selectedIndex: _selectedIndex,
      onItemSelected: _onSidebarItemSelected,
      topBarTitle: 'Overview',
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: AppSizes.pagePadding(context),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 720;

                  return AnimatedBuilder(
                    animation: Listenable.merge([
                      listPeopleController,
                      listPeopleController.processStatusNotifier,
                    ]),
                    builder: (context, _) {
                      final allPeople = listPeopleController.people;
                      var people = _statusFilter == null
                          ? allPeople
                          : allPeople
                              .where((p) => p.status == _statusFilter)
                              .toList();

                      if (_areaFilter != null) {
                        people = people.where((p) => p.area == _areaFilter).toList();
                      }
                      if (_roleFilter != null) {
                        people = people.where((p) {
                          if (_roleFilter == 'Teacher') return p.roles.contains('Teacher');
                          if (_roleFilter == 'Student') return p.roles.contains('Student');
                          if (_roleFilter == 'Unassigned') {
                            return p.roles.isEmpty || p.roles.contains('Unassigned');
                          }
                          return true;
                        }).toList();
                      }
                      if (_occupationFilter != null) {
                        people = people.where((p) => p.occupation == _occupationFilter).toList();
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTopBar(context, colors, allPeople, isNarrow),
                          const SizedBox(height: 18),
                          _buildTable(context, colors, people, allPeople),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            color: colors.tileColor,
            height: 40,
            child: Center(
              child: Text(
                '© 2024 Geetha Pathshala Management. All rights reserved.',
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
