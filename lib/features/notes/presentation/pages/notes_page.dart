import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recallhub_frontend/features/notes/data/folder_repository.dart';
import 'package:recallhub_frontend/features/notes/domain/folder_model.dart';
import 'package:recallhub_frontend/features/notes/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:recallhub_frontend/features/notes/presentation/pages/widgets/create_folder_dialog.dart';

class NotesPage extends StatefulWidget {
  final Function(String folderId, String folderName)? onFolderSelected;

  const NotesPage({super.key, this.onFolderSelected});


  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final repo = FolderRepository();
  List<FolderModel> _folders = [];

  late TextEditingController _searchController;
  String _searchQuery = "";
  String _folderSort = "Pinned";

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();

    // Load folders from Hive
    _folders = repo.getFolders();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // FILTER + SORT
  List<FolderModel> get _filteredSortedFolders {
    List<FolderModel> list = [..._folders];

    if (_searchQuery.isNotEmpty) {
      list = list.where((f) {
        return f.name.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }

    switch (_folderSort) {
      case "A-Z":
        list.sort((a, b) => a.name.compareTo(b.name));
        break;
      case "Z-A":
        list.sort((a, b) => b.name.compareTo(a.name));
        break;
      case "Recent":
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case "Pinned":
      default:
        list.sort((a, b) {
          if (a.pinned && !b.pinned) return -1;
          if (!a.pinned && b.pinned) return 1;
          return a.name.compareTo(b.name);
        });
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;

        final bgColor = isDark
            ? const Color(0xFF1A1A1A)
            : const Color(0xFFF7FAFC);
        final cardColor = isDark ? const Color(0xFF2A2A2A) : Colors.white;
        final textColor = isDark ? Colors.white : const Color(0xFF2d3748);

        return Scaffold(
          backgroundColor: bgColor,
          floatingActionButton: FloatingActionButton(
            backgroundColor: isDark ? Colors.white : Colors.black,
            onPressed: _openCreateFolderDialog,
            child: Icon(Icons.add, color: isDark ? Colors.black : Colors.white),
          ),

          body: Column(
            children: [
              _buildHeader(isDark, cardColor, textColor),
              Expanded(child: _buildFolderGrid(cardColor, textColor, isDark)),
            ],
          ),
        );
      },
    );
  }

  // HEADER UI
  Widget _buildHeader(bool isDark, Color cardColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      decoration: BoxDecoration(
        color: cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          TextField(
            controller: _searchController,
            style: TextStyle(color: textColor),
            decoration: InputDecoration(
              hintText: "Search...",
              prefixIcon: Icon(Icons.search, color: textColor),
              filled: true,
              fillColor: isDark ? const Color(0xFF2F2F2F) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) => setState(() => _searchQuery = value),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Text(
                  "Home",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: textColor,
                  ),
                ),
              ),

              PopupMenuButton(
                icon: Icon(Icons.sort, color: textColor),
                onSelected: (value) => setState(() => _folderSort = value),
                itemBuilder: (context) => const [
                  PopupMenuItem(value: "Pinned", child: Text("Pinned first")),
                  PopupMenuItem(value: "A-Z", child: Text("Title A–Z")),
                  PopupMenuItem(value: "Z-A", child: Text("Title Z–A")),
                  PopupMenuItem(value: "Recent", child: Text("Recently added")),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // FOLDER GRID
  Widget _buildFolderGrid(Color cardColor, Color textColor, bool isDark) {
    if (_filteredSortedFolders.isEmpty) {
      return Center(
        child: Text("No folders yet", style: TextStyle(color: textColor)),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _getCrossAxisCount(context),
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _filteredSortedFolders.length,
      itemBuilder: (context, index) {
        return _buildFolderCard(
          _filteredSortedFolders[index],
          index,
          cardColor,
          textColor,
          isDark,
        );
      },
    );
  }

  // CREATE FOLDER
  void _openCreateFolderDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateFolderDialog(
          onCreateFolder: (folderName) async {
            await repo.createFolder(folderName);
            setState(() => _folders = repo.getFolders());
          },
        );
      },
    );
  }

  // EDIT FOLDER
  void _editFolderName(FolderModel folder) {
    final controller = TextEditingController(text: folder.name);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Edit folder"),
        content: TextField(controller: controller),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              folder.name = controller.text.trim();
              await repo.updateFolder(folder);
              setState(() {});
              Navigator.pop(context);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  // DELETE FOLDER
  Future<void> _deleteFolder(FolderModel folder) async {
    await repo.deleteFolder(folder);
    setState(() => _folders = repo.getFolders());
  }

  // GRID COUNT
  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1400) return 4;
    if (width > 1000) return 3;
    if (width > 600) return 2;
    return 1;
  }

  // FOLDER CARD UI
  Widget _buildFolderCard(
    FolderModel folder,
    int index,
    Color cardColor,
    Color textColor,
    bool isDark,
  ) {
    final gradients = [
      [const Color(0xFFfa709a), const Color(0xFFfee140)],
      [const Color(0xFF667eea), const Color(0xFF764ba2)],
      [const Color(0xFF4facfe), const Color(0xFF00f2fe)],
      [const Color(0xFFf093fb), const Color(0xFFF5576C)],
      [const Color(0xFF43e97b), const Color(0xFF38f9d7)],
    ];

    final gradient = gradients[index % gradients.length];

    return GestureDetector(
      onTap: () {
        widget.onFolderSelected?.call(folder.id, folder.name);
      },
      child: Container(
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            Container(
              height: 6,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: gradient,
                  begin: Alignment.topLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.folder, color: gradient[0], size: 22),
                      const Spacer(),

                      // PIN
                      GestureDetector(
                        onTap: () async {
                          folder.pinned = !folder.pinned;
                          await repo.updateFolder(folder);
                          setState(() {});
                        },
                        child: Icon(
                          folder.pinned
                              ? Icons.push_pin
                              : Icons.push_pin_outlined,
                          color: textColor,
                          size: 20,
                        ),
                      ),

                      const SizedBox(width: 8),

                      // MENU
                      PopupMenuButton(
                        icon: Icon(Icons.more_vert, color: textColor),
                        onSelected: (value) {
                          if (value == "edit") {
                            _editFolderName(folder);
                          } else if (value == "delete") {
                            _deleteFolder(folder);
                          }
                        },
                        itemBuilder: (context) => const [
                          PopupMenuItem(value: "edit", child: Text("Edit")),
                          PopupMenuItem(value: "delete", child: Text("Delete")),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Text(
                    folder.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const Spacer(),

                  Text(
                    "Created: ${folder.createdAt.toLocal().toString().split(' ')[0]}",
                    style: TextStyle(
                      fontSize: 12,
                      color: textColor.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
