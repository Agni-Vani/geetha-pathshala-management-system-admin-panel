import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_widgets/custom_button.dart';
import '../widgets/custom_widgets/custom_search_filter_bar.dart';
import '../widgets/custom_widgets/custom_sidebar.dart';
import '../widgets/custom_widgets/custom_top_bar.dart';
import 'add_new_patshala_view.dart';

class AllPatshalaView extends StatefulWidget {
  const AllPatshalaView({super.key});

  @override
  State<AllPatshalaView> createState() => _AllPatshalaViewState();
}

class _AllPatshalaViewState extends State<AllPatshalaView> {
  int _selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return Scaffold(
      backgroundColor: colors.tileColor,
      body: Row(
        children: [
          CustomSidebar(
            selectedIndex: _selectedIndex,
            onItemSelected: (index) => setState(() => _selectedIndex = index),
            onLogout: () => Navigator.of(context).maybePop(),
          ),
          Expanded(
            child: Column(
              children: [
                CustomTopBar(title: 'Overview', onBack: () => Navigator.of(context).maybePop()),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "পাঠশালা সমূহ",
                              style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500, color: colors.primaryColor),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Manage and monitor all registered Gita Pathshalas across regions.",
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNewPatshalaView()));
                          },
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            decoration: BoxDecoration(color: colors.primaryColor, borderRadius: BorderRadius.circular(8)),
                            child: Row(
                              children: [
                                Icon(Icons.add, size: 18, color: Colors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Add New Pathshala',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(padding: const EdgeInsets.symmetric(horizontal: 24.0), child: CustomSearchFilterBar()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 24,
                        mainAxisSpacing: 24,
                        childAspectRatio: 1.5,
                      ),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(color: colors.backgroundColor, borderRadius: BorderRadius.circular(8)),
                          child: Center(
                            child: Text(
                              'Pathshala ${index + 1}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: colors.primaryColor),
                            ),
                          ),
                        );
                      },
                      itemCount: 6,
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
          ),
        ],
      ),
    );
  }
}
