import 'package:audioplayers/audioplayers.dart';

class AmbientLayer {
  final String id;
  final String label;
  final String hint;
  final String file;
  final AudioPlayer _player = AudioPlayer();
  bool active = false;
  double volume = 0.55;

  AmbientLayer({
    required this.id,
    required this.label,
    required this.hint,
    required this.file,
  });

  Future<void> play() async {
    await _player.setReleaseMode(ReleaseMode.loop);
    await _player.setVolume(volume);
    await _player.play(AssetSource('sounds/$file'));
    active = true;
  }

  Future<void> stop() async {
    await _player.stop();
    active = false;
  }

  Future<void> setVol(double v) async {
    volume = v;
    await _player.setVolume(v);
  }

  Future<void> toggle() async {
    if (active) {
      await stop();
    } else {
      await play();
    }
  }

  void dispose() {
    _player.dispose();
  }
}

class AmbientMixer {
  final List<AmbientLayer> layers = [
    AmbientLayer(id: 'rain', label: 'Rain', hint: 'Steady rainfall', file: 'rain_loop.mp3'),
    AmbientLayer(id: 'rain_calm', label: 'Calm rain', hint: 'Gentle drizzle', file: 'rain_calm_loop.mp3'),
    AmbientLayer(id: 'rain_birds', label: 'Rain + birds', hint: 'Tropical shower', file: 'rain_birds_loop.mp3'),
    AmbientLayer(id: 'forest', label: 'Forest', hint: 'Woodland ambience', file: 'forest_loop.mp3'),
    AmbientLayer(id: 'stream', label: 'Stream', hint: 'Babbling brook', file: 'stream_loop.mp3'),
    AmbientLayer(id: 'wind', label: 'Wind', hint: 'Gentle breeze', file: 'wind_loop.mp3'),
    AmbientLayer(id: 'windchimes', label: 'Windchimes', hint: 'Metallic tones', file: 'windchimes_loop.mp3'),
    AmbientLayer(id: 'thunder', label: 'Thunder', hint: 'Distant rumble', file: 'thunder_loop.mp3'),
    AmbientLayer(id: 'cafe', label: 'Café', hint: 'Coffee shop murmur', file: 'cafe_loop.mp3'),
    AmbientLayer(id: 'city', label: 'City', hint: 'Urban soundscape', file: 'city_loop.mp3'),
    AmbientLayer(id: 'keyboard', label: 'Keyboard', hint: 'Mechanical typing', file: 'keyboard_loop.mp3'),
    AmbientLayer(id: 'train', label: 'Train', hint: 'Rail journey', file: 'train_loop.mp3'),
    AmbientLayer(id: 'fireplace', label: 'Fireplace', hint: 'Crackling fire', file: 'fireplace_loop.mp3'),
    AmbientLayer(id: 'crickets', label: 'Crickets', hint: 'Summer night', file: 'crickets_loop.mp3'),
  ];

  int get activeCount => layers.where((l) => l.active).length;

  void dispose() {
    for (final layer in layers) {
      layer.dispose();
    }
  }
}
