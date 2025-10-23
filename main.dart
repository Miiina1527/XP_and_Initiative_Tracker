import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:easy_localization/easy_localization.dart';

import 'models/jugador.dart';
import 'models/monster.dart';
import 'models/campaign.dart';
import 'providers/campaigns_provider.dart';
import 'screens/campaign_main_screen.dart';
import 'screens/extras_screen.dart';
import 'providers/settings_provider.dart';
import 'screens/todo_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Hive.initFlutter();

  Hive.registerAdapter(JugadorAdapter());
  Hive.registerAdapter(MonsterAdapter());
  Hive.registerAdapter(CampaignAdapter());

  try {
    Hive.registerAdapter(CampaignAdapter());
  } catch (_) {}

  await Hive.openBox<Jugador>('jugadores');
  await Hive.openBox<Jugador>('enemigos_plantilla');
  await Hive.openBox<Monster>('custom_monsters');
  // ensure settings box exists for extras flag
  await Hive.openBox('settings');

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('ja'),
        Locale('it'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const ProviderScope(child: PathfinderTrackerApp()),
    ),
  );
}

class PathfinderTrackerApp extends StatelessWidget {
  const PathfinderTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'app_title'.tr(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(
        fontFamily: 'NotoSerifJP',
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF3E0),
      appBar: AppBar(
        title: Text('app_title'.tr()),
        actions: [
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TodoScreen())),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(52),
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              // icon intentionally removed to reduce vertical clutter on small devices
              icon: const SizedBox.shrink(),
              label: Text('View campaigns'.tr()),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const CampaignSelectorScreen()));
              },
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                backgroundColor: Colors.amber.shade700,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.extension),
              label: Text('Extras'),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ExtrasScreen()));
              },
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(44),
                backgroundColor: Colors.grey.shade800,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.description),
              label: Text('Create character sheets'.tr()),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('under_development'.tr())));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CampaignSelectorScreen extends ConsumerWidget {
  const CampaignSelectorScreen({super.key});

  Future<void> _showCreateOrEditDialog(BuildContext context, WidgetRef ref, int slot, {Campaign? existing}) async {
    final nameController = TextEditingController(text: existing?.name ?? '');
    String system = existing?.system ?? 'pf1';

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Create campaign'.tr() : 'Edit campaign'.tr()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'.tr()),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: system,
              items: [
                DropdownMenuItem(value: 'pf1', child: Text('system_pathfinder_1e'.tr())),
                DropdownMenuItem(value: 'pf2', child: Text('system_pathfinder_2e'.tr())),
                DropdownMenuItem(value: 'dnd5', child: Text('system_dnd_5e_2014'.tr())),
                if (ref.read(settingsProvider).extrasUnlocked)
                  DropdownMenuItem(value: 'pf_jp_miiina', child: const Text('Pathfinder 日本 Miiina')),
              ],
              onChanged: (v) {
                if (v != null) system = v;
              },
              decoration: InputDecoration(labelText: 'System'.tr()),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: Text('Cancel'.tr())),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return; // simple validation

              if (existing == null) {
                final ok = await ref.read(campaignsProvider.notifier).createCampaign(slot, name, system);
                if (!ok) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not create campaign'.tr())));
                  return;
                }
              } else {
                final updated = Campaign(slot: slot, name: name, system: system, createdAt: existing.createdAt);
                await ref.read(campaignsProvider.notifier).updateCampaign(slot, updated);
              }

              if (!context.mounted) return;
              Navigator.of(context).pop();
            },
            child: Text(existing == null ? 'Create'.tr() : 'Save'.tr()),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final campaigns = ref.watch(campaignsProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Select Campaign'.tr())),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;
              final availableHeight = constraints.maxHeight;
              final cardHeight = math.max(150.0, (availableHeight - 48) / 4);

              if (isPortrait) {
                return ListView.builder(
                  itemCount: 4,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 88, top: 8),
                  itemBuilder: (context, index) {
                    final camp = (index < campaigns.length) ? campaigns[index] : null;
                    return SizedBox(
                      height: cardHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              child: ConstrainedBox(
                                constraints: BoxConstraints(minHeight: cardHeight - 8),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 6),
                                    if (camp == null) ...[
                                      Text('slot_label'.tr(args: ['${index + 1}'])),
                                      const SizedBox(height: 6),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 14), minimumSize: Size(0, 36)),
                                        onPressed: () => _showCreateOrEditDialog(context, ref, index),
                                        child: Text('Create campaign'.tr(), style: const TextStyle(fontSize: 14)),
                                      ),
                                    ] else ...[
                                      Text(camp.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                      const SizedBox(height: 4),
                                      Text(camp.system, style: const TextStyle(color: Colors.grey)),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 6,
                                        alignment: WrapAlignment.center,
                                        children: [
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), minimumSize: Size(0, 36)),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => CampaignMainScreen(campaignSlot: index)),
                                              );
                                            },
                                            child: Text('Open'.tr(), style: const TextStyle(fontSize: 14)),
                                          ),
                                          OutlinedButton(
                                            style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), minimumSize: Size(0, 36)),
                                            onPressed: () => _showCreateOrEditDialog(context, ref, index, existing: camp),
                                            child: Text('Edit'.tr(), style: const TextStyle(fontSize: 14)),
                                          ),
                                          TextButton(
                                            style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12), minimumSize: Size(0, 36)),
                                            onPressed: () async {
                                              final confirm = await showDialog<bool>(
                                                context: context,
                                                builder: (ctx) => AlertDialog(
                                                  title: Text('Delete campaign'.tr()),
                                                  content: Text('Are you sure you want to delete this campaign and its data?'.tr()),
                                                  actions: [
                                                    TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel'.tr())),
                                                    ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete'.tr())),
                                                  ],
                                                ),
                                              );
                                              if (confirm == true) {
                                                await ref.read(campaignsProvider.notifier).deleteCampaign(index);
                                              }
                                            },
                                            child: Text('Delete'.tr(), style: const TextStyle(color: Colors.red, fontSize: 14)),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else {
                return GridView.builder(
                  itemCount: 4,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.4,
                  ),
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewPadding.bottom + 88),
                  itemBuilder: (context, index) {
                    final camp = (index < campaigns.length) ? campaigns[index] : null;
                    return Card(
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(minHeight: 120),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 8),
                                if (camp == null) ...[
                                  Text('slot_label'.tr(args: ['${index + 1}'])),
                                  const SizedBox(height: 8),
                                  ElevatedButton(
                                    onPressed: () => _showCreateOrEditDialog(context, ref, index),
                                    child: Text('Create campaign'.tr()),
                                  ),
                                ] else ...[
                                  Text(camp.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 6),
                                  Text(camp.system, style: const TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 12),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 6,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => CampaignMainScreen(campaignSlot: index)),
                                          );
                                        },
                                        child: Text('Open'.tr()),
                                      ),
                                      OutlinedButton(
                                        onPressed: () => _showCreateOrEditDialog(context, ref, index, existing: camp),
                                        child: Text('Edit'.tr()),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          final confirm = await showDialog<bool>(
                                            context: context,
                                            builder: (ctx) => AlertDialog(
                                              title: Text('Delete campaign'.tr()),
                                              content: Text('Are you sure you want to delete this campaign and its data?'.tr()),
                                              actions: [
                                                TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text('Cancel'.tr())),
                                                ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text('Delete'.tr())),
                                              ],
                                            ),
                                          );
                                          if (confirm == true) {
                                            await ref.read(campaignsProvider.notifier).deleteCampaign(index);
                                          }
                                        },
                                        child: Text('Delete'.tr(), style: const TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}