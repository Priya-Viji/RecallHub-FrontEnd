import 'package:flutter/material.dart';
import 'package:recallhub_frontend/features/dashboard/widgets/dashboard_appbar.dart';
import 'package:recallhub_frontend/features/dashboard/widgets/dashboard_content.dart';
import 'package:recallhub_frontend/features/dashboard/widgets/dashboard_sidebar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String activeRoute = "/notes";

  void _onItemSelected(String route) {
    setState(() => activeRoute = route);
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: DashboardAppBar(),
      drawer: isWide
          ? null
          : DashboardSidebar(
              activeRoute: activeRoute,
              onItemSelected: _onItemSelected,
            ),
      body: Row(
        children: [
          if (isWide)
            DashboardSidebar(
              activeRoute: activeRoute,
              onItemSelected: _onItemSelected,
            ),

          // ⭐ MAIN CONTENT AREA
          Expanded(
            child: DashboardContent(
              activeRoute: activeRoute,

              // ⭐ This callback changes the route INSIDE the dashboard
              onRouteChange: (newRoute) {
                setState(() {
                  activeRoute = newRoute;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
