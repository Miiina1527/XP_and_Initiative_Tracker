enum KonamiInput { up, down, left, right, a, b, c, d }

class KonamiDetector {
  final List<KonamiInput> _target = [
    KonamiInput.up,
    KonamiInput.up,
    KonamiInput.down,
    KonamiInput.down,
    KonamiInput.left,
    KonamiInput.right,
    KonamiInput.left,
    KonamiInput.right,
    KonamiInput.b,
    KonamiInput.a,
  ];

  int _pos = 0;

  /// No timeout behavior as per user request.
  KonamiDetector();

  /// Add an input. Returns true if the sequence was completed by this input.
  bool add(KonamiInput input) {
    // KMP-like fallback: if mismatch, try to find largest prefix
    while (_pos > 0 && _target[_pos] != input) {
      // fallback: reduce _pos until prefix matches
      _pos = _fallback(_pos - 1);
    }

    if (_target[_pos] == input) {
      _pos++;
      if (_pos == _target.length) {
        _pos = 0; // reset after success
        return true;
      }
      return false;
    }

    // if still mismatch and at pos==0, nothing to do
    return false;
  }

  int _fallback(int pos) {
    // compute fallback by checking prefixes
    for (int newPos = pos; newPos > 0; newPos--) {
      bool ok = true;
      for (int i = 0; i < newPos; i++) {
        if (_target[i] != _target[pos - newPos + 1 + i]) {
          ok = false;
          break;
        }
      }
      if (ok) return newPos;
    }
    return 0;
  }

  void reset() {
    _pos = 0;
  }
}
