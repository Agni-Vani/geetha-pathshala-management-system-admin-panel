import 'package:flutter/material.dart';

import '../../../../../core/shared/widget/ornamental_card.dart';
import '../../../../../core/theme/app_colors.dart';

/// Registry card for one person.
///
/// Deliberately plainer than [CustomPathshalaCard]: a Pathshala is a place and
/// carries the gurukul illustration, while a person card is a directory entry —
/// parchment, an initials avatar and the contact details, so the information
/// stays the loudest thing on the card.
class CustomPersonCard extends StatelessWidget {
  final String name;
  final String? legalName;
  final String? phone;
  final String? email;
  final String? gender;
  final DateTime? dateOfBirth;

  /// Only a non-active person is marked — an "Active" badge on every card is
  /// noise, since active is the norm.
  final bool isActive;
  final VoidCallback? onTap;

  const CustomPersonCard({
    super.key,
    required this.name,
    this.legalName,
    this.phone,
    this.email,
    this.gender,
    this.dateOfBirth,
    this.isActive = true,
    this.onTap,
  });

  String get _initials {
    final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first.characters.first.toUpperCase();
    return (parts.first.characters.first + parts.last.characters.first).toUpperCase();
  }

  int? get _age {
    if (dateOfBirth == null) return null;
    final now = DateTime.now();
    var years = now.year - dateOfBirth!.year;
    final hadBirthday = now.month > dateOfBirth!.month ||
        (now.month == dateOfBirth!.month && now.day >= dateOfBirth!.day);
    if (!hadBirthday) years -= 1;
    return years < 0 ? null : years;
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);
    // Only worth a second line when it differs from the name already shown.
    final trimmedLegalName = legalName?.trim();
    final subtitle = (trimmedLegalName != null &&
            trimmedLegalName.isNotEmpty &&
            trimmedLegalName != name.trim())
        ? trimmedLegalName
        : null;

    final age = _age;
    final normalizedGender = gender?.trim();
    final chips = <Widget>[
      if (normalizedGender != null && normalizedGender.isNotEmpty)
        _MetaChip(icon: Icons.wc_outlined, label: normalizedGender, colors: colors),
      if (age != null)
        _MetaChip(icon: Icons.cake_outlined, label: '$age yrs', colors: colors),
      if (!isActive)
        _MetaChip(
          icon: Icons.pause_circle_outline,
          label: 'Inactive',
          colors: colors,
          foreground: colors.errorColor,
        ),
    ];

    return OrnamentalCard(
      onTap: onTap,
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _InitialsAvatar(initials: _initials, colors: colors),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: colors.textColor,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 11.5, color: colors.hintColor),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(height: 1, color: colors.ornamentColor.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          _ContactRow(
            icon: Icons.call_outlined,
            value: phone,
            placeholder: 'No phone added',
            colors: colors,
          ),
          const SizedBox(height: 9),
          _ContactRow(
            icon: Icons.mail_outline,
            value: email,
            placeholder: 'No email added',
            colors: colors,
          ),
          if (chips.isNotEmpty) ...[
            const Spacer(),
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: chips),
          ],
        ],
      ),
    );
  }
}

class _InitialsAvatar extends StatelessWidget {
  final String initials;
  final AppColors colors;

  const _InitialsAvatar({required this.initials, required this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colors.softAccentColor,
        border: Border.all(color: colors.ornamentColor),
      ),
      child: Text(
        initials,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1,
          color: colors.primaryColor,
        ),
      ),
    );
  }
}

class _ContactRow extends StatelessWidget {
  final IconData icon;
  final String? value;
  final String placeholder;
  final AppColors colors;

  const _ContactRow({
    required this.icon,
    required this.value,
    required this.placeholder,
    required this.colors,
  });

  @override
  Widget build(BuildContext context) {
    final trimmed = value?.trim();
    final isMissing = trimmed == null || trimmed.isEmpty;

    return Row(
      children: [
        Container(
          height: 24,
          width: 24,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: colors.softAccentColor,
            borderRadius: BorderRadius.circular(7),
          ),
          child: Icon(icon, size: 13, color: colors.primaryColor),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: Text(
            isMissing ? placeholder : trimmed,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12,
              color: isMissing ? colors.hintColor : colors.textColor,
              fontStyle: isMissing ? FontStyle.italic : FontStyle.normal,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final AppColors colors;
  final Color? foreground;

  const _MetaChip({
    required this.icon,
    required this.label,
    required this.colors,
    this.foreground,
  });

  @override
  Widget build(BuildContext context) {
    final color = foreground ?? colors.hintColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colors.softAccentColor.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: colors.ornamentColor.withValues(alpha: 0.7)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}
