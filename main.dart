import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:xp_and_initiative_tracker/models/jugador.dart';
import 'package:xp_and_initiative_tracker/models/monster.dart'; // Importar el modelo Monster
import 'screens/datos_screen.dart';
import 'screens/combate_screen.dart';
import 'screens/sesion_screen.dart';
import 'screens/acciones_screen.dart';
import 'screens/iniciativa_screen.dart';
import 'screens/detalles_jugadores_screen.dart';
import 'screens/fondos_screen.dart';
import 'screens/monsterdb_screen.dart';
import 'screens/gM_screen.dart'; // Importar la nueva pantalla gM_screen.dart
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(JugadorAdapter()); // tu clase adaptadora generada
  Hive.registerAdapter(MonsterAdapter()); // registrar el adapter de Monster

  await Hive.openBox<Jugador>('jugadores');
  await Hive.openBox<Jugador>('enemigos_plantilla');
  await Hive.openBox<Monster>('custom_monsters'); // abrir la box de monstruos personalizados

  runApp(
    const ProviderScope(
      child: PathfinderTrackerApp(),
    ),
  );
}

class PathfinderTrackerApp extends StatelessWidget {
  const PathfinderTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pathfinder XP Tracker',
      theme: ThemeData(
        fontFamily: 'NotoSerifJP', // fuente japonesa
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      initialRoute: '/',
      routes: {
        '/': (_) => const HomeScreen(),
        '/datos': (_) => const DatosScreen(),
        '/combate': (_) => const CombateScreen(),
        '/sesion': (_) => const SesionScreen(),
        '/iniciativa': (_) => const IniciativaScreen(),
        '/acciones': (_) => const AccionesScreen(),
        '/detalles': (_) => const DetallesJugadoresScreen(),
        '/fondos': (_) => const FondosScreen(),
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  void _abrirMonsterDbScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MonsterDbScreen(onAddMonster: (_) {}),
      ),
    );
  }
  Uint8List? fondoHome;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadFondo();
  }

  Future<void> _loadFondo() async {
    final box = await Hive.openBox('fondos');
    setState(() {
      fondoHome = box.get('fondoHome');
      _loading = false;
    });
  }

  Future<void> _goToFondosScreen(BuildContext context) async {
    await Navigator.pushNamed(context, '/fondos');
    // Al volver de fondos_screen, recargar fondo
    _loadFondo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _loading
              ? Container(color: Colors.black)
              : (fondoHome != null
                  ? Image.memory(
                      fondoHome!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                  : Container(color: Colors.black)),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Botón pequeño de monstruos a la izquierda de todo
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Material(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          splashColor: Colors.redAccent.withOpacity(0.5),
                          highlightColor: Colors.red.withOpacity(0.2),
                          onTap: () => _abrirMonsterDbScreen(context),
                          child: const Icon(Icons.pest_control, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MenuButton(
                          icon: Icons.storage,
                          text: "Datos",
                          onTap: () => Navigator.pushNamed(context, '/datos'),
                        ),
                        const SizedBox(height: 14),
                        MenuButton(
                          icon: Icons.shield,
                          text: "Iniciativa y Combate",
                          onTap: () => Navigator.pushNamed(context, '/iniciativa'),
                        ),
                        const SizedBox(height: 14),
                        MenuButton(
                          icon: Icons.flash_on,
                          text: "Acciones",
                          onTap: () => Navigator.pushNamed(context, '/acciones'),
                        ),
                        const SizedBox(height: 14),
                        MenuButton(
                          icon: Icons.flag,
                          text: "Terminar Sesión",
                          onTap: () => Navigator.pushNamed(context, '/sesion'),
                        ),
                        const SizedBox(height: 14),
                        MenuButton(
                          icon: Icons.people,
                          text: "Detalles de Jugadores",
                          onTap: () => Navigator.pushNamed(context, '/detalles'),
                        ),
                        const SizedBox(height: 14),
                        MenuButton(
                          icon: Icons.screen_share,
                          text: "GM Screen",
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const GMScreen()),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),
                    // Botón de fondo de pantalla pequeño a la derecha
                    SizedBox(
                      width: 48,
                      height: 48,
                      child: Material(
                        color: Colors.red.shade700,
                        borderRadius: BorderRadius.circular(12),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(12),
                          splashColor: Colors.redAccent.withOpacity(0.5),
                          highlightColor: Colors.red.withOpacity(0.2),
                          onTap: () => _goToFondosScreen(context),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Un botón de menú personalizado con efecto "tinta roja"
class MenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuButton({
    super.key,
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250, // ancho controlado
      height: 50,
      child: Material(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          // ignore: deprecated_member_use
          splashColor: Colors.redAccent.withOpacity(0.5), // tinta roja
          // ignore: deprecated_member_use
          highlightColor: Colors.red.withOpacity(0.2),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
