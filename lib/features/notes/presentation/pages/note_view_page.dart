import 'package:flutter/material.dart';

class NoteViewPage extends StatefulWidget {
  final Map<String, dynamic> note;
  final Function(String, String, Color, bool) onUpdate;

  const NoteViewPage({super.key, required this.note, required this.onUpdate});

  @override
  State<NoteViewPage> createState() => _NoteViewPageState();
}

class _NoteViewPageState extends State<NoteViewPage> {
  late TextEditingController titleCtrl;
  late TextEditingController contentCtrl;

  late Color noteColor;
  late bool isPinned;

  final List<Color> colorOptions = [
    Colors.white,
    const Color(0xFFFFF475),
    const Color(0xFFFBBC04),
    const Color(0xFFCCFF90),
    const Color(0xFFA7FFEB),
    const Color(0xFFCBF0F8),
    const Color(0xFFD7AEFB),
    const Color(0xFFF28B82),
  ];

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.note["title"]);
    contentCtrl = TextEditingController(text: widget.note["content"]);
    noteColor = widget.note["color"] ?? Colors.white;
    isPinned = widget.note["pinned"] ?? false;
  }

  void _saveAndClose() {
    widget.onUpdate(titleCtrl.text, contentCtrl.text, noteColor, isPinned);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: noteColor,
      body: SafeArea(
        child: Column(
          children: [
            // ---------------- TOP BAR ----------------
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: _saveAndClose,
                ),
                const Spacer(),
                IconButton(
                  icon: Icon(
                    isPinned ? Icons.push_pin : Icons.push_pin_outlined,
                  ),
                  onPressed: () {
                    setState(() => isPinned = !isPinned);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.archive_outlined),
                  onPressed: () {},
                ),
                IconButton(icon: const Icon(Icons.more_vert), onPressed: () {}),
              ],
            ),

            // ---------------- CONTENT ----------------
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ListView(
                  children: [
                    TextField(
                      controller: titleCtrl,
                      decoration: const InputDecoration(
                        hintText: "Title",
                        border: InputBorder.none,
                      ),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextField(
                      controller: contentCtrl,
                      decoration: const InputDecoration(
                        hintText: "Note...",
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                  ],
                ),
              ),
            ),

            // ---------------- COLOR PICKER ----------------
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: colorOptions.map((c) {
                  return GestureDetector(
                    onTap: () {
                      setState(() => noteColor = c);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 12),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: c,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.black26,
                          width: noteColor == c ? 2 : 1,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            // ---------------- BOTTOM ACTION BAR ----------------
            Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.add_alert_outlined),
                  Icon(Icons.person_add_alt_1_outlined),
                  Icon(Icons.image_outlined),
                  Icon(Icons.archive_outlined),
                  Icon(Icons.more_vert),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
