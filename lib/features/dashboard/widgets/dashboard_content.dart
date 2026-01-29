import 'package:flutter/material.dart';
import 'package:recallhub_frontend/features/dashboard/widgets/placeholder_widget.dart';
import 'package:recallhub_frontend/features/notes/presentation/pages/notes_page.dart';
import 'package:recallhub_frontend/features/notes/presentation/pages/settings.dart';
import 'package:recallhub_frontend/features/notes/presentation/pages/sub_notes_page.dart';
import 'package:recallhub_frontend/features/notes/presentation/pages/trash_page.dart';

class DashboardContent extends StatefulWidget {
  final String activeRoute;
  final Function(String newRoute) onRouteChange;

  const DashboardContent({
    super.key,
    required this.activeRoute,
    required this.onRouteChange,
  });

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  String? selectedFolderId;
  String? selectedFolderName;

  @override
  Widget build(BuildContext context) {
    switch (widget.activeRoute) {
      // NOTES PAGE
      case "/notes":
        return NotesPage(
          onFolderSelected: (folderId, folderName) {
            setState(() {
              selectedFolderId = folderId;
              selectedFolderName = folderName;
            });

            widget.onRouteChange("/subnotes");
          },
        );

      // SUB NOTES PAGE
      case "/subnotes":
        if (selectedFolderId == null) {
          return const PlaceholderWidget(
            title: "No folder selected",
            subtitle: "Please choose a folder first",
          );
        }

        return SubNotesPage(
          folderId: selectedFolderId!,
          folderName: selectedFolderName!,
          onBack: () {
            widget.onRouteChange("/notes");
          },
        );

      // TRASH PAGE
      case "/trash":
        if (selectedFolderId == null) {
          return const PlaceholderWidget(
            title: "Trash",
            subtitle: "No folder selected",
          );
        }

        return TrashPage(
          folderId: selectedFolderId!,
          onBack: () {
            widget.onRouteChange("/subnotes");
          },
        );

      // SETTINGS PAGE
      case "/settings":
        return SettingsPage();

      // DEFAULT
      default:
        return const PlaceholderWidget(
          title: "Your notes live here",
          subtitle: "Start capturing your ideas",
        );
    }
  }
}
