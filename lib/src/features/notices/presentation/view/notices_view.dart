import 'package:flutter/material.dart';

import '../../../../core/constants/app_sizes.dart';
import '../../../../core/navigation/app_sidebar_navigation.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/shared/widget/custom_widgets/custom_button.dart';
import '../../../../core/shared/widget/custom_widgets/custom_status_badge.dart';
import '../../../../core/shared/widget/custom_widgets/responsive_app_shell.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../di/service_locator.dart';
import '../../domain/notices_domain.dart';
import '../controller/notices_controller.dart';
import '../widgets/add_edit_notice_dialog.dart';

class NoticesView extends StatefulWidget {
  const NoticesView({super.key});

  @override
  State<NoticesView> createState() => _NoticesViewState();
}

class _NoticesViewState extends State<NoticesView> {
  late final NoticesController _controller;
  int _selectedIndex = 7;

  @override
  void initState() {
    super.initState();
    _controller = sl<NoticesController>();
    _controller.load();
  }

  void _onSidebarItemSelected(int index) {
    if (index == _selectedIndex) return;
    setState(() => _selectedIndex = index);
    RegistrySidebarNavigation.pushReplacement(context, index);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    final months = [
      'জানুয়ারি', 'ফেব্রুয়ারি', 'মার্চ', 'এপ্রিল', 'মে', 'জুন',
      'জুলাই', 'আগস্ট', 'সেপ্টেম্বর', 'অক্টোবর', 'নভেম্বর', 'ডিসেম্বর'
    ];
    final bnDigits = ['০', '১', '২', '৩', '৪', '৫', '৬', '৭', '৮', '৯'];
    String bn(int num) => num.toString().split('').map((c) => bnDigits[int.parse(c)]).join();
    return '${bn(date.day)} ${months[date.month - 1]}, ${bn(date.year)}';
  }

  (String, StatusTone) _resolveBadge(Notice notice) {
    switch (notice.status) {
      case NoticeStatus.published:
        return ('Published', StatusTone.positive);
      case NoticeStatus.draft:
        return ('Draft', StatusTone.neutral);
      case NoticeStatus.archived:
        return ('Archived', StatusTone.negative);
    }
  }

  void _openAddNoticeDialog() {
    AddEditNoticeDialog.show(context, controller: _controller);
  }

  void _openEditNoticeDialog(Notice notice) {
    AddEditNoticeDialog.show(context, controller: _controller, notice: notice);
  }

  void _confirmDeleteNotice(Notice notice) {
    showDialog(
      context: context,
      builder: (ctx) {
        final colors = AppColors.context(ctx);
        return AlertDialog(
          backgroundColor: colors.backgroundColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.delete_outline, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'নোটিশ মুছে ফেলুন (Delete Notice)',
                  style: TextStyle(
                    color: colors.textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            '"${notice.title}" নোটিশটি স্থায়ীভাবে মুছে ফেলতে চান?',
            style: TextStyle(color: colors.textColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text('বাতিল', style: TextStyle(color: colors.hintColor)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                Navigator.of(ctx).pop();
                final snackbar = SnackbarNotifier(context: context);
                await _controller.deleteExistingNotice(
                  id: notice.id,
                  snackbarNotifier: snackbar,
                );
              },
              child: const Text('মুছে ফেলুন', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
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
      onTopBarBack: () => Navigator.of(context).maybePop(),
      body: ListenableBuilder(
        listenable: _controller,
        builder: (context, _) {
          final notices = _controller.notices;
          final isLoading = _controller.processStatusNotifier.status is ProcessLoading;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSizes.pagePadding(context),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isNarrow = constraints.maxWidth < 640;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(colors, isNarrow),
                          SizedBox(height: AppSizes.sectionGap(context)),
                          if (isLoading && notices.isEmpty)
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40.0),
                                child: CircularProgressIndicator(),
                              ),
                            )
                          else if (notices.isEmpty)
                            _buildEmptyState(colors)
                          else
                            for (final notice in notices) ...[
                              _buildNoticeCard(colors, notice),
                              const SizedBox(height: 16),
                            ],
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
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(AppColors colors) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          children: [
            Icon(Icons.campaign_outlined, size: 56, color: colors.hintColor.withValues(alpha: 0.5)),
            const SizedBox(height: 12),
            Text(
              'কোন নোটিশ পাওয়া যায়নি',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.textColor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'নতুন নোটিশ যুক্ত করতে উপরের "Add Notice" বোতামে চাপুন।',
              style: TextStyle(fontSize: 13, color: colors.hintColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(AppColors colors, bool isNarrow) {
    final titleBlock = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'নোটিশ',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: colors.primaryColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'সকল পাঠশালার জন্য প্রকাশিত নোটিশসমূহ।',
          style: TextStyle(color: colors.hintColor),
        ),
      ],
    );

    final addButton = SizedBox(
      width: isNarrow ? double.infinity : null,
      child: CustomButton(
        label: 'Add Notice',
        icon: Icons.add,
        onPressed: _openAddNoticeDialog,
      ),
    );

    if (isNarrow) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [titleBlock, const SizedBox(height: 16), addButton],
      );
    }

    return Row(
      children: [
        Expanded(child: titleBlock),
        const SizedBox(width: 16),
        IntrinsicWidth(child: addButton),
      ],
    );
  }

  Widget _buildNoticeCard(AppColors colors, Notice notice) {
    final (badgeLabel, badgeTone) = _resolveBadge(notice);

    String? targetName;
    if (notice.pathshalaId != null && _controller.pathshalas.isNotEmpty) {
      final found = _controller.pathshalas.where((p) => p.id == notice.pathshalaId);
      if (found.isNotEmpty) {
        targetName = found.first.name;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
            child: Icon(
              Icons.campaign_outlined,
              color: colors.primaryColor,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 10,
                        runSpacing: 6,
                        children: [
                          Text(
                            notice.title,
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.textColor,
                            ),
                          ),
                          CustomStatusBadge(label: badgeLabel, tone: badgeTone),
                          if (targetName != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: colors.primaryColor.withValues(alpha: 0.08),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                targetName,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: colors.primaryColor,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          tooltip: 'সম্পাদনা (Edit)',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: colors.hintColor,
                          onPressed: () => _openEditNoticeDialog(notice),
                        ),
                        const SizedBox(width: 12),
                        IconButton(
                          icon: const Icon(Icons.delete_outline, size: 18),
                          tooltip: 'মুছে ফেলুন (Delete)',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          color: Colors.red.withValues(alpha: 0.8),
                          onPressed: () => _confirmDeleteNotice(notice),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  notice.content,
                  style: TextStyle(fontSize: 13, color: colors.hintColor),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 13,
                      color: colors.hintColor,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        _formatDate(notice.publishedAt ?? notice.createdAt),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: colors.hintColor),
                      ),
                    ),
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
