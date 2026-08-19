import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../features/registry/domain/registry_domain.dart';
import '../../features/registry/presentation/view/add_new_patshala_view.dart';
import '../../features/registry/presentation/view/add_person_view.dart';
import '../../features/registry/presentation/widgets/custom_widgets/custom_section_header.dart';
import '../../features/registry/presentation/widgets/custom_widgets/responsive_app_shell.dart';
import 'all_patshala_view.dart';

const _bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];

String _bn(Object value) {
  return value.toString().split('').map((c) {
    final digit = int.tryParse(c);
    return digit != null ? _bnDigits[digit] : c;
  }).join();
}

class _StatInfo {
  final IconData icon;
  final String label;
  final String value;
  final Color tint;

  const _StatInfo({required this.icon, required this.label, required this.value, required this.tint});
}

class _AdminInfo {
  final String name;
  final String role;
  final String phone;
  final String email;
  final String joinedOn;

  const _AdminInfo({
    required this.name,
    required this.role,
    required this.phone,
    required this.email,
    required this.joinedOn,
  });
}

class PatshalaDetailsView extends StatefulWidget {
  final Pathshala pathshala;

  const PatshalaDetailsView({super.key, required this.pathshala});

  @override
  State<PatshalaDetailsView> createState() => _PatshalaDetailsViewState();
}

class _PatshalaDetailsViewState extends State<PatshalaDetailsView> {
  static const _tabs = ['সারসংক্ষেপ', 'প্রশাসক', 'শিক্ষক', 'শিক্ষার্থী', 'উপস্থিতি', 'কার্যক্রম'];

  // TODO: this section's data (head, stats, administrator profile) isn't
  // backed by the domain layer yet — placeholder values only, matching the
  // provided design, until a real usecase/entity exists for them.
  static const _demoHead = 'Sri Ramakanta Das';
  static const _demoAdmin = _AdminInfo(
    name: 'সঞ্জয় রায়',
    role: 'প্রধান প্রশাসক',
    phone: '+৮৮০ ১৭১২-৩৪৫৬৭৮',
    email: 'sanjay.roy@gitapathshala.org',
    joinedOn: '১২ জানুয়ারি, ২০২৩',
  );

