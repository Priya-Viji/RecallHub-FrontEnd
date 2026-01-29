import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recallhub_frontend/features/dashboard/widgets/dashboard_user_info.dart';
import 'package:recallhub_frontend/features/notes/presentation/bloc/theme_bloc/theme_bloc.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, state) {
        final isDark = state == ThemeMode.dark;

        return AppBar(
          backgroundColor: isDark ? const Color(0xFF1a202c) : Colors.white,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black12,
          toolbarHeight: 70,
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: isDark
                  ? null
                  : LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.blue.shade50.withValues(alpha: 0.3),
                      ],
                    ),
              border: Border(
                bottom: BorderSide(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey.shade200,
                  width: 1,
                ),
              ),
            ),
          ),
          title: Row(
            children: [
              // Container(
              //   padding: const EdgeInsets.all(8),
              //   decoration: BoxDecoration(
              //     gradient: LinearGradient(
              //       colors: [Color(0xFFfa709a), Color(0xFFfee140)],
              //     ),
              //     borderRadius: BorderRadius.circular(10),
              //     boxShadow: [
              //       BoxShadow(
              //         color: Colors.pinkAccent.withOpacity(0.3),
              //         blurRadius: 8,
              //         offset: const Offset(0, 2),
              //       ),
              //     ],
              //   ),
              //   child: const Icon(
              //     Icons.notes_rounded,
              //     color: Colors.white,
              //     size: 24,
              //   ),
              // ),
              const SizedBox(width: 12),
              ShaderMask(
                shaderCallback: (bounds) => LinearGradient(
                  colors: [Color(0xFFfa709a), Color(0xFFfee140)],
                ).createShader(bounds),
                child: const Text(
                  "RecallHub",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 22,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ],
          ),
          actions: [
           
            // Theme toggle with animation
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: IconButton(
                icon: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (child, animation) {
                    return RotationTransition(
                      turns: animation,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    key: ValueKey(isDark),
                    color: isDark
                        ? Colors.amber.shade300
                        : Colors.indigo.shade700,
                  ),
                ),
                onPressed: () {
                  context.read<ThemeBloc>().add(ToggleThemeEvent());
                },
                tooltip: isDark ? 'Light mode' : 'Dark mode',
                style: IconButton.styleFrom(
                  backgroundColor: isDark
                      ? Colors.amber.withValues(alpha: 0.1)
                      : Colors.indigo.withValues(alpha: 0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),

           
            const SizedBox(width: 8),
            DashboardUserInfo(),
            const SizedBox(width: 16),
          ],
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
