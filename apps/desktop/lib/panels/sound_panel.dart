import 'package:flutter/material.dart';
import '../theme.dart';
import '../services/ambient_mixer.dart';

class SoundPanel extends StatefulWidget {
  final GruvboxTheme theme;
  const SoundPanel({super.key, required this.theme});

  @override
  State<SoundPanel> createState() => _SoundPanelState();
}

class _SoundPanelState extends State<SoundPanel> {
  final AmbientMixer _mixer = AmbientMixer();

  @override
  void dispose() {
    _mixer.dispose();
    super.dispose();
  }

  GruvboxTheme get t => widget.theme;

  @override
  Widget build(BuildContext context) {
    final activeCount = _mixer.activeCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 18, 20, 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Mixer List
          Expanded(
            flex: 6,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Text(
                      'Ambient mixer',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.1,
                        color: t.text,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (activeCount > 0)
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: t.accentBright,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  activeCount > 0
                      ? '$activeCount layer${activeCount == 1 ? '' : 's'} playing'
                      : 'All layers muted',
                  style: TextStyle(fontSize: 11, color: t.textDim),
                ),
                const SizedBox(height: 10),

                // Layers
                Expanded(
                  child: ListView.builder(
                    itemCount: _mixer.layers.length,
                    padding: EdgeInsets.zero,
                    itemBuilder: (context, index) {
                      final layer = _mixer.layers[index];
                      return _LayerRow(
                        layer: layer,
                        theme: t,
                        onToggle: () async {
                          await layer.toggle();
                          setState(() {});
                        },
                        onVolumeChanged: (v) async {
                          await layer.setVol(v);
                          setState(() {});
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // Right side: Visualizer and Dynamic Icon
          Expanded(
            flex: 4,
            child: _VisualizerArea(
              theme: t,
              mixer: _mixer,
            ),
          ),
        ],
      ),
    );
  }
}

class _VisualizerArea extends StatelessWidget {
  final GruvboxTheme theme;
  final AmbientMixer mixer;

  const _VisualizerArea({
    required this.theme,
    required this.mixer,
  });

  IconData _getIcon() {
    final active = mixer.layers.where((l) => l.active).toList();
    if (active.isEmpty) return Icons.multitrack_audio_outlined;
    if (active.length > 1) return Icons.auto_awesome_outlined;

    final id = active.first.id;
    if (id.contains('rain')) return Icons.umbrella_outlined;
    if (id.contains('forest')) return Icons.forest_outlined;
    if (id.contains('stream')) return Icons.water_outlined;
    if (id.contains('wind')) return Icons.air_outlined;
    if (id.contains('thunder')) return Icons.thunderstorm_outlined;
    if (id.contains('cafe')) return Icons.coffee_outlined;
    if (id.contains('city')) return Icons.location_city_outlined;
    if (id.contains('keyboard')) return Icons.keyboard_outlined;
    if (id.contains('train')) return Icons.train_outlined;
    if (id.contains('fire')) return Icons.local_fire_department_outlined;
    if (id.contains('cricket')) return Icons.nights_stay_outlined;
    if (id.contains('chime')) return Icons.music_note_outlined;

    return Icons.waves_outlined;
  }

  @override
  Widget build(BuildContext context) {
    final isActive = mixer.activeCount > 0;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive ? theme.accentSoft : theme.surface,
          ),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: Icon(
              _getIcon(),
              key: ValueKey(_getIcon()),
              size: 48,
              color: isActive ? theme.accent : theme.textDim,
            ),
          ),
        ),
        const SizedBox(height: 32),
        _SoundVisualizer(
          theme: theme,
          isActive: isActive,
        ),
      ],
    );
  }
}

class _SoundVisualizer extends StatefulWidget {
  final GruvboxTheme theme;
  final bool isActive;

  const _SoundVisualizer({
    required this.theme,
    required this.isActive,
  });

  @override
  State<_SoundVisualizer> createState() => _SoundVisualizerState();
}

class _SoundVisualizerState extends State<_SoundVisualizer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<double> _heights = List.generate(12, (_) => 0.2);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(12, (index) {
            // Pseudo-random animation based on index and controller
            final wave = (1.0 + (index % 3) * 0.2) * _controller.value;
            final baseHeight = widget.isActive ? 4.0 : 2.0;
            final maxHeight = widget.isActive ? 24.0 : 2.0;
            final h = baseHeight + (maxHeight - baseHeight) * (0.2 + 0.8 * (index % 4 == 0 ? wave : (1.0 - wave)).abs());

            return AnimatedContainer(
              duration: const Duration(milliseconds: 100),
              width: 3,
              height: h,
              margin: const EdgeInsets.symmetric(horizontal: 1.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(99),
                color: widget.isActive ? widget.theme.accent : widget.theme.borderHeavy,
              ),
            );
          }),
        );
      },
    );
  }
}

class _LayerRow extends StatefulWidget {
  final AmbientLayer layer;
  final GruvboxTheme theme;
  final VoidCallback onToggle;
  final ValueChanged<double> onVolumeChanged;

  const _LayerRow({
    required this.layer,
    required this.theme,
    required this.onToggle,
    required this.onVolumeChanged,
  });

  @override
  State<_LayerRow> createState() => _LayerRowState();
}

class _LayerRowState extends State<_LayerRow> with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  GruvboxTheme get t => widget.theme;
  AmbientLayer get layer => widget.layer;

  @override
  Widget build(BuildContext context) {
    final isActive = layer.active;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onToggle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: isActive
                ? t.accentSoft
                : (_hovered ? t.surface : Colors.transparent),
            border: Border.all(
              color: isActive ? t.accentBorder : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              // Chip indicator
              SizedBox(
                width: 22,
                height: 22,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (isActive)
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Container(
                            width: 14 + (8 * _pulseController.value),
                            height: 14 + (8 * _pulseController.value),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: t.accent.withValues(alpha: 0.2 * (1 - _pulseController.value)),
                            ),
                          );
                        },
                      ),
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActive ? t.accent : t.borderHeavy,
                          width: 1.5,
                        ),
                      ),
                      child: Center(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isActive ? 8 : 6,
                          height: isActive ? 8 : 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isActive ? t.accent : t.textDim,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),

              // Labels
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      layer.label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive ? t.accent : t.text,
                      ),
                    ),
                    Text(
                      layer.hint,
                      style: TextStyle(fontSize: 10, color: t.textDim),
                    ),
                  ],
                ),
              ),

              // Volume slider (only when active)
              if (isActive)
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: 1.0,
                  child: SizedBox(
                    width: 80,
                    child: SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 2,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
                        activeTrackColor: t.accent,
                        inactiveTrackColor: t.borderHeavy,
                        thumbColor: t.accent,
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
                        overlayColor: t.accent.withValues(alpha: 0.1),
                      ),
                      child: Slider(
                        value: layer.volume,
                        onChanged: widget.onVolumeChanged,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
