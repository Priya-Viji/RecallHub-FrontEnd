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

class _SidebarMenuState extends State<SidebarMenu>
    with TickerProviderStateMixin {
  String? hoveredRoute;
  final Map<String, AnimationController> _controllers = {};
  final Map<String, Animation<double>> _scaleAnimations = {};

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    final routes = ["/notes", "/Collab", "/trash"];
    for (var route in routes) {
      _controllers[route] = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 200),
      );
      _scaleAnimations[route] = Tween<double>(begin: 1.0, end: 0.95).animate(
        CurvedAnimation(parent: _controllers[route]!, curve: Curves.easeInOut),
      );
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onItemTap(String route) {
    _controllers[route]?.forward().then((_) {
      _controllers[route]?.reverse();
    });
    widget.onItemSelected(route);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 16),

        // Menu Section Label
        if (!widget.isCollapsed)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'WORKSPACE',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade500,
                letterSpacing: 1.2,
              ),
            ),
          ),

        const SizedBox(height: 8),

        // Menu items with beautiful animations
        _buildMenuItem(
          icon: Icons.lightbulb_rounded,
          title: "Notes",
          route: "/notes",
          gradient: [const Color(0xFFfa709a), const Color(0xFFfee140)],
        ),
        _buildMenuItem(
          icon: Icons.people_rounded,
          title: "Collab",
          route: "/Collab",
          gradient: [const Color(0xFF667eea), const Color(0xFF764ba2)],
        ),
        _buildMenuItem(
          icon: Icons.delete_rounded,
          title: "Trash",
          route: "/trash",
          gradient: [const Color(0xFFf093fb), const Color(0xFFF5576C)],
        ),

        const Spacer(),

        // if (!widget.isCollapsed)
        //   Padding(
        //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        //     child: Text(
        //       'Sign IN',
        //       style: TextStyle(
        //         fontSize: 11,
        //         fontWeight: FontWeight.w600,
        //         color: Colors.grey.shade500,
        //         letterSpacing: 1.2,
        //       ),
        //     ),
        //   ),

        _buildMenuItem(
          icon: Icons.settings_rounded,
          title: "Settings",
          route: "/settings",
          gradient: [Color(0xFFfa709a), Color(0xFFfee140)],
        ),

        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String route,
    required List<Color> gradient,
  }) {
    final isActive = widget.activeRoute == route;
    final isHovered = hoveredRoute == route;

    return MouseRegion(
      onEnter: (_) => setState(() => hoveredRoute = route),
      onExit: (_) => setState(() => hoveredRoute = null),
      child: Tooltip(
        message: widget.isCollapsed ? title : '',
        waitDuration: const Duration(milliseconds: 500),
        child: ScaleTransition(
          scale: _scaleAnimations[route] ?? AlwaysStoppedAnimation(1.0),
          child: Container(
            margin: EdgeInsets.symmetric(
              horizontal: widget.isCollapsed ? 12 : 16,
              vertical: 4,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _onItemTap(route),
                borderRadius: BorderRadius.circular(16),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeInOut,
                  padding: EdgeInsets.symmetric(
                    horizontal: widget.isCollapsed ? 0 : 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    gradient: isActive
                        ? LinearGradient(
                            colors: gradient
                                .map((c) => c.withValues(alpha: 0.15))
                                .toList(),
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: isActive
                        ? null
                        : isHovered
                        ? const Color(0xFFedf2f7)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: isActive
                        ? Border.all(
                            color: gradient[0].withValues(alpha: 0.3),
                            width: 1.5,
                          )
                        : null,
                    boxShadow: isActive
                        ? [
                            BoxShadow(
                              color: gradient[0].withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : null,
                  ),

                  // FIXED LAYOUT: No Flexible, No Expanded
                  child: widget.isCollapsed
                      ? Center(
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              gradient: isActive
                                  ? LinearGradient(
                                      colors: gradient,
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    )
                                  : null,
                              color: isActive
                                  ? null
                                  : (isHovered ? Colors.white : null),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: isActive
                                  ? [
                                      BoxShadow(
                                        color: gradient[0].withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              icon,
                              color: isActive
                                  ? Colors.white
                                  : isHovered
                                  ? gradient[0]
                                  : Colors.grey.shade600,
                              size: 22,
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                gradient: isActive
                                    ? LinearGradient(
                                        colors: gradient,
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : null,
                                color: isActive
                                    ? null
                                    : (isHovered ? Colors.white : null),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: isActive
                                    ? [
                                        BoxShadow(
                                          color: gradient[0].withValues(alpha: 0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Icon(
                                icon,
                                color: isActive
                                    ? Colors.white
                                    : isHovered
                                    ? gradient[0]
                                    : Colors.grey.shade600,
                                size: 20,
                              ),
                            ),

                            const SizedBox(width: 12),

                            // FIX: No Flexible → Safe Text
                            Flexible(
                              fit: FlexFit.loose,
                              child: Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isActive
                                      ? gradient[0]
                                      : const Color(0xFF2d3748),
                                  fontSize: 14,
                                  fontWeight: isActive
                                      ? FontWeight.w600
                                      : FontWeight.w500,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ),

                            if (isActive)
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: gradient),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: gradient[0].withValues(alpha: 0.5),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
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
