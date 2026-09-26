import 'package:flutter/material.dart';

import '../../../../core/navigation/app_route_names.dart';
import '../../../../core/shared/reactive_notifier/process_notifier.dart';
import '../../../../core/shared/reactive_notifier/snackbar_notifier.dart';
import '../../../../core/shared/widget/app_background.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_field_decoration.dart';
import '../../../../di/service_locator.dart';
import '../controller/auth_controller.dart';

class LoginView extends StatefulWidget {
  final AuthController? controller;

  const LoginView({super.key, this.controller});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final AuthController _authController;
  late final SnackbarNotifier _snackbarNotifier;

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'arrow360degree@gmail.com');
  final _passwordController = TextEditingController(text: 'Admin@123456');

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _authController = widget.controller ?? sl<AuthController>();
    _snackbarNotifier = SnackbarNotifier(context: context);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _authController.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
      snackbarNotifier: _snackbarNotifier,
    );

    if (success && mounted) {
      Navigator.of(context).pushReplacementNamed(AppRouteNames.dashboard);
    }
  }

  void _fillFirstAdminCredentials() {
    setState(() {
      _emailController.text = 'arrow360degree@gmail.com';
      _passwordController.text = 'Admin@123456';
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.context(context);

    return AppBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 460),
              child: Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: colors.backgroundColor,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: colors.shadowColor.withValues(alpha: 0.1),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo and Brand Header
                      Center(
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: colors.primaryColor.withValues(alpha: 0.12),
                          child: Icon(
                            Icons.temple_hindu_outlined,
                            size: 36,
                            color: colors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'গীতা পাঠশালা',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: colors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'কেন্দ্রীয় প্রশাসনিক পোর্টাল',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          color: colors.hintColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // Email Field
                      Text(
                        'ইমেইল বা ইউজারনেম',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: const Key('login_email_field'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        autofillHints: const [AutofillHints.email],
                        decoration: AppFieldDecoration.build(
                          context,
                          hint: 'arrow360degree@gmail.com',
                          prefix: Icons.email_outlined,
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'অনুগ্রহ করে ইমেইল প্রদান করুন';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      Text(
                        'পাসওয়ার্ড',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: colors.textColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        key: const Key('login_password_field'),
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: AppFieldDecoration.build(
                          context,
                          hint: '••••••••',
                          prefix: Icons.lock_outline,
                        ).copyWith(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              size: 20,
                              color: colors.hintColor,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'অনুগ্রহ করে পাসওয়ার্ড প্রদান করুন';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _handleLogin(),
                      ),
                      const SizedBox(height: 16),

                      // Demo Admin Fast Fill Chip
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _fillFirstAdminCredentials,
                          icon: Icon(Icons.flash_on, size: 16, color: colors.primaryColor),
                          label: Text(
                            'Super Admin Credentials (Demo Fill)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: colors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Submit Button
                      ListenableBuilder(
                        listenable: _authController.processStatusNotifier,
                        builder: (context, _) {
                          final isLoading =
                              _authController.processStatusNotifier.status is ProcessLoading;

                          return ElevatedButton(
                            key: const Key('login_submit_button'),
                            onPressed: isLoading ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primaryColor,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 2,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : const Text(
                                    'লগইন করুন',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
