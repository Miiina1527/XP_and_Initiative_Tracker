import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:hive_flutter/adapters.dart';
import '../providers/jugadores_provider.dart';
import '../providers/campaigns_provider.dart';
import '../models/jugador.dart';
import 'monsterdb_screen.dart';

class DatosScreen extends ConsumerStatefulWidget {
  final int? campaignSlot;
  const DatosScreen({super.key, this.campaignSlot});

  @override
  ConsumerState<DatosScreen> createState() => _DatosScreenState();
}

class _DatosScreenState extends ConsumerState<DatosScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nombreCtrl = TextEditingController();
  final _hpCtrl = TextEditingController(text: '0');
  final _maxHpCtrl = TextEditingController(text: '10'); // Nuevo controlador para maxHp
  final _acCtrl = TextEditingController(text: '10');
  final _xpCtrl = TextEditingController(text: '0');
  final _nivel = TextEditingController(text: '1');
  bool _esEnemigo = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _hpCtrl.dispose();
    _acCtrl.dispose();
    _xpCtrl.dispose();
    _nivel.dispose();
    _maxHpCtrl.dispose(); // Liberar el controlador
    super.dispose();
  }

  int _toInt(String s, int fallback) => int.tryParse(s.trim()) ?? fallback;

  void _limpiarFormulario() {
    _nombreCtrl.clear();
    _hpCtrl.text = '0';
    _maxHpCtrl.text = '10';
    _acCtrl.text = '10';
    _xpCtrl.text = '0';
    _nivel.text = '1';
    setState(() => _esEnemigo = false);
  }

  void _agregarJugador() {
    if (_formKey.currentState!.validate()) {
      final nuevo = Jugador(
        nombre: _nombreCtrl.text.trim(),
        hp: _toInt(_hpCtrl.text, 0),
        maxHp: _toInt(_maxHpCtrl.text, 10), // Asignar maxHp
        ac: _toInt(_acCtrl.text, 10),
        nivel: _toInt(_nivel.text, 1), // Usar el campo nivel simplificado
        xp: _toInt(_xpCtrl.text, 0),
        esEnemigo: _esEnemigo,
        accionesClase: 0,
        accionesHeroicas: 0,
        danoHecho: 0,
      );
      // If a campaignSlot is provided and the per-slot jugadores box is open, save there.
      final hasSlotBox = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
      final jugadoresNotifier = hasSlotBox
        ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
        : ref.read(jugadoresProvider.notifier);
      jugadoresNotifier.agregarJugador(nuevo);
      _limpiarFormulario();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("player_added".tr())),
      );
    }
  }

  void _editarJugadorDialog(int index, Jugador j) {
    final nombre = TextEditingController(text: j.nombre);
    final hp = TextEditingController(text: j.hp.toString());
    final maxHp = TextEditingController(text: j.maxHp.toString()); // Nuevo campo
    final ac = TextEditingController(text: j.ac.toString());
    final nivel = TextEditingController(text: j.nivel.toString()); // Usar el campo nivel
    final xp = TextEditingController(text: j.xp.toString());
    bool esEnemigo = j.esEnemigo;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('${"edit_player".tr()} ${j.nombre}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombre,
                    decoration: InputDecoration(labelText: "name".tr()),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: hp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "hp".tr()),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: maxHp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "max_hp".tr()),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ac,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "ac".tr()),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nivel,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "level".tr()),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: xp,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "total_xp".tr()),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: esEnemigo,
                    onChanged: (v) => setState(() => esEnemigo = v),
                    title: Text("is_enemy".tr()),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            actions: [
                  TextButton(
                onPressed: () {
                  final hasSlotBox = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
                  final jugadoresNotifier = hasSlotBox
                    ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
                    : ref.read(jugadoresProvider.notifier);
                  jugadoresNotifier.eliminarJugador(index);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: Text("delete".tr()),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel".tr()),
              ),
              ElevatedButton(
                  onPressed: () {
                  final actualizado = j.copyWith(
                    nombre: nombre.text.trim().isEmpty ? j.nombre : nombre.text.trim(),
                    hp: _toInt(hp.text, j.hp),
                    maxHp: _toInt(maxHp.text, j.maxHp), // Actualizar maxHp
                    ac: _toInt(ac.text, j.ac),
                    nivel: _toInt(nivel.text, j.nivel), // Usar el campo nivel
                    xp: _toInt(xp.text, j.xp),
                    esEnemigo: esEnemigo,
                  );
                  final hasSlotBox = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
                  final jugadoresNotifier = hasSlotBox
                    ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
                    : ref.read(jugadoresProvider.notifier);
                  jugadoresNotifier.actualizarJugador(index, actualizado);
                  Navigator.pop(context);
                },
                child: Text("save".tr()),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  final jugadores = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}')
    ? ref.watch(jugadoresProviderForSlot(widget.campaignSlot!))
    : ref.watch(jugadoresProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0), // Fondo pergamino claro
      appBar: AppBar(
        title: Text("player_data".tr()),
        backgroundColor: const Color(0xFFB68D40), // Marrón dorado
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // --- Formulario para añadir jugador ---
          Card(
            color: const Color(0xFFF5E6CA),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Text(
                      "add_player_enemy".tr(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSerifJP',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Campo Nombre
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: InputDecoration(
                        labelText: "name".tr(),
                        prefixIcon: const Icon(Icons.person, color: Colors.brown),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? "put_a_name".tr() : null,
                    ),
                    const SizedBox(height: 8),

                    // HP, HP Máximo y AC
                    Row(
                      children: [
                      Expanded(
                        child: TextFormField(
                        controller: _hpCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "hp".tr(),
                          prefixIcon: const Icon(Icons.favorite, color: Colors.red),
                        ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                        controller: _maxHpCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "max_hp".tr(),
                          prefixIcon: const Icon(Icons.favorite_border, color: Colors.redAccent),
                        ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                        controller: _acCtrl,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: "ac".tr(),
                          prefixIcon: const Icon(Icons.shield, color: Colors.blue),
                        ),
                        ),
                      ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Nivel (en una sola fila)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _nivel,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "level".tr(),
                              prefixIcon: const Icon(Icons.star, color: Colors.amber),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // XP y Switch ¿Es enemigo? (en una sola fila)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _xpCtrl,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: "total_xp".tr(),
                              prefixIcon: const Icon(Icons.flash_on, color: Colors.orange),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SwitchListTile(
                            value: _esEnemigo,
                            onChanged: (v) => setState(() => _esEnemigo = v),
                            title: Text("is_enemy".tr()),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFB68D40),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            icon: const Icon(Icons.person_add),
                            onPressed: _agregarJugador,
                            label: Text("add".tr()),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _limpiarFormulario,
                          child: Text("clear".tr()),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // --- Lista de jugadores ---
          if (jugadores.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  "no_characters_yet".tr(),
                  style: const TextStyle(fontFamily: 'NotoSerifJP'),
                ),
              ),
            )
          else
            ...List.generate(jugadores.length, (index) {
              final j = jugadores[index];
              return Card(
                color: const Color(0xFFF5E6CA),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: j.esEnemigo ? Colors.red[300] : Colors.green[300],
                    child: Text(
                      j.nombre.isNotEmpty ? j.nombre[0].toUpperCase() : '?',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text(j.nombre, style: const TextStyle(fontFamily: 'NotoSerifJP')),
                  subtitle: Text(
                    'HP: ${j.hp} | AC: ${j.ac} | Nivel: ${j.nivel} | XP: ${j.xp}',
                    style: const TextStyle(fontSize: 13),
                  ),
                  trailing: j.esEnemigo
                      ? const Icon(Icons.close, color: Colors.red)
                      : const Icon(Icons.check, color: Colors.green),
                  onTap: () => _editarJugadorDialog(index, j),
                ),
              );
            }),
          const SizedBox(height: 80),
          // Botón para abrir MonsterDbScreen como popup
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24, right: 24),
              child: FloatingActionButton(
                // ignore: deprecated_member_use
                backgroundColor: Colors.red.shade700.withOpacity(0.85),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    // ignore: deprecated_member_use
                    barrierColor: Colors.black.withOpacity(0.3),
                    builder: (context) => Dialog(
                      // ignore: deprecated_member_use
                      backgroundColor: Colors.white.withOpacity(0.95),
                      insetPadding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: 400,
                        height: 600,
                        child: MonsterDbScreen(
                          initialSistema: () {
                            if (widget.campaignSlot == null) return null;
                            final camp = ref.read(campaignsProvider)[widget.campaignSlot!];
                            if (camp == null) return null;
                            return camp.system == 'dnd5' ? SistemaJuego.dnd5e : SistemaJuego.pathfinder;
                          }(),
                          hideSistemaSelector: widget.campaignSlot != null,
                          onAddMonster: (monsterData) {
                            final nuevo = Jugador(
                              nombre: monsterData['nombre'],
                              hp: monsterData['hp'] ?? 0,
                              maxHp: monsterData['hp'] ?? 0,
                              ac: monsterData['ac'] ?? 10,
                              nivel: monsterData['nivelClase1'] ?? 1, // Usar nivel desde el dato del monstruo
                              xp: 0,
                              esEnemigo: true,
                              accionesClase: 0,
                              accionesHeroicas: 0,
                              danoHecho: 0,
                              iniciativa: monsterData['iniciativa'] ?? 0,
                              att: monsterData['att'],
                              movs: monsterData['movs'],
                            );
                            final hasSlotBox2 = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
                            final jugadoresNotifier = hasSlotBox2
                              ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
                              : ref.read(jugadoresProvider.notifier);
                            jugadoresNotifier.agregarJugador(nuevo);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${monsterData['nombre']} ${hasSlotBox2 ? "monster_added_to_slot".tr() : "monster_added_as_enemy".tr()}')),
                            );
                          },
                            campaignSlot: widget.campaignSlot,
                        ),
                      ),
                    ),
                  );
                },
                tooltip: "add_enemy_from_monster_db".tr(),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
