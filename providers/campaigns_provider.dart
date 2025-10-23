import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/campaign.dart';
import '../models/jugador.dart';
import '../models/monster.dart';

final campaignsProvider =
    StateNotifierProvider<CampaignsNotifier, List<Campaign?>>((ref) {
  return CampaignsNotifier();
});

class CampaignsNotifier extends StateNotifier<List<Campaign?>> {
  static const String _boxName = 'campaigns';
  static const String _key = 'slots'; // almacena List<Campaign?> de 4 elementos

  Box? _box;

  CampaignsNotifier() : super(List<Campaign?>.filled(4, null)) {
    _load();
  }

  Future<void> _load() async {
    _box = await Hive.openBox(_boxName);
    final raw = _box!.get(_key);
    if (raw is List) {
      // asegurarse de tener exactamente 4 slots
      final loaded = List<Campaign?>.filled(4, null);
      for (var i = 0; i < 4; i++) {
        if (i < raw.length && raw[i] is Campaign) {
          loaded[i] = raw[i] as Campaign;
        } else {
          loaded[i] = null;
        }
      }
      state = loaded;
    } else {
      state = List<Campaign?>.filled(4, null);
      await _save();
    }
  }

  Future<void> _save() async {
    await _box?.put(_key, state);
  }

  // helpers para nombres de boxes por slot
  String _jugadoresBoxName(int slot) => 'jugadores_slot_$slot';
  String _enemigosBoxName(int slot) => 'enemigos_plantilla_slot_$slot';
  String _customMonstersBoxName(int slot) => 'custom_monsters_slot_$slot';
  String _fondosBoxName(int slot) => 'fondos_slot_$slot';

  Campaign? getCampaign(int slot) =>
      (slot >= 0 && slot < state.length) ? state[slot] : null;

  Future<bool> createCampaign(int slot, String name, String system) async {
    if (slot < 0 || slot >= state.length) return false;
    // si ya existe campaña en el slot, no crear
    if (state[slot] != null) return false;
    // crear Campaign y persistir
    final newCamp = Campaign(slot: slot, name: name, system: system);
    final newState = [...state];
    newState[slot] = newCamp;
    state = newState;
    await _save();

    // crear/abrir boxes dedicados a la campaña
    try {
      await Hive.openBox<Jugador>(_jugadoresBoxName(slot));
      await Hive.openBox<Jugador>(_enemigosBoxName(slot));
      await Hive.openBox<Monster>(_customMonstersBoxName(slot));
      await Hive.openBox(_fondosBoxName(slot)); // fondos pueden ser bytes/u otra estructura
    } catch (_) {
      // ignore errores de apertura (se puede loggear si se desea)
    }
    return true;
  }

  Future<void> updateCampaign(int slot, Campaign campaign) async {
    if (slot < 0 || slot >= state.length) return;
    final newState = [...state];
    newState[slot] = campaign;
    state = newState;
    await _save();
  }

  Future<void> deleteCampaign(int slot) async {
    if (slot < 0 || slot >= state.length) return;
    // eliminar datos asociados: cerrar y borrar boxes por slot
    final boxNames = [
      _jugadoresBoxName(slot),
      _enemigosBoxName(slot),
      _customMonstersBoxName(slot),
      _fondosBoxName(slot),
    ];
    for (final name in boxNames) {
      try {
        if (Hive.isBoxOpen(name)) {
          await Hive.box(name).close();
        }
        // Borra el archivo del box en disco
        await Hive.deleteBoxFromDisk(name);
      } catch (_) {
        // ignore
      }
    }

    final newState = [...state];
    newState[slot] = null;
    state = newState;
    await _save();
  }

  int count() => state.where((c) => c != null).length;
}