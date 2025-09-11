import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/jugadores_provider.dart';
import '../models/jugador.dart';
import 'monsterdb_screen.dart';

class DatosScreen extends ConsumerStatefulWidget {
  const DatosScreen({super.key});

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
  final _nivelClase1Ctrl = TextEditingController(text: '1');
  final _nivelClase2Ctrl = TextEditingController(text: '0');
  final _nivelClase3Ctrl = TextEditingController(text: '0');
  bool _esEnemigo = false;

  @override
  void dispose() {
    _nombreCtrl.dispose();
    _hpCtrl.dispose();
    _acCtrl.dispose();
    _xpCtrl.dispose();
    _nivelClase1Ctrl.dispose();
    _nivelClase2Ctrl.dispose();
    _nivelClase3Ctrl.dispose();
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
    _nivelClase1Ctrl.text = '1';
    _nivelClase2Ctrl.text = '0';
    _nivelClase3Ctrl.text = '0';
    setState(() => _esEnemigo = false);
  }

  void _agregarJugador() {
    if (_formKey.currentState!.validate()) {
      final nuevo = Jugador(
        nombre: _nombreCtrl.text.trim(),
        hp: _toInt(_hpCtrl.text, 0),
        maxHp: _toInt(_maxHpCtrl.text, 10), // Asignar maxHp
        ac: _toInt(_acCtrl.text, 10),
        nivelClase1: _toInt(_nivelClase1Ctrl.text, 1),
        nivelClase2: _toInt(_nivelClase2Ctrl.text, 0),
        nivelClase3: _toInt(_nivelClase3Ctrl.text, 0),
        xp: _toInt(_xpCtrl.text, 0),
        esEnemigo: _esEnemigo,
        accionesClase: 0,
        accionesHeroicas: 0,
        danoHecho: 0,
      );
      ref.read(jugadoresProvider.notifier).agregarJugador(nuevo);
      _limpiarFormulario();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Jugador añadido')),
      );
    }
  }

  void _editarJugadorDialog(int index, Jugador j) {
    final nombre = TextEditingController(text: j.nombre);
    final hp = TextEditingController(text: j.hp.toString());
    final maxHp = TextEditingController(text: j.maxHp.toString()); // Nuevo campo
    final ac = TextEditingController(text: j.ac.toString());
    final nivelClase1 = TextEditingController(text: j.nivelClase1.toString());
    final nivelClase2 = TextEditingController(text: j.nivelClase2.toString());
    final nivelClase3 = TextEditingController(text: j.nivelClase3.toString());
    final xp = TextEditingController(text: j.xp.toString());
    bool esEnemigo = j.esEnemigo;

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text('Editar ${j.nombre}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: nombre,
                    decoration: const InputDecoration(labelText: 'Nombre'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: hp,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'HP'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: maxHp,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'HP Máximo'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: ac,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'AC'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nivelClase1,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nivel'),
                  ),
                  TextField(
                    controller: nivelClase2,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nivel'),
                  ),
                  TextField(
                    controller: nivelClase3,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Nivel'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: xp,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'XP total'),
                  ),
                  const SizedBox(height: 8),
                  SwitchListTile(
                    value: esEnemigo,
                    onChanged: (v) => setState(() => esEnemigo = v),
                    title: const Text('¿Es enemigo?'),
                    contentPadding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  ref.read(jugadoresProvider.notifier).eliminarJugador(index);
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Eliminar'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: () {
                  final actualizado = j.copyWith(
                    nombre: nombre.text.trim().isEmpty ? j.nombre : nombre.text.trim(),
                    hp: _toInt(hp.text, j.hp),
                    maxHp: _toInt(maxHp.text, j.maxHp), // Actualizar maxHp
                    ac: _toInt(ac.text, j.ac),
                    nivelClase1: _toInt(nivelClase1.text, j.nivelClase1),
                    nivelClase2: _toInt(nivelClase2.text, j.nivelClase2),
                    nivelClase3: _toInt(nivelClase3.text, j.nivelClase3),
                    xp: _toInt(xp.text, j.xp),
                    esEnemigo: esEnemigo,
                  );
                  ref.read(jugadoresProvider.notifier).actualizarJugador(index, actualizado);
                  Navigator.pop(context);
                },
                child: const Text('Guardar'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final jugadores = ref.watch(jugadoresProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0), // Fondo pergamino claro
      appBar: AppBar(
        title: const Text('Datos de Jugadores'),
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
                    const Text(
                      'Añadir jugador / enemigo',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'NotoSerifJP',
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Campo Nombre
                    TextFormField(
                      controller: _nombreCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        prefixIcon: Icon(Icons.person, color: Colors.brown),
                      ),
                      validator: (v) => (v == null || v.trim().isEmpty) ? 'Pon un nombre' : null,
                    ),
                    const SizedBox(height: 8),

                    // HP, HP Máximo y AC
                    Row(
                      children: [
                      Expanded(
                        child: TextFormField(
                        controller: _hpCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'HP',
                          prefixIcon: Icon(Icons.favorite, color: Colors.red),
                        ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                        controller: _maxHpCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'HP Máximo',
                          prefixIcon: Icon(Icons.favorite_border, color: Colors.redAccent),
                        ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                        controller: _acCtrl,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'AC',
                          prefixIcon: Icon(Icons.shield, color: Colors.blue),
                        ),
                        ),
                      ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Nivel por clase (en una sola fila)
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _nivelClase1Ctrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nivel Clase 1',
                              prefixIcon: Icon(Icons.star, color: Colors.amber),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _nivelClase2Ctrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nivel Clase 2',
                              prefixIcon: Icon(Icons.star, color: Colors.pink),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextFormField(
                            controller: _nivelClase3Ctrl,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Nivel Clase 3',
                              prefixIcon: Icon(Icons.star, color: Colors.cyan),
                            ),
                          ),
                        ),
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
                            decoration: const InputDecoration(
                              labelText: 'XP total',
                              prefixIcon: Icon(Icons.flash_on, color: Colors.orange),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SwitchListTile(
                            value: _esEnemigo,
                            onChanged: (v) => setState(() => _esEnemigo = v),
                            title: const Text('¿Es enemigo?'),
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
                            label: const Text('Añadir'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        OutlinedButton(
                          onPressed: _limpiarFormulario,
                          child: const Text('Limpiar'),
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
            const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text(
                  'Aún no hay personajes. Agrega el primero arriba.',
                  style: TextStyle(fontFamily: 'NotoSerifJP'),
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
                backgroundColor: Colors.red.shade700.withOpacity(0.85),
                child: const Icon(Icons.auto_awesome, color: Colors.white),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.3),
                    builder: (context) => Dialog(
                      backgroundColor: Colors.white.withOpacity(0.95),
                      insetPadding: const EdgeInsets.all(16),
                      child: SizedBox(
                        width: 400,
                        height: 600,
                        child: MonsterDbScreen(
                          onAddMonster: (monsterData) {
                            final nuevo = Jugador(
                              nombre: monsterData['nombre'],
                              hp: monsterData['hp'] ?? 0,
                              maxHp: monsterData['hp'] ?? 0,
                              ac: monsterData['ac'] ?? 10,
                              nivelClase1: monsterData['nivelClase1'] ?? 1,
                              nivelClase2: monsterData['nivelClase2'] ?? 0,
                              nivelClase3: monsterData['nivelClase3'] ?? 0,
                              xp: 0,
                              esEnemigo: true,
                              accionesClase: 0,
                              accionesHeroicas: 0,
                              danoHecho: 0,
                              iniciativa: monsterData['iniciativa'] ?? 0,
                              att: monsterData['att'],
                              movs: monsterData['movs'],
                            );
                            ref.read(jugadoresProvider.notifier).agregarJugador(nuevo);
                            Navigator.of(context).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('${monsterData['nombre']} añadido como enemigo.')),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                tooltip: 'Añadir enemigo desde base de monstruos',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
