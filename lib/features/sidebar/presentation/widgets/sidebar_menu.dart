import 'package:flutter/material.dart';

class SidebarMenu extends StatefulWidget {
  final bool isCollapsed;
  final String activeRoute;
  final Function(String) onItemSelected;
  final VoidCallback onToggle;

  const SidebarMenu({
    required this.isCollapsed,
    required this.activeRoute,
    required this.onItemSelected,
    required this.onToggle,
    super.key,
  });

  @override
  State<SidebarMenu> createState() => _SidebarMenuState();
}

class _SidebarMenuState extends State<SidebarMenu> {
  String? hoveredRoute;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with toggle button
        SizedBox(
          height: 70,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 8.0,
              vertical: 12.0,
            ),
            child: Row(
              children: [
                // Toggle button
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.grey.shade700),
                  tooltip: widget.isCollapsed ? 'Expand menu' : 'Collapse menu',
                  onPressed: widget.onToggle,
                  splashRadius: 20,
                ),

                // Logo and title (hidden when collapsed)
                if (!widget.isCollapsed) ...[
                  SizedBox(width: 8),
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber.shade700,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    "RecallHub",
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),

        // Menu items
        _buildMenuItem(Icons.lightbulb_outline, "Notes", "/notes"),
        _buildMenuItem(Icons.notifications_outlined, "Reminders", "/reminders"),
        _buildMenuItem(Icons.label_outline, "Labels", "/labels"),
        _buildMenuItem(Icons.archive_outlined, "Archive", "/archive"),
        _buildMenuItem(Icons.delete_outline, "Trash", "/trash"),

        Spacer(),

        Divider(height: 1, thickness: 1, color: Colors.grey.shade300),
        _buildMenuItem(Icons.settings_outlined, "Settings", "/settings"),
        SizedBox(height: 8),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String route) {
    final isActive = widget.activeRoute == route;
    final isHovered = hoveredRoute == route;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredRoute = route),
      onExit: (_) => setState(() => hoveredRoute = null),
      child: Tooltip(
        message: widget.isCollapsed ? title : '',
        waitDuration: Duration(milliseconds: 500),
        child: InkWell(
          onTap: () => widget.onItemSelected(route),
          borderRadius: BorderRadius.circular(25),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: widget.isCollapsed ? 8 : 12,
              vertical: 4,
            ),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isCollapsed ? 0 : 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? Colors.amber.shade50
                  : isHovered
                  ? Colors.grey.shade100
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isActive
                      ? Colors.amber.shade700
                      : Colors.grey.shade700,
                  size: 24,
                ),
                if (!widget.isCollapsed) ...[
                  SizedBox(width: 20),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: isActive
                            ? Colors.amber.shade900
                            : Colors.grey.shade800,
                        fontSize: 14,
                        fontWeight: isActive
                            ? FontWeight.w500
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
