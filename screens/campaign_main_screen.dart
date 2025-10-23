import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:typed_data';

import '../models/jugador.dart';
import '../models/monster.dart';
import '../providers/jugadores_provider.dart';
import '../providers/campaigns_provider.dart';
import 'monsterdb_screen.dart';
import 'gm_screen.dart';
import '../utils/calculoxp.dart' as calc;
import 'datos_screen.dart';
import 'sesion_screen.dart';
import 'acciones_screen.dart';
import 'iniciativa_screen.dart';
import 'detalles_jugadores_screen.dart';
import 'fondos_screen.dart';

class CampaignMainScreen extends ConsumerStatefulWidget {
  final int? campaignSlot;
  const CampaignMainScreen({this.campaignSlot, super.key});

  @override
  ConsumerState<CampaignMainScreen> createState() => _CampaignMainScreenState();
}

class _CampaignMainScreenState extends ConsumerState<CampaignMainScreen> {
  Uint8List? fondoHome;
  bool _loading = true;
  bool _openedBoxesForSlot = false;

  @override
  void initState() {
    super.initState();
    _loadFondo();
  }

  Future<void> _openBoxesForSlot(int slot) async {
    try {
      await Hive.openBox<Jugador>('jugadores_slot_$slot');
      await Hive.openBox<Jugador>('enemigos_plantilla_slot_$slot');
      await Hive.openBox<Monster>('custom_monsters_slot_$slot');
      await Hive.openBox('fondos_slot_$slot');
    } catch (_) {
      // ignore errors opening per-slot boxes
    }
  }

  Future<void> _loadFondo() async {
    if (widget.campaignSlot != null && !_openedBoxesForSlot) {
      await _openBoxesForSlot(widget.campaignSlot!);
      _openedBoxesForSlot = true;
    }

    Box? box;
    if (widget.campaignSlot != null && Hive.isBoxOpen('fondos_slot_${widget.campaignSlot}')) {
      box = Hive.box('fondos_slot_${widget.campaignSlot}');
    } else {
      try {
        box = await Hive.openBox('fondos');
      } catch (_) {
        box = null;
      }
    }

    if (!mounted) return;
    setState(() {
      fondoHome = box?.get('fondoHome');
      _loading = false;
    });
  }

