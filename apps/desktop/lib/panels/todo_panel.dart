import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class TodoItem {
  String text;
  bool done;
  TodoItem({required this.text, this.done = false});

  Map<String, dynamic> toJson() => {'text': text, 'done': done};
  factory TodoItem.fromJson(Map<String, dynamic> json) =>
      TodoItem(text: json['text'] as String, done: json['done'] as bool);
}

class TodoPanel extends StatefulWidget {
  final GruvboxTheme theme;
  const TodoPanel({super.key, required this.theme});

  @override
  State<TodoPanel> createState() => _TodoPanelState();
}

class _TodoPanelState extends State<TodoPanel> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  List<TodoItem> _todos = [];
  late String _todayKey;

  GruvboxTheme get t => widget.theme;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _todayKey = 'lofikofi:micro-todos:${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_todayKey);
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      setState(() {
        _todos = list.map((e) => TodoItem.fromJson(e as Map<String, dynamic>)).toList();
      });
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_todayKey, jsonEncode(_todos.map((e) => e.toJson()).toList()));
  }

  void _add() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _todos.add(TodoItem(text: text));
      _controller.clear();
    });
    _save();
    _focusNode.requestFocus();
  }

  void _toggleItem(int index) {
    setState(() => _todos[index].done = !_todos[index].done);
    _save();
  }

  void _clearDone() {
    setState(() => _todos.removeWhere((t) => t.done));
    _save();
  }

  int get _openCount => _todos.where((t) => !t.done).length;

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: t.border),
            ),
            child: Text(
              'Micro-todos',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
                color: t.textDim,
              ),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            'Daily tasks. Resets each morning.',
            style: TextStyle(fontSize: 11, color: t.textDim),
          ),
          const SizedBox(height: 10),

          // Input row
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  focusNode: _focusNode,
                  onSubmitted: (_) => _add(),
                  style: TextStyle(fontSize: 12, color: t.text),
                  decoration: InputDecoration(
                    hintText: 'Add a task…',
                    hintStyle: TextStyle(fontSize: 12, color: t.textDim),
                    filled: true,
                    fillColor: t.surface,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: t.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: t.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide(color: t.accent),
                    ),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                onTap: _add,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: t.accent,
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: t.textOnAccent,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Todo list
          Expanded(
            child: _todos.isEmpty
                ? Text(
                    'No tasks yet. Add one above.',
                    style: TextStyle(fontSize: 11, color: t.textDim),
                  )
                : ListView.builder(
                    itemCount: _todos.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final item = _todos[index];
                      return _TodoRow(
                        item: item,
                        theme: t,
                        onTap: () => _toggleItem(index),
                      );
                    },
                  ),
          ),

          // Footer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_openCount open',
                style: TextStyle(fontSize: 10, color: t.textDim),
              ),
              _GhostButton(
                label: 'Clear done',
                theme: t,
                enabled: _todos.any((t) => t.done),
                onTap: _clearDone,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TodoRow extends StatefulWidget {
  final TodoItem item;
  final GruvboxTheme theme;
  final VoidCallback onTap;

  const _TodoRow({
    required this.item,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_TodoRow> createState() => _TodoRowState();
}

class _TodoRowState extends State<_TodoRow> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final done = widget.item.done;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: _hovered ? t.surface : Colors.transparent,
          ),
          child: Opacity(
            opacity: done ? 0.4 : 1.0,
            child: Row(
              children: [
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: done ? t.accent : t.borderHeavy,
                      width: 1.5,
                    ),
                    color: done ? t.accentSoft : Colors.transparent,
                  ),
                  child: done
                      ? Icon(Icons.check, size: 10, color: t.accent)
                      : null,
                ),
                const SizedBox(width: 9),
                Expanded(
                  child: Text(
                    widget.item.text,
                    style: TextStyle(
                      fontSize: 12,
                      color: done ? t.textDim : t.text,
                      decoration: done ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GhostButton extends StatefulWidget {
  final String label;
  final GruvboxTheme theme;
  final bool enabled;
  final VoidCallback onTap;

  const _GhostButton({
    required this.label,
    required this.theme,
    required this.enabled,
    required this.onTap,
  });

  @override
  State<_GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<_GhostButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.enabled ? widget.onTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: t.border),
            color: _hovered && widget.enabled ? t.surface : Colors.transparent,
          ),
          child: Opacity(
            opacity: widget.enabled ? 1.0 : 0.25,
            child: Text(
              widget.label,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: _hovered && widget.enabled ? t.textSecondary : t.textDim,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
