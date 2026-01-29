import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recallhub_frontend/features/notes/data/note_repository.dart';
import 'package:recallhub_frontend/features/notes/domain/note_model.dart';
import 'package:recallhub_frontend/features/notes/presentation/bloc/theme_bloc/theme_bloc.dart';

class TrashPage extends StatefulWidget {
  final String folderId;
  final VoidCallback? onBack;

  const TrashPage({super.key, required this.folderId, this.onBack});

  @override
  State<TrashPage> createState() => _TrashPageState();
}

class _TrashPageState extends State<TrashPage> {
  final NoteRepository repo = NoteRepository();
  List<NoteModel> _trashNotes = [];

  @override
  void initState() {
    super.initState();
    _loadTrash();
  }

  void _loadTrash() {
    _trashNotes = repo.getTrashNotesForFolder(widget.folderId);
    setState(() {});
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
          child: Column(
            children: [
              _buildHeader(cardColor, textColor),
              Expanded(
                child: _trashNotes.isEmpty
                    ? Center(
                        child: Text(
                          "Trash is empty",
                          style: TextStyle(color: textColor.withValues(alpha: 0.6)),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(24),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 1.2,
                            ),
                        itemCount: _trashNotes.length,
                        itemBuilder: (context, index) {
                          return _buildTrashCard(
                            _trashNotes[index],
                            cardColor,
                            textColor,
                            isDark,
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
            "Trash",
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------- TRASH CARD ----------------
  Widget _buildTrashCard(
    NoteModel note,
    Color cardColor,
    Color textColor,
    bool isDark,
  ) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
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
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Row: Restore + Delete Forever
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.restore, color: textColor),
                onPressed: () async {
                  await repo.restoreNote(note);
                  _loadTrash();
                },
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.delete_forever, color: Colors.red),
                onPressed: () async {
                  await repo.deleteForever(note);
                  _loadTrash();
                },
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Title
          Text(
            note.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontWeight: FontWeight.bold, color: textColor),
          ),

          const SizedBox(height: 6),

          // Content
          Expanded(
            child: Text(
              note.content,
              maxLines: 6,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    );
  }
}