  void _abrirMonsterDbScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Consumer(
          builder: (context, ref, child) {
            // Determine initial system for MonsterDb (pathfinder vs dnd) and hide selector when opened from a campaign
            SistemaJuego? initialMb;
            if (widget.campaignSlot != null) {
              final camp = ref.read(campaignsProvider)[widget.campaignSlot!];
              if (camp != null) {
                switch (camp.system) {
                  case 'pf1':
                  case 'pf2':
                    initialMb = SistemaJuego.pathfinder;
                    break;
                  case 'dnd5':
                    initialMb = SistemaJuego.dnd5e;
                    break;
                  default:
                    initialMb = null;
                }
              }
            }

            return MonsterDbScreen(
              initialSistema: initialMb,
              hideSistemaSelector: widget.campaignSlot != null,
              onAddMonster: (monsterData) {
                final nuevo = Jugador(
                  nombre: monsterData['nombre'],
                  hp: monsterData['hp'] ?? 0,
                  maxHp: monsterData['hp'] ?? 0,
                  ac: monsterData['ac'] ?? 10,
                  nivel: monsterData['nivelClase1'] ?? 1,
                  xp: 0,
                  esEnemigo: true,
                  accionesClase: 0,
                  accionesHeroicas: 0,
                  danoHecho: 0,
                  iniciativa: monsterData['iniciativa'] ?? 0,
                  att: monsterData['att'],
                  movs: monsterData['movs'],
                );
                // Prefer slot-specific jugadores box if open, otherwise use global provider
                final hasSlotBox = widget.campaignSlot != null && Hive.isBoxOpen('jugadores_slot_${widget.campaignSlot}');
                final jugadoresNotifier = hasSlotBox
                  ? ref.read(jugadoresProviderForSlot(widget.campaignSlot!).notifier)
                  : ref.read(jugadoresProvider.notifier);
                jugadoresNotifier.agregarJugador(nuevo);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${monsterData['nombre']} ${hasSlotBox ? "monster_added_to_slot".tr() : "monster_added_as_enemy".tr()}')),
                );
              },
              campaignSlot: widget.campaignSlot,
            );
          },
        ),
      ),
    );
  }

  Future<void> _goToFondosScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FondosScreen(campaignSlot: widget.campaignSlot)),
    );
    _loadFondo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Consumer(builder: (context, ref, _) {
          final slot = widget.campaignSlot;
          if (slot == null) return Text('campaign'.tr());
          final campaigns = ref.watch(campaignsProvider);
          final camp = (slot < campaigns.length) ? campaigns[slot] : null;
          return Text(camp != null ? camp.name : 'slot_label'.tr(args: ['${slot + 1}']));
        }),
      ),
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
          SafeArea(
            child: SingleChildScrollView(
              // Include bottom safe area padding to avoid BottomOverflow when rotating or on devices with gesture bars
              padding: EdgeInsets.only(top: 24, bottom: MediaQuery.of(context).viewPadding.bottom + 24),
              child: Center(
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
                              text: "data".tr(),
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => DatosScreen(campaignSlot: widget.campaignSlot)),
                              ),
                            ),
                            const SizedBox(height: 14),
                            MenuButton(
                              icon: Icons.shield,
                              text: "initiative_and_combat".tr(),
                              onTap: () {
                                // If opened from a campaign, pass the campaignSlot and initial system
                                calc.SistemaJuego? initialSistema;
                                if (widget.campaignSlot != null) {
                                  final camp = ref.read(campaignsProvider)[widget.campaignSlot!];
                                  if (camp != null) {
                                    switch (camp.system) {
                                      case 'pf1':
                                        initialSistema = calc.SistemaJuego.pathfinder1e;
                                        break;
                                      case 'pf2':
                                        initialSistema = calc.SistemaJuego.pathfinder2e;
                                        break;
                                      case 'dnd5':
                                        initialSistema = calc.SistemaJuego.dnd5e;
                                        break;
                                      default:
                                        initialSistema = null;
                                    }
                                  }
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => IniciativaScreen(
                                      campaignSlot: widget.campaignSlot,
                                      initialSistema: initialSistema,
                                      hideSistemaSelector: widget.campaignSlot != null,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            MenuButton(
                              icon: Icons.flash_on,
                              text: "actions".tr(),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AccionesScreen(campaignSlot: widget.campaignSlot))),
                            ),
                            const SizedBox(height: 14),
                            MenuButton(
                              icon: Icons.flag,
                              text: "end_session".tr(),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SesionScreen(campaignSlot: widget.campaignSlot))),
                            ),
                            const SizedBox(height: 14),
                            MenuButton(
                              icon: Icons.people,
                              text: "player_details".tr(),
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetallesJugadoresScreen(campaignSlot: widget.campaignSlot))),
                            ),
                            const SizedBox(height: 14),
                            DisabledMenuButton(
                              icon: Icons.description,
                              text: "character_sheets".tr(),
                              message: "under_development".tr(),
                            ),
                            const SizedBox(height: 14),
                            MenuButton(
                              icon: Icons.screen_share,
                              text: "gm_screen".tr(),
                              onTap: () {
                                // Determine initial system from campaign if present
                                SistemaGM? initialGM;
                                if (widget.campaignSlot != null) {
                                  final camp = ref.read(campaignsProvider)[widget.campaignSlot!];
                                  if (camp != null) {
                                    switch (camp.system) {
                                      case 'pf1':
                                        initialGM = SistemaGM.pathfinder1e;
                                        break;
                                      case 'pf2':
                                        initialGM = SistemaGM.pathfinder2e;
                                        break;
                                      case 'dnd5':
                                        initialGM = SistemaGM.dnd5e;
                                        break;
                                      default:
                                        initialGM = null;
                                    }
                                  }
                                }

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GMScreen(
                                      campaignSlot: widget.campaignSlot,
                                      hideSistemaSelector: widget.campaignSlot != null,
                                      initialSistema: initialGM,
                                    ),
                                  ),
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
            ),
          ),
        ],
      ),
    );
  }
}

/// Un botón de menú desactivado que muestra un mensaje al presionarlo
class DisabledMenuButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final String message;

  const DisabledMenuButton({
    super.key,
    required this.icon,
    required this.text,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 50,
      child: Material(
        color: Colors.grey.shade600,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.grey.withOpacity(0.3),
          highlightColor: Colors.grey.withOpacity(0.1),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.grey.shade700,
                duration: const Duration(seconds: 3),
              ),
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white70),
              const SizedBox(width: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white70,
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
      width: 250,
      height: 50,
      child: Material(
        color: Colors.red.shade700,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.redAccent.withOpacity(0.5),
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