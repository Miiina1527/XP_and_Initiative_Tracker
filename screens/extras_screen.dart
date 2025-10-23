import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../utils/konami_detector.dart';
import '../providers/settings_provider.dart';
// imports trimmed
import 'package:audioplayers/audioplayers.dart';

class ExtrasScreen extends ConsumerStatefulWidget {
  const ExtrasScreen({super.key});

  @override
  ConsumerState<ExtrasScreen> createState() => _ExtrasScreenState();
}

class _ExtrasScreenState extends ConsumerState<ExtrasScreen> {
  final KonamiDetector _detector = KonamiDetector();
  final AudioPlayer _player = AudioPlayer();
  bool _unlocked = false;

  @override
  void initState() {
    super.initState();
    // ensure settings box is open
    ref.read(settingsProvider).init().then((_) {
      setState(() {
        _unlocked = ref.read(settingsProvider).extrasUnlocked;
      });
    });
  }

  void _handleInput(KonamiInput input) async {
    final ok = _detector.add(input);
    if (ok && !_unlocked) {
      // unlock
      await ref.read(settingsProvider).setExtrasUnlocked(true);
      setState(() {
        _unlocked = true;
      });
      // play bell sound
      try {
        await _player.play(AssetSource('sounds/bell.mp3'));
      } catch (e) {
        // ignore audio errors
      }
    }
  }

  Widget _buildColumn(int index) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < -8) {
          _handleInput(KonamiInput.up);
        } else if (details.delta.dy > 8) {
          _handleInput(KonamiInput.down);
        }
      },
      child: Container(
        width: 110,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6)],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/images/d8.png', width: 64, height: 64),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: [
                IconButton(onPressed: () => _handleInput(KonamiInput.up), icon: const Icon(Icons.arrow_upward)),
                IconButton(onPressed: () => _handleInput(KonamiInput.down), icon: const Icon(Icons.arrow_downward)),
                IconButton(onPressed: () => _handleInput(KonamiInput.left), icon: const Icon(Icons.arrow_back)),
                IconButton(onPressed: () => _handleInput(KonamiInput.right), icon: const Icon(Icons.arrow_forward)),
                ElevatedButton(onPressed: () => _handleInput(KonamiInput.a), child: const Text('A')),
                ElevatedButton(onPressed: () => _handleInput(KonamiInput.b), child: const Text('B')),
                ElevatedButton(onPressed: () => _handleInput(KonamiInput.c), child: const Text('C')),
                ElevatedButton(onPressed: () => _handleInput(KonamiInput.d), child: const Text('D')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Extras')),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: Row(
                children: List.generate(10, (i) => _buildColumn(i)),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 600),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                gradient: _unlocked
                    ? LinearGradient(colors: [Colors.amber.shade700, Colors.orange.shade200])
                    : null,
                color: _unlocked ? null : Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: _unlocked ? [BoxShadow(color: Colors.amber.withOpacity(0.6), blurRadius: 12, spreadRadius: 2)] : null,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Start', style: TextStyle(color: _unlocked ? Colors.white : Colors.white, fontSize: 16)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
