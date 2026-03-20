import 'dart:async';
import 'package:flutter/material.dart';
import '../theme.dart';

enum FocusMode { pomodoro, deep }

class FocusPanel extends StatefulWidget {
  final GruvboxTheme theme;
  const FocusPanel({super.key, required this.theme});

  @override
  State<FocusPanel> createState() => _FocusPanelState();
}

class _FocusPanelState extends State<FocusPanel> {
  static const _presets = {
    FocusMode.pomodoro: (work: 25 * 60, breakTime: 5 * 60),
    FocusMode.deep: (work: 50 * 60, breakTime: 0),
  };

  FocusMode _mode = FocusMode.pomodoro;
  int _remaining = 25 * 60;
  bool _running = false;
  bool _onBreak = false;
  Timer? _timer;

  GruvboxTheme get t => widget.theme;

  String _format(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  void _switchMode(FocusMode next) {
    _stopTimer();
    setState(() {
      _mode = next;
      _onBreak = false;
      _remaining = _presets[next]!.work;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
    setState(() => _running = false);
  }

  void _startTimer() {
    if (_running) return;
    setState(() => _running = true);
    _tick();
  }

  void _tick() {
    if (!_running) return;
    _timer = Timer(const Duration(seconds: 1), () {
      if (!_running) return;
      setState(() {
        if (_remaining <= 0) {
          if (_mode == FocusMode.pomodoro && !_onBreak && _presets[FocusMode.pomodoro]!.breakTime > 0) {
            _onBreak = true;
            _remaining = _presets[FocusMode.pomodoro]!.breakTime;
          } else {
            _reset();
            return;
          }
        } else {
          _remaining--;
        }
      });
      _tick();
    });
  }

  void _toggle() {
    _running ? _stopTimer() : _startTimer();
  }

  void _reset() {
    _stopTimer();
    setState(() {
      _onBreak = false;
      _remaining = _presets[_mode]!.work;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Pill label
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: t.border),
              ),
              child: Text(
                'Focus timer',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.4,
                  color: t.textDim,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Mode toggle
            _ModeToggle(
              theme: t,
              mode: _mode,
              onSwitch: _switchMode,
            ),
            const SizedBox(height: 8),

            // Hint
            Text(
              _mode == FocusMode.pomodoro
                  ? '25 minute focus, 5 minute break.'
                  : 'Long, interruption-free focus block.',
              style: TextStyle(fontSize: 11, color: t.textDim),
            ),

            // Timer face
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  Text(
                    _format(_remaining),
                    style: TextStyle(
                      fontSize: 72,
                      fontWeight: FontWeight.w200,
                      letterSpacing: 3,
                      height: 1,
                      color: t.text,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _running
                        ? (_mode == FocusMode.pomodoro && _onBreak ? 'BREAK' : 'IN SESSION')
                        : 'IDLE',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                      color: t.textDim,
                    ),
                  ),
                ],
              ),
            ),

            // Controls
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Start / Pause
                _ControlButton(
                  theme: t,
                  isPrimary: true,
                  icon: _running ? Icons.pause_rounded : Icons.play_arrow_rounded,
                  label: _running ? 'Pause' : 'Start',
                  onTap: _toggle,
                ),
                const SizedBox(width: 10),
                // Reset
                _ControlButton(
                  theme: t,
                  isPrimary: false,
                  icon: Icons.refresh_rounded,
                  label: 'Reset',
                  onTap: _reset,
                ),
              ],
            ),
            const SizedBox(height: 12),

            Text(
              'Space to start / pause, R to reset (coming soon).',
              style: TextStyle(fontSize: 10, color: t.textDim),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  final GruvboxTheme theme;
  final FocusMode mode;
  final ValueChanged<FocusMode> onSwitch;

  const _ModeToggle({
    required this.theme,
    required this.mode,
    required this.onSwitch,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.surface,
        border: Border.all(color: theme.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleItem(
            label: 'Pomodoro',
            isActive: mode == FocusMode.pomodoro,
            theme: theme,
            onTap: () => onSwitch(FocusMode.pomodoro),
          ),
          const SizedBox(width: 2),
          _ToggleItem(
            label: 'Deep work',
            isActive: mode == FocusMode.deep,
            theme: theme,
            onTap: () => onSwitch(FocusMode.deep),
          ),
        ],
      ),
    );
  }
}

class _ToggleItem extends StatefulWidget {
  final String label;
  final bool isActive;
  final GruvboxTheme theme;
  final VoidCallback onTap;

  const _ToggleItem({
    required this.label,
    required this.isActive,
    required this.theme,
    required this.onTap,
  });

  @override
  State<_ToggleItem> createState() => _ToggleItemState();
}

class _ToggleItemState extends State<_ToggleItem> {
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: widget.isActive ? t.accentSoft : Colors.transparent,
            border: Border.all(
              color: widget.isActive ? t.accentBorder : Colors.transparent,
            ),
          ),
          child: Text(
            widget.label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: widget.isActive
                  ? t.accent
                  : (_hovered ? t.textSecondary : t.textDim),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlButton extends StatefulWidget {
  final GruvboxTheme theme;
  final bool isPrimary;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ControlButton({
    required this.theme,
    required this.isPrimary,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<_ControlButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.theme;
    final bg = widget.isPrimary
        ? (_hovered ? t.accentBright : t.accent)
        : (_hovered ? t.surface : Colors.transparent);
    final fg = widget.isPrimary
        ? t.textOnAccent
        : (_hovered ? t.text : t.textSecondary);
    final borderColor = widget.isPrimary
        ? (_hovered ? t.accentBright : t.accent)
        : t.border;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: bg,
            border: Border.all(color: borderColor),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 14, color: fg),
              const SizedBox(width: 6),
              Text(
                widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: widget.isPrimary ? FontWeight.w600 : FontWeight.w500,
                  color: fg,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
