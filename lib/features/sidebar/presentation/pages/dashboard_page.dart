import 'package:flutter/material.dart';
import '../widgets/collapsible_sidebar.dart';
import '../widgets/sidebar_menu.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String activeRoute = "/notes"; // Start with Notes

  void _onItemSelected(String route) {
    setState(() {
      activeRoute = route;
    });

    // Close drawer on mobile after selection
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  // Get the appropriate content widget based on route
  Widget _getContentForRoute() {
    switch (activeRoute) {
      case '/notes':
        return _buildPlaceholder(
          icon: Icons.lightbulb_outline,
          title: 'Notes you add appear here',
          color: Colors.amber.shade700,
        );
      case '/reminders':
        return _buildPlaceholder(
          icon: Icons.notifications_outlined,
          title: 'Reminders you add appear here',
          color: Colors.blue.shade700,
        );
      case '/labels':
        return _buildPlaceholder(
          icon: Icons.label_outline,
          title: 'Create labels to organize your notes',
          color: Colors.green.shade700,
        );
      case '/archive':
        return _buildPlaceholder(
          icon: Icons.archive_outlined,
          title: 'Archived notes appear here',
          color: Colors.grey.shade700,
        );
      case '/trash':
        return _buildPlaceholder(
          icon: Icons.delete_outline,
          title: 'Notes in trash are deleted after 7 days',
          color: Colors.red.shade700,
        );
      case '/settings':
        return _buildPlaceholder(
          icon: Icons.settings_outlined,
          title: 'Settings',
          color: Colors.grey.shade700,
        );
      default:
        return _buildPlaceholder(
          icon: Icons.lightbulb_outline,
          title: 'Notes you add appear here',
          color: Colors.amber.shade700,
        );
    }
  }

  Widget _buildPlaceholder({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 120, color: color.withOpacity(0.3)),
          SizedBox(height: 24),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getTitleForRoute() {
    switch (activeRoute) {
      case '/notes':
        return 'Notes';
      case '/reminders':
        return 'Reminders';
      case '/labels':
        return 'Labels';
      case '/archive':
        return 'Archive';
      case '/trash':
        return 'Trash';
      case '/settings':
        return 'Settings';
      default:
        return 'RecallHub';
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: isWide
          ? null
          : AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              iconTheme: IconThemeData(color: Colors.grey.shade700),
              title: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: Colors.amber.shade700,
                    size: 24,
                  ),
                  SizedBox(width: 12),
                  Text(
                    _getTitleForRoute(),
                    style: TextStyle(
                      color: Colors.grey.shade800,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: Colors.grey.shade300,
                ),
              ),
            ),
      drawer: isWide
          ? null
          : Drawer(
              backgroundColor: Colors.white,
              child: SidebarMenu(
                isCollapsed: false,
                activeRoute: activeRoute,
                onItemSelected: _onItemSelected,
                onToggle: () {}, // Not needed in drawer
              ),
            ),
      body: Row(
        children: [
          // Desktop sidebar - only shown on wide screens
          if (isWide)
            CollapsibleSidebar(
              activeRoute: activeRoute,
              onItemSelected: _onItemSelected,
            ),

          // Main content area
          Expanded(
            child: Container(color: Colors.white, child: _getContentForRoute()),
          ),
        ],
      ),
    );
  }
}
