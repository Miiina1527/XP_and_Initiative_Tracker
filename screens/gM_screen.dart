import 'package:flutter/material.dart';

class GMScreen extends StatelessWidget {
  const GMScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('GM Screen'),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: 'Combate'),
              Tab(text: 'Condiciones'),
              Tab(text: 'Equipo'),
              Tab(text: 'GM'),
              Tab(text: 'Habilidades'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _CombateTab(),
            _CondicionesTab(),
            _EquipoTab(),
            _GMTab(),
            _HabilidadesTab(),
          ],
        ),
      ),
    );
  }
}

class _CombateTab extends StatelessWidget {
  const _CombateTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: const Text('Armor Class Modifiers'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Defender is...')),
                  DataColumn(label: Text('Melee')),
                  DataColumn(label: Text('Ranged')),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('Behind cover')), DataCell(Text('+4')), DataCell(Text('+4'))]),
                  DataRow(cells: [DataCell(Text('Blinded')), DataCell(Text('-2')), DataCell(Text('-2'))]),
                  DataRow(cells: [DataCell(Text('Concealed or invisible')), DataCell(Text('See Concealment')), DataCell(Text('See Concealment'))]),
                  DataRow(cells: [DataCell(Text('Cowering')), DataCell(Text('-2')), DataCell(Text('-2'))]),
                  DataRow(cells: [DataCell(Text('Entangled')), DataCell(Text('+0²')), DataCell(Text('+0²'))]),
                  DataRow(cells: [DataCell(Text('Flat-footed')), DataCell(Text('+0¹')), DataCell(Text('+0¹'))]),
                  DataRow(cells: [DataCell(Text('Grappling (but the attacker is not)')), DataCell(Text('+0')), DataCell(Text('+0'))]),
                  DataRow(cells: [DataCell(Text('Helpless')), DataCell(Text('-4³')), DataCell(Text('+0³'))]),
                  DataRow(cells: [DataCell(Text('Kneeling or sitting')), DataCell(Text('-2')), DataCell(Text('+2'))]),
                  DataRow(cells: [DataCell(Text('Pinned')), DataCell(Text('-4³')), DataCell(Text('+0³'))]),
                  DataRow(cells: [DataCell(Text('Prone')), DataCell(Text('-4')), DataCell(Text('+4'))]),
                  DataRow(cells: [DataCell(Text('Squeezing through a space')), DataCell(Text('-4')), DataCell(Text('-4'))]),
                  DataRow(cells: [DataCell(Text('Stunned')), DataCell(Text('-2')), DataCell(Text('-2'))]),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¹ The defender loses any Dexterity bonus to AC.'),
                  Text('² An entangled character takes a –4 penalty to Dexterity.'),
                  Text('³ The defender is flat-footed and cannot add his Dex bonus to AC.'),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Attack Roll Modifiers'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Attacker is...')),
                  DataColumn(label: Text('Melee')),
                  DataColumn(label: Text('Ranged')),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('Dazzled')), DataCell(Text('-1')), DataCell(Text('-1'))]),
                  DataRow(cells: [DataCell(Text('Entangled')), DataCell(Text('-2¹')), DataCell(Text('-2¹'))]),
                  DataRow(cells: [DataCell(Text('Flanking defender')), DataCell(Text('+2')), DataCell(Text('—'))]),
                  DataRow(cells: [DataCell(Text('Invisible')), DataCell(Text('+2²')), DataCell(Text('+2²'))]),
                  DataRow(cells: [DataCell(Text('On higher ground')), DataCell(Text('+1')), DataCell(Text('+0'))]),
                  DataRow(cells: [DataCell(Text('Prone')), DataCell(Text('-4³')), DataCell(Text('—³'))]),
                  DataRow(cells: [DataCell(Text('Shaken or frightened')), DataCell(Text('-2')), DataCell(Text('-2'))]),
                  DataRow(cells: [DataCell(Text('Squeezing through a space')), DataCell(Text('-4')), DataCell(Text('-4'))]),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¹ An entangled character also takes a –4 penalty to Dexterity, which may affect his attack roll.'),
                  Text('² The defender loses any Dexterity bonus to AC.'),
                  Text('³ Most ranged weapons can’t be used while the attacker is prone, but you can use a crossbow or shuriken while prone at no penalty.'),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Combat Maneuvers'),
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CMB = BAB + Str modifier + special size modifier'),
                  const Text('CMD = BAB + Str modifier + Dex modifier + special size modifier +10'),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Maneuver', style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(label: Text('Effect')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('Bull Rush', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Push target 5 ft., +5 ft. for every 5 by which check exceeds CMD')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Dirty Trick', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Inflict a temporary negative condition')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Disarm', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Target drops 1 item or 2 items if check exceeds CMD by 10')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Drag', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Pull target 5 ft., +5 ft. for every 5 by which check exceeds CMD')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Grapple', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Both target and attacker gain grappled condition')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Overrun', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Move through target, knocked prone if check exceeds CMD by 5')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Reposition', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Move target 5 ft. within reach, +5 ft. for every 5 by which check exceeds CMD')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Steal', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Take a worn item from the target')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Sunder', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Deal damage to item held or worn by target')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Trip', style: TextStyle(fontWeight: FontWeight.bold))),
                          const DataCell(Text('Knock target prone, attacker knocked prone if check fails by 10 or more')),
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
          title: const Text('Concentration Checks'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Situation')),
                  DataColumn(label: Text('Concentration Check DC')),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('Cast defensively')), DataCell(Text('15 + double spell level'))]),
                  DataRow(cells: [DataCell(Text('Injured while casting')), DataCell(Text('10 + damage dealt + spell level'))]),
                  DataRow(cells: [DataCell(Text('Continuous damage while casting')), DataCell(Text('10 + 1/2 damage dealt + spell level'))]),
                  DataRow(cells: [DataCell(Text('Affected by a non-damaging spell while casting')), DataCell(Text('DC of the spell + spell level'))]),
                  DataRow(cells: [DataCell(Text('Grappled or pinned while casting')), DataCell(Text("10 + grappler's CMB + spell level"))]),
                  DataRow(cells: [DataCell(Text('Vigorous motion while casting')), DataCell(Text('10 + spell level'))]),
                  DataRow(cells: [DataCell(Text('Violent motion while casting')), DataCell(Text('15 + spell level'))]),
                  DataRow(cells: [DataCell(Text('Extremely violent motion while casting')), DataCell(Text('20 + spell level'))]),
                  DataRow(cells: [DataCell(Text('Wind with rain or sleet while casting')), DataCell(Text('5 + spell level'))]),
                  DataRow(cells: [DataCell(Text('Wind with hail and debris while casting')), DataCell(Text('10 + spell level'))]),
                  DataRow(cells: [DataCell(Text('Weather caused by spell')), DataCell(Text('see spell'))]),
                  DataRow(cells: [DataCell(Text('Entangled while casting')), DataCell(Text('15 + spell level'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Two-Weapon Fighting Penalties'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Circumstances')),
                  DataColumn(label: Text('Primary Hand')),
                  DataColumn(label: Text('Off Hand')),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('Normal penalties')), DataCell(Text('-6')), DataCell(Text('-10'))]),
                  DataRow(cells: [DataCell(Text('Off-hand weapon is light')), DataCell(Text('-4')), DataCell(Text('-8'))]),
                  DataRow(cells: [DataCell(Text('Two-Weapon Fighting feat')), DataCell(Text('-4')), DataCell(Text('-4'))]),
                  DataRow(cells: [DataCell(Text('Off-hand weapon is light and Two-Weapon Fighting feat')), DataCell(Text('-2')), DataCell(Text('-2'))]),
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

