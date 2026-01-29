import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recallhub_frontend/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:recallhub_frontend/features/notes/presentation/bloc/theme_bloc/theme_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeBloc = context.read<ThemeBloc>();
    final authBloc = context.read<AuthBloc>();

    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        final bg = isDark ? const Color(0xFF121212) : const Color(0xFFF7FAFC);
        final card = isDark ? const Color(0xFF1E1E1E) : Colors.white;
        final textPrimary = isDark ? Colors.white : Colors.black87;
        final textSecondary = isDark
            ? Colors.grey.shade400
            : Colors.grey.shade600;

        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            title: const Text("Settings"),
            backgroundColor: card,
            elevation: 0,
          ),

          body: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              String name = "Guest";
              String email = "Not signed in";
              String photo = "";

              if (state is Authenticated) {
                name = state.user.name ?? "User";
                email = state.user.email ?? "";
                photo = state.user.photoUrl ?? "";
              }

              return ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  // -------------------------
                  // ACCOUNT SECTION
                  // -------------------------
                  _sectionTitle("Account", textPrimary),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: _cardDecoration(card, isDark),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundImage: photo.isNotEmpty
                              ? NetworkImage(photo)
                              : null,
                          child: photo.isEmpty
                              ? const Icon(Icons.person, size: 30)
                              : null,
                        ),
                        const SizedBox(width: 16),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(email, style: TextStyle(color: textSecondary)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // -------------------------
                  // APPEARANCE SECTION
                  // -------------------------
                  _sectionTitle("Appearance", textPrimary),
                  const SizedBox(height: 10),

                  Container(
                    decoration: _cardDecoration(card, isDark),
                    child: SwitchListTile(
                      title: Text(
                        "Dark Mode",
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      value: isDark,
                      onChanged: (_) => themeBloc.add(ToggleThemeEvent()),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // -------------------------
                  // ABOUT SECTION
                  // -------------------------
                  _sectionTitle("About", textPrimary),
                  const SizedBox(height: 10),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(card, isDark),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "App Version",
                          style: TextStyle(color: textPrimary),
                        ),
                        Text("1.0.0", style: TextStyle(color: textSecondary)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // -------------------------
                  // SIGN OUT (SMALL ICON)
                  // -------------------------
                  if (state is Authenticated)
                    Container(
                      decoration: _cardDecoration(card, isDark),
                      child: ListTile(
                        leading: const Icon(
                          Icons.logout_rounded,
                          color: Colors.redAccent,
                          size: 22,
                        ),
                        title: const Text(
                          "Sign Out",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.redAccent,
                          ),
                        ),
                        onTap: () {
                          authBloc.add(SignOutRequested());
                          Navigator.pop(context);
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  // -------------------------
  // HELPERS
  // -------------------------

  Widget _sectionTitle(String text, Color color) {
    return Text(
      text,
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: color),
    );
  }

  BoxDecoration _cardDecoration(Color cardColor, bool isDark) {
    return BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
