// Lista de las 20 plantillas más usadas en Pathfinder
const List<Map<String, dynamic>> plantillasPathfinder = [
  {
    "nombre": "Aberración",
    "type": "other",
    "descripcion": "Criatura con anatomía y mente alienígena, resistente a efectos mentales.",
    "mods": {
      "fuerza": 2,
      "destreza": 0,
      "constitucion": 2,
      "inteligencia": 2,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Resistencia a efectos mentales", "Visión en la oscuridad"],
    "caracteristicas": ["Ataques naturales"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Bestia Mágica",
    "type": "other",
    "descripcion": "Animal con habilidades sobrenaturales y mayor inteligencia.",
    "mods": {
      "fuerza": 2,
      "destreza": 2,
      "constitucion": 2,
      "inteligencia": 2,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["DR/magia", "Sentidos agudos"],
    "caracteristicas": ["Puede lanzar conjuros menores"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Celestial (Half-Celestial)",
    "type": "other",
    "descripcion": "Criatura con sangre celestial, con resistencias y conjuros innatos.",
    "mods": {
      "fuerza": 4,
      "destreza": 0,
      "constitucion": 2,
      "inteligencia": 2,
      "sabiduria": 2,
      "carisma": 2
    },
    "traits": ["Resistencia a energía", "Conjuros innatos", "Alas"],
    "caracteristicas": ["Visión en la oscuridad", "DR/malvado"],
    "idiomas": ["Common", "Celestial"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Constructo",
    "type": "other",
    "descripcion": "Criatura artificial, inmune a efectos biológicos y mentales.",
    "mods": {
      "fuerza": 2,
      "destreza": 0,
      "constitucion": 0,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Inmune a veneno", "Inmune a enfermedad", "No duerme"],
    "caracteristicas": ["No puede ser curado por energía positiva"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Demonio (Half-Fiend)",
    "type": "other",
    "descripcion": "Criatura con sangre demoníaca, con resistencias y conjuros innatos.",
    "mods": {
      "fuerza": 4,
      "destreza": 0,
      "constitucion": 2,
      "inteligencia": 2,
      "sabiduria": 2,
      "carisma": 2
    },
    "traits": ["Resistencia a energía", "Conjuros innatos", "Alas"],
    "caracteristicas": ["Visión en la oscuridad", "DR/bien"],
    "idiomas": ["Common", "Infernal"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Elemental",
    "type": "other",
    "descripcion": "Criatura compuesta de uno de los elementos primordiales.",
    "mods": {
      "fuerza": 2,
      "destreza": 2,
      "constitucion": 2,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Resistencia elemental", "Ataques elementales"],
    "caracteristicas": ["No respira", "No duerme"],
    "idiomas": ["Common"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Engendro de Vampiro",
    "type": "undead",
    "descripcion": "No muerto creado por vampiro, con habilidades menores.",
    "mods": {
      "fuerza": 0,
      "destreza": 0,
      "constitucion": 0,
      "inteligencia": -2,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Drenaje de sangre menor", "Obediencia al vampiro creador"],
    "caracteristicas": ["No puede crear engendros"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Esqueleto",
    "type": "undead",
    "descripcion": "No muerto animado, resistente a daño cortante y frío.",
    "mods": {
      "fuerza": 2,
      "destreza": 2,
      "constitucion": 0,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["DR/golpe contundente", "Inmune a frío"],
    "caracteristicas": ["No puede hablar", "Obedece órdenes simples"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Fantasma",
    "type": "undead",
    "descripcion": "No muerto incorpóreo, capaz de poseer y asustar.",
    "mods": {
      "fuerza": 0,
      "destreza": 0,
      "constitucion": 0,
      "inteligencia": 2,
      "sabiduria": 2,
      "carisma": 2
    },
    "traits": ["Incorpóreo", "Posesión", "Aullido aterrador"],
    "caracteristicas": ["Rejuvenecimiento", "Puede volar"],
    "idiomas": ["Common"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Lich",
    "type": "undead",
    "descripcion": "Poderoso no muerto lanzador de conjuros, con filacteria y resistencias mágicas.",
    "mods": {
      "fuerza": 0,
      "destreza": 0,
      "constitucion": 0,
      "inteligencia": 2,
      "sabiduria": 2,
      "carisma": 2
    },
    "traits": ["Filacteria", "Resistencia a conjuros", "Inmune a frío y electricidad"],
    "caracteristicas": ["Rejuvenecimiento", "Toque paralizante"],
    "idiomas": ["Common"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Licántropo",
    "type": "other",
    "descripcion": "Humanoide capaz de transformarse en animal, con resistencia y ataques naturales.",
    "mods": {
      "fuerza": 2,
      "destreza": 2,
      "constitucion": 2,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Cambio de forma", "DR/plata", "Sentidos agudos"],
    "caracteristicas": ["Ataques naturales (mordisco/garras)", "Vulnerable a plata"],
    "idiomas": ["Common"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Licántropo Infectado",
    "type": "other",
    "descripcion": "Humanoide infectado por licantropía, con cambio de forma involuntario.",
    "mods": {
      "fuerza": 2,
      "destreza": 2,
      "constitucion": 2,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Cambio de forma involuntario", "DR/plata"],
    "caracteristicas": ["Ataques naturales", "Vulnerable a plata"],
    "idiomas": ["Common"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Momia",
    "type": "undead",
    "descripcion": "No muerto envuelto en vendas, con aura de miedo y toque desecante.",
    "mods": {
      "fuerza": 0,
      "destreza": 0,
      "constitucion": -2,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 2
    },
    "traits": ["Aura de miedo", "Toque desecante"],
    "caracteristicas": ["Vulnerable al fuego", "Resistente a frío y electricidad"],
    "idiomas": ["Common"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "No Muerto",
    "type": "undead",
    "descripcion": "Criatura animada por energía negativa, inmune a efectos de muerte y enfermedades.",
    "mods": {
      "fuerza": 2,
      "destreza": 0,
      "constitucion": 0,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 2
    },
    "traits": ["Inmune a muerte", "Inmune a enfermedad", "No respira"],
    "caracteristicas": ["No puede ser curado por energía positiva", "Vulnerable a energía positiva"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Planta Animada",
    "type": "other",
    "descripcion": "Planta con movilidad y ataques naturales.",
    "mods": {
      "fuerza": 2,
      "destreza": 0,
      "constitucion": 2,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Inmune a polimorfismo", "Resistente a venenos"],
    "caracteristicas": ["Ataques naturales (ramas/vide)"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Quimérico",
    "type": "other",
    "descripcion": "Criatura con partes de diferentes animales, con múltiples ataques naturales.",
    "mods": {
      "fuerza": 2,
      "destreza": 2,
      "constitucion": 2,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 0
    },
    "traits": ["Ataques múltiples", "Sentidos agudos"],
    "caracteristicas": ["Puede volar (si tiene alas)", "Ataques de mordisco/garras/cuernos"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Sombra",
    "type": "undead",
    "descripcion": "No muerto de las sombras, con habilidades de drenaje de fuerza.",
    "mods": {
      "fuerza": 0,
      "destreza": 2,
      "constitucion": 0,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 2
    },
    "traits": ["Incorpóreo", "Drenaje de fuerza"],
    "caracteristicas": ["Resistente a frío", "Puede atravesar objetos"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Vampiro",
    "type": "undead",
    "descripcion": "No muerto con habilidades de drenaje de sangre y regeneración.",
    "mods": {
      "fuerza": 2,
      "destreza": 2,
      "constitucion": 0,
      "inteligencia": 2,
      "sabiduria": 0,
      "carisma": 4
    },
    "traits": ["Regeneración", "Drenaje de sangre", "Forma de niebla"],
    "caracteristicas": ["Debilidad a luz solar", "Puede crear engendros"],
    "idiomas": ["Common"],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  },
  {
    "nombre": "Zombie",
    "type": "undead",
    "descripcion": "No muerto lento y resistente, difícil de destruir.",
    "mods": {
      "fuerza": 0,
      "destreza": -2,
      "constitucion": 0,
      "inteligencia": 0,
      "sabiduria": 0,
      "carisma": 2
    },
    "traits": ["DR/cortante", "Lento"],
    "caracteristicas": ["No puede correr", "Obedece órdenes simples"],
    "idiomas": [],
    "habilidadesExtra": [],
    "puntosHabilidadExtra": 0
  }
];