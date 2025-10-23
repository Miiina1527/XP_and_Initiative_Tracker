import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

enum SistemaGM {
  pathfinder1e,
  pathfinder2e,
  dnd5e,
  dnd5e2024,
}

class GMScreen extends StatefulWidget {
  final int? campaignSlot;
  final bool hideSistemaSelector;
  final SistemaGM? initialSistema;

  const GMScreen({super.key, this.campaignSlot, this.hideSistemaSelector = false, this.initialSistema});

  @override
  State<GMScreen> createState() => _GMScreenState();
}

class _GMScreenState extends State<GMScreen> {
  late SistemaGM _sistemaSeleccionado;

  String get _nombreSistema {
    switch (_sistemaSeleccionado) {
      case SistemaGM.pathfinder1e:
        return "system_pathfinder_1e".tr();
      case SistemaGM.pathfinder2e:
        return "system_pathfinder_2e".tr();
      case SistemaGM.dnd5e:
        return "system_dnd_5e_2014".tr();
      case SistemaGM.dnd5e2024:
        return "system_dnd_5e_2024".tr();
    }
  }

  int get _cantidadTabs {
    switch (_sistemaSeleccionado) {
      case SistemaGM.pathfinder1e:
        return 5;
      case SistemaGM.pathfinder2e:
        return 4; // Menos tabs para PF2e
      case SistemaGM.dnd5e:
      case SistemaGM.dnd5e2024:
        return 4; // Menos tabs para D&D
    }
  }

  @override
  void initState() {
    super.initState();
    _sistemaSeleccionado = widget.initialSistema ?? SistemaGM.pathfinder1e;
  }

  List<Tab> get _tabs {
    switch (_sistemaSeleccionado) {
      case SistemaGM.pathfinder1e:
        return [
          Tab(text: "combat".tr()),
          Tab(text: "conditions".tr()),
          Tab(text: "equipment".tr()),
          Tab(text: "gm".tr()),
          Tab(text: "skills".tr()),
        ];
      case SistemaGM.pathfinder2e:
        return [
          Tab(text: "basics".tr()),
          Tab(text: "skills".tr()),
          Tab(text: "environment".tr()),
          Tab(text: "gm".tr()),
          Tab(text: "reference".tr()),
        ];
      case SistemaGM.dnd5e:
      case SistemaGM.dnd5e2024:
        return [
          Tab(text: "combat".tr()),
          Tab(text: "conditions".tr()),
          Tab(text: "skills".tr()),
          Tab(text: "gm".tr()),
        ];
    }
  }

