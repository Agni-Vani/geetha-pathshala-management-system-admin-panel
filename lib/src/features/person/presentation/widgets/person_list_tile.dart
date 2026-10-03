import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/person.dart';
import '../../domain/entities/person_enums.dart';

/// Single-row tile representing one registered person in the directory.
class PersonListTile extends StatelessWidget {
  final Person person;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onToggleStatus;

  const PersonListTile({
    super.key,
    required this.person,
    this.onTap,
    this.onEdit,
    this.onToggleStatus,
  });

  String get _initials {
    final name = person.displayName.trim();
    final parts = name.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  int? get _age {
    final dob = person.dateOfBirth;
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

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    final isActive = person.status == PersonStatus.active;
    final age = _age;
    final gender = _displayGender(person.gender);

    final showLegalDiff = person.preferredName != null &&
        person.preferredName!.trim().isNotEmpty &&
        person.preferredName!.trim() != person.legalName.trim();

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 780;
        final isMedium = constraints.maxWidth >= 520 && constraints.maxWidth < 780;

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            hoverColor: colors.softAccentColor.withValues(alpha: 0.12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF13201F) : Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isDark ? colors.dividerColor : const Color(0xFFE5E7EB),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: isWide
                  ? _buildWideRow(colors, isActive, age, gender, showLegalDiff)
                  : (isMedium
                      ? _buildMediumRow(colors, isActive, age, gender, showLegalDiff)
                      : _buildNarrowColumn(colors, isActive, age, gender, showLegalDiff)),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar(AppColors colors) {
    return Container(
      width: 38,
      height: 38,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors.softAccentColor.withValues(alpha: 0.6),
        shape: BoxShape.circle,
        border: Border.all(
          color: colors.primaryColor.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        _initials,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: colors.primaryColor,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(bool isActive) {
    final bg = isActive ? const Color(0xFFECFDF5) : const Color(0xFFFFF7ED);
    final border = isActive ? const Color(0xFFA7F3D0) : const Color(0xFFFED7AA);
    final text = isActive ? const Color(0xFF065F46) : const Color(0xFF9A3412);
    final dotColor = isActive ? const Color(0xFF10B981) : const Color(0xFFF97316);
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
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(AppColors colors, bool isActive) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onToggleStatus != null)
          IconButton(
            icon: Icon(
              isActive ? Icons.pause_circle_outline : Icons.play_circle_outline,
              size: 19,
              color: isActive ? colors.hintColor : Colors.green[700],
            ),
            tooltip: isActive ? 'Mark Inactive' : 'Mark Active',
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            onPressed: onToggleStatus,
          ),
        const SizedBox(width: 4),
        if (onEdit != null)
          IconButton(
            icon: Icon(
              Icons.edit_outlined,
              size: 19,
              color: colors.primaryColor,
            ),
            tooltip: 'Edit Person',
            padding: const EdgeInsets.all(6),
            constraints: const BoxConstraints(),
            onPressed: onEdit,
          ),
      ],
    );
  }

  Widget _buildWideRow(
    AppColors colors,
    bool isActive,
    int? age,
    String? gender,
    bool showLegalDiff,
  ) {
    return Row(
      children: [
        _buildAvatar(colors),
        const SizedBox(width: 14),

        // Name & preferred name
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                person.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
              ),
              if (showLegalDiff) ...[
                const SizedBox(height: 2),
                Text(
                  person.legalName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: colors.hintColor,
                  ),
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Phone & Email
        Expanded(
          flex: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (person.primaryPhone != null && person.primaryPhone!.isNotEmpty)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.call_outlined, size: 13, color: colors.hintColor),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        person.primaryPhone!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12.5, color: colors.textColor),
                      ),
                    ),
                  ],
                )
              else
                Text(
                  'No phone',
                  style: TextStyle(fontSize: 12, color: colors.hintColor, fontStyle: FontStyle.italic),
                ),
              if (person.primaryEmail != null && person.primaryEmail!.isNotEmpty) ...[
                const SizedBox(height: 2),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.mail_outline, size: 13, color: colors.hintColor),
                    const SizedBox(width: 5),
                    Flexible(
                      child: Text(
                        person.primaryEmail!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: colors.hintColor),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),

        const SizedBox(width: 12),

        // Gender & Age
        Expanded(
          flex: 2,
          child: Text(
            [
              if (gender != null) gender,
              if (age != null) '$age yrs',
            ].join(' • '),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12.5, color: colors.hintColor),
          ),
        ),

        const SizedBox(width: 12),

        // Status badge
        _buildStatusBadge(isActive),

        const SizedBox(width: 12),

        // Actions
        _buildActions(colors, isActive),
      ],
    );
  }

  Widget _buildMediumRow(
    AppColors colors,
    bool isActive,
    int? age,
    String? gender,
    bool showLegalDiff,
  ) {
    return Row(
      children: [
        _buildAvatar(colors),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                person.displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: colors.textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                [
                  if (person.primaryPhone != null) person.primaryPhone!,
                  if (gender != null) gender,
                  if (age != null) '$age yrs',
                ].join(' • '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 12, color: colors.hintColor),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        _buildStatusBadge(isActive),
        const SizedBox(width: 6),
        _buildActions(colors, isActive),
      ],
    );
  }

  Widget _buildNarrowColumn(
    AppColors colors,
    bool isActive,
    int? age,
    String? gender,
    bool showLegalDiff,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildAvatar(colors),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    person.displayName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: colors.textColor,
                    ),
                  ),
                  if (showLegalDiff)
                    Text(
                      person.legalName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11.5, color: colors.hintColor),
                    ),
                ],
              ),
            ),
            _buildActions(colors, isActive),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (person.primaryPhone != null && person.primaryPhone!.isNotEmpty) ...[
              Icon(Icons.call_outlined, size: 12, color: colors.hintColor),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  person.primaryPhone!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 12, color: colors.textColor),
                ),
              ),
              const SizedBox(width: 8),
            ],
            const Spacer(),
            _buildStatusBadge(isActive),
          ],
        ),
      ],
    );
  }
}
