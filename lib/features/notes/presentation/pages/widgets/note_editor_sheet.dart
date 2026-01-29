import 'package:flutter/material.dart';

class NoteEditorDialog extends StatefulWidget {
  final Function(String title, String content, Color color) onSave;

  const NoteEditorDialog({super.key, required this.onSave});

  @override
  State<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  Color _selectedColor = Colors.white;

  final List<Color> _colors = [
    Colors.white,
    const Color(0xFFFFF475), // yellow
    const Color(0xFFFBBC04), // orange
    const Color(0xFFCCFF90), // light green
    const Color(0xFFA7FFEB), // teal
    const Color(0xFFCBF0F8), // light blue
    const Color(0xFFD7AEFB), // purple
    const Color(0xFFF28B82), // red
  ];

  void _handleSave() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    widget.onSave(title, content, _selectedColor);
    Navigator.pop(context);
  }

  void _openColorPicker() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text("Choose color"),
          content: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: _colors.map((color) {
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedColor = color);
                  Navigator.pop(context);
                },
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.black12),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 0,
      backgroundColor: _selectedColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),

            // Content
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                hintText: "Take a note...",
                border: InputBorder.none,
              ),
              maxLines: 5,
              style: const TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 16),

            // Icon Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.color_lens_outlined, size: 20),
                      onPressed: _openColorPicker,
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.notifications_none_rounded, size: 20),
                    const SizedBox(width: 12),
                    const Icon(Icons.person_add_alt_1_rounded, size: 20),
                    const SizedBox(width: 12),
                    const Icon(Icons.image_outlined, size: 20),
                    const SizedBox(width: 12),
                    const Icon(Icons.archive_outlined, size: 20),
                    const SizedBox(width: 12),
                    const Icon(Icons.more_vert_rounded, size: 20),
                  ],
                ),

                TextButton(
                  onPressed: _handleSave,
                  child: const Text(
                    "Close",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
