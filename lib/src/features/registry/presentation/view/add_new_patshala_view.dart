import 'package:flutter/material.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/snackbar_notifier.dart';
import 'package:geetha_pathshala_management_web/src/core/shared/reactive_notifier/widget/process_notifier_button.dart';
import 'package:geetha_pathshala_management_web/src/di/di.dart';
import 'package:geetha_pathshala_management_web/src/features/registry/presentation/controller/create_pathshala_controller.dart';

import '../../../../core/theme/app_colors.dart';
import '../widgets/custom_widgets/custom_sidebar.dart';
import '../widgets/custom_widgets/custom_top_bar.dart';

class AddNewPatshalaView extends StatefulWidget {

  const AddNewPatshalaView({super.key});

  @override
  State<AddNewPatshalaView> createState() => _AddNewPatshalaViewState();
}

class _AddNewPatshalaViewState extends State<AddNewPatshalaView> {
  int _selectedIndex = 1;
  CreatePathshalaController createPathshalaController = sl.get<CreatePathshalaController>();
  late final SnackbarNotifier snackbarNotifier;

  @override
  void initState() {
    snackbarNotifier = SnackbarNotifier(context: context);
    // TODO: implement initState
    super.initState();
  }

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
                Expanded(
                  child: Container(
                    color: colors.tileColor,
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text('Pathshalas', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Icon(Icons.chevron_right, size: 14, color: colors.hintColor),
                            ),
                            Text('Add New Pathshala', style: TextStyle(fontSize: 12, color: colors.hintColor)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Add New Pathshala',
                          style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: colors.primaryColor),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Register a new study center to expand the community's access to ancient wisdom.",
                          style: TextStyle(color: colors.hintColor),
                        ),
                        Flexible(
                          child: Container(
                            width: double.infinity,
                            margin: const EdgeInsets.symmetric(vertical: 24),

                            decoration: BoxDecoration(
                              color: colors.backgroundColor,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))],
                            ),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,

                                children: [
                                  Text(
                                    'General Information',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: colors.primaryColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.black),
                        ),

                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),

                          child: Center(
                            child: Text('Cancel', style: TextStyle(fontSize: 12, color: Colors.black)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 15),

                      RProcessNotifierButton(
                        key: UniqueKey(),
                        height: 50,
                        width: 200,
                        generalText: 'Save Pathshala',
                        loadingText: "Saving Information",
                        errorText: "Error Saving Information",
                        processStatusNotifier: createPathshalaController.processStatusNotifier,
                        onSave: (processNotifier) {
                          debugPrint("Save Clicked");
                          createPathshalaController.create(snackbarNotifier: snackbarNotifier);
                        },
                        onDone: () {
                          Navigator.pop(context);
                        },
                      ),
                      
                    ],
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