  List<Widget> get _tabViews {
    switch (_sistemaSeleccionado) {
      case SistemaGM.pathfinder1e:
        return [
          const _CombateTabPF1e(),
          const _CondicionesTabPF1e(),
          const _EquipoTab(),
          const _GMTabPF1e(),
          const _HabilidadesTab(),
        ];
      case SistemaGM.pathfinder2e:
        return [
          _BasicosTabPF2e(),
          _HabilidadesTabPF2e(),
          _AmbienteTabPF2e(),
          _GMTabPF2e(),
          _ReferenceTabPF2e(),
        ];
      case SistemaGM.dnd5e:
        return [
          _CombateTabDnD(),
          _CondicionesTabDnD(),
          _HabilidadesTabDnD(),
          _GMTabDnD(),
        ];
      case SistemaGM.dnd5e2024:
        return [
          _CombateTabDnD(),
          _CondicionesTabDnD(),
          _HabilidadesTabDnD(),
          _GMTabDnD(),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: _cantidadTabs,
      child: Scaffold(
        appBar: AppBar(
          title: Text('${"gm_screen".tr()} - $_nombreSistema'),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Column(
              children: [
                // Selector de sistema
                if (!widget.hideSistemaSelector)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                    children: [
                      Text('${"system".tr()}: ', style: TextStyle(fontWeight: FontWeight.bold)),
                      Expanded(
                        child: DropdownButton<SistemaGM>(
                          value: _sistemaSeleccionado,
                          isExpanded: true,
                          items: SistemaGM.values.map((sistema) {
                            String nombre;
                            switch (sistema) {
                              case SistemaGM.pathfinder1e:
                                nombre = "system_pathfinder_1e".tr();
                                break;
                              case SistemaGM.pathfinder2e:
                                nombre = "system_pathfinder_2e".tr();
                                break;
                              case SistemaGM.dnd5e:
                                nombre = "system_dnd_5e_2014".tr();
                                break;
                              case SistemaGM.dnd5e2024:
                                nombre = "system_dnd_5e_2024".tr();
                                break;
                            }
                            return DropdownMenuItem(
                              value: sistema,
                              child: Text(nombre),
                            );
                          }).toList(),
                          onChanged: (SistemaGM? nuevoSistema) {
                            if (nuevoSistema != null) {
                              setState(() {
                                _sistemaSeleccionado = nuevoSistema;
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                // Tabs
                TabBar(
                  isScrollable: true,
                  tabs: _tabs,
                ),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: _tabViews,
        ),
      ),
    );
  }
}

class _CombateTabPF1e extends StatelessWidget {
  const _CombateTabPF1e();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text("armor_class_modifiers".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text("defender_is".tr())),
                  DataColumn(label: Text("melee".tr())),
                  DataColumn(label: Text("ranged".tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text("behind_cover".tr())), DataCell(Text('+4')), DataCell(Text('+4'))]),
                  DataRow(cells: [DataCell(Text("blinded".tr())), DataCell(Text('-2')), DataCell(Text('-2'))]),
                  DataRow(cells: [DataCell(Text("concealed_or_invisible".tr())), DataCell(Text("see_concealment".tr())), DataCell(Text("see_concealment".tr()))]),
                  DataRow(cells: [DataCell(Text("cowering".tr())), DataCell(Text('-2')), DataCell(Text('-2'))]),
                  DataRow(cells: [DataCell(Text("entangled".tr())), DataCell(Text('+0²')), DataCell(Text('+0²'))]),
                  DataRow(cells: [DataCell(Text("flat_footed".tr())), DataCell(Text('+0¹')), DataCell(Text('+0¹'))]),
                  DataRow(cells: [DataCell(Text("grappling_not_attacker".tr())), DataCell(Text('+0')), DataCell(Text('+0'))]),
                  DataRow(cells: [DataCell(Text("helpless".tr())), DataCell(Text('-4³')), DataCell(Text('+0³'))]),
                  DataRow(cells: [DataCell(Text("kneeling_or_sitting".tr())), DataCell(Text('-2')), DataCell(Text('+2'))]),
                  DataRow(cells: [DataCell(Text("pinned".tr())), DataCell(Text('-4³')), DataCell(Text('+0³'))]),
                  DataRow(cells: [DataCell(Text("prone".tr())), DataCell(Text('-4')), DataCell(Text('+4'))]),
                  DataRow(cells: [DataCell(Text("squeezing_through_space".tr())), DataCell(Text('-4')), DataCell(Text('-4'))]),
                  DataRow(cells: [DataCell(Text("stunned".tr())), DataCell(Text('-2')), DataCell(Text('-2'))]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("ac_note_1".tr()),
                  Text("ac_note_2".tr()),
                  Text("ac_note_3".tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("attack_roll_modifiers".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text("attacker_is".tr())),
                  DataColumn(label: Text("melee".tr())),
                  DataColumn(label: Text("ranged".tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text("dazzled".tr())), DataCell(Text('-1')), DataCell(Text('-1'))]),
                  DataRow(cells: [DataCell(Text("entangled".tr())), DataCell(Text('-2¹')), DataCell(Text('-2¹'))]),
                  DataRow(cells: [DataCell(Text("flanking_defender".tr())), DataCell(Text('+2')), DataCell(Text('—'))]),
                  DataRow(cells: [DataCell(Text("invisible".tr())), DataCell(Text('+2²')), DataCell(Text('+2²'))]),
                  DataRow(cells: [DataCell(Text("on_higher_ground".tr())), DataCell(Text('+1')), DataCell(Text('+0'))]),
                  DataRow(cells: [DataCell(Text("prone".tr())), DataCell(Text('-4³')), DataCell(Text('—³'))]),
                  DataRow(cells: [DataCell(Text("shaken_or_frightened".tr())), DataCell(Text('-2')), DataCell(Text('-2'))]),
                  DataRow(cells: [DataCell(Text("squeezing_through_space".tr())), DataCell(Text('-4')), DataCell(Text('-4'))]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("attack_note_1".tr()),
                  Text("attack_note_2".tr()),
                  Text("attack_note_3".tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("combat_maneuvers".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('cmb_formula'.tr()),
                  Text('cmd_formula'.tr()),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('maneuver'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('effect'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('bull_rush'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('bull_rush_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('dirty_trick'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('dirty_trick_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('disarm'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('disarm_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('drag'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('drag_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('grapple'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('grapple_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('overrun'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('overrun_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('reposition'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('reposition_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('steal'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('steal_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('sunder'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('sunder_effect'.tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('trip'.tr(), style: TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text('trip_effect'.tr())),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("concentration_checks".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('situation'.tr())),
                  DataColumn(label: Text('concentration_check_dc'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('cast_defensively'.tr())), DataCell(Text('15_plus_double_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('injured_while_casting'.tr())), DataCell(Text('10_plus_damage_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('continuous_damage_while_casting'.tr())), DataCell(Text('10_plus_half_damage_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('affected_by_non_damaging_spell'.tr())), DataCell(Text('dc_of_spell_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('grappled_or_pinned_while_casting'.tr())), DataCell(Text('10_plus_cmb_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('vigorous_motion_while_casting'.tr())), DataCell(Text('10_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('violent_motion_while_casting'.tr())), DataCell(Text('15_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('extremely_violent_motion'.tr())), DataCell(Text('20_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('wind_with_rain_or_sleet'.tr())), DataCell(Text('5_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('wind_with_hail_and_debris'.tr())), DataCell(Text('10_plus_spell_level'.tr()))]),
                  DataRow(cells: [DataCell(Text('weather_caused_by_spell'.tr())), DataCell(Text('see_spell'.tr()))]),
                  DataRow(cells: [DataCell(Text('entangled_while_casting'.tr())), DataCell(Text('15_plus_spell_level'.tr()))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("two_weapon_fighting_penalties".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('circumstances'.tr())),
                  DataColumn(label: Text('primary_hand'.tr())),
                  DataColumn(label: Text('off_hand'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('normal_penalties'.tr())), DataCell(Text('-6')), DataCell(Text('-10'))]),
                  DataRow(cells: [DataCell(Text('off_hand_weapon_is_light'.tr())), DataCell(Text('-4')), DataCell(Text('-8'))]),
                  DataRow(cells: [DataCell(Text('two_weapon_fighting_feat'.tr())), DataCell(Text('-4')), DataCell(Text('-4'))]),
                  DataRow(cells: [DataCell(Text('light_weapon_and_feat'.tr())), DataCell(Text('-2')), DataCell(Text('-2'))]),
                ],
              ),
            ),
          ],
        ),
        // ...agrega más ExpansionTiles para otras secciones de combate
      ],
    );
  }
}

class _CondicionesTabPF1e extends StatelessWidget {
  const _CondicionesTabPF1e();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text("common_conditions".tr()),
          children: [
            ListTile(
              title: Text('blinded_condition'.tr()),
              subtitle: Text('blinded_description'.tr()),
            ),
            ListTile(
              title: Text('stunned_condition'.tr()),
              subtitle: Text('stunned_description'.tr()),
            ),
            ListTile(
              title: Text('blind_condition'.tr()),
              subtitle: Text('blind_description'.tr()),
            ),
            ListTile(
              title: Text('concentrated_condition'.tr()),
              subtitle: Text('concentrated_description'.tr()),
            ),
            ListTile(
              title: Text('disarmed_condition'.tr()),
              subtitle: Text('disarmed_description'.tr()),
            ),
            ListTile(
              title: Text('damaged_condition'.tr()),
              subtitle: Text('damaged_description'.tr()),
            ),
            ListTile(
              title: Text('fatigued_condition'.tr()),
              subtitle: Text('fatigued_description'.tr()),
            ),
            ListTile(
              title: Text('injured_condition'.tr()),
              subtitle: Text('injured_description'.tr()),
            ),
            ListTile(
              title: Text('unconscious_condition'.tr()),
              subtitle: Text('unconscious_description'.tr()),
            ),
            ListTile(
              title: Text('intimidated_condition'.tr()),
              subtitle: Text('intimidated_description'.tr()),
            ),
            ListTile(
              title: Text('paralyzed_condition'.tr()),
              subtitle: Text('paralyzed_description'.tr()),
            ),
            ListTile(
              title: Text('dazed_condition'.tr()),
              subtitle: Text('dazed_description'.tr()),
            ),
            ListTile(
              title: Text('prone_condition'.tr()),
              subtitle: Text('prone_description'.tr()),
            ),
            ListTile(
              title: Text('bleeding_condition'.tr()),
              subtitle: Text('bleeding_description'.tr()),
            ),
            ListTile(
              title: Text('deaf_condition'.tr()),
              subtitle: Text('deaf_description'.tr()),
            ),
            ListTile(
              title: Text('shaky_condition'.tr()),
              subtitle: Text('shaky_description'.tr()),
            ),
            ListTile(
              title: Text('prone_lying_condition'.tr()),
              subtitle: Text('prone_lying_description'.tr()),
            ),
            ListTile(
              title: Text('vulnerable_condition'.tr()),
              subtitle: Text('vulnerable_description'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}

class _EquipoTab extends StatelessWidget {
  const _EquipoTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text("armor_weapon_hardness_hp".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('weapon_or_shield'.tr())),
                  DataColumn(label: Text('hardness_1'.tr())),
                  DataColumn(label: Text('hit_points_2_3'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('light_blade'.tr())), DataCell(Text('10')), DataCell(Text('2'))]),
                  DataRow(cells: [DataCell(Text('one_handed_blade'.tr())), DataCell(Text('10')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('two_handed_blade'.tr())), DataCell(Text('10')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('light_metal_hafted_weapon'.tr())), DataCell(Text('10')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('one_handed_metal_hafted_weapon'.tr())), DataCell(Text('10')), DataCell(Text('20'))]),
                  DataRow(cells: [DataCell(Text('light_hafted_weapon'.tr())), DataCell(Text('5')), DataCell(Text('2'))]),
                  DataRow(cells: [DataCell(Text('one_handed_hafted_weapon'.tr())), DataCell(Text('5')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('two_handed_hafted_weapon'.tr())), DataCell(Text('5')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('projectile_weapon'.tr())), DataCell(Text('5')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('armor'.tr())), DataCell(Text('special_4'.tr())), DataCell(Text('armor_bonus_x5'.tr()))]),
                  DataRow(cells: [DataCell(Text('buckler'.tr())), DataCell(Text('10')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('light_wooden_shield'.tr())), DataCell(Text('5')), DataCell(Text('7'))]),
                  DataRow(cells: [DataCell(Text('heavy_wooden_shield'.tr())), DataCell(Text('5')), DataCell(Text('15'))]),
                  DataRow(cells: [DataCell(Text('light_steel_shield'.tr())), DataCell(Text('10')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('heavy_steel_shield'.tr())), DataCell(Text('10')), DataCell(Text('20'))]),
                  DataRow(cells: [DataCell(Text('tower_shield'.tr())), DataCell(Text('5')), DataCell(Text('20'))]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('hardness_note_1'.tr()),
                  Text('hardness_note_2'.tr()),
                  Text('hardness_note_3'.tr()),
                  Text('hardness_note_4'.tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("breaking_items".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('breaking_items_table_title'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('strength_check_to'.tr())),
                        DataColumn(label: Text('dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('break_down_simple_door'.tr())), DataCell(Text('13'))]),
                        DataRow(cells: [DataCell(Text('break_down_good_door'.tr())), DataCell(Text('18'))]),
                        DataRow(cells: [DataCell(Text('break_down_strong_door'.tr())), DataCell(Text('23'))]),
                        DataRow(cells: [DataCell(Text('burst_rope_bonds'.tr())), DataCell(Text('23'))]),
                        DataRow(cells: [DataCell(Text('bend_iron_bars'.tr())), DataCell(Text('24'))]),
                        DataRow(cells: [DataCell(Text('break_down_barred_door'.tr())), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('burst_chain_bonds'.tr())), DataCell(Text('26'))]),
                        DataRow(cells: [DataCell(Text('break_down_iron_door'.tr())), DataCell(Text('28'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('condition'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('condition'.tr())),
                        DataColumn(label: Text('dc_adjustment'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('hold_portal'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('arcane_lock'.tr())), DataCell(Text('+10'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('dc_adjustment_note'.tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("object_hardness_hp".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('object'.tr())),
                  DataColumn(label: Text('hardness'.tr())),
                  DataColumn(label: Text('hit_points'.tr())),
                  DataColumn(label: Text('dc'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('rope_1_in_diameter'.tr())), DataCell(Text('0')), DataCell(Text('2')), DataCell(Text('23'))]),
                  DataRow(cells: [DataCell(Text('simple_wooden_door'.tr())), DataCell(Text('5')), DataCell(Text('10')), DataCell(Text('13'))]),
                  DataRow(cells: [DataCell(Text('small_chest'.tr())), DataCell(Text('5')), DataCell(Text('1')), DataCell(Text('17'))]),
                  DataRow(cells: [DataCell(Text('good_wooden_door'.tr())), DataCell(Text('5')), DataCell(Text('15')), DataCell(Text('18'))]),
                  DataRow(cells: [DataCell(Text('treasure_chest'.tr())), DataCell(Text('5')), DataCell(Text('15')), DataCell(Text('23'))]),
                  DataRow(cells: [DataCell(Text('strong_wooden_door'.tr())), DataCell(Text('5')), DataCell(Text('20')), DataCell(Text('23'))]),
                  DataRow(cells: [DataCell(Text('masonry_wall_1_ft_thick'.tr())), DataCell(Text('8')), DataCell(Text('90')), DataCell(Text('35'))]),
                  DataRow(cells: [DataCell(Text('hewn_stone_3_ft_thick'.tr())), DataCell(Text('8')), DataCell(Text('540')), DataCell(Text('50'))]),
                  DataRow(cells: [DataCell(Text('chain'.tr())), DataCell(Text('10')), DataCell(Text('5')), DataCell(Text('26'))]),
                  DataRow(cells: [DataCell(Text('manacles'.tr())), DataCell(Text('10')), DataCell(Text('10')), DataCell(Text('26'))]),
                  DataRow(cells: [DataCell(Text('masterwork_manacles'.tr())), DataCell(Text('10')), DataCell(Text('10')), DataCell(Text('28'))]),
                  DataRow(cells: [DataCell(Text('iron_door_2_in_thick'.tr())), DataCell(Text('10')), DataCell(Text('60')), DataCell(Text('28'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("substance_hardness_hp".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('substance'.tr())),
                  DataColumn(label: Text('hardness'.tr())),
                  DataColumn(label: Text('hit_points'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('glass'.tr())), DataCell(Text('1')), DataCell(Text('1_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('paper_or_cloth'.tr())), DataCell(Text('0')), DataCell(Text('2_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('rope'.tr())), DataCell(Text('0')), DataCell(Text('2_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('ice'.tr())), DataCell(Text('0')), DataCell(Text('3_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('leather_or_hide'.tr())), DataCell(Text('2')), DataCell(Text('5_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('wood'.tr())), DataCell(Text('5')), DataCell(Text('10_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('stone'.tr())), DataCell(Text('8')), DataCell(Text('15_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('iron_or_steel'.tr())), DataCell(Text('10')), DataCell(Text('30_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('mithral'.tr())), DataCell(Text('15')), DataCell(Text('30_per_in_thickness'.tr()))]),
                  DataRow(cells: [DataCell(Text('adamantine'.tr())), DataCell(Text('20')), DataCell(Text('40_per_in_thickness'.tr()))]),
                ],
              ),
            ),
          ],
        ),
        // ...agrega más ExpansionTiles para otras tablas de equipo
      ],
    );
  }
}

class _GMTabPF1e extends StatelessWidget {
  const _GMTabPF1e();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text("experience_point_awards".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('cr'.tr())),
                  DataColumn(label: Text('total_xp'.tr())),
                  DataColumn(label: Text('party_1_3'.tr())),
                  DataColumn(label: Text('party_4_5'.tr())),
                  DataColumn(label: Text('party_6_plus'.tr())),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('1/8')), DataCell(Text('50')), DataCell(Text('15')), DataCell(Text('15')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('1/6')), DataCell(Text('65')), DataCell(Text('20')), DataCell(Text('15')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('1/4')), DataCell(Text('100')), DataCell(Text('25')), DataCell(Text('25')), DataCell(Text('15'))]),
                  DataRow(cells: [DataCell(Text('1/3')), DataCell(Text('135')), DataCell(Text('35')), DataCell(Text('25')), DataCell(Text('25'))]),
                  DataRow(cells: [DataCell(Text('1/2')), DataCell(Text('200')), DataCell(Text('50')), DataCell(Text('35')), DataCell(Text('35'))]),
                  DataRow(cells: [DataCell(Text('1')), DataCell(Text('400')), DataCell(Text('135')), DataCell(Text('100')), DataCell(Text('65'))]),
                  DataRow(cells: [DataCell(Text('2')), DataCell(Text('600')), DataCell(Text('200')), DataCell(Text('150')), DataCell(Text('100'))]),
                  DataRow(cells: [DataCell(Text('3')), DataCell(Text('800')), DataCell(Text('265')), DataCell(Text('200')), DataCell(Text('135'))]),
                  DataRow(cells: [DataCell(Text('4')), DataCell(Text('1,200')), DataCell(Text('400')), DataCell(Text('300')), DataCell(Text('200'))]),
                  DataRow(cells: [DataCell(Text('5')), DataCell(Text('1,600')), DataCell(Text('535')), DataCell(Text('400')), DataCell(Text('265'))]),
                  DataRow(cells: [DataCell(Text('6')), DataCell(Text('2,400')), DataCell(Text('800')), DataCell(Text('600')), DataCell(Text('400'))]),
                  DataRow(cells: [DataCell(Text('7')), DataCell(Text('3,200')), DataCell(Text('1,070')), DataCell(Text('800')), DataCell(Text('535'))]),
                  DataRow(cells: [DataCell(Text('8')), DataCell(Text('4,800')), DataCell(Text('1,600')), DataCell(Text('1,200')), DataCell(Text('800'))]),
                  DataRow(cells: [DataCell(Text('9')), DataCell(Text('6,400')), DataCell(Text('2,130')), DataCell(Text('1,600')), DataCell(Text('1,070'))]),
                  DataRow(cells: [DataCell(Text('10')), DataCell(Text('9,600')), DataCell(Text('3,200')), DataCell(Text('2,400')), DataCell(Text('1,600'))]),
                  DataRow(cells: [DataCell(Text('11')), DataCell(Text('12,800')), DataCell(Text('4,270')), DataCell(Text('3,200')), DataCell(Text('2,130'))]),
                  DataRow(cells: [DataCell(Text('12')), DataCell(Text('19,200')), DataCell(Text('6,400')), DataCell(Text('4,800')), DataCell(Text('3,200'))]),
                  DataRow(cells: [DataCell(Text('13')), DataCell(Text('25,600')), DataCell(Text('8,530')), DataCell(Text('6,400')), DataCell(Text('4,270'))]),
                  DataRow(cells: [DataCell(Text('14')), DataCell(Text('38,400')), DataCell(Text('12,800')), DataCell(Text('9,600')), DataCell(Text('6,400'))]),
                  DataRow(cells: [DataCell(Text('15')), DataCell(Text('51,200')), DataCell(Text('17,100')), DataCell(Text('12,800')), DataCell(Text('8,530'))]),
                  DataRow(cells: [DataCell(Text('16')), DataCell(Text('76,800')), DataCell(Text('25,600')), DataCell(Text('19,200')), DataCell(Text('12,800'))]),
                  DataRow(cells: [DataCell(Text('17')), DataCell(Text('102,400')), DataCell(Text('34,100')), DataCell(Text('25,600')), DataCell(Text('17,100'))]),
                  DataRow(cells: [DataCell(Text('18')), DataCell(Text('153,600')), DataCell(Text('51,200')), DataCell(Text('38,400')), DataCell(Text('25,600'))]),
                  DataRow(cells: [DataCell(Text('19')), DataCell(Text('204,800')), DataCell(Text('68,300')), DataCell(Text('51,200')), DataCell(Text('34,100'))]),
                  DataRow(cells: [DataCell(Text('20')), DataCell(Text('307,200')), DataCell(Text('102,000')), DataCell(Text('76,800')), DataCell(Text('51,200'))]),
                  DataRow(cells: [DataCell(Text('21')), DataCell(Text('409,600')), DataCell(Text('137,000')), DataCell(Text('102,400')), DataCell(Text('68,300'))]),
                  DataRow(cells: [DataCell(Text('22')), DataCell(Text('614,400')), DataCell(Text('205,000')), DataCell(Text('153,600')), DataCell(Text('102,400'))]),
                  DataRow(cells: [DataCell(Text('23')), DataCell(Text('819,200')), DataCell(Text('273,000')), DataCell(Text('204,800')), DataCell(Text('137,000'))]),
                  DataRow(cells: [DataCell(Text('24')), DataCell(Text('1,228,800')), DataCell(Text('410,000')), DataCell(Text('307,200')), DataCell(Text('204,800'))]),
                  DataRow(cells: [DataCell(Text('25')), DataCell(Text('1,638,400')), DataCell(Text('546,000')), DataCell(Text('409,600')), DataCell(Text('273,000'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("treasure_values_per_encounter".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('average_party_level'.tr())),
                  DataColumn(label: Text('slow'.tr())),
                  DataColumn(label: Text('medium'.tr())),
                  DataColumn(label: Text('fast'.tr())),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('1')), DataCell(Text('170 gp')), DataCell(Text('260 gp')), DataCell(Text('400 gp'))]),
                  DataRow(cells: [DataCell(Text('2')), DataCell(Text('350 gp')), DataCell(Text('550 gp')), DataCell(Text('800 gp'))]),
                  DataRow(cells: [DataCell(Text('3')), DataCell(Text('550 gp')), DataCell(Text('800 gp')), DataCell(Text('1,200 gp'))]),
                  DataRow(cells: [DataCell(Text('4')), DataCell(Text('750 gp')), DataCell(Text('1,150 gp')), DataCell(Text('1,700 gp'))]),
                  DataRow(cells: [DataCell(Text('5')), DataCell(Text('1,000 gp')), DataCell(Text('1,550 gp')), DataCell(Text('2,300 gp'))]),
                  DataRow(cells: [DataCell(Text('6')), DataCell(Text('1,350 gp')), DataCell(Text('2,000 gp')), DataCell(Text('3,000 gp'))]),
                  DataRow(cells: [DataCell(Text('7')), DataCell(Text('1,750 gp')), DataCell(Text('2,600 gp')), DataCell(Text('3,900 gp'))]),
                  DataRow(cells: [DataCell(Text('8')), DataCell(Text('2,200 gp')), DataCell(Text('3,350 gp')), DataCell(Text('5,000 gp'))]),
                  DataRow(cells: [DataCell(Text('9')), DataCell(Text('2,850 gp')), DataCell(Text('4,250 gp')), DataCell(Text('6,400 gp'))]),
                  DataRow(cells: [DataCell(Text('10')), DataCell(Text('3,650 gp')), DataCell(Text('5,450 gp')), DataCell(Text('8,200 gp'))]),
                  DataRow(cells: [DataCell(Text('11')), DataCell(Text('4,650 gp')), DataCell(Text('7,000 gp')), DataCell(Text('10,500 gp'))]),
                  DataRow(cells: [DataCell(Text('12')), DataCell(Text('6,000 gp')), DataCell(Text('9,000 gp')), DataCell(Text('13,500 gp'))]),
                  DataRow(cells: [DataCell(Text('13')), DataCell(Text('7,750 gp')), DataCell(Text('11,600 gp')), DataCell(Text('17,500 gp'))]),
                  DataRow(cells: [DataCell(Text('14')), DataCell(Text('10,000 gp')), DataCell(Text('15,000 gp')), DataCell(Text('22,000 gp'))]),
                  DataRow(cells: [DataCell(Text('15')), DataCell(Text('13,000 gp')), DataCell(Text('19,500 gp')), DataCell(Text('29,000 gp'))]),
                  DataRow(cells: [DataCell(Text('16')), DataCell(Text('16,500 gp')), DataCell(Text('25,000 gp')), DataCell(Text('38,000 gp'))]),
                  DataRow(cells: [DataCell(Text('17')), DataCell(Text('22,000 gp')), DataCell(Text('32,000 gp')), DataCell(Text('48,000 gp'))]),
                  DataRow(cells: [DataCell(Text('18')), DataCell(Text('28,000 gp')), DataCell(Text('41,000 gp')), DataCell(Text('62,000 gp'))]),
                  DataRow(cells: [DataCell(Text('19')), DataCell(Text('35,000 gp')), DataCell(Text('53,000 gp')), DataCell(Text('79,000 gp'))]),
                  DataRow(cells: [DataCell(Text('20')), DataCell(Text('44,000 gp')), DataCell(Text('67,000 gp')), DataCell(Text('100,000 gp'))]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('treasure_encounter_note_1'.tr()),
                  Text('treasure_encounter_note_2'.tr()),
                  Text('treasure_encounter_note_3'.tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("character_wealth_by_level".tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pc_level'.tr())),
                  DataColumn(label: Text('wealth'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('1')), DataCell(Text('varies_asterisk'.tr()))]),
                  DataRow(cells: [DataCell(Text('2')), DataCell(Text('1,000 gp'))]),
                  DataRow(cells: [DataCell(Text('3')), DataCell(Text('3,000 gp'))]),
                  DataRow(cells: [DataCell(Text('4')), DataCell(Text('6,000 gp'))]),
                  DataRow(cells: [DataCell(Text('5')), DataCell(Text('10,500 gp'))]),
                  DataRow(cells: [DataCell(Text('6')), DataCell(Text('16,000 gp'))]),
                  DataRow(cells: [DataCell(Text('7')), DataCell(Text('23,500 gp'))]),
                  DataRow(cells: [DataCell(Text('8')), DataCell(Text('33,000 gp'))]),
                  DataRow(cells: [DataCell(Text('9')), DataCell(Text('46,000 gp'))]),
                  DataRow(cells: [DataCell(Text('10')), DataCell(Text('62,000 gp'))]),
                  DataRow(cells: [DataCell(Text('11')), DataCell(Text('82,000 gp'))]),
                  DataRow(cells: [DataCell(Text('12')), DataCell(Text('108,000 gp'))]),
                  DataRow(cells: [DataCell(Text('13')), DataCell(Text('140,000 gp'))]),
                  DataRow(cells: [DataCell(Text('14')), DataCell(Text('185,000 gp'))]),
                  DataRow(cells: [DataCell(Text('15')), DataCell(Text('240,000 gp'))]),
                  DataRow(cells: [DataCell(Text('16')), DataCell(Text('315,000 gp'))]),
                  DataRow(cells: [DataCell(Text('17')), DataCell(Text('410,000 gp'))]),
                  DataRow(cells: [DataCell(Text('18')), DataCell(Text('530,000 gp'))]),
                  DataRow(cells: [DataCell(Text('19')), DataCell(Text('685,000 gp'))]),
                  DataRow(cells: [DataCell(Text('20')), DataCell(Text('880,000 gp'))]),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('wealth_note_1'.tr()),
                  Text('wealth_note_2'.tr()),
                  Text('wealth_note_3'.tr()),
                ],
              ),
            ),
          ],
        ),
        // ...agrega más ExpansionTiles para otras tablas de GM
      ],
    );
  }
}

class _HabilidadesTab extends StatelessWidget {
  const _HabilidadesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text("acrobatics".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('move_across_narrow_surface'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('width'.tr())),
                        DataColumn(label: Text('acrobatics_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('greater_than_3_feet_wide'.tr())), DataCell(Text('0¹'))]),
                        DataRow(cells: [DataCell(Text('1_3_feet_wide'.tr())), DataCell(Text('5¹'))]),
                        DataRow(cells: [DataCell(Text('7_11_inches_wide'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('2_6_inches_wide'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('less_than_2_inches_wide'.tr())), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('move_through_threatened_area'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('action'.tr())),
                        DataColumn(label: Text('acrobatics_dc_2'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('move_through_threatened_area_action'.tr())), DataCell(Text('opponents_cmd'.tr()))]),
                        DataRow(cells: [DataCell(Text('move_through_enemy_space'.tr())), DataCell(Text('5_plus_opponents_cmd'.tr()))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('long_jump'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('distance'.tr())),
                        DataColumn(label: Text('acrobatics_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('5_feet'.tr())), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('10_feet'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('15_feet'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('20_feet'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('greater_than_20_feet'.tr())), DataCell(Text('plus_5_per_5_feet'.tr()))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('high_jump'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('height'.tr())),
                        DataColumn(label: Text('acrobatics_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('1_foot'.tr())), DataCell(Text('4'))]),
                        DataRow(cells: [DataCell(Text('2_feet'.tr())), DataCell(Text('8'))]),
                        DataRow(cells: [DataCell(Text('3_feet'.tr())), DataCell(Text('12'))]),
                        DataRow(cells: [DataCell(Text('4_feet'.tr())), DataCell(Text('16'))]),
                        DataRow(cells: [DataCell(Text('greater_than_4_feet'.tr())), DataCell(Text('plus_4_per_foot'.tr()))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('acrobatics_modifiers'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('modifier'.tr())),
                        DataColumn(label: Text('dc_modifier'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('slightly_obstructed'.tr())), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('severely_obstructed'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('slightly_slippery'.tr())), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('severely_slippery'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('slightly_sloped'.tr())), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('severely_sloped'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('slightly_unsteady'.tr())), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('moderately_unsteady'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('severely_unsteady'.tr())), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('move_full_speed_narrow'.tr())), DataCell(Text('+5³'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('acrobatics_note_1'.tr()),
                  Text('acrobatics_note_2'.tr()),
                  Text('acrobatics_note_3'.tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("bluff".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('circumstances'.tr())),
                        DataColumn(label: Text('bluff_modifier'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('target_wants_to_believe'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('lie_is_believable'.tr())), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('lie_is_unlikely'.tr())), DataCell(Text('-5'))]),
                        DataRow(cells: [DataCell(Text('lie_is_far_fetched'.tr())), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('lie_is_impossible'.tr())), DataCell(Text('-20'))]),
                        DataRow(cells: [DataCell(Text('target_is_drunk'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('convincing_proof'.tr())), DataCell(Text('up_to_plus_10'.tr()))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('feint_dc_explanation'.tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("climb".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('example_surface_activity'.tr())),
                        DataColumn(label: Text('climb_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('steep_slope_knotted_rope'.tr())), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('rope_wall_knotted_rope'.tr())), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('surface_ledges_rough_wall'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('surface_handholds_tree'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('uneven_surface_narrow_handholds'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('rough_surface_rock_brick'.tr())), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('overhang_ceiling_handholds'.tr())), DataCell(Text('30'))]),
                        DataRow(cells: [DataCell(Text('perfectly_smooth_surface'.tr())), DataCell(Text('-'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('climb_modifiers'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('climb_modifiers'.tr())),
                        DataColumn(label: Text('dc_modifiers'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('brace_opposite_walls'.tr())), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('brace_perpendicular_walls'.tr())), DataCell(Text('-5'))]),
                        DataRow(cells: [DataCell(Text('surface_is_slippery'.tr())), DataCell(Text('+5'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("diplomacy".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('attitude_diplomacy_dc'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('starting_attitude'.tr())),
                        DataColumn(label: Text('diplomacy_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('hostile'.tr())), DataCell(Text('25_plus_creature_cha'.tr()))]),
                        DataRow(cells: [DataCell(Text('unfriendly'.tr())), DataCell(Text('20_plus_creature_cha'.tr()))]),
                        DataRow(cells: [DataCell(Text('indifferent'.tr())), DataCell(Text('15_plus_creature_cha'.tr()))]),
                        DataRow(cells: [DataCell(Text('friendly'.tr())), DataCell(Text('10_plus_creature_cha'.tr()))]),
                        DataRow(cells: [DataCell(Text('helpful'.tr())), DataCell(Text('0_plus_creature_cha'.tr()))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('request_dc_modifiers'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('request'.tr())),
                        DataColumn(label: Text('dc_modifier'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('give_simple_advice'.tr())), DataCell(Text('-5'))]),
                        DataRow(cells: [DataCell(Text('give_detailed_advice'.tr())), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('give_simple_aid'.tr())), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('reveal_unimportant_secret'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('give_lengthy_aid'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('give_dangerous_aid'.tr())), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('reveal_important_secret'.tr())), DataCell(Text('10_or_more'.tr()))]),
                        DataRow(cells: [DataCell(Text('aid_with_punishment'.tr())), DataCell(Text('15_or_more'.tr()))]),
                        DataRow(cells: [DataCell(Text('additional_requests'.tr())), DataCell(Text('5_per_request'.tr()))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("disable_device".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('disable_device_dcs'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('device'.tr())),
                        DataColumn(label: Text('time'.tr())),
                        DataColumn(label: Text('disable_device_dc_asterisk'.tr())),
                        DataColumn(label: Text('example'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('simple'.tr())), DataCell(Text('1_round'.tr())), DataCell(Text('10')), DataCell(Text('jam_lock'.tr()))]),
                        DataRow(cells: [DataCell(Text('tricky'.tr())), DataCell(Text('1d4_rounds'.tr())), DataCell(Text('15')), DataCell(Text('sabotage_wagon_wheel'.tr()))]),
                        DataRow(cells: [DataCell(Text('difficult'.tr())), DataCell(Text('2d4_rounds'.tr())), DataCell(Text('20')), DataCell(Text('disarm_trap_reset'.tr()))]),
                        DataRow(cells: [DataCell(Text('extreme'.tr())), DataCell(Text('2d4_rounds'.tr())), DataCell(Text('25')), DataCell(Text('disarm_complex_trap_sabotage'.tr()))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('no_trace_note'.tr(), style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("fly".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('flying_maneuvers'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('flying_maneuver'.tr())),
                        DataColumn(label: Text('fly_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('move_less_half_speed'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('hover'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('turn_45_degrees'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('turn_180_degrees'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('fly_up_45_angle'.tr())), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("heal".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('heal_tasks'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('task'.tr())),
                        DataColumn(label: Text('dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('first_aid'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('long_term_care'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('treat_wounds_spikes'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('treat_deadly_wounds'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('treat_poison'.tr())), DataCell(Text('poison_save_dc'.tr()))]),
                        DataRow(cells: [DataCell(Text('treat_disease'.tr())), DataCell(Text('disease_save_dc'.tr()))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("knowledge".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('knowledge_tasks'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('task'.tr())),
                        DataColumn(label: Text('knowledge_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('easy_question'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('basic_question'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('hard_question'.tr())), DataCell(Text('20+'))]),
                        DataRow(cells: [DataCell(Text('identify_auras_arcana'.tr())), DataCell(Text('arcana_15_plus_spell_level'.tr()))]),
                        DataRow(cells: [DataCell(Text('identify_spell_effect_arcana'.tr())), DataCell(Text('arcana_20_plus_spell_level'.tr()))]),
                        DataRow(cells: [DataCell(Text('identify_underground_hazard'.tr())), DataCell(Text('15_plus_hazard_cr'.tr()))]),
                        DataRow(cells: [DataCell(Text('identify_dangerous_construction'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('recognize_terrain_features'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('know_obscure_event'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('know_local_laws'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('identify_common_plant_animal'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('know_proper_etiquette'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('identify_planar_origin'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('recognize_deity_symbol'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('know_monster_abilities'.tr())), DataCell(Text('10_plus_monster_cr'.tr()))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("perception".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('perception_details'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('detail'.tr())),
                        DataColumn(label: Text('perception_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('hear_battle_sound'.tr())), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('notice_garbage_stench'.tr())), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('detect_smoke_smell'.tr())), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('hear_conversation_details'.tr())), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('notice_visible_creature'.tr())), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('determine_spoiled_food'.tr())), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('hear_creature_walking'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('hear_whispered_conversation'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('find_concealed_door'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('hear_key_in_lock'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('find_secret_door'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('hear_bow_drawn'.tr())), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('sense_burrowing_creature'.tr())), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('notice_pickpocket'.tr())), DataCell(Text('opposed_sleight_hand'.tr()))]),
                        DataRow(cells: [DataCell(Text('notice_stealth_creature'.tr())), DataCell(Text('opposed_stealth'.tr()))]),
                        DataRow(cells: [DataCell(Text('find_hidden_trap'.tr())), DataCell(Text('varies_by_trap'.tr()))]),
                        DataRow(cells: [DataCell(Text('identify_potion_taste'.tr())), DataCell(Text('15_plus_caster_level'.tr()))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('perception_modifiers'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('perception_modifiers'.tr())),
                        DataColumn(label: Text('dc_modifier'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('distance_to_source'.tr())), DataCell(Text('plus_1_per_10_feet'.tr()))]),
                        DataRow(cells: [DataCell(Text('through_closed_door'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('through_wall'.tr())), DataCell(Text('plus_10_per_foot'.tr()))]),
                        DataRow(cells: [DataCell(Text('favorable_conditions_1'.tr())), DataCell(Text('-2'))]),
                        DataRow(cells: [DataCell(Text('unfavorable_conditions_1'.tr())), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('terrible_conditions_2'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('creature_distracted'.tr())), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('creature_asleep'.tr())), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('creature_invisible'.tr())), DataCell(Text('+20'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('perception_note_1'.tr()),
                  Text('perception_note_2'.tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("ride".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ride_tasks'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('task'.tr())),
                        DataColumn(label: Text('ride_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('guide_with_knees'.tr())), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('stay_in_saddle'.tr())), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('fight_combat_mount'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('cover'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('soft_fall'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('leap'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('spur_mount'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('control_mount_battle'.tr())), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('fast_mount_dismount'.tr())), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("spellcraft".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('spellcraft_tasks'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('task'.tr())),
                        DataColumn(label: Text('spellcraft_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('identify_spell_being_cast'.tr())), DataCell(Text('spellcraft_15_plus_spell_level'.tr()))]),
                        DataRow(cells: [DataCell(Text('learn_spell_spellbook'.tr())), DataCell(Text('spellcraft_15_plus_spell_level'.tr()))]),
                        DataRow(cells: [DataCell(Text('prepare_spell_borrowed_book'.tr())), DataCell(Text('spellcraft_15_plus_spell_level'.tr()))]),
                        DataRow(cells: [DataCell(Text('identify_magic_item_properties'.tr())), DataCell(Text('15_plus_item_caster_level'.tr()))]),
                        DataRow(cells: [DataCell(Text('decipher_scroll'.tr())), DataCell(Text('spellcraft_20_plus_spell_level'.tr()))]),
                        DataRow(cells: [DataCell(Text('craft_magic_item'.tr())), DataCell(Text('varies_by_item'.tr()))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("survival".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('track_creatures_surface'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('surface'.tr())),
                        DataColumn(label: Text('survival_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('very_soft_ground'.tr())), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('soft_ground'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('firm_ground'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('hard_ground'.tr())), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('tracking_modifiers'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('tracking_condition'.tr())),
                        DataColumn(label: Text('survival_dc_modifier'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('every_three_creatures'.tr())), DataCell(Text('-1'))]),
                        DataRow(cells: [DataCell(Text('size_of_creature_tracked'.tr())), DataCell(Text(''))]),
                        DataRow(cells: [DataCell(Text('size_fine'.tr())), DataCell(Text('+8'))]),
                        DataRow(cells: [DataCell(Text('size_diminutive'.tr())), DataCell(Text('+4'))]),
                        DataRow(cells: [DataCell(Text('size_tiny'.tr())), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('size_small'.tr())), DataCell(Text('+1'))]),
                        DataRow(cells: [DataCell(Text('size_medium'.tr())), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('size_large'.tr())), DataCell(Text('-1'))]),
                        DataRow(cells: [DataCell(Text('size_huge'.tr())), DataCell(Text('-2'))]),
                        DataRow(cells: [DataCell(Text('size_gargantuan'.tr())), DataCell(Text('-4'))]),
                        DataRow(cells: [DataCell(Text('size_colossal'.tr())), DataCell(Text('-8'))]),
                        DataRow(cells: [DataCell(Text('every_24_hours'.tr())), DataCell(Text('+1'))]),
                        DataRow(cells: [DataCell(Text('every_hour_rain'.tr())), DataCell(Text('+1'))]),
                        DataRow(cells: [DataCell(Text('fresh_snow'.tr())), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('poor_visibility'.tr())), DataCell(Text(''))]),
                        DataRow(cells: [DataCell(Text('overcast_moonless'.tr())), DataCell(Text('+6'))]),
                        DataRow(cells: [DataCell(Text('moonlight'.tr())), DataCell(Text('+3'))]),
                        DataRow(cells: [DataCell(Text('fog_precipitation'.tr())), DataCell(Text('+3'))]),
                        DataRow(cells: [DataCell(Text('party_hides_trail'.tr())), DataCell(Text('+5'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('tracking_note'.tr()),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("swim".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('swim_dcs_water_condition'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('water_condition'.tr())),
                        DataColumn(label: Text('swim_dc'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('calm_water'.tr())), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('rough_water'.tr())), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('stormy_water'.tr())), DataCell(Text('20¹'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('¹ You can’t take 10 on a Swim check in stormy water, even if you aren’t otherwise being threatened or distracted.', style: TextStyle(fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text("wind_effects_on_flight".tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('wind_effects_flight_title'.tr(), style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('wind_force'.tr())),
                        DataColumn(label: Text('wind_speed'.tr())),
                        DataColumn(label: Text('checked_size'.tr())),
                        DataColumn(label: Text('blown_away_size'.tr())),
                        DataColumn(label: Text('fly_penalty'.tr())),
                      ],
                      rows: [
                        DataRow(cells: [DataCell(Text('wind_light'.tr())), DataCell(Text('wind_0_10_mph'.tr())), DataCell(Text('—')), DataCell(Text('—')), DataCell(Text('—'))]),
                        DataRow(cells: [DataCell(Text('wind_moderate'.tr())), DataCell(Text('wind_11_20_mph'.tr())), DataCell(Text('—')), DataCell(Text('—')), DataCell(Text('—'))]),
                        DataRow(cells: [DataCell(Text('wind_strong'.tr())), DataCell(Text('wind_21_30_mph'.tr())), DataCell(Text('wind_tiny'.tr())), DataCell(Text('—')), DataCell(Text('-2'))]),
                        DataRow(cells: [DataCell(Text('wind_severe'.tr())), DataCell(Text('wind_31_50_mph'.tr())), DataCell(Text('wind_small'.tr())), DataCell(Text('wind_tiny'.tr())), DataCell(Text('-4'))]),
                        DataRow(cells: [DataCell(Text('wind_windstorm'.tr())), DataCell(Text('wind_51_74_mph'.tr())), DataCell(Text('wind_medium'.tr())), DataCell(Text('wind_small'.tr())), DataCell(Text('-8'))]),
                        DataRow(cells: [DataCell(Text('wind_hurricane'.tr())), DataCell(Text('wind_75_174_mph'.tr())), DataCell(Text('wind_large'.tr())), DataCell(Text('wind_medium'.tr())), DataCell(Text('-12'))]),
                        DataRow(cells: [DataCell(Text('wind_tornado'.tr())), DataCell(Text('wind_175_plus_mph'.tr())), DataCell(Text('wind_huge'.tr())), DataCell(Text('wind_large'.tr())), DataCell(Text('-16'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        // ...agrega más ExpansionTiles para otras tablas de habilidades
      ],
    );
  }
}

// ============================================
// PATHFINDER 2e TABS
// ============================================

class _BasicosTabPF2e extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('basic_actions'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_action_aid'.tr()),
              subtitle: Text('pf2e_action_aid_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_crawl'.tr()),
              subtitle: Text('pf2e_action_crawl_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_delay'.tr()),
              subtitle: Text('pf2e_action_delay_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_drop_prone'.tr()),
              subtitle: Text('pf2e_action_drop_prone_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_escape'.tr()),
              subtitle: Text('pf2e_action_escape_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_interact'.tr()),
              subtitle: Text('pf2e_action_interact_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_leap'.tr()),
              subtitle: Text('pf2e_action_leap_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_ready'.tr()),
              subtitle: Text('pf2e_action_ready_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_release'.tr()),
              subtitle: Text('pf2e_action_release_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_seek'.tr()),
              subtitle: Text('pf2e_action_seek_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_sense_motive'.tr()),
              subtitle: Text('pf2e_action_sense_motive_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_stand'.tr()),
              subtitle: Text('pf2e_action_stand_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_step'.tr()),
              subtitle: Text('pf2e_action_step_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_stride'.tr()),
              subtitle: Text('pf2e_action_stride_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_strike'.tr()),
              subtitle: Text('pf2e_action_strike_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_action_take_cover'.tr()),
              subtitle: Text('pf2e_action_take_cover_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('specialty_basic_actions'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_specialty_arrest_fall'.tr()),
              subtitle: Text('pf2e_specialty_arrest_fall_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_avert_gaze'.tr()),
              subtitle: Text('pf2e_specialty_avert_gaze_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_burrow'.tr()),
              subtitle: Text('pf2e_specialty_burrow_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_dismiss'.tr()),
              subtitle: Text('pf2e_specialty_dismiss_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_fly'.tr()),
              subtitle: Text('pf2e_specialty_fly_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_grab_edge'.tr()),
              subtitle: Text('pf2e_specialty_grab_edge_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_mount'.tr()),
              subtitle: Text('pf2e_specialty_mount_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_point_out'.tr()),
              subtitle: Text('pf2e_specialty_point_out_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_raise_shield'.tr()),
              subtitle: Text('pf2e_specialty_raise_shield_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_specialty_sustain'.tr()),
              subtitle: Text('pf2e_specialty_sustain_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('common_conditions'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_condition_blinded'.tr()),
              subtitle: Text('pf2e_condition_blinded_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_broken'.tr()),
              subtitle: Text('pf2e_condition_broken_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_clumsy'.tr()),
              subtitle: Text('pf2e_condition_clumsy_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_confused'.tr()),
              subtitle: Text('pf2e_condition_confused_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_controlled'.tr()),
              subtitle: Text('pf2e_condition_controlled_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_dazzled'.tr()),
              subtitle: Text('pf2e_condition_dazzled_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_deafened'.tr()),
              subtitle: Text('pf2e_condition_deafened_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_drained'.tr()),
              subtitle: Text('pf2e_condition_drained_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_encumbered'.tr()),
              subtitle: Text('pf2e_condition_encumbered_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_enfeebled'.tr()),
              subtitle: Text('pf2e_condition_enfeebled_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_fascinated'.tr()),
              subtitle: Text('pf2e_condition_fascinated_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_fatigued'.tr()),
              subtitle: Text('pf2e_condition_fatigued_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_fleeing'.tr()),
              subtitle: Text('pf2e_condition_fleeing_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_frightened'.tr()),
              subtitle: Text('pf2e_condition_frightened_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_grabbed'.tr()),
              subtitle: Text('pf2e_condition_grabbed_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_immobilized'.tr()),
              subtitle: Text('pf2e_condition_immobilized_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_off_guard'.tr()),
              subtitle: Text('pf2e_condition_off_guard_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_paralyzed'.tr()),
              subtitle: Text('pf2e_condition_paralyzed_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_persistent_damage'.tr()),
              subtitle: Text('pf2e_condition_persistent_damage_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_petrified'.tr()),
              subtitle: Text('pf2e_condition_petrified_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_prone'.tr()),
              subtitle: Text('pf2e_condition_prone_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_quickened'.tr()),
              subtitle: Text('pf2e_condition_quickened_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_restrained'.tr()),
              subtitle: Text('pf2e_condition_restrained_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_sickened'.tr()),
              subtitle: Text('pf2e_condition_sickened_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_slowed'.tr()),
              subtitle: Text('pf2e_condition_slowed_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_stunned'.tr()),
              subtitle: Text('pf2e_condition_stunned_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_condition_stupefied'.tr()),
              subtitle: Text('pf2e_condition_stupefied_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('death_and_dying'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_death_knocked_out'.tr()),
              subtitle: Text('pf2e_death_knocked_out_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_death_dying'.tr()),
              subtitle: Text('pf2e_death_dying_desc'.tr()),
            ),
            ExpansionTile(
              title: Text('pf2e_death_recovery_checks'.tr()),
              children: [
                ListTile(
                  title: Text('pf2e_death_recovery_rule'.tr()),
                  subtitle: Text('pf2e_death_recovery_rule_desc'.tr()),
                ),
                ListTile(
                  title: Text('pf2e_death_critical_success'.tr()),
                  subtitle: Text('pf2e_death_critical_success_desc'.tr()),
                ),
                ListTile(
                  title: Text('pf2e_death_success'.tr()),
                  subtitle: Text('pf2e_death_success_desc'.tr()),
                ),
                ListTile(
                  title: Text('pf2e_death_failure'.tr()),
                  subtitle: Text('pf2e_death_failure_desc'.tr()),
                ),
                ListTile(
                  title: Text('pf2e_death_critical_failure'.tr()),
                  subtitle: Text('pf2e_death_critical_failure_desc'.tr()),
                ),
              ],
            ),
            ListTile(
              title: Text('pf2e_death_wounded'.tr()),
              subtitle: Text('pf2e_death_wounded_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_death_doomed'.tr()),
              subtitle: Text('pf2e_death_doomed_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('exploration_activities'.tr()),
          children: [
            ListTile(
              title: Text('avoid_notice'.tr()),
              subtitle: Text('avoid_notice_description'.tr()),
            ),
            ListTile(
              title: Text('defend'.tr()),
              subtitle: Text('defend_description'.tr()),
            ),
            ListTile(
              title: Text('detect_magic'.tr()),
              subtitle: Text('detect_magic_description'.tr()),
            ),
            ListTile(
              title: Text('follow_tracks'.tr()),
              subtitle: Text('follow_tracks_description'.tr()),
            ),
            ListTile(
              title: Text('investigate'.tr()),
              subtitle: Text('investigate_description'.tr()),
            ),
            ListTile(
              title: Text('refocus'.tr()),
              subtitle: Text('refocus_description'.tr()),
            ),
            ListTile(
              title: Text('scout'.tr()),
              subtitle: Text('scout_description'.tr()),
            ),
            ListTile(
              title: Text('search_exploration'.tr()),
              subtitle: Text('search_exploration_description'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('hero_points'.tr()),
          children: [
            ListTile(
              title: Text('spending_hero_points'.tr()),
              subtitle: Text('hero_point_uses'.tr()),
            ),
            ListTile(
              title: Text('gaining_hero_points'.tr()),
              subtitle: Text('hero_point_awards'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('turns_and_rounds'.tr()),
          children: [
            ListTile(
              title: Text('turn_structure'.tr()),
              subtitle: Text('turn_structure_description'.tr()),
            ),
            ListTile(
              title: Text('actions_per_turn'.tr()),
              subtitle: Text('three_actions_one_reaction'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('unconscious_rules'.tr()),
          children: [
            ListTile(
              title: Text('unconscious_condition'.tr()),
              subtitle: Text('unconscious_description_pf2e'.tr()),
            ),
            ListTile(
              title: Text('waking_up'.tr()),
              subtitle: Text('waking_up_description'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}

class _HabilidadesTabPF2e extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('dcs_by_level'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('level'.tr())),
                  DataColumn(label: Text('pf2e_trivial'.tr())),
                  DataColumn(label: Text('pf2e_easy'.tr())),
                  DataColumn(label: Text('pf2e_medium'.tr())),
                  DataColumn(label: Text('pf2e_hard'.tr())),
                  DataColumn(label: Text('pf2e_extreme'.tr())),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('0')), DataCell(Text('10')), DataCell(Text('12')), DataCell(Text('14')), DataCell(Text('16')), DataCell(Text('18'))]),
                  DataRow(cells: [DataCell(Text('1')), DataCell(Text('11')), DataCell(Text('13')), DataCell(Text('15')), DataCell(Text('17')), DataCell(Text('19'))]),
                  DataRow(cells: [DataCell(Text('2')), DataCell(Text('12')), DataCell(Text('14')), DataCell(Text('16')), DataCell(Text('18')), DataCell(Text('20'))]),
                  DataRow(cells: [DataCell(Text('3')), DataCell(Text('13')), DataCell(Text('15')), DataCell(Text('17')), DataCell(Text('19')), DataCell(Text('21'))]),
                  DataRow(cells: [DataCell(Text('4')), DataCell(Text('14')), DataCell(Text('16')), DataCell(Text('18')), DataCell(Text('20')), DataCell(Text('22'))]),
                  DataRow(cells: [DataCell(Text('5')), DataCell(Text('15')), DataCell(Text('17')), DataCell(Text('19')), DataCell(Text('21')), DataCell(Text('23'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('creature_identification'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_creature_id_rules'.tr()),
              subtitle: Text('pf2e_creature_id_rules_desc'.tr()),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('pf2e_creature_type'.tr())),
                DataColumn(label: Text('pf2e_skill_required'.tr())),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_aberration'.tr())),
                  DataCell(Text('pf2e_skill_occultism'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_animal'.tr())),
                  DataCell(Text('pf2e_skill_nature'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_astral'.tr())),
                  DataCell(Text('pf2e_skill_occultism'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_beast'.tr())),
                  DataCell(Text('pf2e_skill_arcana_nature'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_celestial'.tr())),
                  DataCell(Text('pf2e_skill_religion'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_construct'.tr())),
                  DataCell(Text('pf2e_skill_arcana_crafting'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_dragon'.tr())),
                  DataCell(Text('pf2e_skill_arcana'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_dream'.tr())),
                  DataCell(Text('pf2e_skill_occultism'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_elemental'.tr())),
                  DataCell(Text('pf2e_skill_arcana_nature'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_ethereal'.tr())),
                  DataCell(Text('pf2e_skill_occultism'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_fey'.tr())),
                  DataCell(Text('pf2e_skill_nature'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_fiend'.tr())),
                  DataCell(Text('pf2e_skill_religion'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_fungus'.tr())),
                  DataCell(Text('pf2e_skill_nature'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_humanoid'.tr())),
                  DataCell(Text('pf2e_skill_society'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_monitor'.tr())),
                  DataCell(Text('pf2e_skill_religion'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_ooze'.tr())),
                  DataCell(Text('pf2e_skill_occultism'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_plant'.tr())),
                  DataCell(Text('pf2e_skill_nature'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_shade'.tr())),
                  DataCell(Text('pf2e_skill_religion'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_spirit'.tr())),
                  DataCell(Text('pf2e_skill_occultism'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_time'.tr())),
                  DataCell(Text('pf2e_skill_occultism'.tr())),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_creature_undead'.tr())),
                  DataCell(Text('pf2e_skill_religion'.tr())),
                ]),
              ],
            ),
          ],
        ),
        ExpansionTile(
          title: Text('detecting_creatures'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_detection_observed'.tr()),
              subtitle: Text('pf2e_detection_observed_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_detection_concealed'.tr()),
              subtitle: Text('pf2e_detection_concealed_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_detection_hidden'.tr()),
              subtitle: Text('pf2e_detection_hidden_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_detection_undetected'.tr()),
              subtitle: Text('pf2e_detection_undetected_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_detection_unnoticed'.tr()),
              subtitle: Text('pf2e_detection_unnoticed_desc'.tr()),
            ),
            ListTile(
              title: Text('pf2e_detection_invisible'.tr()),
              subtitle: Text('pf2e_detection_invisible_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('earn_income'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_earn_income_rules'.tr()),
              subtitle: Text('pf2e_earn_income_rules_desc'.tr()),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('pf2e_task_level'.tr())),
                DataColumn(label: Text('pf2e_dc'.tr())),
                DataColumn(label: Text('pf2e_failed'.tr())),
                DataColumn(label: Text('pf2e_trained'.tr())),
                DataColumn(label: Text('pf2e_expert'.tr())),
                DataColumn(label: Text('pf2e_master'.tr())),
                DataColumn(label: Text('pf2e_legendary'.tr())),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('0')),
                  DataCell(Text('14')),
                  DataCell(Text('1 cp')),
                  DataCell(Text('5 cp')),
                  DataCell(Text('5 cp')),
                  DataCell(Text('5 cp')),
                  DataCell(Text('5 cp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('1')),
                  DataCell(Text('15')),
                  DataCell(Text('2 cp')),
                  DataCell(Text('2 sp')),
                  DataCell(Text('2 sp')),
                  DataCell(Text('2 sp')),
                  DataCell(Text('2 sp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('2')),
                  DataCell(Text('16')),
                  DataCell(Text('4 cp')),
                  DataCell(Text('3 sp')),
                  DataCell(Text('3 sp')),
                  DataCell(Text('3 sp')),
                  DataCell(Text('3 sp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('3')),
                  DataCell(Text('18')),
                  DataCell(Text('8 cp')),
                  DataCell(Text('5 sp')),
                  DataCell(Text('5 sp')),
                  DataCell(Text('5 sp')),
                  DataCell(Text('5 sp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('4')),
                  DataCell(Text('19')),
                  DataCell(Text('1 sp')),
                  DataCell(Text('7 sp')),
                  DataCell(Text('8 sp')),
                  DataCell(Text('8 sp')),
                  DataCell(Text('8 sp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('5')),
                  DataCell(Text('20')),
                  DataCell(Text('2 sp')),
                  DataCell(Text('9 sp')),
                  DataCell(Text('1 gp')),
                  DataCell(Text('1 gp')),
                  DataCell(Text('1 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('6')),
                  DataCell(Text('22')),
                  DataCell(Text('3 sp')),
                  DataCell(Text('1 gp, 5 sp')),
                  DataCell(Text('2 gp')),
                  DataCell(Text('2 gp')),
                  DataCell(Text('2 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('7')),
                  DataCell(Text('23')),
                  DataCell(Text('4 sp')),
                  DataCell(Text('2 gp')),
                  DataCell(Text('2 gp, 5 sp')),
                  DataCell(Text('2 gp, 5 sp')),
                  DataCell(Text('2 gp, 5 sp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('8')),
                  DataCell(Text('24')),
                  DataCell(Text('5 sp')),
                  DataCell(Text('2 gp, 5 sp')),
                  DataCell(Text('3 gp')),
                  DataCell(Text('3 gp')),
                  DataCell(Text('3 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('9')),
                  DataCell(Text('26')),
                  DataCell(Text('6 sp')),
                  DataCell(Text('3 gp')),
                  DataCell(Text('4 gp')),
                  DataCell(Text('4 gp')),
                  DataCell(Text('4 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('10')),
                  DataCell(Text('27')),
                  DataCell(Text('7 sp')),
                  DataCell(Text('4 gp')),
                  DataCell(Text('5 gp')),
                  DataCell(Text('6 gp')),
                  DataCell(Text('6 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('11')),
                  DataCell(Text('28')),
                  DataCell(Text('8 sp')),
                  DataCell(Text('5 gp')),
                  DataCell(Text('6 gp')),
                  DataCell(Text('8 gp')),
                  DataCell(Text('8 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('12')),
                  DataCell(Text('30')),
                  DataCell(Text('9 sp')),
                  DataCell(Text('6 gp')),
                  DataCell(Text('8 gp')),
                  DataCell(Text('10 gp')),
                  DataCell(Text('10 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('13')),
                  DataCell(Text('31')),
                  DataCell(Text('1 gp')),
                  DataCell(Text('7 gp')),
                  DataCell(Text('10 gp')),
                  DataCell(Text('15 gp')),
                  DataCell(Text('15 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('14')),
                  DataCell(Text('32')),
                  DataCell(Text('1 gp, 5 sp')),
                  DataCell(Text('8 gp')),
                  DataCell(Text('15 gp')),
                  DataCell(Text('20 gp')),
                  DataCell(Text('20 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('15')),
                  DataCell(Text('34')),
                  DataCell(Text('2 gp')),
                  DataCell(Text('10 gp')),
                  DataCell(Text('20 gp')),
                  DataCell(Text('28 gp')),
                  DataCell(Text('28 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('16')),
                  DataCell(Text('35')),
                  DataCell(Text('2 gp, 5 sp')),
                  DataCell(Text('13 gp')),
                  DataCell(Text('25 gp')),
                  DataCell(Text('36 gp')),
                  DataCell(Text('40 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('17')),
                  DataCell(Text('36')),
                  DataCell(Text('3 gp')),
                  DataCell(Text('15 gp')),
                  DataCell(Text('30 gp')),
                  DataCell(Text('45 gp')),
                  DataCell(Text('55 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('18')),
                  DataCell(Text('38')),
                  DataCell(Text('4 gp')),
                  DataCell(Text('20 gp')),
                  DataCell(Text('45 gp')),
                  DataCell(Text('70 gp')),
                  DataCell(Text('90 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('19')),
                  DataCell(Text('39')),
                  DataCell(Text('6 gp')),
                  DataCell(Text('30 gp')),
                  DataCell(Text('60 gp')),
                  DataCell(Text('100 gp')),
                  DataCell(Text('130 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('20')),
                  DataCell(Text('40')),
                  DataCell(Text('8 gp')),
                  DataCell(Text('40 gp')),
                  DataCell(Text('75 gp')),
                  DataCell(Text('150 gp')),
                  DataCell(Text('200 gp')),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_critical_success'.tr())),
                  DataCell(Text('—')),
                  DataCell(Text('—')),
                  DataCell(Text('50 gp')),
                  DataCell(Text('90 gp')),
                  DataCell(Text('175 gp')),
                  DataCell(Text('300 gp')),
                ]),
              ],
            ),
          ],
        ),
        ExpansionTile(
          title: Text('skill_actions'.tr()),
          children: [
            ListTile(
              title: Text('climb_action'.tr()),
              subtitle: Text('climb_dc_description'.tr()),
            ),
            ListTile(
              title: Text('demoralize_action'.tr()),
              subtitle: Text('demoralize_description'.tr()),
            ),
            ListTile(
              title: Text('grapple_action'.tr()),
              subtitle: Text('grapple_description_pf2e'.tr()),
            ),
            ListTile(
              title: Text('hide_action'.tr()),
              subtitle: Text('hide_description'.tr()),
            ),
            ListTile(
              title: Text('sneak_action'.tr()),
              subtitle: Text('sneak_description'.tr()),
            ),
            ListTile(
              title: Text('trip_action'.tr()),
              subtitle: Text('trip_description_pf2e'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('treat_wounds'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_treat_wounds_rules'.tr()),
              subtitle: Text('pf2e_treat_wounds_rules_desc'.tr()),
            ),
            DataTable(
              columns: [
                DataColumn(label: Text('pf2e_proficiency'.tr())),
                DataColumn(label: Text('pf2e_dc'.tr())),
                DataColumn(label: Text('pf2e_success_healing'.tr())),
                DataColumn(label: Text('pf2e_critical_healing'.tr())),
              ],
              rows: [
                DataRow(cells: [
                  DataCell(Text('pf2e_trained'.tr())),
                  DataCell(Text('15')),
                  DataCell(Text('2d8')),
                  DataCell(Text('4d8')),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_expert*'.tr())),
                  DataCell(Text('20')),
                  DataCell(Text('2d8+10')),
                  DataCell(Text('4d8+10')),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_master*'.tr())),
                  DataCell(Text('30')),
                  DataCell(Text('2d8+30')),
                  DataCell(Text('4d8+30')),
                ]),
                DataRow(cells: [
                  DataCell(Text('pf2e_legendary*'.tr())),
                  DataCell(Text('40')),
                  DataCell(Text('2d8+50')),
                  DataCell(Text('4d8+50')),
                ]),
              ],
            ),
            ListTile(
              title: Text('pf2e_treat_wounds_note'.tr()),
              subtitle: Text('pf2e_treat_wounds_note_desc'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}

class _AmbienteTabPF2e extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('pf2e_cover'.tr()),
          children: [
            ListTile(
              title: Text('lesser_cover'.tr()),
              subtitle: Text('lesser_cover_desc'.tr()),
            ),
            ListTile(
              title: Text('greater_cover'.tr()),
              subtitle: Text('greater_cover_desc'.tr()),
            ),
            ListTile(
              title: Text('standard_cover'.tr()),
              subtitle: Text('standard_cover_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('environmental_damage'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pf2e_category'.tr())),
                  DataColumn(label: Text('pf2e_damage'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('pf2e_minor'.tr())),
                    DataCell(Text('1d6-2d6')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_moderate'.tr())),
                    DataCell(Text('4d6-6d6')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_major'.tr())),
                    DataCell(Text('8d6-12d6')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_massive'.tr())),
                    DataCell(Text('16d6-24d6')),
                  ]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('falling_damage'.tr()),
          children: [
            ListTile(
              title: Text('falling_distance'.tr()),
              subtitle: Text('falling_damage_formula'.tr()),
            ),
            ListTile(
              title: Text('maximum_falling_damage'.tr()),
              subtitle: Text('falling_damage_cap'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('force_open'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pf2e_structure'.tr())),
                  DataColumn(label: Text('pf2e_force_open_dc'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('pf2e_stuck_door_window'.tr())),
                    DataCell(Text('15')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_exceptionally_stuck'.tr())),
                    DataCell(Text('20')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_lift_wooden_portcullis'.tr())),
                    DataCell(Text('20')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_lift_iron_portcullis'.tr())),
                    DataCell(Text('30')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_bend_metal_bars'.tr())),
                    DataCell(Text('30')),
                  ]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('structures'.tr()),
          children: [
            // Doors, Gates, and Walls
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_doors_gates_walls'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pf2e_door'.tr())),
                  DataColumn(label: Text('pf2e_climb_dc'.tr())),
                  DataColumn(label: Text('pf2e_hardness_hp_bt'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('pf2e_wood'.tr())),
                    DataCell(Text('20')),
                    DataCell(Text('10, 40 (20)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_stone'.tr())),
                    DataCell(Text('30')),
                    DataCell(Text('14, 56 (28)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_reinforced_wood'.tr())),
                    DataCell(Text('15')),
                    DataCell(Text('15, 60 (30)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_iron'.tr())),
                    DataCell(Text('30')),
                    DataCell(Text('18, 72 (36)')),
                  ]),
                ],
              ),
            ),
            // Walls
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_wall'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pf2e_wall'.tr())),
                  DataColumn(label: Text('pf2e_climb_dc'.tr())),
                  DataColumn(label: Text('pf2e_hardness_hp_bt'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('pf2e_crumbling_masonry'.tr())),
                    DataCell(Text('15')),
                    DataCell(Text('10, 40 (20)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_wooden_slats'.tr())),
                    DataCell(Text('15')),
                    DataCell(Text('10, 40 (20)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_masonry'.tr())),
                    DataCell(Text('20')),
                    DataCell(Text('14, 56 (28)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_hewn_stone'.tr())),
                    DataCell(Text('30')),
                    DataCell(Text('14, 56 (28)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_iron'.tr())),
                    DataCell(Text('40')),
                    DataCell(Text('18, 72 (36)')),
                  ]),
                ],
              ),
            ),
            // Portcullis
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_portcullis'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pf2e_portcullis'.tr())),
                  DataColumn(label: Text('pf2e_climb_dc'.tr())),
                  DataColumn(label: Text('pf2e_hardness_hp_bt'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('pf2e_wood'.tr())),
                    DataCell(Text('10')),
                    DataCell(Text('10, 40 (20)')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_iron'.tr())),
                    DataCell(Text('10')),
                    DataCell(Text('18, 72 (36)')),
                  ]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('temperature'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pf2e_category'.tr())),
                  DataColumn(label: Text('pf2e_temperature'.tr())),
                  DataColumn(label: Text('pf2e_fatigue'.tr())),
                  DataColumn(label: Text('pf2e_damage'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('pf2e_incredible_cold'.tr())),
                    DataCell(Text('-30°F (-62°C)')),
                    DataCell(Text('pf2e_2_hours'.tr())),
                    DataCell(Text('pf2e_moderate_cold_minute'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_extreme_cold'.tr())),
                    DataCell(Text('-79°F to -21°F (-61°C to -29°C)')),
                    DataCell(Text('pf2e_4_hours'.tr())),
                    DataCell(Text('pf2e_minor_cold_10min'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_severe_cold'.tr())),
                    DataCell(Text('-20°F to 12°F (-28°C to -11°C)')),
                    DataCell(Text('pf2e_4_hours'.tr())),
                    DataCell(Text('pf2e_minor_cold_hour'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_mild_cold'.tr())),
                    DataCell(Text('13°F to 32°F (-10°C to 0°C)')),
                    DataCell(Text('pf2e_4_hours'.tr())),
                    DataCell(Text('pf2e_none'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_normal'.tr())),
                    DataCell(Text('33°F to 94°F (1°C to 34°C)')),
                    DataCell(Text('pf2e_8_hours'.tr())),
                    DataCell(Text('pf2e_none'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_mild_heat'.tr())),
                    DataCell(Text('95°F to 104°F (35°C to 40°C)')),
                    DataCell(Text('pf2e_4_hours'.tr())),
                    DataCell(Text('pf2e_none'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_severe_heat'.tr())),
                    DataCell(Text('105°F to 114°F (41°C to 45°C)')),
                    DataCell(Text('pf2e_4_hours'.tr())),
                    DataCell(Text('pf2e_minor_fire_hour'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_extreme_heat'.tr())),
                    DataCell(Text('115°F to 139°F (46°C to 59°C)')),
                    DataCell(Text('pf2e_4_hours'.tr())),
                    DataCell(Text('pf2e_minor_fire_10min'.tr())),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('pf2e_incredible_heat'.tr())),
                    DataCell(Text('140°F+ (60°C+)')),
                    DataCell(Text('pf2e_2_hours'.tr())),
                    DataCell(Text('pf2e_moderate_fire_minute'.tr())),
                  ]),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('pf2e_temperature_note'.tr(), 
                style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('terrain'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Difficult Terrain
                  ListTile(
                    title: Text('pf2e_difficult_terrain'.tr(), 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('pf2e_difficult_terrain_desc'.tr()),
                  ),
                  // Greater Difficult Terrain
                  ListTile(
                    title: Text('pf2e_greater_difficult_terrain'.tr(), 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('pf2e_greater_difficult_terrain_desc'.tr()),
                  ),
                  // Hazardous Terrain
                  ListTile(
                    title: Text('pf2e_hazardous_terrain'.tr(), 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('pf2e_hazardous_terrain_desc'.tr()),
                  ),
                  // Narrow Surface
                  ListTile(
                    title: Text('pf2e_narrow_surface'.tr(), 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('pf2e_narrow_surface_desc'.tr()),
                  ),
                  // Uneven Ground
                  ListTile(
                    title: Text('pf2e_uneven_ground'.tr(), 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('pf2e_uneven_ground_desc'.tr()),
                  ),
                  // Incline
                  ListTile(
                    title: Text('pf2e_incline'.tr(), 
                      style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('pf2e_incline_desc'.tr()),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('travel_speed'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: DataTable(
                columns: [
                  DataColumn(label: Text('pf2e_speed'.tr())),
                  DataColumn(label: Text('pf2e_feet_per_minute'.tr())),
                  DataColumn(label: Text('pf2e_miles_per_hour'.tr())),
                  DataColumn(label: Text('pf2e_miles_per_day'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('10')),
                    DataCell(Text('100')),
                    DataCell(Text('1')),
                    DataCell(Text('8')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('15')),
                    DataCell(Text('150')),
                    DataCell(Text('1-1/2')),
                    DataCell(Text('12')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('20')),
                    DataCell(Text('200')),
                    DataCell(Text('2')),
                    DataCell(Text('16')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('25')),
                    DataCell(Text('250')),
                    DataCell(Text('2-1/2')),
                    DataCell(Text('20')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('30')),
                    DataCell(Text('300')),
                    DataCell(Text('3')),
                    DataCell(Text('24')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('35')),
                    DataCell(Text('350')),
                    DataCell(Text('3-1/2')),
                    DataCell(Text('28')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('40')),
                    DataCell(Text('400')),
                    DataCell(Text('4')),
                    DataCell(Text('32')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('50')),
                    DataCell(Text('500')),
                    DataCell(Text('5')),
                    DataCell(Text('40')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('60')),
                    DataCell(Text('600')),
                    DataCell(Text('6')),
                    DataCell(Text('48')),
                  ]),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GMTabPF2e extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('encounter_budget'.tr()),
          children: [
            // Encounter Budget Table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_encounter_budget'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_threat'.tr())),
                    DataColumn(label: Text('pf2e_xp_budget'.tr())),
                    DataColumn(label: Text('pf2e_character_adjustment'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('pf2e_encounter_trivial'.tr())),
                      DataCell(Text('40 or less')),
                      DataCell(Text('10 or less')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_encounter_low'.tr())),
                      DataCell(Text('60')),
                      DataCell(Text('15')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_encounter_moderate'.tr())),
                      DataCell(Text('80')),
                      DataCell(Text('20')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_encounter_severe'.tr())),
                      DataCell(Text('120')),
                      DataCell(Text('30')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_encounter_extreme'.tr())),
                      DataCell(Text('160')),
                      DataCell(Text('40')),
                    ]),
                  ],
                ),
              ),
            ),
            
            // Creature XP and Role Table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_creature_xp_role'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_creature_level'.tr())),
                    DataColumn(label: Text('pf2e_xp'.tr())),
                    DataColumn(label: Text('pf2e_suggested_role'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Party Level -4')),
                      DataCell(Text('10')),
                      DataCell(Text('pf2e_low_threat_lackey'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level -3')),
                      DataCell(Text('15')),
                      DataCell(Text('pf2e_low_moderate_threat_lackey'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level -2')),
                      DataCell(Text('20')),
                      DataCell(Text('pf2e_any_lackey_standard'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level -1')),
                      DataCell(Text('30')),
                      DataCell(Text('pf2e_any_standard_creature'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party level')),
                      DataCell(Text('40')),
                      DataCell(Text('pf2e_any_standard_moderate_boss'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level +1')),
                      DataCell(Text('60')),
                      DataCell(Text('pf2e_low_moderate_threat_boss'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level +2')),
                      DataCell(Text('80')),
                      DataCell(Text('pf2e_moderate_severe_threat_boss'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level +3')),
                      DataCell(Text('120')),
                      DataCell(Text('pf2e_severe_extreme_threat_boss'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level +4')),
                      DataCell(Text('160')),
                      DataCell(Text('pf2e_extreme_threat_solo_boss'.tr())),
                    ]),
                  ],
                ),
              ),
            ),
            
            // Hazard XP Table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_hazard_xp'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_level'.tr())),
                    DataColumn(label: Text('pf2e_simple_hazard'.tr())),
                    DataColumn(label: Text('pf2e_complex_hazard'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('Party Level -4')),
                      DataCell(Text('2 XP')),
                      DataCell(Text('10 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level -3')),
                      DataCell(Text('3 XP')),
                      DataCell(Text('15 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level -2')),
                      DataCell(Text('4 XP')),
                      DataCell(Text('20 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party Level -1')),
                      DataCell(Text('6 XP')),
                      DataCell(Text('30 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party level')),
                      DataCell(Text('8 XP')),
                      DataCell(Text('40 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party level +1')),
                      DataCell(Text('12 XP')),
                      DataCell(Text('60 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party level +2')),
                      DataCell(Text('16 XP')),
                      DataCell(Text('80 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party level +3')),
                      DataCell(Text('24 XP')),
                      DataCell(Text('120 XP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('Party level +4')),
                      DataCell(Text('30 XP')),
                      DataCell(Text('150 XP')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('creature_numbers'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_level'.tr())),
                    DataColumn(label: Text('pf2e_skill'.tr())),
                    DataColumn(label: Text('pf2e_ac'.tr())),
                    DataColumn(label: Text('pf2e_saves_high'.tr())),
                    DataColumn(label: Text('pf2e_saves_medium'.tr())),
                    DataColumn(label: Text('pf2e_saves_low'.tr())),
                    DataColumn(label: Text('pf2e_hp'.tr())),
                    DataColumn(label: Text('pf2e_strike'.tr())),
                    DataColumn(label: Text('pf2e_spell_dc_attack'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('-1')),
                      DataCell(Text('+5')),
                      DataCell(Text('15')),
                      DataCell(Text('+8')),
                      DataCell(Text('+5')),
                      DataCell(Text('+2')),
                      DataCell(Text('9')),
                      DataCell(Text('+8 for 1d4+1')),
                      DataCell(Text('16/+6')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('0')),
                      DataCell(Text('+6')),
                      DataCell(Text('16')),
                      DataCell(Text('+9')),
                      DataCell(Text('+6')),
                      DataCell(Text('+3')),
                      DataCell(Text('18')),
                      DataCell(Text('+8 for 1d6+2')),
                      DataCell(Text('16/+6')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('1')),
                      DataCell(Text('+7')),
                      DataCell(Text('16')),
                      DataCell(Text('+10')),
                      DataCell(Text('+7')),
                      DataCell(Text('+4')),
                      DataCell(Text('25')),
                      DataCell(Text('+9 for 1d6+3')),
                      DataCell(Text('17/+9')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2')),
                      DataCell(Text('+8')),
                      DataCell(Text('18')),
                      DataCell(Text('+11')),
                      DataCell(Text('+8')),
                      DataCell(Text('+5')),
                      DataCell(Text('38')),
                      DataCell(Text('+11 for 1d10+4')),
                      DataCell(Text('18/+10')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('3')),
                      DataCell(Text('+10')),
                      DataCell(Text('19')),
                      DataCell(Text('+12')),
                      DataCell(Text('+9')),
                      DataCell(Text('+6')),
                      DataCell(Text('55')),
                      DataCell(Text('+12 for 1d10+6')),
                      DataCell(Text('20/+12')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('4')),
                      DataCell(Text('+12')),
                      DataCell(Text('21')),
                      DataCell(Text('+14')),
                      DataCell(Text('+11')),
                      DataCell(Text('+8')),
                      DataCell(Text('75')),
                      DataCell(Text('+14 for 2d8+5')),
                      DataCell(Text('21/+13')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('5')),
                      DataCell(Text('+13')),
                      DataCell(Text('22')),
                      DataCell(Text('+15')),
                      DataCell(Text('+12')),
                      DataCell(Text('+9')),
                      DataCell(Text('95')),
                      DataCell(Text('+15 for 2d8+7')),
                      DataCell(Text('22/+14')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('6')),
                      DataCell(Text('+15')),
                      DataCell(Text('24')),
                      DataCell(Text('+17')),
                      DataCell(Text('+14')),
                      DataCell(Text('+11')),
                      DataCell(Text('120')),
                      DataCell(Text('+17 for 2d8+9')),
                      DataCell(Text('24/+16')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('7')),
                      DataCell(Text('+17')),
                      DataCell(Text('25')),
                      DataCell(Text('+18')),
                      DataCell(Text('+15')),
                      DataCell(Text('+12')),
                      DataCell(Text('145')),
                      DataCell(Text('+18 for 2d10+9')),
                      DataCell(Text('25/+17')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('8')),
                      DataCell(Text('+18')),
                      DataCell(Text('27')),
                      DataCell(Text('+19')),
                      DataCell(Text('+16')),
                      DataCell(Text('+13')),
                      DataCell(Text('170')),
                      DataCell(Text('+20 for 2d10+11')),
                      DataCell(Text('26/+18')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('9')),
                      DataCell(Text('+20')),
                      DataCell(Text('28')),
                      DataCell(Text('+21')),
                      DataCell(Text('+18')),
                      DataCell(Text('+15')),
                      DataCell(Text('195')),
                      DataCell(Text('+21 for 2d10+13')),
                      DataCell(Text('28/+20')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('10')),
                      DataCell(Text('+22')),
                      DataCell(Text('30')),
                      DataCell(Text('+22')),
                      DataCell(Text('+19')),
                      DataCell(Text('+16')),
                      DataCell(Text('220')),
                      DataCell(Text('+23 for 2d12+13')),
                      DataCell(Text('29/+21')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('11')),
                      DataCell(Text('+23')),
                      DataCell(Text('31')),
                      DataCell(Text('+24')),
                      DataCell(Text('+21')),
                      DataCell(Text('+18')),
                      DataCell(Text('245')),
                      DataCell(Text('+24 for 2d12+15')),
                      DataCell(Text('30/+22')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('12')),
                      DataCell(Text('+25')),
                      DataCell(Text('33')),
                      DataCell(Text('+25')),
                      DataCell(Text('+22')),
                      DataCell(Text('+19')),
                      DataCell(Text('270')),
                      DataCell(Text('+26 for 3d10+14')),
                      DataCell(Text('32/+24')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('13')),
                      DataCell(Text('+27')),
                      DataCell(Text('34')),
                      DataCell(Text('+26')),
                      DataCell(Text('+23')),
                      DataCell(Text('+20')),
                      DataCell(Text('295')),
                      DataCell(Text('+27 for 3d10+16')),
                      DataCell(Text('33/+25')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('14')),
                      DataCell(Text('+28')),
                      DataCell(Text('36')),
                      DataCell(Text('+28')),
                      DataCell(Text('+25')),
                      DataCell(Text('+22')),
                      DataCell(Text('320')),
                      DataCell(Text('+29 for 3d10+18')),
                      DataCell(Text('34/+26')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('15')),
                      DataCell(Text('+30')),
                      DataCell(Text('37')),
                      DataCell(Text('+29')),
                      DataCell(Text('+26')),
                      DataCell(Text('+23')),
                      DataCell(Text('345')),
                      DataCell(Text('+30 for 3d12+17')),
                      DataCell(Text('36/+28')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('16')),
                      DataCell(Text('+32')),
                      DataCell(Text('39')),
                      DataCell(Text('+30')),
                      DataCell(Text('+28')),
                      DataCell(Text('+25')),
                      DataCell(Text('370')),
                      DataCell(Text('+32 for 3d12+18')),
                      DataCell(Text('37/+29')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('17')),
                      DataCell(Text('+33')),
                      DataCell(Text('40')),
                      DataCell(Text('+32')),
                      DataCell(Text('+29')),
                      DataCell(Text('+26')),
                      DataCell(Text('395')),
                      DataCell(Text('+33 for 3d12+19')),
                      DataCell(Text('38/+30')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('18')),
                      DataCell(Text('+35')),
                      DataCell(Text('42')),
                      DataCell(Text('+33')),
                      DataCell(Text('+30')),
                      DataCell(Text('+27')),
                      DataCell(Text('420')),
                      DataCell(Text('+35 for 3d12+20')),
                      DataCell(Text('40/+32')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('19')),
                      DataCell(Text('+37')),
                      DataCell(Text('43')),
                      DataCell(Text('+35')),
                      DataCell(Text('+32')),
                      DataCell(Text('+29')),
                      DataCell(Text('445')),
                      DataCell(Text('+36 for 4d10+20')),
                      DataCell(Text('41/+33')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('20')),
                      DataCell(Text('+38')),
                      DataCell(Text('45')),
                      DataCell(Text('+36')),
                      DataCell(Text('+33')),
                      DataCell(Text('+30')),
                      DataCell(Text('470')),
                      DataCell(Text('+38 for 4d10+22')),
                      DataCell(Text('42/+34')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('hazard_numbers'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_hazard_numbers_desc'.tr(), 
                style: TextStyle(fontStyle: FontStyle.italic)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_level'.tr())),
                    DataColumn(label: Text('pf2e_stealth_disable_dc'.tr())),
                    DataColumn(label: Text('pf2e_ac'.tr())),
                    DataColumn(label: Text('pf2e_saves_high'.tr())),
                    DataColumn(label: Text('pf2e_saves_low'.tr())),
                    DataColumn(label: Text('pf2e_hazard_hardness_hp_bt'.tr())),
                    DataColumn(label: Text('pf2e_hazard_attack'.tr())),
                    DataColumn(label: Text('pf2e_damage'.tr())),
                    DataColumn(label: Text('pf2e_hazard_dc'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('-1')),
                      DataCell(Text('15/18')),
                      DataCell(Text('15')),
                      DataCell(Text('+3')),
                      DataCell(Text('+2')),
                      DataCell(Text('3, 12 (6)')),
                      DataCell(Text('+10')),
                      DataCell(Text('2d4+1')),
                      DataCell(Text('16/19')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('0')),
                      DataCell(Text('16/19')),
                      DataCell(Text('16')),
                      DataCell(Text('+9')),
                      DataCell(Text('+3')),
                      DataCell(Text('4, 16 (8)')),
                      DataCell(Text('+11')),
                      DataCell(Text('2d6+3')),
                      DataCell(Text('16/19')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('1')),
                      DataCell(Text('17/20')),
                      DataCell(Text('16')),
                      DataCell(Text('+10')),
                      DataCell(Text('+4')),
                      DataCell(Text('6, 24 (12)')),
                      DataCell(Text('+13')),
                      DataCell(Text('2d6+5')),
                      DataCell(Text('17/20')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2')),
                      DataCell(Text('18/21')),
                      DataCell(Text('18')),
                      DataCell(Text('+11')),
                      DataCell(Text('+5')),
                      DataCell(Text('8, 32 (16)')),
                      DataCell(Text('+14')),
                      DataCell(Text('2d10+7')),
                      DataCell(Text('18/22')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('3')),
                      DataCell(Text('20/23')),
                      DataCell(Text('19')),
                      DataCell(Text('+12')),
                      DataCell(Text('+6')),
                      DataCell(Text('11, 44 (22)')),
                      DataCell(Text('+16')),
                      DataCell(Text('2d10+13')),
                      DataCell(Text('20/23')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('4')),
                      DataCell(Text('22/25')),
                      DataCell(Text('21')),
                      DataCell(Text('+14')),
                      DataCell(Text('+8')),
                      DataCell(Text('12, 48 (24)')),
                      DataCell(Text('+17')),
                      DataCell(Text('4d8+10')),
                      DataCell(Text('21/25')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('5')),
                      DataCell(Text('23/26')),
                      DataCell(Text('22')),
                      DataCell(Text('+15')),
                      DataCell(Text('+9')),
                      DataCell(Text('13, 52 (26)')),
                      DataCell(Text('+19')),
                      DataCell(Text('4d8+14')),
                      DataCell(Text('22/26')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('6')),
                      DataCell(Text('25/28')),
                      DataCell(Text('24')),
                      DataCell(Text('+17')),
                      DataCell(Text('+11')),
                      DataCell(Text('14, 56 (28)')),
                      DataCell(Text('+20')),
                      DataCell(Text('4d8+18')),
                      DataCell(Text('24/27')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('7')),
                      DataCell(Text('27/30')),
                      DataCell(Text('25')),
                      DataCell(Text('+18')),
                      DataCell(Text('+12')),
                      DataCell(Text('15, 60 (30)')),
                      DataCell(Text('+22')),
                      DataCell(Text('4d10+18')),
                      DataCell(Text('25/29')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('8')),
                      DataCell(Text('28/31')),
                      DataCell(Text('27')),
                      DataCell(Text('+19')),
                      DataCell(Text('+13')),
                      DataCell(Text('16, 64 (32)')),
                      DataCell(Text('+23')),
                      DataCell(Text('4d10+22')),
                      DataCell(Text('26/30')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('9')),
                      DataCell(Text('30/33')),
                      DataCell(Text('29')),
                      DataCell(Text('+21')),
                      DataCell(Text('+15')),
                      DataCell(Text('17, 68 (34)')),
                      DataCell(Text('+25')),
                      DataCell(Text('4d10+26')),
                      DataCell(Text('28/32')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('10')),
                      DataCell(Text('32/35')),
                      DataCell(Text('30')),
                      DataCell(Text('+22')),
                      DataCell(Text('+16')),
                      DataCell(Text('18, 72 (36)')),
                      DataCell(Text('+26')),
                      DataCell(Text('4d12+26')),
                      DataCell(Text('29/33')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('11')),
                      DataCell(Text('33/36')),
                      DataCell(Text('31')),
                      DataCell(Text('+24')),
                      DataCell(Text('+18')),
                      DataCell(Text('20, 80 (40)')),
                      DataCell(Text('+28')),
                      DataCell(Text('4d12+30')),
                      DataCell(Text('30/34')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('12')),
                      DataCell(Text('35/38')),
                      DataCell(Text('33')),
                      DataCell(Text('+25')),
                      DataCell(Text('+19')),
                      DataCell(Text('21, 84 (42)')),
                      DataCell(Text('+29')),
                      DataCell(Text('6d10+27')),
                      DataCell(Text('32/36')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('13')),
                      DataCell(Text('37/40')),
                      DataCell(Text('34')),
                      DataCell(Text('+26')),
                      DataCell(Text('+20')),
                      DataCell(Text('22, 88 (44)')),
                      DataCell(Text('+31')),
                      DataCell(Text('6d10+31')),
                      DataCell(Text('33/37')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('14')),
                      DataCell(Text('38/41')),
                      DataCell(Text('36')),
                      DataCell(Text('+28')),
                      DataCell(Text('+22')),
                      DataCell(Text('23, 92 (46)')),
                      DataCell(Text('+32')),
                      DataCell(Text('6d10+35')),
                      DataCell(Text('34/39')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('15')),
                      DataCell(Text('40/43')),
                      DataCell(Text('37')),
                      DataCell(Text('+29')),
                      DataCell(Text('+23')),
                      DataCell(Text('24, 96 (48)')),
                      DataCell(Text('+34')),
                      DataCell(Text('6d12+33')),
                      DataCell(Text('36/40')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('16')),
                      DataCell(Text('42/45')),
                      DataCell(Text('39')),
                      DataCell(Text('+30')),
                      DataCell(Text('+25')),
                      DataCell(Text('26, 104 (52)')),
                      DataCell(Text('+35')),
                      DataCell(Text('6d12+35')),
                      DataCell(Text('37/41')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('17')),
                      DataCell(Text('43/46')),
                      DataCell(Text('40')),
                      DataCell(Text('+32')),
                      DataCell(Text('+26')),
                      DataCell(Text('28, 112 (56)')),
                      DataCell(Text('+37')),
                      DataCell(Text('6d12+37')),
                      DataCell(Text('38/43')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('18')),
                      DataCell(Text('45/48')),
                      DataCell(Text('42')),
                      DataCell(Text('+33')),
                      DataCell(Text('+27')),
                      DataCell(Text('30, 120 (60)')),
                      DataCell(Text('+38')),
                      DataCell(Text('6d12+41')),
                      DataCell(Text('40/44')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('19')),
                      DataCell(Text('47/50')),
                      DataCell(Text('43')),
                      DataCell(Text('+35')),
                      DataCell(Text('+29')),
                      DataCell(Text('32, 128 (64)')),
                      DataCell(Text('+40')),
                      DataCell(Text('8d10+40')),
                      DataCell(Text('41/46')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('20')),
                      DataCell(Text('48/51')),
                      DataCell(Text('45')),
                      DataCell(Text('+36')),
                      DataCell(Text('+30')),
                      DataCell(Text('34, 136 (68)')),
                      DataCell(Text('+41')),
                      DataCell(Text('8d10+44')),
                      DataCell(Text('42/47')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('reputation'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_type'.tr())),
                    DataColumn(label: Text('pf2e_minor'.tr())),
                    DataColumn(label: Text('pf2e_moderate'.tr())),
                    DataColumn(label: Text('pf2e_major'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('pf2e_favor'.tr())),
                      DataCell(Text('+1 RP')),
                      DataCell(Text('+2 RP')),
                      DataCell(Text('+5 RP')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_disservice'.tr())),
                      DataCell(Text('-1 RP')),
                      DataCell(Text('-2 RP')),
                      DataCell(Text('-5 RP or more')),
                    ]),
                  ],
                ),
              ),
            ),
            
            // Reputation Scale Table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_reputation_scale'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_reputation_status'.tr())),
                    DataColumn(label: Text('pf2e_reputation_points'.tr())),
                    DataColumn(label: Text('pf2e_raised_by'.tr())),
                    DataColumn(label: Text('pf2e_lowered_by'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('pf2e_revered'.tr())),
                      DataCell(Text('30 to 50')),
                      DataCell(Text('pf2e_major_favor'.tr())),
                      DataCell(Text('pf2e_moderate_major_disservice'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_admired'.tr())),
                      DataCell(Text('15 to 29')),
                      DataCell(Text('pf2e_major_favor'.tr())),
                      DataCell(Text('pf2e_any_disservice'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_liked'.tr())),
                      DataCell(Text('5 to 14')),
                      DataCell(Text('pf2e_moderate_major_favor'.tr())),
                      DataCell(Text('pf2e_any_disservice'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_ignored'.tr())),
                      DataCell(Text('-4 to 4')),
                      DataCell(Text('pf2e_any_favor'.tr())),
                      DataCell(Text('pf2e_any_disservice'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_disliked'.tr())),
                      DataCell(Text('-5 to -14')),
                      DataCell(Text('pf2e_any_favor'.tr())),
                      DataCell(Text('pf2e_moderate_major_disservice'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_hated'.tr())),
                      DataCell(Text('-15 to -29')),
                      DataCell(Text('pf2e_any_favor'.tr())),
                      DataCell(Text('pf2e_major_disservice'.tr())),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_hunted'.tr())),
                      DataCell(Text('-30 to -50')),
                      DataCell(Text('pf2e_moderate_major_favor'.tr())),
                      DataCell(Text('pf2e_major_disservice'.tr())),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('treasure_by_encounter'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_level'.tr())),
                    DataColumn(label: Text('pf2e_total_treasure_per_level'.tr())),
                    DataColumn(label: Text('pf2e_encounter_low'.tr())),
                    DataColumn(label: Text('pf2e_encounter_moderate'.tr())),
                    DataColumn(label: Text('pf2e_encounter_severe'.tr())),
                    DataColumn(label: Text('pf2e_encounter_extreme'.tr())),
                    DataColumn(label: Text('pf2e_extra_treasure'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('1')),
                      DataCell(Text('175 gp')),
                      DataCell(Text('13 gp')),
                      DataCell(Text('18 gp')),
                      DataCell(Text('26 gp')),
                      DataCell(Text('35 gp')),
                      DataCell(Text('35 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2')),
                      DataCell(Text('300 gp')),
                      DataCell(Text('23 gp')),
                      DataCell(Text('30 gp')),
                      DataCell(Text('45 gp')),
                      DataCell(Text('60 gp')),
                      DataCell(Text('60 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('3')),
                      DataCell(Text('500 gp')),
                      DataCell(Text('38 gp')),
                      DataCell(Text('50 gp')),
                      DataCell(Text('75 gp')),
                      DataCell(Text('100 gp')),
                      DataCell(Text('100 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('4')),
                      DataCell(Text('850 gp')),
                      DataCell(Text('65 gp')),
                      DataCell(Text('85 gp')),
                      DataCell(Text('130 gp')),
                      DataCell(Text('170 gp')),
                      DataCell(Text('170 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('5')),
                      DataCell(Text('1,350 gp')),
                      DataCell(Text('100 gp')),
                      DataCell(Text('135 gp')),
                      DataCell(Text('200 gp')),
                      DataCell(Text('270 gp')),
                      DataCell(Text('270 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('6')),
                      DataCell(Text('2,000 gp')),
                      DataCell(Text('150 gp')),
                      DataCell(Text('200 gp')),
                      DataCell(Text('300 gp')),
                      DataCell(Text('400 gp')),
                      DataCell(Text('400 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('7')),
                      DataCell(Text('2,900 gp')),
                      DataCell(Text('220 gp')),
                      DataCell(Text('290 gp')),
                      DataCell(Text('440 gp')),
                      DataCell(Text('580 gp')),
                      DataCell(Text('580 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('8')),
                      DataCell(Text('4,000 gp')),
                      DataCell(Text('300 gp')),
                      DataCell(Text('400 gp')),
                      DataCell(Text('600 gp')),
                      DataCell(Text('800 gp')),
                      DataCell(Text('800 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('9')),
                      DataCell(Text('5,700 gp')),
                      DataCell(Text('430 gp')),
                      DataCell(Text('570 gp')),
                      DataCell(Text('860 gp')),
                      DataCell(Text('1,140 gp')),
                      DataCell(Text('1,140 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('10')),
                      DataCell(Text('8,000 gp')),
                      DataCell(Text('600 gp')),
                      DataCell(Text('800 gp')),
                      DataCell(Text('1,200 gp')),
                      DataCell(Text('1,600 gp')),
                      DataCell(Text('1,600 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('11')),
                      DataCell(Text('11,500 gp')),
                      DataCell(Text('865 gp')),
                      DataCell(Text('1,150 gp')),
                      DataCell(Text('1,725 gp')),
                      DataCell(Text('2,300 gp')),
                      DataCell(Text('2,300 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('12')),
                      DataCell(Text('16,500 gp')),
                      DataCell(Text('1,250 gp')),
                      DataCell(Text('1,650 gp')),
                      DataCell(Text('2,475 gp')),
                      DataCell(Text('3,300 gp')),
                      DataCell(Text('3,300 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('13')),
                      DataCell(Text('25,000 gp')),
                      DataCell(Text('1,875 gp')),
                      DataCell(Text('2,500 gp')),
                      DataCell(Text('3,750 gp')),
                      DataCell(Text('5,000 gp')),
                      DataCell(Text('5,000 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('14')),
                      DataCell(Text('36,500 gp')),
                      DataCell(Text('2,750 gp')),
                      DataCell(Text('3,650 gp')),
                      DataCell(Text('5,500 gp')),
                      DataCell(Text('7,300 gp')),
                      DataCell(Text('7,300 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('15')),
                      DataCell(Text('54,500 gp')),
                      DataCell(Text('4,100 gp')),
                      DataCell(Text('5,450 gp')),
                      DataCell(Text('8,200 gp')),
                      DataCell(Text('10,900 gp')),
                      DataCell(Text('10,900 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('16')),
                      DataCell(Text('82,500 gp')),
                      DataCell(Text('6,200 gp')),
                      DataCell(Text('8,250 gp')),
                      DataCell(Text('12,400 gp')),
                      DataCell(Text('16,500 gp')),
                      DataCell(Text('16,500 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('17')),
                      DataCell(Text('128,000 gp')),
                      DataCell(Text('9,600 gp')),
                      DataCell(Text('12,800 gp')),
                      DataCell(Text('19,200 gp')),
                      DataCell(Text('25,600 gp')),
                      DataCell(Text('25,600 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('18')),
                      DataCell(Text('208,000 gp')),
                      DataCell(Text('15,600 gp')),
                      DataCell(Text('20,800 gp')),
                      DataCell(Text('31,200 gp')),
                      DataCell(Text('41,600 gp')),
                      DataCell(Text('41,600 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('19')),
                      DataCell(Text('355,000 gp')),
                      DataCell(Text('26,600 gp')),
                      DataCell(Text('35,500 gp')),
                      DataCell(Text('53,250 gp')),
                      DataCell(Text('71,000 gp')),
                      DataCell(Text('71,000 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('20')),
                      DataCell(Text('490,000 gp')),
                      DataCell(Text('36,800 gp')),
                      DataCell(Text('49,000 gp')),
                      DataCell(Text('73,500 gp')),
                      DataCell(Text('98,000 gp')),
                      DataCell(Text('98,000 gp')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('treasure_by_level'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_level'.tr())),
                    DataColumn(label: Text('pf2e_total_value'.tr())),
                    DataColumn(label: Text('pf2e_permanent_items_level'.tr())),
                    DataColumn(label: Text('pf2e_consumables_level'.tr())),
                    DataColumn(label: Text('pf2e_party_currency'.tr())),
                    DataColumn(label: Text('pf2e_currency_per_additional_pc'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('1')),
                      DataCell(Text('175 gp')),
                      DataCell(Text('2nd: 2, 1st: 2')),
                      DataCell(Text('2nd: 2, 1st: 3')),
                      DataCell(Text('40 gp')),
                      DataCell(Text('10 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('2')),
                      DataCell(Text('300 gp')),
                      DataCell(Text('3rd: 2, 2nd: 2')),
                      DataCell(Text('3rd: 2, 2nd: 2, 1st: 2')),
                      DataCell(Text('70 gp')),
                      DataCell(Text('18 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('3')),
                      DataCell(Text('500 gp')),
                      DataCell(Text('4th: 2, 3rd: 2')),
                      DataCell(Text('4th: 2, 3rd: 2, 2nd: 2')),
                      DataCell(Text('120 gp')),
                      DataCell(Text('30 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('4')),
                      DataCell(Text('850 gp')),
                      DataCell(Text('5th: 2, 4th: 2')),
                      DataCell(Text('5th: 2, 4th: 2, 3rd: 2')),
                      DataCell(Text('200 gp')),
                      DataCell(Text('50 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('5')),
                      DataCell(Text('1,350 gp')),
                      DataCell(Text('6th: 2, 5th: 2')),
                      DataCell(Text('6th: 2, 5th: 2, 4th: 2')),
                      DataCell(Text('320 gp')),
                      DataCell(Text('80 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('6')),
                      DataCell(Text('2,000 gp')),
                      DataCell(Text('7th: 2, 6th: 2')),
                      DataCell(Text('7th: 2, 6th: 2, 5th: 2')),
                      DataCell(Text('500 gp')),
                      DataCell(Text('125 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('7')),
                      DataCell(Text('2,900 gp')),
                      DataCell(Text('8th: 2, 7th: 2')),
                      DataCell(Text('8th: 2, 7th: 2, 6th: 2')),
                      DataCell(Text('720 gp')),
                      DataCell(Text('180 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('8')),
                      DataCell(Text('4,000 gp')),
                      DataCell(Text('9th: 2, 8th: 2')),
                      DataCell(Text('9th: 2, 8th: 2, 7th: 2')),
                      DataCell(Text('1,000 gp')),
                      DataCell(Text('250 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('9')),
                      DataCell(Text('5,700 gp')),
                      DataCell(Text('10th: 2, 9th: 2')),
                      DataCell(Text('10th: 2, 9th: 2, 8th: 2')),
                      DataCell(Text('1,400 gp')),
                      DataCell(Text('350 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('10')),
                      DataCell(Text('8,000 gp')),
                      DataCell(Text('11th: 2, 10th: 2')),
                      DataCell(Text('11th: 2, 10th: 2, 9th: 2')),
                      DataCell(Text('2,000 gp')),
                      DataCell(Text('500 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('11')),
                      DataCell(Text('11,500 gp')),
                      DataCell(Text('12th: 2, 11th: 2')),
                      DataCell(Text('12th: 2, 11th: 2, 10th: 2')),
                      DataCell(Text('2,800 gp')),
                      DataCell(Text('700 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('12')),
                      DataCell(Text('16,500 gp')),
                      DataCell(Text('13th: 2, 12th: 2')),
                      DataCell(Text('13th: 2, 12th: 2, 11th: 2')),
                      DataCell(Text('4,000 gp')),
                      DataCell(Text('1,000 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('13')),
                      DataCell(Text('25,000 gp')),
                      DataCell(Text('14th: 2, 13th: 2')),
                      DataCell(Text('14th: 2, 13th: 2, 12th: 2')),
                      DataCell(Text('6,000 gp')),
                      DataCell(Text('1,500 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('14')),
                      DataCell(Text('36,500 gp')),
                      DataCell(Text('15th: 2, 14th: 2')),
                      DataCell(Text('15th: 2, 14th: 2, 13th: 2')),
                      DataCell(Text('9,000 gp')),
                      DataCell(Text('2,250 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('15')),
                      DataCell(Text('54,500 gp')),
                      DataCell(Text('16th: 2, 15th: 2')),
                      DataCell(Text('16th: 2, 15th: 2, 14th: 2')),
                      DataCell(Text('13,000 gp')),
                      DataCell(Text('3,250 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('16')),
                      DataCell(Text('82,500 gp')),
                      DataCell(Text('17th: 2, 16th: 2')),
                      DataCell(Text('17th: 2, 16th: 2, 15th: 2')),
                      DataCell(Text('20,000 gp')),
                      DataCell(Text('5,000 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('17')),
                      DataCell(Text('128,000 gp')),
                      DataCell(Text('18th: 2, 17th: 2')),
                      DataCell(Text('18th: 2, 17th: 2, 16th: 2')),
                      DataCell(Text('30,000 gp')),
                      DataCell(Text('7,500 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('18')),
                      DataCell(Text('208,000 gp')),
                      DataCell(Text('19th: 2, 18th: 2')),
                      DataCell(Text('19th: 2, 18th: 2, 17th: 2')),
                      DataCell(Text('48,000 gp')),
                      DataCell(Text('12,000 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('19')),
                      DataCell(Text('355,000 gp')),
                      DataCell(Text('20th: 2, 19th: 2')),
                      DataCell(Text('20th: 2, 19th: 2, 18th: 2')),
                      DataCell(Text('80,000 gp')),
                      DataCell(Text('20,000 gp')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('20')),
                      DataCell(Text('490,000 gp')),
                      DataCell(Text('20th: 4')),
                      DataCell(Text('20th: 4, 19th: 2')),
                      DataCell(Text('140,000 gp')),
                      DataCell(Text('35,000 gp')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('victory_points'.tr()),
          children: [
            // Accumulating Rolls Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_accumulating_rolls'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('pf2e_accumulating_critical_success'.tr()),
                  Text('pf2e_accumulating_success'.tr()),
                  Text('pf2e_accumulating_critical_failure'.tr()),
                ],
              ),
            ),
            
            // Diminishing Rolls Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_diminishing_rolls'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('pf2e_diminishing_critical_success'.tr()),
                  Text('pf2e_diminishing_success'.tr()),
                  Text('pf2e_diminishing_failure'.tr()),
                  Text('pf2e_diminishing_critical_failure'.tr()),
                ],
              ),
            ),
            
            // Victory Point Scales Table
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('pf2e_victory_point_scales'.tr(), 
                style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: DataTable(
                  columns: [
                    DataColumn(label: Text('pf2e_duration_challenge'.tr())),
                    DataColumn(label: Text('pf2e_vp_end_point'.tr())),
                    DataColumn(label: Text('pf2e_vp_thresholds'.tr())),
                  ],
                  rows: [
                    DataRow(cells: [
                      DataCell(Text('pf2e_quick_encounter'.tr())),
                      DataCell(Text('3-5')),
                      DataCell(Text('—')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_long_encounter'.tr())),
                      DataCell(Text('7-10')),
                      DataCell(Text('4')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_most_session'.tr())),
                      DataCell(Text('15-25')),
                      DataCell(Text('5, 10, 15')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_adventure_wide_sideline'.tr())),
                      DataCell(Text('15-20')),
                      DataCell(Text('5, 10, 15')),
                    ]),
                    DataRow(cells: [
                      DataCell(Text('pf2e_adventure_wide_forefront'.tr())),
                      DataCell(Text('25-50')),
                      DataCell(Text('10, 20, 30, 40')),
                    ]),
                  ],
                ),
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('xp_awards'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("pf2e_accomplishment_awards".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_accomplishment".tr())),
                        DataColumn(label: Text("pf2e_xp_award".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("pf2e_minor".tr())),
                          DataCell(Text("10 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_moderate".tr())),
                          DataCell(Text("30 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_major".tr())),
                          DataCell(Text("80 XP")),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text("pf2e_accomplishment_note".tr(), 
                       style: const TextStyle(fontStyle: FontStyle.italic)),
                  const SizedBox(height: 16),
                  Text("pf2e_adversary_level_awards".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_adversary_level".tr())),
                        DataColumn(label: Text("pf2e_xp_award".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_4".tr())),
                          DataCell(Text("10 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_3".tr())),
                          DataCell(Text("15 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_2".tr())),
                          DataCell(Text("20 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_1".tr())),
                          DataCell(Text("30 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level".tr())),
                          DataCell(Text("40 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_1".tr())),
                          DataCell(Text("60 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_2".tr())),
                          DataCell(Text("80 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_3".tr())),
                          DataCell(Text("120 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_4".tr())),
                          DataCell(Text("160 XP")),
                        ]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text("pf2e_hazard_awards".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_level".tr())),
                        DataColumn(label: Text("pf2e_simple_hazard".tr())),
                        DataColumn(label: Text("pf2e_complex_hazard".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_4".tr())),
                          DataCell(Text("2 XP")),
                          DataCell(Text("10 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_3".tr())),
                          DataCell(Text("3 XP")),
                          DataCell(Text("15 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_2".tr())),
                          DataCell(Text("4 XP")),
                          DataCell(Text("20 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_minus_1".tr())),
                          DataCell(Text("6 XP")),
                          DataCell(Text("30 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level".tr())),
                          DataCell(Text("8 XP")),
                          DataCell(Text("40 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_1".tr())),
                          DataCell(Text("12 XP")),
                          DataCell(Text("60 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_2".tr())),
                          DataCell(Text("16 XP")),
                          DataCell(Text("80 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_3".tr())),
                          DataCell(Text("24 XP")),
                          DataCell(Text("120 XP")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_party_level_plus_4".tr())),
                          DataCell(Text("32 XP")),
                          DataCell(Text("160 XP")),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('elite_weak_adjustments'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Elite Adjustment Section
                  Text("pf2e_elite_adjustment".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("pf2e_elite_rules".tr()),
                  const SizedBox(height: 4),
                  Text("pf2e_elite_rule_1".tr()),
                  Text("pf2e_elite_rule_2".tr()),
                  Text("pf2e_elite_rule_3".tr()),
                  const SizedBox(height: 8),
                  
                  // Elite HP Table
                  Text("pf2e_elite_hp_table".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_starting_level".tr())),
                        DataColumn(label: Text("pf2e_hp_increase".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("pf2e_level_1_or_lower".tr())),
                          DataCell(Text("10")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("2-4")),
                          DataCell(Text("15")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("5-19")),
                          DataCell(Text("20")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("20+")),
                          DataCell(Text("30")),
                        ]),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Weak Adjustment Section
                  Text("pf2e_weak_adjustment".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text("pf2e_weak_rules".tr()),
                  const SizedBox(height: 4),
                  Text("pf2e_weak_rule_1".tr()),
                  Text("pf2e_weak_rule_2".tr()),
                  Text("pf2e_weak_rule_3".tr()),
                  const SizedBox(height: 8),
                  
                  // Weak HP Table
                  Text("pf2e_weak_hp_table".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_starting_level".tr())),
                        DataColumn(label: Text("pf2e_hp_decrease".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("1-2")),
                          DataCell(Text("-10")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("3-5")),
                          DataCell(Text("-15")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("6-20")),
                          DataCell(Text("-20")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("21+")),
                          DataCell(Text("-30")),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ReferenceTabPF2e extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('pf2e_dc_adjustments'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("pf2e_dc_adjustments_rules".tr()),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_difficulty".tr())),
                        DataColumn(label: Text("pf2e_adjustment".tr())),
                        DataColumn(label: Text("pf2e_rarity".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("pf2e_incredibly_easy".tr())),
                          DataCell(Text("-10")),
                          DataCell(Text("-")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_very_easy".tr())),
                          DataCell(Text("-5")),
                          DataCell(Text("-")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_dc_easy".tr())),
                          DataCell(Text("-2")),
                          DataCell(Text("-")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_dc_hard".tr())),
                          DataCell(Text("+2")),
                          DataCell(Text("pf2e_uncommon".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_very_hard".tr())),
                          DataCell(Text("+5")),
                          DataCell(Text("pf2e_rare".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_incredibly_hard".tr())),
                          DataCell(Text("+10")),
                          DataCell(Text("pf2e_unique".tr())),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('pf2e_dcs_by_level'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("pf2e_dcs_by_level_rules".tr()),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_level".tr())),
                        DataColumn(label: Text("pf2e_dc".tr())),
                        DataColumn(label: Text("pf2e_spell_rank".tr())),
                        DataColumn(label: Text("pf2e_dc".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("0")),
                          DataCell(Text("14")),
                          DataCell(Text("1st")),
                          DataCell(Text("15")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("1")),
                          DataCell(Text("15")),
                          DataCell(Text("2nd")),
                          DataCell(Text("18")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("2")),
                          DataCell(Text("16")),
                          DataCell(Text("3rd")),
                          DataCell(Text("20")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("3")),
                          DataCell(Text("18")),
                          DataCell(Text("4th")),
                          DataCell(Text("23")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("4")),
                          DataCell(Text("19")),
                          DataCell(Text("5th")),
                          DataCell(Text("26")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("5")),
                          DataCell(Text("20")),
                          DataCell(Text("6th")),
                          DataCell(Text("28")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("6")),
                          DataCell(Text("22")),
                          DataCell(Text("7th")),
                          DataCell(Text("31")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("7")),
                          DataCell(Text("23")),
                          DataCell(Text("8th")),
                          DataCell(Text("34")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("8")),
                          DataCell(Text("24")),
                          DataCell(Text("9th")),
                          DataCell(Text("36")),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("9")),
                          DataCell(Text("26")),
                          DataCell(Text("10th")),
                          DataCell(Text("39")),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('simple_dcs'.tr()),
          children: [
            ListTile(
              title: Text('untrained_dc'.tr()),
              subtitle: Text('dc_10'.tr()),
            ),
            ListTile(
              title: Text('trained_dc'.tr()),
              subtitle: Text('dc_15'.tr()),
            ),
            ListTile(
              title: Text('expert_dc'.tr()),
              subtitle: Text('dc_20'.tr()),
            ),
            ListTile(
              title: Text('master_dc'.tr()),
              subtitle: Text('dc_30'.tr()),
            ),
            ListTile(
              title: Text('legendary_dc'.tr()),
              subtitle: Text('dc_40'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('material_statistics'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("pf2e_material_hardness_hp_bt".tr(), 
                       style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text("pf2e_material".tr())),
                        DataColumn(label: Text("pf2e_hardness".tr())),
                        DataColumn(label: Text("pf2e_hp".tr())),
                        DataColumn(label: Text("pf2e_bt".tr())),
                        DataColumn(label: Text("pf2e_example_items".tr())),
                      ],
                      rows: [
                        DataRow(cells: [
                          DataCell(Text("pf2e_paper".tr())),
                          DataCell(Text("0")),
                          DataCell(Text("1")),
                          DataCell(Text("—")),
                          DataCell(Text("pf2e_paper_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_thin_cloth".tr())),
                          DataCell(Text("0")),
                          DataCell(Text("1")),
                          DataCell(Text("—")),
                          DataCell(Text("pf2e_cloth_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_thin_glass".tr())),
                          DataCell(Text("0")),
                          DataCell(Text("1")),
                          DataCell(Text("—")),
                          DataCell(Text("pf2e_glass_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_cloth".tr())),
                          DataCell(Text("1")),
                          DataCell(Text("4")),
                          DataCell(Text("2")),
                          DataCell(Text("pf2e_cloth_heavy_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_glass".tr())),
                          DataCell(Text("1")),
                          DataCell(Text("2")),
                          DataCell(Text("1")),
                          DataCell(Text("pf2e_glass_heavy_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_glass_structure".tr())),
                          DataCell(Text("2")),
                          DataCell(Text("8")),
                          DataCell(Text("4")),
                          DataCell(Text("pf2e_glass_structure_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_thin_leather".tr())),
                          DataCell(Text("2")),
                          DataCell(Text("8")),
                          DataCell(Text("4")),
                          DataCell(Text("pf2e_leather_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_thin_rope".tr())),
                          DataCell(Text("2")),
                          DataCell(Text("8")),
                          DataCell(Text("4")),
                          DataCell(Text("pf2e_rope_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_thin_wood".tr())),
                          DataCell(Text("3")),
                          DataCell(Text("12")),
                          DataCell(Text("6")),
                          DataCell(Text("pf2e_wood_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_leather".tr())),
                          DataCell(Text("4")),
                          DataCell(Text("16")),
                          DataCell(Text("8")),
                          DataCell(Text("pf2e_leather_heavy_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_rope".tr())),
                          DataCell(Text("4")),
                          DataCell(Text("16")),
                          DataCell(Text("8")),
                          DataCell(Text("pf2e_rope_heavy_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_thin_stone".tr())),
                          DataCell(Text("5")),
                          DataCell(Text("16")),
                          DataCell(Text("8")),
                          DataCell(Text("pf2e_stone_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_thin_iron_steel".tr())),
                          DataCell(Text("5")),
                          DataCell(Text("20")),
                          DataCell(Text("10")),
                          DataCell(Text("pf2e_iron_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_wood_heavy".tr())),
                          DataCell(Text("5")),
                          DataCell(Text("20")),
                          DataCell(Text("10")),
                          DataCell(Text("pf2e_wood_heavy_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_stone_heavy".tr())),
                          DataCell(Text("7")),
                          DataCell(Text("28")),
                          DataCell(Text("14")),
                          DataCell(Text("pf2e_stone_heavy_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_iron_steel".tr())),
                          DataCell(Text("9")),
                          DataCell(Text("36")),
                          DataCell(Text("18")),
                          DataCell(Text("pf2e_iron_heavy_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_wooden_structure".tr())),
                          DataCell(Text("10")),
                          DataCell(Text("40")),
                          DataCell(Text("20")),
                          DataCell(Text("pf2e_wooden_structure_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_stone_structure".tr())),
                          DataCell(Text("14")),
                          DataCell(Text("56")),
                          DataCell(Text("28")),
                          DataCell(Text("pf2e_stone_structure_examples".tr())),
                        ]),
                        DataRow(cells: [
                          DataCell(Text("pf2e_iron_steel_structure".tr())),
                          DataCell(Text("18")),
                          DataCell(Text("72")),
                          DataCell(Text("36")),
                          DataCell(Text("pf2e_iron_structure_examples".tr())),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('specific_skill_dcs'.tr()),
          children: [
            ListTile(
              title: Text('pf2e_craft_skill'.tr()),
              subtitle: Text('pf2e_craft_dc_rule'.tr()),
            ),
            ListTile(
              title: Text('pf2e_earn_income_tasks'.tr()),
              subtitle: Text('pf2e_earn_income_dc_rule'.tr()),
            ),
            ListTile(
              title: Text('pf2e_gather_information'.tr()),
              subtitle: Text('pf2e_gather_information_dc_rule'.tr()),
            ),
            ListTile(
              title: Text('pf2e_identify_magic_learn_spell'.tr()),
              subtitle: Text('pf2e_identify_magic_dc_rule'.tr()),
            ),
            ListTile(
              title: Text('pf2e_recall_knowledge'.tr()),
              subtitle: Text('pf2e_recall_knowledge_dc_rule'.tr()),
            ),
            ListTile(
              title: Text('pf2e_sense_direction'.tr()),
              subtitle: Text('pf2e_sense_direction_dc_rule'.tr()),
            ),
            ListTile(
              title: Text('pf2e_social_skills'.tr()),
              subtitle: Text('pf2e_social_skills_dc_rule'.tr()),
            ),
            ListTile(
              title: Text('pf2e_track_skill'.tr()),
              subtitle: Text('pf2e_track_dc_rule'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('weapon_traits'.tr()),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // First set of traits (A-C)
                    ListTile(
                      title: Text('pf2e_agile_trait'.tr()),
                      subtitle: Text('pf2e_agile_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_alchemical_trait'.tr()),
                      subtitle: Text('pf2e_alchemical_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_attached_trait'.tr()),
                      subtitle: Text('pf2e_attached_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_backstabber_trait'.tr()),
                      subtitle: Text('pf2e_backstabber_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_backswing_trait'.tr()),
                      subtitle: Text('pf2e_backswing_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_brace_trait'.tr()),
                      subtitle: Text('pf2e_brace_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_brutal_trait'.tr()),
                      subtitle: Text('pf2e_brutal_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_capacity_trait'.tr()),
                      subtitle: Text('pf2e_capacity_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_climbing_trait'.tr()),
                      subtitle: Text('pf2e_climbing_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_clockwork_trait'.tr()),
                      subtitle: Text('pf2e_clockwork_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_cobbled_trait'.tr()),
                      subtitle: Text('pf2e_cobbled_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_combination_trait'.tr()),
                      subtitle: Text('pf2e_combination_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_concealable_trait'.tr()),
                      subtitle: Text('pf2e_concealable_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_concussive_trait'.tr()),
                      subtitle: Text('pf2e_concussive_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_critical_fusion_trait'.tr()),
                      subtitle: Text('pf2e_critical_fusion_description'.tr()),
                    ),
                    
                    // D-F traits
                    ListTile(
                      title: Text('pf2e_deadly_trait'.tr()),
                      subtitle: Text('pf2e_deadly_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_disarm_trait'.tr()),
                      subtitle: Text('pf2e_disarm_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_double_barrel_trait'.tr()),
                      subtitle: Text('pf2e_double_barrel_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_fatal_trait'.tr()),
                      subtitle: Text('pf2e_fatal_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_fatal_aim_trait'.tr()),
                      subtitle: Text('pf2e_fatal_aim_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_finesse_trait'.tr()),
                      subtitle: Text('pf2e_finesse_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_forceful_trait'.tr()),
                      subtitle: Text('pf2e_forceful_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_free_hand_trait'.tr()),
                      subtitle: Text('pf2e_free_hand_description'.tr()),
                    ),
                    
                    // G-N traits
                    ListTile(
                      title: Text('pf2e_grapple_trait'.tr()),
                      subtitle: Text('pf2e_grapple_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_hampering_trait'.tr()),
                      subtitle: Text('pf2e_hampering_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_injection_trait'.tr()),
                      subtitle: Text('pf2e_injection_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_jousting_trait'.tr()),
                      subtitle: Text('pf2e_jousting_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_kickback_trait'.tr()),
                      subtitle: Text('pf2e_kickback_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_modular_trait'.tr()),
                      subtitle: Text('pf2e_modular_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_nonlethal_trait'.tr()),
                      subtitle: Text('pf2e_nonlethal_description'.tr()),
                    ),
                    
                    // P-R traits
                    ListTile(
                      title: Text('pf2e_parry_trait'.tr()),
                      subtitle: Text('pf2e_parry_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_propulsive_trait'.tr()),
                      subtitle: Text('pf2e_propulsive_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_ranged_trip_trait'.tr()),
                      subtitle: Text('pf2e_ranged_trip_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_razing_trait'.tr()),
                      subtitle: Text('pf2e_razing_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_reach_trait'.tr()),
                      subtitle: Text('pf2e_reach_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_recovery_trait'.tr()),
                      subtitle: Text('pf2e_recovery_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_reload_trait'.tr()),
                      subtitle: Text('pf2e_reload_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_repeating_trait'.tr()),
                      subtitle: Text('pf2e_repeating_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_resonant_trait'.tr()),
                      subtitle: Text('pf2e_resonant_description'.tr()),
                    ),
                    
                    // S-V traits
                    ListTile(
                      title: Text('pf2e_scatter_trait'.tr()),
                      subtitle: Text('pf2e_scatter_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_shove_trait'.tr()),
                      subtitle: Text('pf2e_shove_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_sweep_trait'.tr()),
                      subtitle: Text('pf2e_sweep_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_tearing_trait'.tr()),
                      subtitle: Text('pf2e_tearing_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_tethered_trait'.tr()),
                      subtitle: Text('pf2e_tethered_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_thrown_trait'.tr()),
                      subtitle: Text('pf2e_thrown_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_training_trait'.tr()),
                      subtitle: Text('pf2e_training_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_trip_trait'.tr()),
                      subtitle: Text('pf2e_trip_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_twin_trait'.tr()),
                      subtitle: Text('pf2e_twin_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_two_hand_trait'.tr()),
                      subtitle: Text('pf2e_two_hand_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_unarmed_trait'.tr()),
                      subtitle: Text('pf2e_unarmed_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_vehicular_trait'.tr()),
                      subtitle: Text('pf2e_vehicular_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_venomous_trait'.tr()),
                      subtitle: Text('pf2e_venomous_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_versatile_trait'.tr()),
                      subtitle: Text('pf2e_versatile_description'.tr()),
                    ),
                    ListTile(
                      title: Text('pf2e_volley_trait'.tr()),
                      subtitle: Text('pf2e_volley_description'.tr()),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ============================================
// D&D 5e TABS
// ============================================

class _CombateTabDnD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('dnd5e_actions_in_combat'.tr()),
          children: [
            ListTile(
              title: Text('dnd5e_attack'.tr()),
              subtitle: Text('dnd5e_attack_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_cast_spell'.tr()),
              subtitle: Text('dnd5e_cast_spell_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_dash'.tr()),
              subtitle: Text('dnd5e_dash_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_disengage'.tr()),
              subtitle: Text('dnd5e_disengage_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_dodge'.tr()),
              subtitle: Text('dnd5e_dodge_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_help'.tr()),
              subtitle: Text('dnd5e_help_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_hide'.tr()),
              subtitle: Text('dnd5e_hide_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_ready'.tr()),
              subtitle: Text('dnd5e_ready_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_search'.tr()),
              subtitle: Text('dnd5e_search_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_use_magic_item'.tr()),
              subtitle: Text('dnd5e_use_magic_item_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_use_object'.tr()),
              subtitle: Text('dnd5e_use_object_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_use_special_ability'.tr()),
              subtitle: Text('dnd5e_use_special_ability_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_long_jump'.tr()),
          children: [
            ListTile(
              title: Text('dnd5e_long_jump_rule'.tr()),
              subtitle: Text('dnd5e_long_jump_rule_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_high_jump'.tr()),
          children: [
            ListTile(
              title: Text('dnd5e_high_jump_rule'.tr()),
              subtitle: Text('dnd5e_high_jump_rule_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_concentration'.tr()),
          children: [
            ListTile(
              title: Text('dnd5e_concentration_rules'.tr()),
              subtitle: Text('dnd5e_concentration_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_losing_concentration'.tr()),
              subtitle: Text('dnd5e_losing_concentration_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_things_you_can_do'.tr()),
          children: [
            ListTile(
              title: Text('dnd5e_move_speed'.tr()),
              subtitle: Text('dnd5e_move_speed_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_take_action'.tr()),
              subtitle: Text('dnd5e_take_action_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_communicate'.tr()),
              subtitle: Text('dnd5e_communicate_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_interact_object'.tr()),
              subtitle: Text('dnd5e_interact_object_desc'.tr()),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_combat_conditions'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_condition'.tr())),
                  DataColumn(label: Text('dnd5e_ac_effect'.tr())),
                  DataColumn(label: Text('dnd5e_attack_effect'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('dnd5e_blinded'.tr())), 
                    DataCell(Text('dnd5e_blinded_ac_effect'.tr())), 
                    DataCell(Text('dnd5e_blinded_attack_effect'.tr()))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_prone'.tr())), 
                    DataCell(Text('dnd5e_prone_ac_effect'.tr())), 
                    DataCell(Text('dnd5e_prone_attack_effect'.tr()))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_restrained'.tr())), 
                    DataCell(Text('dnd5e_restrained_ac_effect'.tr())), 
                    DataCell(Text('dnd5e_restrained_attack_effect'.tr()))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_unconscious'.tr())), 
                    DataCell(Text('dnd5e_unconscious_ac_effect'.tr())), 
                    DataCell(Text('dnd5e_unconscious_attack_effect'.tr()))
                  ]),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CondicionesTabDnD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('dnd5e_conditions'.tr()),
          children: [
            ListTile(
              title: Text('dnd5e_blinded'.tr()),
              subtitle: Text('dnd5e_blinded_full_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_charmed'.tr()),
              subtitle: Text('dnd5e_charmed_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_deafened'.tr()),
              subtitle: Text('dnd5e_deafened_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_frightened'.tr()),
              subtitle: Text('dnd5e_frightened_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_grappled'.tr()),
              subtitle: Text('dnd5e_grappled_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_incapacitated'.tr()),
              subtitle: Text('dnd5e_incapacitated_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_invisible'.tr()),
              subtitle: Text('dnd5e_invisible_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_paralyzed'.tr()),
              subtitle: Text('dnd5e_paralyzed_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_petrified'.tr()),
              subtitle: Text('dnd5e_petrified_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_poisoned'.tr()),
              subtitle: Text('dnd5e_poisoned_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_prone'.tr()),
              subtitle: Text('dnd5e_prone_full_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_restrained'.tr()),
              subtitle: Text('dnd5e_restrained_full_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_stunned'.tr()),
              subtitle: Text('dnd5e_stunned_desc'.tr()),
            ),
            ListTile(
              title: Text('dnd5e_unconscious'.tr()),
              subtitle: Text('dnd5e_unconscious_full_desc'.tr()),
            ),
          ],
        ),
      ],
    );
  }
}

class _HabilidadesTabDnD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('dnd5e_setting_dc'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_difficulty'.tr())),
                  DataColumn(label: Text('dnd5e_dc'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('dnd5e_very_easy'.tr())), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_easy'.tr())), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_moderate'.tr())), DataCell(Text('15'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_hard'.tr())), DataCell(Text('20'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_very_hard'.tr())), DataCell(Text('25'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_nearly_impossible'.tr())), DataCell(Text('30'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_tracking_dcs'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_ground_surface'.tr())),
                  DataColumn(label: Text('dnd5e_dc'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('dnd5e_soft_surface'.tr())), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_dirt_grass'.tr())), DataCell(Text('15'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_bare_stone'.tr())), DataCell(Text('20'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_each_day_passed'.tr())), DataCell(Text('+5'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_creature_left_trail'.tr())), DataCell(Text('-5'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_damage_by_level'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_level'.tr())),
                  DataColumn(label: Text('dnd5e_setback'.tr())),
                  DataColumn(label: Text('dnd5e_dangerous'.tr())),
                  DataColumn(label: Text('dnd5e_deadly_damage'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('1-4')), DataCell(Text('1d10')), DataCell(Text('2d10')), DataCell(Text('4d10'))]),
                  DataRow(cells: [DataCell(Text('5-10')), DataCell(Text('2d10')), DataCell(Text('4d10')), DataCell(Text('10d10'))]),
                  DataRow(cells: [DataCell(Text('11-16')), DataCell(Text('4d10')), DataCell(Text('10d10')), DataCell(Text('18d10'))]),
                  DataRow(cells: [DataCell(Text('17-20')), DataCell(Text('10d10')), DataCell(Text('18d10')), DataCell(Text('24d10'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_object_armor_class'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_substance'.tr())),
                  DataColumn(label: Text('dnd5e_ac'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('dnd5e_cloth_paper_rope'.tr())), DataCell(Text('11'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_crystal_glass_ice'.tr())), DataCell(Text('13'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_wood_bone'.tr())), DataCell(Text('15'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_stone'.tr())), DataCell(Text('17'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_iron_steel'.tr())), DataCell(Text('19'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_mithral'.tr())), DataCell(Text('21'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_adamantine'.tr())), DataCell(Text('23'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_object_hit_points'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_size'.tr())),
                  DataColumn(label: Text('dnd5e_fragile'.tr())),
                  DataColumn(label: Text('dnd5e_resilient'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('dnd5e_tiny_bottle_lock'.tr())), DataCell(Text('2 (1d4)')), DataCell(Text('5 (2d4)'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_small_chest_lute'.tr())), DataCell(Text('3 (1d6)')), DataCell(Text('10 (3d6)'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_medium_barrel_chandelier'.tr())), DataCell(Text('4 (1d8)')), DataCell(Text('18 (4d8)'))]),
                  DataRow(cells: [DataCell(Text('dnd5e_large_cart_window'.tr())), DataCell(Text('5 (1d10)')), DataCell(Text('27 (5d10)'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_skills_abilities'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_skill'.tr())),
                  DataColumn(label: Text('dnd5e_ability'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('dnd5e_acrobatics'.tr())), DataCell(Text('dnd5e_dexterity'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_animal_handling'.tr())), DataCell(Text('dnd5e_wisdom'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_arcana'.tr())), DataCell(Text('dnd5e_intelligence'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_athletics'.tr())), DataCell(Text('dnd5e_strength'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_deception'.tr())), DataCell(Text('dnd5e_charisma'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_history'.tr())), DataCell(Text('dnd5e_intelligence'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_insight'.tr())), DataCell(Text('dnd5e_wisdom'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_intimidation'.tr())), DataCell(Text('dnd5e_charisma'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_investigation'.tr())), DataCell(Text('dnd5e_intelligence'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_medicine'.tr())), DataCell(Text('dnd5e_wisdom'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_nature'.tr())), DataCell(Text('dnd5e_intelligence'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_perception'.tr())), DataCell(Text('dnd5e_wisdom'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_performance'.tr())), DataCell(Text('dnd5e_charisma'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_persuasion'.tr())), DataCell(Text('dnd5e_charisma'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_religion'.tr())), DataCell(Text('dnd5e_intelligence'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_sleight_of_hand'.tr())), DataCell(Text('dnd5e_dexterity'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_stealth'.tr())), DataCell(Text('dnd5e_dexterity'.tr()))]),
                  DataRow(cells: [DataCell(Text('dnd5e_survival'.tr())), DataCell(Text('dnd5e_wisdom'.tr()))]),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _GMTabDnD extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: Text('dnd5e_encounter_difficulty'.tr()),
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('dnd5e_xp_thresholds_by_level'.tr()),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_level'.tr())),
                  DataColumn(label: Text('dnd5e_easy'.tr())),
                  DataColumn(label: Text('dnd5e_medium'.tr())),
                  DataColumn(label: Text('dnd5e_hard'.tr())),
                  DataColumn(label: Text('dnd5e_deadly'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('1')), DataCell(Text('25')), DataCell(Text('50')), DataCell(Text('75')), DataCell(Text('100'))]),
                  DataRow(cells: [DataCell(Text('2')), DataCell(Text('50')), DataCell(Text('100')), DataCell(Text('150')), DataCell(Text('200'))]),
                  DataRow(cells: [DataCell(Text('3')), DataCell(Text('75')), DataCell(Text('150')), DataCell(Text('225')), DataCell(Text('400'))]),
                  DataRow(cells: [DataCell(Text('4')), DataCell(Text('125')), DataCell(Text('250')), DataCell(Text('375')), DataCell(Text('500'))]),
                  DataRow(cells: [DataCell(Text('5')), DataCell(Text('250')), DataCell(Text('500')), DataCell(Text('750')), DataCell(Text('1,100'))]),
                  DataRow(cells: [DataCell(Text('6')), DataCell(Text('300')), DataCell(Text('600')), DataCell(Text('900')), DataCell(Text('1,400'))]),
                  DataRow(cells: [DataCell(Text('7')), DataCell(Text('350')), DataCell(Text('750')), DataCell(Text('1,100')), DataCell(Text('1,700'))]),
                  DataRow(cells: [DataCell(Text('8')), DataCell(Text('450')), DataCell(Text('900')), DataCell(Text('1,400')), DataCell(Text('2,100'))]),
                  DataRow(cells: [DataCell(Text('9')), DataCell(Text('550')), DataCell(Text('1,100')), DataCell(Text('1,600')), DataCell(Text('2,400'))]),
                  DataRow(cells: [DataCell(Text('10')), DataCell(Text('600')), DataCell(Text('1,200')), DataCell(Text('1,900')), DataCell(Text('2,800'))]),
                  DataRow(cells: [DataCell(Text('11')), DataCell(Text('800')), DataCell(Text('1,600')), DataCell(Text('2,400')), DataCell(Text('3,600'))]),
                  DataRow(cells: [DataCell(Text('12')), DataCell(Text('1,000')), DataCell(Text('2,000')), DataCell(Text('3,000')), DataCell(Text('4,500'))]),
                  DataRow(cells: [DataCell(Text('13')), DataCell(Text('1,100')), DataCell(Text('2,200')), DataCell(Text('3,400')), DataCell(Text('5,100'))]),
                  DataRow(cells: [DataCell(Text('14')), DataCell(Text('1,250')), DataCell(Text('2,500')), DataCell(Text('3,800')), DataCell(Text('5,700'))]),
                  DataRow(cells: [DataCell(Text('15')), DataCell(Text('1,400')), DataCell(Text('2,800')), DataCell(Text('4,300')), DataCell(Text('6,400'))]),
                  DataRow(cells: [DataCell(Text('16')), DataCell(Text('1,600')), DataCell(Text('3,200')), DataCell(Text('4,800')), DataCell(Text('7,200'))]),
                  DataRow(cells: [DataCell(Text('17')), DataCell(Text('2,000')), DataCell(Text('3,900')), DataCell(Text('5,900')), DataCell(Text('8,800'))]),
                  DataRow(cells: [DataCell(Text('18')), DataCell(Text('2,100')), DataCell(Text('4,200')), DataCell(Text('6,300')), DataCell(Text('9,500'))]),
                  DataRow(cells: [DataCell(Text('19')), DataCell(Text('2,400')), DataCell(Text('4,900')), DataCell(Text('7,300')), DataCell(Text('10,900'))]),
                  DataRow(cells: [DataCell(Text('20')), DataCell(Text('2,800')), DataCell(Text('5,700')), DataCell(Text('8,500')), DataCell(Text('12,700'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_travel_pace'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_pace'.tr())),
                  DataColumn(label: Text('dnd5e_minute'.tr())),
                  DataColumn(label: Text('dnd5e_hour'.tr())),
                  DataColumn(label: Text('dnd5e_day'.tr())),
                  DataColumn(label: Text('dnd5e_effect'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('dnd5e_fast'.tr())),
                    DataCell(Text('400 ft')),
                    DataCell(Text('4 mi')),
                    DataCell(Text('30 mi')),
                    DataCell(Text('dnd5e_minus_5_perception'.tr()))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_normal'.tr())),
                    DataCell(Text('300 ft')),
                    DataCell(Text('3 mi')),
                    DataCell(Text('24 mi')),
                    DataCell(Text('—'))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_slow'.tr())),
                    DataCell(Text('200 ft')),
                    DataCell(Text('2 mi')),
                    DataCell(Text('18 mi')),
                    DataCell(Text('dnd5e_stealth_possible'.tr()))
                  ]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_cover'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_cover_type'.tr())),
                  DataColumn(label: Text('dnd5e_ac_bonus'.tr())),
                  DataColumn(label: Text('dnd5e_dex_save_bonus'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('dnd5e_half_cover'.tr())),
                    DataCell(Text('+2')),
                    DataCell(Text('+2'))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_three_quarters_cover'.tr())),
                    DataCell(Text('+5')),
                    DataCell(Text('+5'))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_total_cover'.tr())),
                    DataCell(Text('dnd5e_cannot_be_targeted'.tr())),
                    DataCell(Text('dnd5e_no_damage'.tr()))
                  ]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_light_and_vision'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_light_level'.tr())),
                  DataColumn(label: Text('dnd5e_effect'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('dnd5e_bright_light'.tr())),
                    DataCell(Text('dnd5e_normal_vision'.tr()))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_dim_light'.tr())),
                    DataCell(Text('dnd5e_lightly_obscured'.tr()))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_darkness'.tr())),
                    DataCell(Text('dnd5e_heavily_obscured'.tr()))
                  ]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_encounter_distance'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_terrain'.tr())),
                  DataColumn(label: Text('dnd5e_encounter_distance'.tr())),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('dnd5e_arctic_desert_farmland_grassland_hills'.tr())),
                    DataCell(Text('6d6 × 10 ft'))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_forest_swamp_mountains_jungle'.tr())),
                    DataCell(Text('2d8 × 10 ft'))
                  ]),
                  DataRow(cells: [
                    DataCell(Text('dnd5e_urban'.tr())),
                    DataCell(Text('2d6 × 10 ft'))
                  ]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: Text('dnd5e_encounter_multipliers'.tr()),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('dnd5e_number_of_monsters'.tr())),
                  DataColumn(label: Text('dnd5e_multiplier'.tr())),
                ],
                rows: [
                  DataRow(cells: [DataCell(Text('1')), DataCell(Text('×1'))]),
                  DataRow(cells: [DataCell(Text('2')), DataCell(Text('×1.5'))]),
                  DataRow(cells: [DataCell(Text('3-6')), DataCell(Text('×2'))]),
                  DataRow(cells: [DataCell(Text('7-10')), DataCell(Text('×2.5'))]),
                  DataRow(cells: [DataCell(Text('11-14')), DataCell(Text('×3'))]),
                  DataRow(cells: [DataCell(Text('15+')), DataCell(Text('×4'))]),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
