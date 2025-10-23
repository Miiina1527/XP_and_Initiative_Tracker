import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/adapters.dart';
import '../utils/pfmonster_database.dart' as pf;
import '../utils/dndmonster_database.dart' as dnd;
import '../models/monster.dart';
import '../providers/monstruos_provider.dart';

class MonsterDbScreen extends ConsumerStatefulWidget {
  final void Function(Map<String, dynamic>)? onAddMonster;
  // If provided, initialSistema fixes the game system and can be used to hide the
  // system selector when opening the screen from a campaign context.
  final SistemaJuego? initialSistema;
  final bool hideSistemaSelector;
  // Optional campaign slot to persist custom monsters into per-campaign boxes
  final int? campaignSlot;

  const MonsterDbScreen({super.key, this.onAddMonster, this.initialSistema, this.hideSistemaSelector = false, this.campaignSlot});

  @override
  ConsumerState<MonsterDbScreen> createState() => _MonsterDbScreenState();
}

enum SistemaJuego { pathfinder, dnd5e }

class _MonsterDbScreenState extends ConsumerState<MonsterDbScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _hpCtrl = TextEditingController(text: '0');
  final _acCtrl = TextEditingController(text: '10');
  final _nivelCtrl = TextEditingController(text: '1');
  final _xpCtrl = TextEditingController(text: '0');
  final _initiativeCtrl = TextEditingController(text: '0');
  final _attCtrl = TextEditingController();
  final _movsCtrl = TextEditingController();
  final _typeCtrl = TextEditingController();

  String _searchQuery = '';
  late SistemaJuego _sistemaSeleccionado = widget.initialSistema ?? SistemaJuego.pathfinder;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _hpCtrl.dispose();
    _acCtrl.dispose();
    _nivelCtrl.dispose();
    _xpCtrl.dispose();
    _initiativeCtrl.dispose();
    _attCtrl.dispose();
    _movsCtrl.dispose();
    _typeCtrl.dispose();
    super.dispose();
  }

  void _limpiarFormulario() {
    _nameCtrl.clear();
    _hpCtrl.text = '0';
    _acCtrl.text = '10';
    _nivelCtrl.text = '1';
    _xpCtrl.text = '0';
    _initiativeCtrl.text = '0';
    _attCtrl.clear();
    _movsCtrl.clear();
    _typeCtrl.clear();
  }

  void _agregarEnemigoPersonalizado() async {
    if (_formKey.currentState!.validate()) {
      final monster = Monster(
        name: _nameCtrl.text.trim(),
        hp: int.tryParse(_hpCtrl.text) ?? 0,
        ac: int.tryParse(_acCtrl.text) ?? 10,
        nivel: int.tryParse(_nivelCtrl.text) ?? 1,
        xp: int.tryParse(_xpCtrl.text) ?? 0,
        initiative: int.tryParse(_initiativeCtrl.text) ?? 0,
        att: _attCtrl.text.trim().isEmpty ? null : _attCtrl.text.trim(),
        movs: _movsCtrl.text.trim().isEmpty ? null : _movsCtrl.text.trim(),
        type: _typeCtrl.text.trim().isEmpty ? '-' : _typeCtrl.text.trim(),
      );
      final messenger = ScaffoldMessenger.of(context);
      // Use per-slot provider notifier when available, otherwise global provider
      final hasSlot = widget.campaignSlot != null && Hive.isBoxOpen('custom_monsters_slot_${widget.campaignSlot}');
      final notifier = hasSlot
          ? ref.read(monstruosProviderForSlot(widget.campaignSlot!).notifier)
          : ref.read(monstruosProvider.notifier);
      await notifier.agregar(monster);
      if (!mounted) return;
      _limpiarFormulario();
      messenger.showSnackBar(
        SnackBar(content: Text('monster_added'.tr())),
      );
    }
  }

  void _editarCustomMonsterDialog(int index, Monster monster) {
    final parentContext = context;
    final nameCtrl = TextEditingController(text: monster.name);
    final hpCtrl = TextEditingController(text: monster.hp.toString());
    final acCtrl = TextEditingController(text: monster.ac.toString());
    final nivelCtrl = TextEditingController(text: monster.nivel.toString());
    final xpCtrl = TextEditingController(text: monster.xp.toString());
    final initiativeCtrl = TextEditingController(text: monster.initiative.toString());
    final attCtrl = TextEditingController(text: monster.att ?? '');
    final movsCtrl = TextEditingController(text: monster.movs ?? '');
    final typeCtrl = TextEditingController(text: monster.type);

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setStateDialog) => AlertDialog(
          title: Text('edit_monster_title'.tr(args: [monster.name])),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nameCtrl,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: hpCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'HP'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: acCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'AC'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: nivelCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Nivel'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: xpCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'XP'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: initiativeCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(labelText: 'Iniciativa'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: typeCtrl,
                          decoration: const InputDecoration(labelText: 'Tipo'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: attCtrl,
                          decoration: const InputDecoration(labelText: 'Ataque'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: movsCtrl,
                          decoration: const InputDecoration(labelText: 'Movs'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  final navigator = Navigator.of(parentContext);
                  final messenger = ScaffoldMessenger.of(parentContext);
                  final hasSlot = widget.campaignSlot != null && Hive.isBoxOpen('custom_monsters_slot_${widget.campaignSlot}');
                  final notifier = hasSlot
                      ? ref.read(monstruosProviderForSlot(widget.campaignSlot!).notifier)
                      : ref.read(monstruosProvider.notifier);
                  notifier.eliminar(index).then((_) {
                    if (!mounted) return;
                    navigator.pop();
                    messenger.showSnackBar(
                      SnackBar(content: Text('monster_deleted'.tr(args: [monster.name]))),
                    );
                  });
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text('delete'.tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('cancel'.tr()),
              ),
                  ElevatedButton(
                onPressed: () {
                  if (nameCtrl.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('name_cannot_be_empty'.tr())),
                    );
                    return;
                  }
                  final actualizado = monster.copyWith(
                    name: nameCtrl.text.trim(),
                    hp: int.tryParse(hpCtrl.text) ?? monster.hp,
                    ac: int.tryParse(acCtrl.text) ?? monster.ac,
                    nivel: int.tryParse(nivelCtrl.text) ?? monster.nivel,
                    xp: int.tryParse(xpCtrl.text) ?? monster.xp,
                    initiative: int.tryParse(initiativeCtrl.text) ?? monster.initiative,
                    att: attCtrl.text.trim().isEmpty ? null : attCtrl.text.trim(),
                    movs: movsCtrl.text.trim().isEmpty ? null : movsCtrl.text.trim(),
                    type: typeCtrl.text.trim().isEmpty ? '-' : typeCtrl.text.trim(),
                  );
                  final navigator = Navigator.of(parentContext);
                  final messenger = ScaffoldMessenger.of(parentContext);
                  final hasSlot = widget.campaignSlot != null && Hive.isBoxOpen('custom_monsters_slot_${widget.campaignSlot}');
                  final notifier = hasSlot
                      ? ref.read(monstruosProviderForSlot(widget.campaignSlot!).notifier)
                      : ref.read(monstruosProvider.notifier);
                  notifier.editar(index, actualizado).then((_) {
                    if (!mounted) return;
                    navigator.pop();
                    messenger.showSnackBar(
                      SnackBar(content: Text('monster_updated'.tr(args: [actualizado.name]))),
                    );
                  });
                },
                child: Text('save'.tr()),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // If a campaign slot is provided and the per-slot box is open, use the
    // per-slot provider; otherwise fall back to the global provider.
    final hasSlot = widget.campaignSlot != null && Hive.isBoxOpen('custom_monsters_slot_${widget.campaignSlot}');
    final customMonsters = hasSlot
        ? ref.watch(monstruosProviderForSlot(widget.campaignSlot!))
        : ref.watch(monstruosProvider);

    // Obtener la base de datos según el sistema seleccionado
    final baseMonsters = _sistemaSeleccionado == SistemaJuego.pathfinder 
        ? pf.monsterDatabase 
        : dnd.dndmonsterDatabase;

    // Filtrar monstruos base
    final filteredMonsters = baseMonsters.where((monster) {
      final query = _searchQuery.toLowerCase();
      final name = monster['name']?.toString() ?? '';
      final type = monster['type']?.toString() ?? '';
      
      // Para D&D usamos 'challenge_rating', para Pathfinder 'nivel' o 'level'
      final level = _sistemaSeleccionado == SistemaJuego.dnd5e 
          ? (monster['challenge_rating']?.toString() ?? '') 
          : (monster['nivel']?.toString() ?? monster['level']?.toString() ?? '');
      
      return name.toLowerCase().contains(query) ||
          type.toLowerCase().contains(query) ||
          level.contains(query);
    }).toList();

    // Filtrar monstruos personalizados
    final filteredCustomMonsters = customMonsters.where((monster) {
      final query = _searchQuery.toLowerCase();
      return monster.name.toLowerCase().contains(query) ||
          monster.type.toLowerCase().contains(query) ||
          monster.nivel.toString().contains(query);
    }).toList();

    final addCustomMonsterCard = Card(
      color: const Color(0xFFF5E6CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ExpansionTile(
        title: Text(
          'add_custom_monster'.tr(),
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'NotoSerifJP',
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(
                      labelText: 'name'.tr(),
                      prefixIcon: const Icon(Icons.person, color: Colors.brown),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'enter_name'.tr() : null,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _hpCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'hp'.tr(),
                            prefixIcon: const Icon(Icons.favorite, color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _acCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'ac'.tr(),
                            prefixIcon: const Icon(Icons.shield, color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _nivelCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'level'.tr(),
                            prefixIcon: const Icon(Icons.star, color: Colors.amber),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _xpCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'experience_points'.tr(),
                            prefixIcon: const Icon(Icons.flash_on, color: Colors.orange),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _initiativeCtrl,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'initiative'.tr(),
                            prefixIcon: const Icon(Icons.bolt, color: Colors.deepPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _typeCtrl,
                          decoration: InputDecoration(
                            labelText: 'type'.tr(),
                            prefixIcon: const Icon(Icons.category, color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _attCtrl,
                          decoration: InputDecoration(
                            labelText: 'attack'.tr(),
                            prefixIcon: const Icon(Icons.gavel, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _movsCtrl,
                          decoration: InputDecoration(
                            labelText: 'movements'.tr(),
                            prefixIcon: const Icon(Icons.directions_run, color: Colors.teal),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red.shade700,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          icon: const Icon(Icons.add),
                          onPressed: _agregarEnemigoPersonalizado,
                          label: Text('add'.tr()),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _limpiarFormulario,
                        child: Text('clear_form'.tr()),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('monster_database'.tr()),
      ),
      body: Column(
        children: [
          // Selector de sistema de juego (oculto si `hideSistemaSelector` se pide)
          if (!widget.hideSistemaSelector)
            Container(
              margin: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.gamepad, color: Colors.blue),
                    const SizedBox(width: 12),
                    Text(
                      'game_system'.tr(),
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SegmentedButton<SistemaJuego>(
                        segments: [
                          ButtonSegment<SistemaJuego>(
                            value: SistemaJuego.pathfinder,
                            label: Text('pathfinder'.tr()),
                            icon: const Icon(Icons.shield),
                          ),
                          ButtonSegment<SistemaJuego>(
                            value: SistemaJuego.dnd5e,
                            label: Text('dnd'.tr()),
                            icon: const Icon(Icons.casino),
                          ),
                        ],
                        selected: {_sistemaSeleccionado},
                        onSelectionChanged: (Set<SistemaJuego> newSelection) {
                          setState(() {
                            _sistemaSeleccionado = newSelection.first;
                            _searchQuery = ''; // Limpiar búsqueda al cambiar sistema
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: _sistemaSeleccionado == SistemaJuego.dnd5e 
                    ? 'search_name_type_cr'.tr() 
                    : 'search_name_type_level'.tr(),
                prefixIcon: const Icon(Icons.search),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              controller: TextEditingController(text: _searchQuery),
            ),
          ),
          addCustomMonsterCard,
          Expanded(
            child: ListView(
              children: [
                // Monstruos personalizados primero
                ...filteredCustomMonsters.map((monster) {
                  // Resolve the original index in the underlying customMonsters
                  // list so edits/deletes operate on the correct item even when
                  // the list is filtered.
                  final originalIndex = customMonsters.indexOf(monster);
                  return GestureDetector(
                    onTap: () => _editarCustomMonsterDialog(originalIndex, monster),
                    child: Card(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  child: Text(monster.name.isNotEmpty ? monster.name[0].toUpperCase() : '?'),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    monster.name,
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  onPressed: () {
                                    final playerData = <String, dynamic>{
                                      'nombre': monster.name,
                                      'nivelClase1': monster.nivel,
                                      'hp': monster.hp,
                                      'maxHp': monster.hp,
                                      'ac': monster.ac,
                                      'iniciativa': monster.initiative,
                                      'att': monster.att,
                                      'movs': monster.movs,
                                    };
                                    if (widget.onAddMonster != null) {
                                      widget.onAddMonster!(playerData);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('monster_added_as_player'.tr(args: [monster.name]))),
                                        );
                                      }
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('action_only_available_from_datos'.tr())),
                                        );
                                      }
                                    }
                                  },
                                  child: Text('add_monster'.tr()),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              runSpacing: 4,
                              children: [
                                Text('Type: ${monster.type.isEmpty ? '-' : monster.type}'),
                                Text('Level: ${monster.nivel}'),
                                Text('HP: ${monster.hp}'),
                                Text('AC: ${monster.ac}'),
                                Text('Initiative: ${monster.initiative}'),
                                Text('XP: ${monster.xp}'),
                              ],
                            ),
                            if (monster.att != null && monster.att!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text('Attack: ${monster.att!}'),
                              ),
                            if (monster.movs != null && monster.movs!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 2),
                                child: Text('Movements: ${monster.movs!}'),
                              ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('tap_to_edit_delete'.tr(), style: const TextStyle(fontSize: 11, color: Colors.grey)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
                // Monstruos base
                ...filteredMonsters.map((monster) => Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(monster['name'][0].toUpperCase()),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                monster['name'],
                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () {
                                final nivel = _sistemaSeleccionado == SistemaJuego.dnd5e 
                                    ? (monster['nivel']?.toInt() ?? 1) // CR como int
                                    : (monster['nivel'] ?? monster['level'] ?? 1);
                                
                                // Convertir valores a int para asegurar compatibilidad
                                final hp = _sistemaSeleccionado == SistemaJuego.dnd5e
                                    ? int.tryParse(monster['hp']?.toString() ?? '0') ?? 0
                                    : (monster['hp'] ?? 0);
                                final ac = _sistemaSeleccionado == SistemaJuego.dnd5e
                                    ? int.tryParse(monster['ac']?.toString() ?? '10') ?? 10
                                    : (monster['ac'] ?? 10);
                                final iniciativa = monster['initiative'] ?? 0;
                                
                                final playerData = <String, dynamic>{
                                  'nombre': monster['name'],
                                  'nivelClase1': nivel,
                                  'hp': hp,
                                  'maxHp': hp,
                                  'ac': ac,
                                  'iniciativa': iniciativa,
                                  'att': monster['att'],
                                  'movs': monster['movs'],
                                };
                                if (widget.onAddMonster != null) {
                                  widget.onAddMonster!(playerData);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('monster_added_as_player'.tr(args: [monster['name']]))),
                                    );
                                  }
                                } else {
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('action_only_available_from_datos'.tr())),
                                    );
                                  }
                                }
                              },
                              child: Text('add_monster'.tr()),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Text('Type: ${monster['type'] ?? '-'}'),
                            if (_sistemaSeleccionado == SistemaJuego.dnd5e)
                              Text('CR: ${monster['nivel']?.toString() ?? '-'}')
                            else
                              Text('Level: ${(monster['nivel'] ?? monster['level'] ?? '-').toString()}'),
                            Text('HP: ${(monster['hp'] ?? '-').toString()}'),
                            Text('AC: ${(monster['ac'] ?? '-').toString()}'),
                            Text('Initiative: ${(monster['initiative'] ?? '-').toString()}'),
                            Text('XP: ${(monster['xp'] ?? '-').toString()}'),
                          ],
                        ),
                        if (monster['att'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Attack: ${monster['att']}'),
                          ),
                        if (monster['movs'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text('Movements: ${monster['movs']}'),
                          ),
                        ...monster.entries.where((e) => !['name','type','nivel','level','hp','ac','initiative','xp','att','movs'].contains(e.key)).map((e) =>
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text('${e.key}: ${e.value}'),
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}