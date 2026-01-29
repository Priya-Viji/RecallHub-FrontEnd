import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recallhub_frontend/features/notes/domain/note_model.dart';
import 'package:recallhub_frontend/features/notes/data/note_repository.dart';
import 'package:recallhub_frontend/features/notes/presentation/bloc/theme_bloc/theme_bloc.dart';
import 'package:recallhub_frontend/features/notes/presentation/pages/widgets/note_editor_sheet.dart';
import 'note_view_page.dart';

class SubNotesPage extends StatefulWidget {
  final String folderId;
  final String folderName;
  final VoidCallback? onBack;

  const SubNotesPage({
    super.key,
    required this.folderId,
    required this.folderName,
    this.onBack,
  });

  @override
  State<SubNotesPage> createState() => _SubNotesPageState();
}

class _SubNotesPageState extends State<SubNotesPage> {
  final NoteRepository repo = NoteRepository();

  List<NoteModel> _notes = [];
  String _searchQuery = "";
  String _sortType = "Recent";

  @override
  void initState() {
    super.initState();
    _loadNotes();
    repo.cleanOldTrash();
  }

  void _loadNotes() {
    _notes = repo.getNotesForFolder(widget.folderId);
    setState(() {});
  }

  // Detect if a color is dark or light (Google Keep logic)
  bool isColorDark(Color color) {
    return color.computeLuminance() < 0.5;
  }

  List<NoteModel> get _filteredNotes {
    List<NoteModel> list = [..._notes];

    if (_searchQuery.isNotEmpty) {
      list = list.where((note) {
        final title = note.title.toLowerCase();
        final content = note.content.toLowerCase();
        return title.contains(_searchQuery) || content.contains(_searchQuery);
      }).toList();
    }

    switch (_sortType) {
      case "A-Z":
        list.sort((a, b) => a.title.compareTo(b.title));
        break;
      case "Z-A":
        list.sort((a, b) => b.title.compareTo(a.title));
        break;
      case "Pinned":
        list.sort((a, b) {
          if (a.pinned && !b.pinned) return -1;
          if (!a.pinned && b.pinned) return 1;
          return 0;
        });
        break;
      case "Recent":
      default:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
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

        return Container(
          color: bgColor,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(cardColor, textColor),
                  _buildSearchBar(cardColor, textColor),
                  Expanded(
                    child: _filteredNotes.isEmpty
                        ? Center(
                            child: Text(
                              "No notes found",
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          )
                        : _buildNotesGrid(cardColor, textColor, isDark),
                  ),
                ],
              ),

              // Floating Action Button
              Positioned(
                bottom: 20,
                right: 20,
                child: FloatingActionButton(
                  backgroundColor: isDark ? Colors.white : Colors.black,
                  child: Icon(
                    Icons.add,
                    color: isDark ? Colors.black : Colors.white,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => NoteEditorDialog(
                        onSave: (title, content, color) async {
                          await repo.createNote(
                            folderId: widget.folderId,
                            title: title,
                            content: content,
                            color: color,
                          );
                          _loadNotes();
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---------------- HEADER ----------------
  Widget _buildHeader(Color cardColor, Color textColor) {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      color: cardColor,
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            color: textColor,
            onPressed: widget.onBack,
          ),
          const SizedBox(width: 8),
          Text(
            widget.folderName,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const Spacer(),
          PopupMenuButton(
            icon: Icon(Icons.sort, color: textColor),
            onSelected: (value) => setState(() => _sortType = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: "Pinned", child: Text("Pinned First")),
              PopupMenuItem(value: "A-Z", child: Text("Title A–Z")),
              PopupMenuItem(value: "Z-A", child: Text("Title Z–A")),
              PopupMenuItem(value: "Recent", child: Text("Recently Added")),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------- SEARCH BAR ----------------
  Widget _buildSearchBar(Color cardColor, Color textColor) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search notes...",
          hintStyle: TextStyle(color: Colors.grey.shade500),
          prefixIcon: Icon(Icons.search, color: textColor),
          filled: true,
          fillColor: cardColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
        ),
        style: TextStyle(color: textColor),
        onChanged: (value) {
          setState(() => _searchQuery = value.toLowerCase());
        },
      ),
    );
  }

  // ---------------- GRID ----------------
  Widget _buildNotesGrid(Color cardColor, Color textColor, bool isDark) {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.2,
      ),
      itemCount: _filteredNotes.length,
      itemBuilder: (context, index) {
        return _buildNoteCard(
          _filteredNotes[index],
          cardColor,
          textColor,
          isDark,
        );
      },
    );
  }

  // ---------------- NOTE CARD ----------------
  Widget _buildNoteCard(
    NoteModel note,
    Color cardColor,
    Color textColor,
    bool isDark,
  ) {
    final Color bg = note.colorValue != null
        ? Color(note.colorValue!)
        : cardColor;
    final bool darkText = !isColorDark(bg);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => NoteViewPage(
              note: {
                "title": note.title,
                "content": note.content,
                "color": bg,
                "pinned": note.pinned,
              },
              onUpdate: (newTitle, newContent, newColor, newPinned) async {
                note.title = newTitle;
                note.content = newContent;
                note.colorValue = newColor.value;
                note.pinned = newPinned;
                await repo.updateNote(note);
                _loadNotes();
              },
            ),
          ),
        );
      },

      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () async {
                    note.pinned = !note.pinned;
                    await repo.updateNote(note);
                    setState(() {});
                  },
                  child: Icon(
                    note.pinned ? Icons.push_pin : Icons.push_pin_outlined,
                    size: 20,
                    color: darkText ? Colors.black87 : Colors.white,
                  ),
                ),
                const Spacer(),
                PopupMenuButton(
                  icon: Icon(
                    Icons.more_vert,
                    color: darkText ? Colors.black87 : Colors.white,
                  ),
                  onSelected: (value) async {
                    if (value == "delete") {
                      await repo.softDeleteNote(note);
                      _loadNotes();
                    } else if (value == "edit") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteViewPage(
                            note: {
                              "title": note.title,
                              "content": note.content,
                              "color": bg,
                              "pinned": note.pinned,
                            },
                            onUpdate:
                                (
                                  newTitle,
                                  newContent,
                                  newColor,
                                  newPinned,
                                ) async {
                                  note.title = newTitle;
                                  note.content = newContent;
                                  note.colorValue = newColor.value;
                                  note.pinned = newPinned;
                                  await repo.updateNote(note);
                                  _loadNotes();
                                },
                          ),
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => const [
                    PopupMenuItem(value: "edit", child: Text("Edit")),
                    PopupMenuItem(
                      value: "delete",
                      child: Text("Move to Trash"),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              note.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: darkText ? Colors.black87 : Colors.white,
              ),
            ),
            const SizedBox(height: 6),
            Expanded(
              child: Text(
                note.content,
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: darkText ? Colors.black87 : Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