  int _selectedIndex = 1;
  int _selectedTab = 1;

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    switch (index) {
      case 1:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AllPatshalaView()));
        break;
      case 2:
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const AddPersonRegistryView()));
        break;
      default:
        setState(() => _selectedIndex = index);
    }
  }

  // Material's OutlinedButton.icon/ElevatedButton.icon throw a
  // "BoxConstraints forces an infinite width" layout error when nested as a
  // bare Row child without Expanded (their internal _InputPadding wrapper
  // can't resolve the unbounded main-axis constraint Row hands non-flex
  // children). The rest of the app avoids this by hand-rolling buttons with
  // InkWell + Container + Row — mirroring that here.
  Widget _pillButton({
    required VoidCallback? onPressed,
    required IconData icon,
    required String label,
    required bool filled,
    required AppColors colors,
    bool expand = false,
  }) {
    final contentColor = filled ? Colors.white : colors.primaryColor;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: expand ? double.infinity : null,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 13),
        decoration: BoxDecoration(
          color: filled ? colors.primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: filled ? null : Border.all(color: colors.primaryColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: contentColor),
            const SizedBox(width: 8),
            Text(label, style: TextStyle(color: contentColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  List<_StatInfo> _stats(AppColors colors) => [
        _StatInfo(icon: Icons.people_alt_outlined, label: 'শিক্ষার্থী', value: _bn(85), tint: colors.primaryColor),
        _StatInfo(icon: Icons.record_voice_over_outlined, label: 'শিক্ষক', value: _bn(5), tint: const Color(0xFFB8860B)),
        _StatInfo(icon: Icons.event_available_outlined, label: 'উপস্থিতি', value: '${_bn(93)}%', tint: const Color(0xFF2E7BC4)),
        _StatInfo(icon: Icons.campaign_outlined, label: 'নোটিশ', value: _bn(12), tint: colors.errorColor),
      ];

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final pathshala = widget.pathshala;

    return ResponsiveAppShell(
      selectedIndex: _selectedIndex,
      onItemSelected: _onSidebarItemSelected,
      onLogout: () => Navigator.of(context).maybePop(),
      topBarTitle: 'Overview',
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 640;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopRow(colors, pathshala, isNarrow),
                      const SizedBox(height: 20),
                      _buildHeaderCard(colors, pathshala, isNarrow),
                      const SizedBox(height: 24),
                      _buildStatsGrid(colors, isNarrow),
                      const SizedBox(height: 24),
                      _buildTabs(colors),
                      const SizedBox(height: 20),
                      _buildTabContent(colors, isNarrow),
                    ],
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

  Widget _buildTopRow(AppColors colors, Pathshala pathshala, bool isNarrow) {
    final breadcrumb = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Pathshalas', style: TextStyle(fontSize: 12, color: colors.hintColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
        ),
        Flexible(
          child: Text(
            pathshala.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: colors.textColor, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );

    final actions = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _pillButton(
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => AddNewPatshalaView(existingPathshala: pathshala)))
                .then((_) => setState(() {}));
          },
          icon: Icons.edit_outlined,
          label: 'Edit',
          filled: false,
          colors: colors,
        ),
        const SizedBox(width: 12),
        _pillButton(
          onPressed: () {},
          icon: Icons.add,
          label: 'Add Class',
          filled: true,
          colors: colors,
        ),
      ],
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [breadcrumb, const SizedBox(height: 12), actions],
      );
    }

    return Row(
      children: [
        Expanded(child: breadcrumb),
        actions,
      ],
    );
  }

  Widget _buildHeaderCard(AppColors colors, Pathshala pathshala, bool isNarrow) {
    final info = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 32,
          backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
          child: Icon(Icons.account_balance_outlined, color: colors.primaryColor, size: 30),
        ),
        const SizedBox(width: 16),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: 10,
                runSpacing: 6,
                children: [
                  Text(
                    pathshala.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: colors.textColor),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: pathshala.isOperational ? const Color(0xFFE6F4EA) : colors.tileColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      pathshala.isOperational ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: pathshala.isOperational ? const Color(0xFF1E7B34) : colors.hintColor,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: colors.hintColor),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      pathshala.address.formatted,
                      style: TextStyle(fontSize: 13, color: colors.textColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.person_outline, size: 16, color: colors.hintColor),
                  const SizedBox(width: 6),
                  Text('Head: $_demoHead', style: TextStyle(fontSize: 13, color: colors.textColor)),
                ],
              ),
            ],
          ),
        ),
      ],
    );

    final scheduleButton = _pillButton(
      onPressed: () {},
      icon: Icons.visibility_outlined,
      label: 'View Class Schedule',
      filled: true,
      colors: colors,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Stack(
        children: [
          Positioned(
            top: isNarrow ? -16 : -30,
            right: isNarrow ? -16 : -30,
            child: Container(
              width: isNarrow ? 80 : 140,
              height: isNarrow ? 80 : 140,
              decoration: BoxDecoration(shape: BoxShape.circle, color: colors.primaryColor.withValues(alpha: 0.05)),
            ),
          ),
          isNarrow
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [info, const SizedBox(height: 16), SizedBox(width: double.infinity, child: scheduleButton)],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: info),
                    const SizedBox(width: 16),
                    scheduleButton,
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(AppColors colors, bool isNarrow) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isNarrow ? 2 : 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        mainAxisExtent: 130,
      ),
      itemCount: _stats(colors).length,
      itemBuilder: (context, index) {
        final stat = _stats(colors)[index];
        return Container(
          padding: const EdgeInsets.all(18),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: colors.backgroundColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Stack(
            children: [
              Positioned(
                bottom: -20,
                right: -20,
                child: Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: stat.tint.withValues(alpha: 0.06)),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: stat.tint.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(stat.icon, size: 18, color: stat.tint),
                      ),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          stat.label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.textColor),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    stat.value,
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: colors.textColor),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTabs(AppColors colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(bottom: BorderSide(color: colors.dividerColor)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            for (var i = 0; i < _tabs.length; i++)
              InkWell(
                onTap: () => setState(() => _selectedTab = i),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: _selectedTab == i ? colors.primaryColor : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: Text(
                    _tabs[i],
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: _selectedTab == i ? FontWeight.bold : FontWeight.w500,
                      color: _selectedTab == i ? colors.primaryColor : colors.hintColor,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabContent(AppColors colors, bool isNarrow) {
    if (_selectedTab != 1) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: colors.backgroundColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
        ),
        child: Center(
          child: Text('${_tabs[_selectedTab]} — শীঘ্রই আসছে।', style: TextStyle(color: colors.hintColor)),
        ),
      );
    }

    final photo = CircleAvatar(
      radius: 40,
      backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
      child: Icon(Icons.person, color: colors.primaryColor, size: 40),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_demoAdmin.name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: colors.textColor)),
        const SizedBox(height: 2),
        Text(_demoAdmin.role, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colors.primaryColor)),
        const SizedBox(height: 12),
        Row(
          children: [
            Icon(Icons.call_outlined, size: 15, color: colors.hintColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _demoAdmin.phone,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: colors.textColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.mail_outline, size: 15, color: colors.hintColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                _demoAdmin.email,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: colors.textColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, size: 15, color: colors.hintColor),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'যোগদান: ${_demoAdmin.joinedOn}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 13, color: colors.textColor),
              ),
            ),
          ],
        ),
      ],
    );

    final changeButton = _pillButton(
      onPressed: () {},
      icon: Icons.manage_accounts_outlined,
      label: 'প্রশাসক পরিবর্তন',
      filled: false,
      colors: colors,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: colors.shadowColor, blurRadius: 6, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomSectionHeader(icon: Icons.shield_outlined, title: 'বর্তমান প্রশাসক'),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(color: colors.tileColor, borderRadius: BorderRadius.circular(12)),
            child: Stack(
              children: [
                Positioned(
                  bottom: -20,
                  right: -10,
                  child: Icon(Icons.groups, size: 110, color: colors.primaryColor.withValues(alpha: 0.06)),
                ),
                isNarrow
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [photo, const SizedBox(width: 16), Expanded(child: details)]),
                          const SizedBox(height: 16),
                          SizedBox(width: double.infinity, child: changeButton),
                        ],
                      )
                    : Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          photo,
                          const SizedBox(width: 16),
                          Expanded(child: details),
                          changeButton,
                        ],
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
