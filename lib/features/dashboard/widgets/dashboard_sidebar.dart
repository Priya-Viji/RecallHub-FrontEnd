import 'package:flutter/material.dart';
import 'package:recallhub_frontend/features/dashboard/widgets/sidebar_menu.dart';

class DashboardSidebar extends StatelessWidget {
  final String activeRoute;
  final Function(String) onItemSelected;

  const DashboardSidebar({
    super.key,
    required this.activeRoute,
    required this.onItemSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: SidebarMenu(
        isCollapsed: false,
        activeRoute: activeRoute,
        onItemSelected: onItemSelected,
        onToggle: () {},
      ),
    );
  }
}
