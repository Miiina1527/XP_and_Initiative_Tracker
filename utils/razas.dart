// Lista de razas core de Pathfinder con modificadores, traits e idiomas base
const List<Map<String, dynamic>> razasPathfinder = [
    {
        "nombre": "Aasimar",
        "descripcion": "Descendientes de seres celestiales, los aasimars irradian bondad y poseen dones sobrenaturales.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visión en la oscuridad",
            "Resistencia celestial",
            "Luz diurna 1/día"
        ],
        "skill_bonuses": [
            "+2 a Diplomacia",
            "+2 a Sentir Motivo"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Luz diurna",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Celestial"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Android",
        "descripcion": "Artificial humanoids with resistances and logical minds.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Constructed",
            "Emotionless",
            "Nanite surge"
        ],
        "skill_bonuses": [
            "+2 a Percepción"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Androffan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Aquatic Elf",
        "descripcion": "Elves adapted to aquatic environments, with swim speed and water breathing.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Swim speed",
            "Water breathing",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Nadar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Elven"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Astomoi",
        "descripcion": "Mysterious, faceless humanoids with telepathy and resistance to poison.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Telepathy",
            "Poison resistance",
            "Blindsight"
        ],
        "skill_bonuses": [
            "+2 a Percepción"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Astomoi"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Caligni",
        "descripcion": "Shadow-dwelling humanoids with darkvision and stealth abilities.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Darkvision",
            "Stealthy",
            "Shadow magic"
        ],
        "skill_bonuses": [
            "+2 a Sigilo"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Caligni"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Catfolk",
        "descripcion": "Ágiles y curiosos, los felinoides destacan por su sigilo y su naturaleza juguetona.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la penumbra",
            "Reflejos felinos",
            "Sigilo natural"
        ],
        "skill_bonuses": [
            "+2 a Acrobacias",
            "+2 a Sigilo"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Catfolk"
        ],  
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Changeling",
        "descripcion": "Shapechanging offspring of hags, skilled in deception and disguise.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Change shape (humanoid)",
            "Hag heritage",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Engañar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Deep One Hybrid",
        "descripcion": "Humanoids with deep one ancestry, gaining aquatic traits and madness resistance.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Aquatic adaptation",
            "Madness resistance",
            "Swim speed"
        ],
        "skill_bonuses": [
            "+2 a Nadar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Aquan"
        ], 
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Dhampir",
        "descripcion": "Hijos de vampiros y mortales, los dhampiros caminan entre la vida y la muerte con habilidades únicas.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": -2,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la oscuridad",
            "Resistencia a energía negativa",
            "Hijo de la noche"
        ],
        "skill_bonuses": [
            "+2 a Engañar",
            "+2 a Percepció"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Varisian"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Drider",
        "descripcion": "Drow transformed into spider-like aberrations, skilled in magic and climbing.",
        "mods": {
            "fuerza": 2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Grande",
        "feats_traits": [
            "Spider climb",
            "Spellcasting",
            "Darkvision"
        ],
        "skill_bonuses": [
            "+2 a Trepar"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Web",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Elven",
            "Undercommon"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Drow",
        "descripcion": "Elfos oscuros de las profundidades, los drow son astutos, peligrosos y maestros de la magia sombría.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": -2,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la oscuridad superior",
            "Resistencia a conjuros",
            "Magia drow"
        ],
        "skill_bonuses": [
            "+2 a Engañar",
            "+2 a Sigilo"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Oscuridad",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Elven",
            "Undercommon"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Drow (Noble)",
        "descripcion": "Noble drow with powerful magical abilities and resistances.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": -2,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Superior darkvision",
            "Spell resistance",
            "Noble magic"
        ],
        "skill_bonuses": [
            "+2 a Engañar",
            "+2 a Sigilo"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Levitate",
                "tipo": "Sp",
                "uso": "1/día"
            },
            {
                "nombre": "Detect Thoughts",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Elven",
            "Undercommon"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Duergar",
        "descripcion": "Enanos de las profundidades, los duergar son resistentes y poseen extraños poderes mágicos.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -4
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la oscuridad superior",
            "Resistencia a conjuros",
            "Magia duergar"
        ],
        "skill_bonuses": [
            "+2 a Sigilo en piedra"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Agrandar persona",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Dwarven",
            "Undercommon"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Dwarf",
        "descripcion": "Robustos y tenaces, los enanos son conocidos por su habilidad minera y su lealtad inquebrantable.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la oscuridad",
            "Estabilidad",
            "Bonificador contra venenos",
            "Bonificador contra conjuros y efectos de magia",
            "Entrenamiento con armas enanas"
        ],
        "skill_bonuses": [
            "+2 a Percepció para piedra y metal",
            "+2 a Tasació de metales y gemas"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Dwarven"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Elf",
        "descripcion": "Seres longevos y gráciles, los elfos valoran la magia, el arte y la naturaleza por encima de todo.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": -2,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la penumbra",
            "Inmunidad a sueño mágico",
            "Bonificador contra encantamientos",
            "Competencia con armas largas y arcos"
        ],
        "skill_bonuses": [
            "+2 a Percepció"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Luz",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Elven"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Fetchling",
        "descripcion": "Marcados por el Plano de las Sombras, los sombríngidos son misteriosos y escurridizos.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la penumbra",
            "Afinidad con las sombras",
            "Resistencia a energía negativa"
        ],
        "skill_bonuses": [
            "+2 a Sigilo en penumbra"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Oscurecer objetos",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Fetchling"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Ganzi",
        "descripcion": "Plane-touched humanoids with chaotic traits and resistances.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Chaos resistance",
            "Wild magic",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Engañar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Ganzi"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Gargoyle",
        "descripcion": "Stone-skinned winged creatures, skilled at ambush and defense.",
        "mods": {
            "fuerza": 4,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Natural armor +4",
            "Wings (flight)",
            "Freeze (statue)"
        ],
        "skill_bonuses": [
            "+2 a Sigilo"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Terran"
        ], 
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Gathlain",
        "descripcion": "Fey creatures with wings and magical abilities.",
        "mods": {
            "fuerza": -2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Wings (flight)",
            "Fey magic",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Acrobacias"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Entangle",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Sylvan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Ghoran",
        "descripcion": "Plant-based humanoids with regeneration and photosynthesis.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Plant traits",
            "Regeneration",
            "Photosynthesis"
        ],
        "skill_bonuses": [
            "+2 a Conocimiento (naturaleza)"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Sylvan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Gillmen",
        "descripcion": "Aquatic humanoids with gills and swim speed.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Gills",
            "Swim speed",
            "Water dependency"
        ],
        "skill_bonuses": [
            "+2 a Nadar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Aquan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Gnoll",
        "descripcion": "Hyena-like humanoids known for their strength and ferocity.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Darkvision",
            "Ferocity",
            "Natural weapons (bite)"
        ],
        "skill_bonuses": [
            "+2 a Intimidar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Gnoll"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Gnome",
        "descripcion": "Curiosos y excéntricos, los gnomos disfrutan de la magia, la invenció y las bromas ingeniosas.",
        "mods": {
            "fuerza": -2,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la penumbra",
            "Afinidad con la magia ilusoria",
            "Bonificador contra efectos de miedo",
            "Competencia con armas gnomos"
        ],
        "skill_bonuses": [
            "+2 a Artesanía (alquimia)",
            "+2 a Engañar"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Hablar con animales",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Gnome",
            "Sylvan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Goblin",
        "descripcion": "Pequeños, traviesos y a menudo peligrosos, los goblins son conocidos por su energía caótica.",
        "mods": {
            "fuerza": -2,
            "destreza": 4,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": -2,
            "carisma": 0
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Visió en la oscuridad",
            "Pies ligeros",
            "Piel resistente"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Goblin"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Grippli",
        "descripcion": "Small frog-like humanoids, agile and skilled at climbing.",
        "mods": {
            "fuerza": -2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": 0
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Camouflage",
            "Swamp stride",
            "Climb speed"
        ],
        "skill_bonuses": [
            "+2 a Sigilo",
            "+2 a Trepar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Grippli"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Half-Elf",
        "descripcion": "Híbridos de humano y elfo, los semielfos combinan lo mejor de ambos mundos y se adaptan fácilmente.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la penumbra",
            "Adaptabilidad",
            "Inmunidad a efectos de sueño mágico",
            "Bonificador contra encantamientos"
        ],
        "skill_bonuses": [
            "+2 a Diplomacia"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Elven"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Half-Orc",
        "descripcion": "De sangre mezclada, los semiorcos luchan por encontrar su lugar, mostrando fuerza y determinació.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Visió en la oscuridad",
            "Intimidante",
            "Furia orca",
            "Competencia con armas orcas"
        ],
        "skill_bonuses": [
            "+2 a Intimidar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Orc"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Halfling",
        "descripcion": "Pequeños de estatura pero grandes de corazó, los medianos son famosos por su suerte y su espíritu alegre.",
        "mods": {
            "fuerza": -2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Bonificador a salvaciones",
            "Bonificador a sigilo",
            "Bonificador a acrobacias y trepar",
            "Competencia con armas pequeñas"
        ],
        "skill_bonuses": [
            "+2 a Sigilo"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Halfling"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Hobgoblin",
        "descripcion": "Organizados y marciales, los hobgoblins valoran la disciplina y la fuerza militar.",
        "mods": {
            "fuerza": 2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la oscuridad",
            "Disciplina marcial",
            "Sigilo en la guerra"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Común",
            "Goblin"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Human",
        "descripcion": "Adaptables y versátiles, los humanos prosperan en cualquier entorno y destacan en todas las profesiones.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Talento adicional",
            "Puntos de habilidad extra"
        ],
        "skill_bonuses": [],
        "bonus_feats": [
            "Talento adicional a nivel 1"
        ],
        "spell_like": [],
        "idiomas": [
            "Common"
        ],
        "puntos Habilidad Extra": 1
    },
    {
        "nombre": "Ifrit",
        "descripcion": "Descendientes de genios de fuego, los ifrits son apasionados y poseen una afinidad ígnea.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": -2,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Resistencia al fuego",
            "Magia ígnea",
            "Visió en la oscuridad"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Ignan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Kasatha",
        "descripcion": "Four-armed desert dwellers, skilled in combat and survival.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Four arms",
            "Desert runner",
            "Desert survival"
        ],
        "skill_bonuses": [
            "+2 a Atletismo"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Kasatha"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Kitsune",
        "descripcion": "Foxfolk shapeshifters known for their charm, agility, and magical abilities.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Change shape (fox/human)",
            "Low-light vision",
            "Natural weapons (bite)",
            "+2 bonus on Bluff checks"
        ],
        "skill_bonuses": [
            "+2 a Engañar"
        ],
        "bonus_feats": [],
        "spell_like": [
            {
                "nombre": "Dancing Lights",
                "tipo": "Sp",
                "uso": "1/día"
            }
        ],
        "idiomas": [
            "Common",
            "Sylvan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Kobold",
        "descripcion": "Pequeños y astutos, los kobolds son expertos excavadores y veneran a los dragones.",
        "mods": {
            "fuerza": -4,
            "destreza": 2,
            "constitucion": -2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Visió en la oscuridad",
            "Excavador",
            "Sigilo natural"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Draconic"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Kuru",
        "descripcion": "Savage islanders with a taste for flesh and water adaptation.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Water adaptation",
            "Savage bite",
            "Darkvision"
        ],
        "skill_bonuses": [
            "+2 a Intimidar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Kuru"
        ], 
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Lashunta",
        "descripcion": "Telepathic humanoids with two subraces: charismatic or tough.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Telepathy",
            "Student of technology",
            "Limited telekinesis"
        ],
        "skill_bonuses": [
            "+2 a Diplomacia"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Lashunta"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Lizardfolk",
        "descripcion": "Reptilian humanoids with natural armor and swimming ability.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Natural armor +2",
            "Hold breath",
            "Swim speed"
        ],
        "skill_bonuses": [
            "+2 a Percepció"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Draconic"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Merfolk",
        "descripcion": "Aquatic humanoids with fish tails, excellent swimmers and singers.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Swim speed",
            "Amphibious",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Nadar",
            "+2 a Actuació (cantar)"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Aquan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Monkey Goblin",
        "descripcion": "Agile goblins with prehensile tails and climbing skills.",
        "mods": {
            "fuerza": -2,
            "destreza": 4,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": -2,
            "carisma": 0
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Prehensile tail",
            "Climb speed",
            "Darkvision"
        ],
        "skill_bonuses": [
            "+2 a Acrobacias",
            "+2 a Trepar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Goblin"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Munavri",
        "descripcion": "Pale-skinned subterranean humanoids with telepathy and keen minds.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Telepathy",
            "Light sensitivity",
            "Keen mind"
        ],
        "skill_bonuses": [
            "+2 a Conocimiento (dungeoneering)"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Munavri"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Nagaji",
        "descripcion": "Serpentine humanoids with strong bodies and resistance to poison.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Low-light vision",
            "Poison resistance",
            "Natural armor +1",
            "+2 bonus on Diplomacy checks"
        ],
        "skill_bonuses": [
            "+2 a Diplomacia"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Nagaji"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Orang-Pendak",
        "descripcion": "Small, ape-like jungle dwellers with climbing skills.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Climb speed",
            "Jungle adaptation",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Trepar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Orang-Pendak"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Orc",
        "descripcion": "Fieros y temidos, los orcos viven para la batalla y la supervivencia en entornos hostiles.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": -2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Visió en la oscuridad",
            "Furia orca",
            "Intimidante"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Orc"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Oread",
        "descripcion": "Con sangre elemental de tierra, los oreads son sólidos, pacientes y resistentes.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Resistencia a la tierra",
            "Magia pétrea",
            "Visió en la oscuridad"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Terran"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Ratfolk",
        "descripcion": "Ingeniosos y colaborativos, los ratafolk prosperan en comunidades subterráneas.",
        "mods": {
            "fuerza": -2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la penumbra",
            "Trabajo en equipo",
            "Sigilo natural"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Ratfolk"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Reptoid",
        "descripcion": "Shapechanging reptilian humanoids, masters of infiltration.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Change shape (humanoid)",
            "Infiltrator",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Engañar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Draconic"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Samsaran",
        "descripcion": "Seres de almas reencarnadas, los samsaran buscan sabiduría a través de vidas pasadas.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": -2,
            "inteligencia": 2,
            "sabiduria": 2,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Memoria ancestral",
            "Visió en la penumbra",
            "Resistencia a conjuros mentales"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Samsaran"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Shabti",
        "descripcion": "Constructed beings created to serve as proxies for their creators in the afterlife.",
        "mods": {
            "fuerza": 0,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Immortal",
            "Constructed",
            "Resist negative energy"
        ],
        "skill_bonuses": [
            "+2 a Conocimiento (religió)"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Necril"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Skinwalker",
        "descripcion": "Shapechangers with animal ancestry, able to shift between forms.",
        "mods": {
            "fuerza": 2,
            "destreza": 0,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Change shape (beast-hybrid)",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Supervivencia"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Strix",
        "descripcion": "Criaturas aladas y reservadas, los strix valoran la libertad y la desconfianza hacia extraños.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Alas para volar",
            "Visió en la oscuridad",
            "Desconfianza racial"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Strix"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Suli",
        "descripcion": "Descendientes de genios elementales, los suli dominan varias energías elementales.",
        "mods": {
            "fuerza": 2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Resistencia elemental",
            "Magia elemental menor",
            "Visió en la oscuridad"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Terran",
            "Ignan",
            "Aquan",
            "Auran"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Suli-jann",
        "descripcion": "Suli de linaje más puro, los suli-jann poseen poderes elementales aún mayores.",
        "mods": {
            "fuerza": 2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Resistencia elemental superior",
            "Magia elemental",
            "Visió en la oscuridad"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Terran",
            "Ignan",
            "Aquan",
            "Auran"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Svirfneblin",
        "descripcion": "Gnomos de las profundidades, los svirfneblin son sigilosos y maestros de la magia ilusoria.",
        "mods": {
            "fuerza": -2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Visió en la oscuridad superior",
            "Magia svirfneblin",
            "Bonificador a sigilo"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Gnome",
            "Undercommon"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Sylph",
        "descripcion": "Ligados al aire, las sílfides son etéreas, inteligentes y difíciles de atrapar.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Resistencia al aire",
            "Magia aérea",
            "Visió en la oscuridad"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Auran"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Syrinx",
        "descripcion": "Owl-like humanoids with keen senses and magical abilities.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Keen senses",
            "Magical aptitude",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Percepció"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Syrinx"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Tengu",
        "descripcion": "Avian humanoids known for their quickness, curiosity, and sword skills.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Low-light vision",
            "Swordtrained",
            "Gifted linguist",
            "Natural attacks (bite)"
        ],
        "skill_bonuses": [
            "+2 a Percepció"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Tengu"
        ]
    },
    {
        "nombre": "Tengu",
        "descripcion": "Aves humanoides, los tengu son rápidos, curiosos y hábiles con las armas.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la penumbra",
            "Armas naturales",
            "Aprendizaje de idiomas rápido"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Tengu"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Tiefling",
        "descripcion": "Marcados por la herencia infernal, los tiflin poseen poderes y apariencias inusuales.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Visió en la oscuridad",
            "Resistencia infernal",
            "Magia infernal"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Infernal"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Triaxian",
        "descripcion": "Alien humanoids adapted to extreme climates, with seasonal traits.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Seasonal adaptation",
            "Low-light vision"
        ],
        "skill_bonuses": [
            "+2 a Diplomacia"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Triaxian"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Trox",
        "descripcion": "Large, burrowing insectoid humanoids with great strength.",
        "mods": {
            "fuerza": 4,
            "destreza": 0,
            "constitucion": 2,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Grande",
        "feats_traits": [
            "Burrow speed",
            "Powerful build",
            "Darkvision"
        ],
        "skill_bonuses": [
            "+2 a Intimidar"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Undercommon"
        ]
    },
    {
        "nombre": "Undine",
        "descripcion": "Con sangre de agua elemental, los ondinos son adaptables y fluyen como los ríos.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 2,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Resistencia al agua",
            "Magia acuática",
            "Visió en la oscuridad"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Aquan"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Vanara",
        "descripcion": "Simios ágiles y curiosos, los vanara son conocidos por su destreza y espíritu libre.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Cola prensil",
            "Movimiento ágil",
            "Salto mejorado"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Vanara"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Vishkanya",
        "descripcion": "Exóticos y venenosos, los vishkanya son sigilosos y resistentes a toxinas.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": 2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Veneno natural",
            "Resistencia a venenos",
            "Visió en la penumbra"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Vishkanya"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Wayang",
        "descripcion": "Criaturas sombrías y misteriosas, los wayang tienen una fuerte conexió con las sombras.",
        "mods": {
            "fuerza": -2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": 0
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Afinidad con las sombras",
            "Resistencia a conjuros ilusorios",
            "Visió en la penumbra"
        ],
        "skill_bonuses": [],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Wayang"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Wyrwood",
        "descripcion": "Living constructs made of wood, immune to poison and disease.",
        "mods": {
            "fuerza": 0,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 2,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Pequeño",
        "feats_traits": [
            "Construct traits",
            "Immunity to poison and disease",
            "Wooden body"
        ],
        "skill_bonuses": [
            "+2 a Sigilo"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Wyrwood"
        ],
        "puntos Habilidad Extra": 0
    },
    {
        "nombre": "Wyvaran",
        "descripcion": "Dragon-kin with wings and keen senses.",
        "mods": {
            "fuerza": 2,
            "destreza": 2,
            "constitucion": 0,
            "inteligencia": 0,
            "sabiduria": 0,
            "carisma": -2
        },
        "tamano": "Mediano",
        "feats_traits": [
            "Wings (flight)",
            "Keen senses",
            "Draconic heritage"
        ],
        "skill_bonuses": [
            "+2 a Percepción"
        ],
        "bonus_feats": [],
        "spell_like": [],
        "idiomas": [
            "Common",
            "Draconic"
        ],
        "puntos Habilidad Extra": 0
    }
];
