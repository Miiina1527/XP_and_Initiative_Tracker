import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:xp_and_initiative_tracker/models/jugador.dart';
import 'screens/datos_screen.dart';
import 'screens/combate_screen.dart';
import 'screens/sesion_screen.dart';
import 'screens/acciones_screen.dart';
import 'screens/iniciativa_screen.dart';
import 'screens/detalles_jugadores_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  Hive.registerAdapter(JugadorAdapter()); // tu clase adaptadora generada

  await Hive.openBox<Jugador>('jugadores');

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
      },
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Fondo negro + imagen tenue
          Container(color: Colors.black),
          Opacity(
            opacity: 0.2,
            child: SizedBox(
              width: MediaQuery.of(context).size.width, // Ancho del dispositivo
              height: MediaQuery.of(context).size.height, // Alto del dispositivo
              child: Image.asset(
                "images/fondo.jpeg",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Contenido
          Center(
            child: Column(
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
          splashColor: Colors.redAccent.withOpacity(0.5), // tinta roja
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
