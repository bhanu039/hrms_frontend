import 'package:flutter/material.dart';

import '../app_constants/app_color.dart';
import '../app_constants/app_thems.dart';
import '../theme/theme_controller.dart';

class DrawerWidgets {
  static Widget buildHeader({
    required String name,
    required String email,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(
        top: 50,
        bottom: 22,
        left: 18,
        right: 18,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.backgroundColor, AppColors.primaryColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: AppColors.white,
            child: Icon(
              Icons.business,
              size: 40,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name.isEmpty ? 'Company' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.secondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            email.isEmpty ? 'company@email.com' : email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  static Widget menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color color = AppColors.primaryColor,
    VoidCallback? onTap,
    List<MenuSubItem> subItems = const [],
  }) {
    final theme = Theme.of(context);

    if (subItems.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: AppColors.primaryColor,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Theme(
          data: theme.copyWith(dividerColor: AppColors.transparent),
          child: ExpansionTile(
            leading: Icon(icon, color: color),
            title: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
            ),
            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            tilePadding: const EdgeInsets.symmetric(horizontal: 16),
            childrenPadding: const EdgeInsets.only(
              left: 16,
              right: 8,
              bottom: 8,
            ),
            children: subItems.map((item) {
              return ListTile(
                dense: true,
                leading: Icon(item.icon, size: 20, color: AppColors.grey),
                title: Text(
                  item.title,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                onTap: item.onTap ?? () => showComingSoon(context, item.title),
              );
            }).toList(),
          ),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: AppColors.primaryColor,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.w600, color: color),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: AppColors.secondaryColor,
        ),
        onTap: onTap ?? () => showComingSoon(context, title),
      ),
    );
  }

  static Widget themeModeTile(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.mode,
      builder: (context, themeMode, _) {
        final isDark = themeMode == ThemeMode.dark;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryColor,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: SwitchListTile(
            secondary: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              color: AppColors.primary,
            ),
            title: const Text(
              'Dark mode',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(isDark ? 'Using dark theme' : 'Using light theme'),
            value: isDark,
            activeColor: AppColors.primary,
            onChanged: (_) => ThemeController.toggle(),
          ),
        );
      },
    );
  }

  static Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: AppColors.textSecondaryColor,
          letterSpacing: 1,
        ),
      ),
    );
  }

  static void showComingSoon(
    BuildContext context,
    String title,
  ) {
    final messenger = ScaffoldMessenger.of(context);

    Navigator.pop(context);

    messenger.showSnackBar(
      SnackBar(
        content: Text('$title screen coming soon'),
      ),
    );
  }
}

class MenuSubItem {
  const MenuSubItem({
    required this.icon,
    required this.title,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback? onTap;
}
