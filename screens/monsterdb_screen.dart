import 'package:flutter/material.dart';
import '../utils/monster_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/monster.dart';


class MonsterDbScreen extends StatefulWidget {
  final void Function(Map<String, dynamic>)? onAddMonster; // Callback opcional

  const MonsterDbScreen({Key? key, this.onAddMonster}) : super(key: key);

  @override
  State<MonsterDbScreen> createState() => _MonsterDbScreenState();
}

class _MonsterDbScreenState extends State<MonsterDbScreen> {
  void _editarCustomMonsterDialog(Monster monster) {
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
        return AlertDialog(
          title: Text('Editar ${monster.name}'),
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
              onPressed: () async {
                await monster.delete();
                setState(() {
                  _customMonsters = _customMonstersBox.values.toList();
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${monster.name} eliminado.')),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('El nombre no puede estar vacío.')),
                  );
                  return;
                }
                monster.name = nameCtrl.text.trim();
                monster.hp = int.tryParse(hpCtrl.text) ?? monster.hp;
                monster.ac = int.tryParse(acCtrl.text) ?? monster.ac;
                monster.nivel = int.tryParse(nivelCtrl.text) ?? monster.nivel;
                monster.xp = int.tryParse(xpCtrl.text) ?? monster.xp;
                monster.initiative = int.tryParse(initiativeCtrl.text) ?? monster.initiative;
                monster.att = attCtrl.text.trim().isEmpty ? null : attCtrl.text.trim();
                monster.movs = movsCtrl.text.trim().isEmpty ? null : movsCtrl.text.trim();
                monster.type = typeCtrl.text.trim();
                await monster.save();
                if (mounted) {
                  setState(() {
                    _customMonsters = _customMonstersBox.values.toList();
                  });
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${monster.name} actualizado.')),
                  );
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
  late Box<Monster> _customMonstersBox;
  List<Monster> _customMonsters = [];
  bool _hiveReady = false;
  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _customMonstersBox = await Hive.openBox<Monster>('custom_monsters');
    setState(() {
      _customMonsters = _customMonstersBox.values.toList();
      _hiveReady = true;
    });
  }
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
  final _nivelClase2Ctrl = TextEditingController();
  final _nivelClase3Ctrl = TextEditingController();

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
    _nivelClase2Ctrl.dispose();
    _nivelClase3Ctrl.dispose();
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
    _nivelClase2Ctrl.clear();
    _nivelClase3Ctrl.clear();
  }

  void _agregarEnemigoPersonalizado() {
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
      _customMonstersBox.add(monster);
      setState(() {
        _customMonsters = _customMonstersBox.values.toList();
      });
      _customMonstersBox.flush();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Monstruo personalizado añadido')), 
      );
      _limpiarFormulario();
    }
  }
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // --- Formulario para añadir monstruo personalizado ---
    final addCustomMonsterCard = Card(
      color: const Color(0xFFF5E6CA),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: ExpansionTile(
        title: const Text(
          'Añadir monstruo personalizado',
          style: TextStyle(
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
                    decoration: const InputDecoration(
                      labelText: 'Nombre',
                      prefixIcon: Icon(Icons.person, color: Colors.brown),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty) ? 'Pon un nombre' : null,
                  ),
                  const SizedBox(height: 8),
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
                          controller: _acCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'AC',
                            prefixIcon: Icon(Icons.shield, color: Colors.blue),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _nivelCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Nivel',
                            prefixIcon: Icon(Icons.star, color: Colors.amber),
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
                          decoration: const InputDecoration(
                            labelText: 'XP',
                            prefixIcon: Icon(Icons.flash_on, color: Colors.orange),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _initiativeCtrl,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Iniciativa',
                            prefixIcon: Icon(Icons.bolt, color: Colors.deepPurple),
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
                          decoration: const InputDecoration(
                            labelText: 'Tipo',
                            prefixIcon: Icon(Icons.category, color: Colors.green),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _attCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Ataque',
                            prefixIcon: Icon(Icons.gavel, color: Colors.grey),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextFormField(
                          controller: _movsCtrl,
                          decoration: const InputDecoration(
                            labelText: 'Movs',
                            prefixIcon: Icon(Icons.directions_run, color: Colors.teal),
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
                          label: const Text('Añadir'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton(
                        onPressed: _limpiarFormulario,
                        child: const Text('Limpiar'),
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
    // Filtrar monstruos base
    final filteredMonsters = monsterDatabase.where((monster) {
      final query = _searchQuery.toLowerCase();
      return monster['name'].toLowerCase().contains(query) ||
          monster['type'].toLowerCase().contains(query) ||
          (monster['nivel']?.toString() ?? monster['level']?.toString() ?? '').contains(query);
    }).toList();

    // Filtrar monstruos personalizados
    final filteredCustomMonsters = _customMonsters.where((monster) {
      final query = _searchQuery.toLowerCase();
      return monster.name.toLowerCase().contains(query) ||
          monster.type.toLowerCase().contains(query) ||
          monster.nivel.toString().contains(query);
    }).toList();

    if (!_hiveReady) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Base de Datos de Monstruos'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Buscar por nombre, tipo o nivel',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          addCustomMonsterCard,
          Expanded(
            child: ListView(
              children: [
                // Monstruos personalizados primero
                ...filteredCustomMonsters.map((monster) => GestureDetector(
                  onTap: () => _editarCustomMonsterDialog(monster),
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
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text('${monster.name} añadido como jugador.')),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Esta acción solo está disponible desde la pantalla de Datos.')),
                                    );
                                  }
                                },
                                child: const Text('Añadir Monstruo'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 12,
                            runSpacing: 4,
                            children: [
                              Text('Tipo: ${monster.type}'),
                              Text('Nivel: ${monster.nivel}'),
                              Text('HP: ${monster.hp}'),
                              Text('AC: ${monster.ac}'),
                              Text('Iniciativa: ${monster.initiative}'),
                              Text('XP: ${monster.xp}'),
                            ],
                          ),
                          if (monster.att != null && monster.att!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text('Ataque: ${monster.att}'),
                            ),
                          if (monster.movs != null && monster.movs!.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text('Movs: ${monster.movs}'),
                            ),
                          const Padding(
                            padding: EdgeInsets.only(top: 4),
                            child: Text('Toca la card para editar/eliminar', style: TextStyle(fontSize: 11, color: Colors.grey)),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
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
                                final playerData = <String, dynamic>{
                                  'nombre': monster['name'],
                                  'nivelClase1': monster['nivel'] ?? monster['level'],
                                  'hp': monster['hp'],
                                  'maxHp': monster['hp'],
                                  'ac': monster['ac'],
                                  'iniciativa': monster['initiative'],
                                  'att': monster['att'],
                                  'movs': monster['movs'],
                                };
                                if (widget.onAddMonster != null) {
                                  widget.onAddMonster!(playerData);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${monster['name']} añadido como jugador.')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Esta acción solo está disponible desde la pantalla de Datos.')),
                                  );
                                }
                              },
                              child: const Text('Añadir Monstruo'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 4,
                          children: [
                            Text('Tipo: ${monster['type'] ?? '-'}'),
                            Text('Nivel: ${monster['nivel'] ?? monster['level'] ?? '-'}'),
                            Text('HP: ${monster['hp'] ?? '-'}'),
                            Text('AC: ${monster['ac'] ?? '-'}'),
                            Text('Iniciativa: ${monster['initiative'] ?? '-'}'),
                            Text('XP: ${monster['xp'] ?? '-'}'),
                          ],
                        ),
                        if (monster['att'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text('Ataque: ${monster['att']}'),
                          ),
                        if (monster['movs'] != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text('Movs: ${monster['movs']}'),
                          ),
                        // Mostrar cualquier otro campo adicional
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