class _CondicionesTab extends StatelessWidget {
  const _CondicionesTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: const Text('Condiciones Comunes'),
          children: [
            ListTile(
              title: const Text('Cegado'),
              subtitle: const Text('El personaje no puede ver. Sufre penalizadores a las tiradas de ataque, pierde su bonificador de Destreza a la AC, y falla automáticamente cualquier prueba que requiera visión.'),
            ),
            ListTile(
              title: const Text('Aturdido'),
              subtitle: const Text('El personaje suelta lo que sostiene, no puede actuar, recibe penalizador a la CA y pierde su bonificador de Destreza a la CA.'),
            ),
            ListTile(
              title: const Text('Ciego'),
              subtitle: const Text('El personaje no puede ver y sufre un penalizador de -4 a la CA. Además, no puede realizar acciones que requieran visión, como lanzar conjuros con componentes visuales.'),
            ),
            ListTile(
              title: const Text('Concentrado'),
              subtitle: const Text('El personaje puede realizar acciones que requieren concentración, como lanzar conjuros, sin penalizadores adicionales.'),
            ),
            ListTile(
              title: const Text('Desarmado'),
              subtitle: const Text('El personaje ha perdido su arma principal y no puede hacer ataques con ella. Si es desarmado nuevamente, sufre un penalizador adicional de -4 a la CA.'),
            ),
            ListTile(
              title: const Text('Dañado'),
              subtitle: const Text('El personaje ha sufrido daño y puede tener dificultades para realizar acciones. Sufre un penalizador de -1 a todas las tiradas de ataque, pruebas de habilidad y tiradas de salvación.'),
            ),
            ListTile(
              title: const Text('Fatigado'),
              subtitle: const Text('El personaje no puede correr ni cargar. Además, sufre un penalizador de -2 a la Fuerza y la Destreza. Después de descansar 8 horas, el personaje se recupera de esta condición.'),
            ),
            ListTile(
              title: const Text('Herido'),
              subtitle: const Text('El personaje ha sido herido y sufre un penalizador de -1 a las tiradas de ataque y a las pruebas de habilidad relacionadas con la Fuerza o la Destreza.'),
            ),
            ListTile(
              title: const Text('Inconsciente'),
              subtitle: const Text('El personaje está inconsciente y no puede realizar ninguna acción. Además, es considerado un objetivo fácil y recibe un bono de +4 a las tiradas de ataque en su contra.'),
            ),
            ListTile(
              title: const Text('Intimidado'),
              subtitle: const Text('El personaje está intimidado y sufre un penalizador de -2 a las tiradas de ataque, pruebas de habilidad y tiradas de salvación contra el miedo.'),
            ),
            ListTile(
              title: const Text('Paralizado'),
              subtitle: const Text('El personaje está paralizado y no puede realizar ninguna acción. Además, es considerado un objetivo fácil y recibe un bono de +4 a las tiradas de ataque en su contra.'),
            ),
            ListTile(
              title: const Text('Pasmado'),
              subtitle: const Text('El personaje está pasmado y no puede realizar ninguna acción. Además, sufre un penalizador de -2 a la CA y pierde su bonificador de Destreza a la CA.'),
            ),
            ListTile(
              title: const Text('Prone'),
              subtitle: const Text('El personaje está en el suelo y debe gastar movimiento para levantarse. Además, sufre un penalizador de -4 a la CA contra ataques cuerpo a cuerpo.'),
            ),
            ListTile(
              title: const Text('Sangrando'),
              subtitle: const Text('El personaje está perdiendo puntos de golpe debido a heridas abiertas. Al comienzo de cada uno de sus turnos, sufre 1d4 puntos de daño y debe realizar una tirada de salvación de Constitución CD 10 para evitar recibir daño adicional.'),
            ),
            ListTile(
              title: const Text('Sordo'),
              subtitle: const Text('El personaje no puede oír y sufre un penalizador de -4 a las tiradas de salvación contra efectos que requieren audición.'),
            ),
            ListTile(
              title: const Text('Tembloroso'),
              subtitle: const Text('El personaje tiene dificultades para mantener el equilibrio y sufre un penalizador de -2 a las tiradas de ataque, pruebas de habilidad y tiradas de salvación contra efectos que requieren equilibrio.'),
            ),
            ListTile(
              title: const Text('Tendido'),
              subtitle: const Text('El personaje está tendido en el suelo y no puede levantarse sin gastar movimiento. Además, sufre un penalizador de -4 a la CA contra ataques cuerpo a cuerpo.'),
            ),
            ListTile(
              title: const Text('Vulnerable'),
              subtitle: const Text('El personaje es más susceptible a los ataques y sufre un penalizador de -2 a la CA y a las tiradas de salvación contra efectos que requieren una tirada de salvación.'),
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
          title: const Text('Armor/Weapon Hardness & Hit Points'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Weapon or Shield')),
                  DataColumn(label: Text('Hardness¹')),
                  DataColumn(label: Text('Hit Points², ³')),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('Light blade')), DataCell(Text('10')), DataCell(Text('2'))]),
                  DataRow(cells: [DataCell(Text('One-handed blade')), DataCell(Text('10')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('Two-handed blade')), DataCell(Text('10')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('Light metal-hafted weapon')), DataCell(Text('10')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('One-handed metal-hafted weapon')), DataCell(Text('10')), DataCell(Text('20'))]),
                  DataRow(cells: [DataCell(Text('Light hafted weapon')), DataCell(Text('5')), DataCell(Text('2'))]),
                  DataRow(cells: [DataCell(Text('One-handed hafted weapon')), DataCell(Text('5')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('Two-handed hafted weapon')), DataCell(Text('5')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('Projectile weapon')), DataCell(Text('5')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('Armor')), DataCell(Text('Special⁴')), DataCell(Text('armor bonus × 5'))]),
                  DataRow(cells: [DataCell(Text('Buckler')), DataCell(Text('10')), DataCell(Text('5'))]),
                  DataRow(cells: [DataCell(Text('Light wooden shield')), DataCell(Text('5')), DataCell(Text('7'))]),
                  DataRow(cells: [DataCell(Text('Heavy wooden shield')), DataCell(Text('5')), DataCell(Text('15'))]),
                  DataRow(cells: [DataCell(Text('Light steel shield')), DataCell(Text('10')), DataCell(Text('10'))]),
                  DataRow(cells: [DataCell(Text('Heavy steel shield')), DataCell(Text('10')), DataCell(Text('20'))]),
                  DataRow(cells: [DataCell(Text('Tower shield')), DataCell(Text('5')), DataCell(Text('20'))]),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('¹ Add +2 for each +1 enhancement bonus of magic items.'),
                  Text('² The hp value given is for Medium armor, weapons, and shields. Divide by 2 for each size category of the item smaller than Medium, or multiply it by 2 for each size category larger than Medium.'),
                  Text('³ Add 10 hp for each +1 enhancement bonus of magic items.'),
                  Text('⁴ Varies by material; see Table 7–13: Substance Hardness and Hit Points.'),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Breaking Items'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('7-15: DCs to Break or Burst Items', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Strength Check to:')),
                        DataColumn(label: Text('DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Break down simple door')), DataCell(Text('13'))]),
                        DataRow(cells: [DataCell(Text('Break down good door')), DataCell(Text('18'))]),
                        DataRow(cells: [DataCell(Text('Break down strong door')), DataCell(Text('23'))]),
                        DataRow(cells: [DataCell(Text('Burst rope bonds')), DataCell(Text('23'))]),
                        DataRow(cells: [DataCell(Text('Bend iron bars')), DataCell(Text('24'))]),
                        DataRow(cells: [DataCell(Text('Break down barred door')), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('Burst chain bonds')), DataCell(Text('26'))]),
                        DataRow(cells: [DataCell(Text('Break down iron door')), DataCell(Text('28'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Condition', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Condition')),
                        DataColumn(label: Text('DC Adjustment*')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Hold portal')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Arcane lock')), DataCell(Text('+10'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('*If both apply, use the larger number.'),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Object Hardness & Hit Points'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Object')),
                  DataColumn(label: Text('Hardness')),
                  DataColumn(label: Text('Hit Points')),
                  DataColumn(label: Text('DC')),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('Rope (1 in. diameter)')), DataCell(Text('0')), DataCell(Text('2')), DataCell(Text('23'))]),
                  DataRow(cells: [DataCell(Text('Simple wooden door')), DataCell(Text('5')), DataCell(Text('10')), DataCell(Text('13'))]),
                  DataRow(cells: [DataCell(Text('Small chest')), DataCell(Text('5')), DataCell(Text('1')), DataCell(Text('17'))]),
                  DataRow(cells: [DataCell(Text('Good wooden door')), DataCell(Text('5')), DataCell(Text('15')), DataCell(Text('18'))]),
                  DataRow(cells: [DataCell(Text('Treasure chest')), DataCell(Text('5')), DataCell(Text('15')), DataCell(Text('23'))]),
                  DataRow(cells: [DataCell(Text('Strong wooden door')), DataCell(Text('5')), DataCell(Text('20')), DataCell(Text('23'))]),
                  DataRow(cells: [DataCell(Text('Masonry wall (1 ft. thick)')), DataCell(Text('8')), DataCell(Text('90')), DataCell(Text('35'))]),
                  DataRow(cells: [DataCell(Text('Hewn stone (3 ft. thick)')), DataCell(Text('8')), DataCell(Text('540')), DataCell(Text('50'))]),
                  DataRow(cells: [DataCell(Text('Chain')), DataCell(Text('10')), DataCell(Text('5')), DataCell(Text('26'))]),
                  DataRow(cells: [DataCell(Text('Manacles')), DataCell(Text('10')), DataCell(Text('10')), DataCell(Text('26'))]),
                  DataRow(cells: [DataCell(Text('Masterwork manacles')), DataCell(Text('10')), DataCell(Text('10')), DataCell(Text('28'))]),
                  DataRow(cells: [DataCell(Text('Iron door (2 in. thick)')), DataCell(Text('10')), DataCell(Text('60')), DataCell(Text('28'))]),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Substance Hardness & Hit Points'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Substance')),
                  DataColumn(label: Text('Hardness')),
                  DataColumn(label: Text('Hit Points')),
                ],
                rows: const [
                  DataRow(cells: [DataCell(Text('Glass')), DataCell(Text('1')), DataCell(Text('1/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Paper or cloth')), DataCell(Text('0')), DataCell(Text('2/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Rope')), DataCell(Text('0')), DataCell(Text('2/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Ice')), DataCell(Text('0')), DataCell(Text('3/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Leather or hide')), DataCell(Text('2')), DataCell(Text('5/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Wood')), DataCell(Text('5')), DataCell(Text('10/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Stone')), DataCell(Text('8')), DataCell(Text('15/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Iron or steel')), DataCell(Text('10')), DataCell(Text('30/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Mithral')), DataCell(Text('15')), DataCell(Text('30/in. of thickness'))]),
                  DataRow(cells: [DataCell(Text('Adamantine')), DataCell(Text('20')), DataCell(Text('40/in. of thickness'))]),
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

class _GMTab extends StatelessWidget {
  const _GMTab();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ExpansionTile(
          title: const Text('Experience Point Awards'),
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('CR')),
                  DataColumn(label: Text('Total XP')),
                  DataColumn(label: Text('1-3')),
                  DataColumn(label: Text('4-5')),
                  DataColumn(label: Text('6+')),
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
          title: const Text('Acrobatics'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Move Across a Narrow Surface', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Width')),
                        DataColumn(label: Text('Acrobatics DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Greater than 3 feet wide')), DataCell(Text('0¹'))]),
                        DataRow(cells: [DataCell(Text('1–3 feet wide')), DataCell(Text('5¹'))]),
                        DataRow(cells: [DataCell(Text('7–11 inches wide')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('2–6 inches wide')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Less than 2 inches wide')), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Move Through a Threatened Area', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Action')),
                        DataColumn(label: Text('Acrobatics DC²')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Move through a threatened area')), DataCell(Text("Opponent's CMD"))]),
                        DataRow(cells: [DataCell(Text("Move through an enemy's space")), DataCell(Text("5 + opponent's CMD"))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Long Jump', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Distance')),
                        DataColumn(label: Text('Acrobatics DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('5 feet')), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('10 feet')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('15 feet')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('20 feet')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('Greater than 20 feet')), DataCell(Text('+5 per 5 feet'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('High Jump', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Height')),
                        DataColumn(label: Text('Acrobatics DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('1 foot')), DataCell(Text('4'))]),
                        DataRow(cells: [DataCell(Text('2 feet')), DataCell(Text('8'))]),
                        DataRow(cells: [DataCell(Text('3 feet')), DataCell(Text('12'))]),
                        DataRow(cells: [DataCell(Text('4 feet')), DataCell(Text('16'))]),
                        DataRow(cells: [DataCell(Text('Greater than 4 feet')), DataCell(Text('+4 per foot'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Acrobatics Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Modifier')),
                        DataColumn(label: Text('DC Modifier')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Slightly obstructed (gravel, sand)')), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('Severely obstructed (cavern, rubble)')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Slightly slippery (wet)')), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('Severely slippery (icy)')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Slightly sloped (<45°)')), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('Severely sloped (>45°)')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Slightly unsteady (boat in rough water)')), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('Moderately unsteady (boat in a storm)')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Severely unsteady (earthquake)')), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('Move at full speed on narrow or uneven surfaces')), DataCell(Text('+5³'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('¹ No check needed unless modifiers increase the DC to 10 or higher.'),
                  const Text('² Increase the DC by 2 for each additional opponent avoided in 1 round.'),
                  const Text('³ This does not apply to checks made to jump.'),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Bluff'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Circumstances')),
                        DataColumn(label: Text('Bluff Modifier')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('The target wants to believe you')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('The lie is believable')), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('The lie is unlikely')), DataCell(Text('-5'))]),
                        DataRow(cells: [DataCell(Text('The lie is far-fetched')), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('The lie is impossible')), DataCell(Text('-20'))]),
                        DataRow(cells: [DataCell(Text('The target is drunk or impaired')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('You possess convincing proof')), DataCell(Text('up to +10'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Feint DC: Bluff check vs. "10 + your opponent’s base attack bonus + your opponent’s Wisdom modifier" or "10 + your opponent’s Sense Motive bonus", whichever is higher. For more information on feinting in combat, see Combat.', style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Climb'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Example Surface or Activity')),
                        DataColumn(label: Text('Climb DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('A steep slope, or a knotted rope next to a wall')), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('A rope next to a wall or a knotted rope')), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('A surface with ledges, rough wall, or ship rigging')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Any surface with handholds, a tree, or an unknotted rope')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('An uneven surface with narrow handholds')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('A rough surface, such as a rock or brick wall')), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('An overhang or ceiling with handholds only')), DataCell(Text('30'))]),
                        DataRow(cells: [DataCell(Text('A perfectly smooth vertical (or inverted) surface cannot be climbed.')), DataCell(Text('-'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('Climb Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Climb Modifiers')),
                        DataColumn(label: Text('DC Modifiers')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Brace against two opposite walls')), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('Brace against two perpendicular walls')), DataCell(Text('-5'))]),
                        DataRow(cells: [DataCell(Text('Surface is slippery')), DataCell(Text('+5'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Diplomacy'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attitude & Diplomacy DC', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Starting Attitude')),
                        DataColumn(label: Text('Diplomacy DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Hostile')), DataCell(Text("25 + creature's Cha modifier"))]),
                        DataRow(cells: [DataCell(Text('Unfriendly')), DataCell(Text("20 + creature's Cha modifier"))]),
                        DataRow(cells: [DataCell(Text('Indifferent')), DataCell(Text("15 + creature's Cha modifier"))]),
                        DataRow(cells: [DataCell(Text('Friendly')), DataCell(Text("10 + creature's Cha modifier"))]),
                        DataRow(cells: [DataCell(Text('Helpful')), DataCell(Text("0 + creature's Cha modifier"))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Request DC Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Request')),
                        DataColumn(label: Text('DC Modifier')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Give simple advice or directions')), DataCell(Text('-5'))]),
                        DataRow(cells: [DataCell(Text('Give detailed advice')), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('Give simple aid')), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('Reveal an unimportant secret')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Give lengthy or complicated aid')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Give dangerous aid')), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('Reveal an important secret')), DataCell(Text('+10 or more'))]),
                        DataRow(cells: [DataCell(Text('Give aid that could result in punishment')), DataCell(Text('+15 or more'))]),
                        DataRow(cells: [DataCell(Text('Additional requests')), DataCell(Text('+5 per request'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Disable Device'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Disable Device DCs', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Device')),
                        DataColumn(label: Text('Time')),
                        DataColumn(label: Text('Disable Device DC*')),
                        DataColumn(label: Text('Example')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Simple')), DataCell(Text('1 round')), DataCell(Text('10')), DataCell(Text('Jam a lock'))]),
                        DataRow(cells: [DataCell(Text('Tricky')), DataCell(Text('1d4 rounds')), DataCell(Text('15')), DataCell(Text('Sabotage a wagon wheel'))]),
                        DataRow(cells: [DataCell(Text('Difficult')), DataCell(Text('2d4 rounds')), DataCell(Text('20')), DataCell(Text('Disarm a trap, reset a trap'))]),
                        DataRow(cells: [DataCell(Text('Extreme')), DataCell(Text('2d4 rounds')), DataCell(Text('25')), DataCell(Text('Disarm a complex trap, cleverly sabotage a clockwork device'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('* If you attempt to leave behind no trace of your tampering, add 5 to the DC.', style: TextStyle(fontStyle: FontStyle.italic)),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Fly'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Flying Maneuvers', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Flying Maneuver')),
                        DataColumn(label: Text('Fly DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Move less than half speed and remain flying')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Hover')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Turn greater than 45° by spending 5 feet of movement')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Turn 180° by spending 10 feet of movement')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('Fly up at greater than 45° angle')), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Heal'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Heal Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Task')),
                        DataColumn(label: Text('DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('First aid')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Long-term care')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Treat wounds from caltrops, spike growth, or spike stones')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Treat deadly wounds')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('Treat poison')), DataCell(Text("Poison's save DC"))]),
                        DataRow(cells: [DataCell(Text('Treat disease')), DataCell(Text("Disease's save DC"))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Knowledge'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Knowledge Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Task')),
                        DataColumn(label: Text('Knowledge DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Easy question')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Basic question')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Hard question')), DataCell(Text('20+'))]),
                        DataRow(cells: [DataCell(Text('Identify auras using detect magic (arcana)')), DataCell(Text('15 + spell level'))]),
                        DataRow(cells: [DataCell(Text('Identify a spell effect that is in place (arcana)')), DataCell(Text('20 + spell level'))]),
                        DataRow(cells: [DataCell(Text('Identify underground hazard (dungeoneering)')), DataCell(Text('15 + hazard\'s CR'))]),
                        DataRow(cells: [DataCell(Text('Identify dangerous construction (engineering)')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Recognize regional terrain features (geography)')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Know obscure or ancient event (history)')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('Know local laws, rulers, and popular locations (local)')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Identify a common plant or animal (nature)')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Know proper etiquette (nobility)')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text("Identify a creature's planar origin (planes)")), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text("Recognize a common deity's symbol or clergy (religion)")), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text("Know a monster's abilities or weaknesses (varies)")), DataCell(Text('10 + monster\'s CR'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Perception'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Perception Details', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Detail')),
                        DataColumn(label: Text('Perception DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Hear the sound of battle')), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('Notice the stench of rotting garbage')), DataCell(Text('-10'))]),
                        DataRow(cells: [DataCell(Text('Detect the smell of smoke')), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('Hear the details of a conversation')), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('Notice a visible creature')), DataCell(Text('0'))]),
                        DataRow(cells: [DataCell(Text('Determine if food is spoiled')), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('Hear the sound of a creature walking')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Hear the details of a whispered conversation')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Find the average concealed door')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Hear the sound of a key being turned in a lock')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('Find the average secret door')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('Hear a bow being drawn')), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('Sense a burrowing creature underneath you')), DataCell(Text('25'))]),
                        DataRow(cells: [DataCell(Text('Notice a pickpocket')), DataCell(Text('Opposed by Sleight of Hand'))]),
                        DataRow(cells: [DataCell(Text('Notice a creature using Stealth')), DataCell(Text('Opposed by Stealth'))]),
                        DataRow(cells: [DataCell(Text('Find a hidden trap')), DataCell(Text('Varies by trap'))]),
                        DataRow(cells: [DataCell(Text('Identify the powers of a potion through taste')), DataCell(Text("15 + the potion's caster level"))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Perception Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Perception Modifiers')),
                        DataColumn(label: Text('DC Modifier')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Distance to the source, object, or creature')), DataCell(Text('+1/10 feet'))]),
                        DataRow(cells: [DataCell(Text('Through a closed door')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Through a wall')), DataCell(Text('+10/foot of thickness'))]),
                        DataRow(cells: [DataCell(Text('Favorable conditions¹')), DataCell(Text('-2'))]),
                        DataRow(cells: [DataCell(Text('Unfavorable conditions¹')), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('Terrible conditions²')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Creature making the check is distracted')), DataCell(Text('+5'))]),
                        DataRow(cells: [DataCell(Text('Creature making the check is asleep')), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('Creature or object is invisible')), DataCell(Text('+20'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('¹ Favorable and unfavorable conditions depend upon the sense being used to make the check.'),
                  const Text('² As for unfavorable conditions, but more extreme.'),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Ride'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ride Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Task')),
                        DataColumn(label: Text('Ride DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Guide with knees')), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('Stay in saddle')), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('Fight with a combat-trained mount')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Cover')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Soft fall')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Leap')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Spur mount')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Control mount in battle')), DataCell(Text('20'))]),
                        DataRow(cells: [DataCell(Text('Fast mount or dismount')), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Spellcraft'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Spellcraft Tasks', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Task')),
                        DataColumn(label: Text('Spellcraft DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Identify a spell as it is being cast')), DataCell(Text('15 + spell level'))]),
                        DataRow(cells: [DataCell(Text('Learn a spell from a spellbook or scroll')), DataCell(Text('15 + spell level'))]),
                        DataRow(cells: [DataCell(Text('Prepare a spell from a borrowed spellbook')), DataCell(Text('15 + spell level'))]),
                        DataRow(cells: [DataCell(Text('Identify the properties of a magic item using detect magic')), DataCell(Text("15 + item's caster level"))]),
                        DataRow(cells: [DataCell(Text('Decipher a scroll')), DataCell(Text('20 + spell level'))]),
                        DataRow(cells: [DataCell(Text('Craft a magic item')), DataCell(Text('Varies by item'))]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Survival'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Track Creatures over Listed Surface', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Surface')),
                        DataColumn(label: Text('Survival DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Very soft ground')), DataCell(Text('5'))]),
                        DataRow(cells: [DataCell(Text('Soft ground')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Firm ground')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Hard ground')), DataCell(Text('20'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text('Tracking Modifiers', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Condition')),
                        DataColumn(label: Text('Survival DC Modifier')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Every three creatures in the group being tracked')), DataCell(Text('-1'))]),
                        DataRow(cells: [DataCell(Text('Size of creature or creatures being tracked:')), DataCell(Text(''))]),
                        DataRow(cells: [DataCell(Text('  - Fine')), DataCell(Text('+8'))]),
                        DataRow(cells: [DataCell(Text('  - Diminutive')), DataCell(Text('+4'))]),
                        DataRow(cells: [DataCell(Text('  - Tiny')), DataCell(Text('+2'))]),
                        DataRow(cells: [DataCell(Text('  - Small')), DataCell(Text('+1'))]),
                        DataRow(cells: [DataCell(Text('  - Medium')), DataCell(Text('+0'))]),
                        DataRow(cells: [DataCell(Text('  - Large')), DataCell(Text('-1'))]),
                        DataRow(cells: [DataCell(Text('  - Huge')), DataCell(Text('-2'))]),
                        DataRow(cells: [DataCell(Text('  - Gargantuan')), DataCell(Text('-4'))]),
                        DataRow(cells: [DataCell(Text('  - Colossal')), DataCell(Text('-8'))]),
                        DataRow(cells: [DataCell(Text('Every 24 hours since the trail was made')), DataCell(Text('+1'))]),
                        DataRow(cells: [DataCell(Text('Every hour of rain since the trail was made')), DataCell(Text('+1'))]),
                        DataRow(cells: [DataCell(Text('Fresh snow since the trail was made')), DataCell(Text('+10'))]),
                        DataRow(cells: [DataCell(Text('Poor visibility:')), DataCell(Text(''))]),
                        DataRow(cells: [DataCell(Text('  - Overcast or moonless night')), DataCell(Text('+6'))]),
                        DataRow(cells: [DataCell(Text('  - Moonlight')), DataCell(Text('+3'))]),
                        DataRow(cells: [DataCell(Text('  - Fog or precipitation')), DataCell(Text('+3'))]),
                        DataRow(cells: [DataCell(Text('Tracked party hides trail (and moves at half speed)')), DataCell(Text('+5'))]),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text('¹ Apply only the largest modifier from this category.'),
                ],
              ),
            ),
          ],
        ),
        ExpansionTile(
          title: const Text('Swim'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Swim DCs by Water Condition', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Water Condition')),
                        DataColumn(label: Text('Swim DC')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Calm water')), DataCell(Text('10'))]),
                        DataRow(cells: [DataCell(Text('Rough water')), DataCell(Text('15'))]),
                        DataRow(cells: [DataCell(Text('Stormy water')), DataCell(Text('20¹'))]),
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
          title: const Text('Wind Effects on Flight'),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Wind Effects on Flight', style: TextStyle(fontWeight: FontWeight.bold)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Wind Force')),
                        DataColumn(label: Text('Wind Speed')),
                        DataColumn(label: Text('Checked Size')),
                        DataColumn(label: Text('Blown Away Size')),
                        DataColumn(label: Text('Fly Penalty')),
                      ],
                      rows: const [
                        DataRow(cells: [DataCell(Text('Light')), DataCell(Text('0–10 mph')), DataCell(Text('—')), DataCell(Text('—')), DataCell(Text('—'))]),
                        DataRow(cells: [DataCell(Text('Moderate')), DataCell(Text('11–20 mph')), DataCell(Text('—')), DataCell(Text('—')), DataCell(Text('—'))]),
                        DataRow(cells: [DataCell(Text('Strong')), DataCell(Text('21–30 mph')), DataCell(Text('Tiny')), DataCell(Text('—')), DataCell(Text('-2'))]),
                        DataRow(cells: [DataCell(Text('Severe')), DataCell(Text('31–50 mph')), DataCell(Text('Small')), DataCell(Text('Tiny')), DataCell(Text('-4'))]),
                        DataRow(cells: [DataCell(Text('Windstorm')), DataCell(Text('51–74 mph')), DataCell(Text('Medium')), DataCell(Text('Small')), DataCell(Text('-8'))]),
                        DataRow(cells: [DataCell(Text('Hurricane')), DataCell(Text('75–174 mph')), DataCell(Text('Large')), DataCell(Text('Medium')), DataCell(Text('-12'))]),
                        DataRow(cells: [DataCell(Text('Tornado')), DataCell(Text('175+ mph')), DataCell(Text('Huge')), DataCell(Text('Large')), DataCell(Text('-16'))]),
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
