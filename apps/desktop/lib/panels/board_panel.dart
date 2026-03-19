import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme.dart';

class BoardCard {
  String title;
  BoardCard({required this.title});

  Map<String, dynamic> toJson() => {'title': title};
  factory BoardCard.fromJson(Map<String, dynamic> json) =>
      BoardCard(title: json['title'] as String);
}

class BoardColumn {
  final String id;
  final String label;
  List<BoardCard> cards;

  BoardColumn({required this.id, required this.label, List<BoardCard>? cards})
      : cards = cards ?? [];

  Map<String, dynamic> toJson() => {
        'id': id,
        'label': label,
        'cards': cards.map((c) => c.toJson()).toList(),
      };

  factory BoardColumn.fromJson(Map<String, dynamic> json) => BoardColumn(
        id: json['id'] as String,
        label: json['label'] as String,
        cards: (json['cards'] as List)
            .map((c) => BoardCard.fromJson(c as Map<String, dynamic>))
            .toList(),
      );
}

class BoardPanel extends StatefulWidget {
  final GruvboxTheme theme;
  const BoardPanel({super.key, required this.theme});

  @override
  State<BoardPanel> createState() => _BoardPanelState();
}

class _BoardPanelState extends State<BoardPanel> {
  List<BoardColumn> _columns = [
    BoardColumn(id: 'today', label: 'Today'),
    BoardColumn(id: 'week', label: 'This week'),
    BoardColumn(id: 'later', label: 'Later'),
  ];

  final Map<String, TextEditingController> _controllers = {};

  GruvboxTheme get t => widget.theme;

  @override
  void initState() {
    super.initState();
    for (final col in _columns) {
      _controllers[col.id] = TextEditingController();
    }
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('lofikofi:boards');
    if (raw != null) {
      final list = jsonDecode(raw) as List;
      setState(() {
        _columns = list.map((e) => BoardColumn.fromJson(e as Map<String, dynamic>)).toList();
        for (final col in _columns) {
          _controllers.putIfAbsent(col.id, () => TextEditingController());
        }
      });
    }
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lofikofi:boards', jsonEncode(_columns.map((c) => c.toJson()).toList()));
  }

  void _addCard(String columnId) {
    final ctrl = _controllers[columnId]!;
    final text = ctrl.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _columns.firstWhere((c) => c.id == columnId).cards.add(BoardCard(title: text));
      ctrl.clear();
    });
    _save();
  }

  void _deleteCard(String columnId, int cardIndex) {
    setState(() {
      _columns.firstWhere((c) => c.id == columnId).cards.removeAt(cardIndex);
    });
    _save();
  }

  void _moveCard(String fromColumnId, int cardIndex, int direction) {
    final colIndex = _columns.indexWhere((c) => c.id == fromColumnId);
    final targetIndex = colIndex + direction;
    if (targetIndex < 0 || targetIndex >= _columns.length) return;
    setState(() {
      final card = _columns[colIndex].cards.removeAt(cardIndex);
      _columns[targetIndex].cards.add(card);
    });
    _save();
  }

  @override
  void dispose() {
    for (final ctrl in _controllers.values) {
      ctrl.dispose();
    }
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
              'Workspace board',
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
            'Drag-free kanban. Move cards with arrows.',
            style: TextStyle(fontSize: 11, color: t.textDim),
          ),
          const SizedBox(height: 10),

          // Columns
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (var i = 0; i < _columns.length; i++) ...[
                  if (i > 0) const SizedBox(width: 8),
                  Expanded(
                    child: _BoardColumnWidget(
                      column: _columns[i],
                      columnIndex: i,
                      totalColumns: _columns.length,
                      theme: t,
                      controller: _controllers[_columns[i].id]!,
                      onAdd: () => _addCard(_columns[i].id),
                      onDelete: (cardIndex) => _deleteCard(_columns[i].id, cardIndex),
                      onMove: (cardIndex, dir) => _moveCard(_columns[i].id, cardIndex, dir),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardColumnWidget extends StatelessWidget {
  final BoardColumn column;
  final int columnIndex;
  final int totalColumns;
  final GruvboxTheme theme;
  final TextEditingController controller;
  final VoidCallback onAdd;
  final void Function(int) onDelete;
  final void Function(int, int) onMove;

  const _BoardColumnWidget({
    required this.column,
    required this.columnIndex,
    required this.totalColumns,
    required this.theme,
    required this.controller,
    required this.onAdd,
    required this.onDelete,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Column header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                column.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.7,
                  color: theme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: theme.surface,
              ),
              child: Text(
                '${column.cards.length}',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: theme.textDim,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Input row
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                onSubmitted: (_) => onAdd(),
                style: TextStyle(fontSize: 11, color: theme.text),
                decoration: InputDecoration(
                  hintText: 'Add card…',
                  hintStyle: TextStyle(fontSize: 11, color: theme.textDim),
                  filled: true,
                  fillColor: theme.surface,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: theme.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: theme.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(color: theme.accent),
                  ),
                  isDense: true,
                ),
              ),
            ),
            const SizedBox(width: 4),
            GestureDetector(
              onTap: onAdd,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: theme.border),
                ),
                child: Icon(Icons.add, size: 14, color: theme.textSecondary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Cards
        Expanded(
          child: ListView.builder(
            itemCount: column.cards.length,
            padding: EdgeInsets.zero,
            itemBuilder: (context, index) {
              return _CardWidget(
                card: column.cards[index],
                theme: theme,
                canMoveLeft: columnIndex > 0,
                canMoveRight: columnIndex < totalColumns - 1,
                onDelete: () => onDelete(index),
                onMoveLeft: () => onMove(index, -1),
                onMoveRight: () => onMove(index, 1),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CardWidget extends StatefulWidget {
  final BoardCard card;
  final GruvboxTheme theme;
  final bool canMoveLeft;
  final bool canMoveRight;
  final VoidCallback onDelete;
  final VoidCallback onMoveLeft;
  final VoidCallback onMoveRight;

  const _CardWidget({
    required this.card,
    required this.theme,
    required this.canMoveLeft,
    required this.canMoveRight,
    required this.onDelete,
    required this.onMoveLeft,
    required this.onMoveRight,
  });

  @override
  State<_CardWidget> createState() => _CardWidgetState();
}

class _CardWidgetState extends State<_CardWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        margin: const EdgeInsets.only(bottom: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: _hovered ? t.surfaceHover : t.surface,
          border: Border.all(color: _hovered ? t.borderHeavy : t.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                widget.card.title,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.4,
                  color: t.text,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (_hovered)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.canMoveLeft)
                    _IconBtn(
                      icon: Icons.chevron_left,
                      theme: t,
                      onTap: widget.onMoveLeft,
                    ),
                  if (widget.canMoveRight)
                    _IconBtn(
                      icon: Icons.chevron_right,
                      theme: t,
                      onTap: widget.onMoveRight,
                    ),
                  _IconBtn(
                    icon: Icons.close,
                    theme: t,
                    onTap: widget.onDelete,
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class _IconBtn extends StatefulWidget {
  final IconData icon;
  final GruvboxTheme theme;
  final VoidCallback onTap;

  const _IconBtn({
    required this.icon,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(left: 2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: _hovered ? t.surfaceActive : Colors.transparent,
          ),
          child: Icon(
            widget.icon,
            size: 12,
            color: _hovered ? t.accent : t.textDim,
          ),
        ),
      ),
    );
  }
}
