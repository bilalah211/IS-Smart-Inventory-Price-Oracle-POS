import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool showBackButton;
  final IconData? icon;
  final VoidCallback? onTap;

  const MyAppbar({
    super.key,
    required this.title,
    this.actions,
    this.showBackButton = false,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(title, style: const TextStyle(color: Colors.white)),
      backgroundColor: AppColors.primaryLight,

      // 🔹 LEADING FIX
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            )
          : icon != null
          ? IconButton(
              icon: Icon(icon, color: Colors.white),
              onPressed:
                  onTap ??
                  () {
                    Scaffold.of(context).openDrawer();
                  },
            )
          : null,

      actions: actions,
      actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
