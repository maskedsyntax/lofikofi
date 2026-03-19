import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme.dart';
import 'panels/sound_panel.dart';
import 'panels/focus_panel.dart';
import 'panels/todo_panel.dart';
import 'panels/board_panel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LofikofiApp());
}

class LofikofiApp extends StatelessWidget {
  const LofikofiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lofikofi — Deep Focus',
      debugShowCheckedModeBanner: false,
      home: AppShell(),
    );
  }
}

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  bool _isDark = false;
  int _tabIndex = 0;

  static const _tabs = ['Ambient', 'Focus', 'Boards', 'To-dos'];

  GruvboxTheme get theme => GruvboxTheme(isDark: _isDark);

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('lofikofi:theme');
    if (stored != null) {
      setState(() => _isDark = stored == 'dark');
    } else {
      setState(() {
        _isDark = WidgetsBinding.instance.platformDispatcher.platformBrightness == Brightness.dark;
      });
    }
  }

  Future<void> _toggleTheme() async {
    final next = !_isDark;
    setState(() => _isDark = next);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('lofikofi:theme', next ? 'dark' : 'light');
  }

  @override
  Widget build(BuildContext context) {
    final t = theme;

    return Scaffold(
      backgroundColor: t.bg,
      body: Column(
        children: [
          // Titlebar
          _Titlebar(theme: t, isDark: _isDark, onToggleTheme: _toggleTheme),

          // Navigation
          _NavBar(
            theme: t,
            tabs: _tabs,
            activeIndex: _tabIndex,
            onTap: (i) => setState(() => _tabIndex = i),
          ),

          // Content
          Expanded(
            child: IndexedStack(
              index: _tabIndex,
              children: [
                SoundPanel(theme: t),
                FocusPanel(theme: t),
                BoardPanel(theme: t),
                TodoPanel(theme: t),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Titlebar extends StatelessWidget {
  final GruvboxTheme theme;
  final bool isDark;
  final VoidCallback onToggleTheme;

  const _Titlebar({
    required this.theme,
    required this.isDark,
    required this.onToggleTheme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      color: theme.bgAlt,
      child: Row(
        children: [
          const Spacer(),
          _ThemeToggleButton(theme: theme, isDark: isDark, onTap: onToggleTheme),
        ],
      ),
    );
  }
}

class _ThemeToggleButton extends StatefulWidget {
  final GruvboxTheme theme;
  final bool isDark;
  final VoidCallback onTap;

  const _ThemeToggleButton({
    required this.theme,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_ThemeToggleButton> createState() => _ThemeToggleButtonState();
}

class _ThemeToggleButtonState extends State<_ThemeToggleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: _hovered ? t.borderHeavy : t.border),
            color: _hovered ? t.surfaceHover : t.surface,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.isDark ? Icons.wb_sunny_outlined : Icons.dark_mode_outlined,
                size: 14,
                color: _hovered ? t.text : t.textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                widget.isDark ? 'Light' : 'Dark',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: _hovered ? t.text : t.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final GruvboxTheme theme;
  final List<String> tabs;
  final int activeIndex;
  final ValueChanged<int> onTap;

  const _NavBar({
    required this.theme,
    required this.tabs,
    required this.activeIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: theme.bg,
        border: Border(bottom: BorderSide(color: theme.border)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: theme.surface,
              border: Border.all(color: theme.border),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < tabs.length; i++) ...[
                  if (i > 0) const SizedBox(width: 2),
                  _SegItem(
                    label: tabs[i],
                    isActive: i == activeIndex,
                    theme: theme,
                    onTap: () => onTap(i),
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

class _SegItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final GruvboxTheme theme;
  final VoidCallback onTap;

  const _SegItem({
    required this.label,
    required this.isActive,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_SegItem> createState() => _SegItemState();
}

class _SegItemState extends State<_SegItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: widget.isActive ? t.bg : Colors.transparent,
            boxShadow: widget.isActive
                ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 2, offset: const Offset(0, 1))]
                : null,
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: widget.isActive ? FontWeight.w600 : FontWeight.w500,
              color: widget.isActive
                  ? t.text
                  : (_hovered ? t.textSecondary : t.textDim),
            ),
          ),
        ),
      ),
    );
  }
}
