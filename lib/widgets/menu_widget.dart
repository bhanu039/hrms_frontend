import 'package:flutter/material.dart';

class DrawerWidgets {
  /// ================= HEADER =================
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
          colors: [
            Color(0xff0f766e),
            Color(0xff2563eb),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Colors.white,
            child: Icon(
              Icons.business,
              size: 40,
              color: Color(0xff0f766e),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            name.isEmpty ? 'Company' : name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            email.isEmpty ? 'company@email.com' : email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  /// ================= MENU TILE =================
  static Widget menuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    Color color = Colors.black87,
    VoidCallback? onTap,
    List<MenuSubItem> subItems = const [],
  }) {

    /// ===== EXPANSION TILE =====
    if (subItems.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
          ),
          child: ExpansionTile(
            leading: Icon(icon, color: color),

            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),

            subtitle: Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            tilePadding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            childrenPadding: const EdgeInsets.only(
              left: 16,
              right: 8,
              bottom: 8,
            ),

            children: subItems.map((item) {
              return ListTile(
                dense: true,

                leading: Icon(
                  item.icon,
                  size: 20,
                  color: Colors.grey,
                ),

                title: Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),

                onTap: item.onTap ?? () {
                  showComingSoon(context, item.title);
                },
              );
            }).toList(),
          ),
        ),
      );
    }

    /// ===== NORMAL TILE =====
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(icon, color: color),

        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),

        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),

        trailing: const Icon(
          Icons.arrow_forward_ios,
          size: 14,
          color: Colors.grey,
        ),

        onTap: onTap ?? () {
          showComingSoon(context, title);
        },
      ),
    );
  }

  /// ================= SECTION TITLE =================
  static Widget sectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.grey,
          letterSpacing: 1,
        ),
      ),
    );
  }

  /// ================= SNACKBAR =================
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

/// ================= SUB MENU MODEL =================
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