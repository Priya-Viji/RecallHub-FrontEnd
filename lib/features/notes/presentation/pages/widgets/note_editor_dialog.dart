import 'package:flutter/material.dart';

class NoteEditorDialog extends StatefulWidget {
  final Function(String, String, Color) onSave;

  const NoteEditorDialog({super.key, required this.onSave});

  @override
  State<NoteEditorDialog> createState() => _NoteEditorDialogState();
}

class _NoteEditorDialogState extends State<NoteEditorDialog> {
  final TextEditingController _titleCtrl = TextEditingController();
  final TextEditingController _contentCtrl = TextEditingController();

  final List<Color> _colors = [
    Colors.white,
    Colors.yellowAccent,
    Colors.redAccent.shade100,
    Colors.greenAccent.shade100,
    Colors.blueAccent.shade100,
    Colors.purpleAccent.shade100,
  ];

  Color _selectedColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: _selectedColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: const EdgeInsets.all(20),
      content: SizedBox(
        width: 350,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleCtrl,
              decoration: const InputDecoration(
                hintText: "Title",
                border: InputBorder.none,
              ),
            ),
            TextField(
              controller: _contentCtrl,
              decoration: const InputDecoration(
                hintText: "Note...",
                border: InputBorder.none,
              ),
              maxLines: 5,
            ),

            const SizedBox(height: 20),

            // 🎨 COLOR PICKER
            SizedBox(
              height: 45,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: _colors.map((c) {
                  return GestureDetector(
                    onTap: () => setState(() => _selectedColor = c),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 35,
                      height: 35,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedColor == c
                              ? Colors.black
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                widget.onSave(
                  _titleCtrl.text,
                  _contentCtrl.text,
                  _selectedColor,
                );
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}
