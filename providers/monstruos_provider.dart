import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import '../models/monster.dart';

class MonstruosNotifier extends StateNotifier<List<Monster>> {
  final Box<Monster> box;

  MonstruosNotifier(this.box) : super(box.values.toList());

  void recargar() {
    state = box.values.toList();
  }

  Future<void> agregar(Monster m) async {
    await box.add(m);
    recargar();
  }

  Future<void> editar(int index, Monster actualizado) async {
    final key = box.keyAt(index);
    await box.put(key, actualizado);
    recargar();
  }

  Future<void> eliminar(int index) async {
    final key = box.keyAt(index);
    await box.delete(key);
    recargar();
  }
}

final monstruosProvider = StateNotifierProvider<MonstruosNotifier, List<Monster>>((ref) {
  final box = Hive.box<Monster>('custom_monsters');
  return MonstruosNotifier(box);
});

// Family provider for per-slot custom monsters
final monstruosProviderForSlot = StateNotifierProvider.family<MonstruosNotifier, List<Monster>, int>((ref, slot) {
  final boxName = 'custom_monsters_slot_$slot';
  if (!Hive.isBoxOpen(boxName)) {
    Hive.openBox<Monster>(boxName);
  }
  final box = Hive.box<Monster>(boxName);
  return MonstruosNotifier(box);
});