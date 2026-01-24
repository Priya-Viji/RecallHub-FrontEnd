import 'package:flutter/material.dart';
import 'sidebar_menu.dart';

class CollapsibleSidebar extends StatefulWidget {
  final String activeRoute;
  final Function(String) onItemSelected;

  const CollapsibleSidebar({
    required this.activeRoute,
    required this.onItemSelected,
    super.key,
  });

  @override
  State<CollapsibleSidebar> createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<CollapsibleSidebar> {
  bool isCollapsed = false;

  void toggleSidebar() {
    setState(() {
      isCollapsed = !isCollapsed;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isCollapsed ? 70 : 250,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.grey.shade300, width: 1),
        ),
      ),
      child: SidebarMenu(
        isCollapsed: isCollapsed,
        activeRoute: widget.activeRoute,
        onItemSelected: widget.onItemSelected,
        onToggle: toggleSidebar,
      ),
    );
  }
}
