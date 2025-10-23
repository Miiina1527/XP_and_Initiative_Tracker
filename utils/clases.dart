const List<Map<String, dynamic>> clasesPathfinder = [
  {
    "nombre": "Alquimista",
    "tipo": "básica",
    "descripcion": "Maestro de pociones, bombas y mutágenos.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (arcano)",
      "Conocimiento (naturaleza)",
      "Hechicería (UOM)",
      "Oficio",
      "Percepción"
    ]
  },
  {
    "nombre": "Antipaladín",
    "tipo": "básica",
    "descripcion": "Versión maligna del paladín.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (religión)",
      "Diplomacia",
      "Intimidar",
      "Montar",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Bardo",
    "tipo": "básica",
    "descripcion": "Artista y lanzador de conjuros versátil.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 6,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Averiguar intenciones",
      "Conocimiento (todos)",
      "Diplomacia",
      "Disfraz",
      "Escapismo",
      "Interpretar",
      "Lingüística",
      "Percepción",
      "Engañar",
      "Oficio",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Brujo (Witch)",
    "tipo": "básica",
    "descripcion": "Lanzador arcano con poderes de pacto.",
    "dadoGolpe": "d6",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Conocimiento (arcano)",
      "Conocimiento (naturaleza)",
      "Conocimiento (los planos)",
      "Conocimiento (religión)",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Bárbaro",
    "tipo": "básica",
    "descripcion": "Guerrero feroz que canaliza la furia en combate.",
    "dadoGolpe": "d12",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Acrobacias",
      "Intimidar",
      "Montar",
      "Nadar",
      "Supervivencia",
      "Trepar",
      "Artesanía",
      "Oficio",
      "Percepción"
    ]
  },
  {
    "nombre": "Caballero (Cavalier)",
    "tipo": "básica",
    "descripcion": "Guerrero montado y líder de batalla.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (nobleza)",
      "Conocimiento (historia)",
      "Diplomacia",
      "Intimidar",
      "Montar",
      "Profesión",
      "Sentir motivaciones"
    ]
  },
  {
    "nombre": "Cazador (Hunter)",
    "tipo": "híbrida",
    "descripcion": "Combinación de druida y explorador.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 6,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (geografía)",
      "Conocimiento (naturaleza)",
      "Curar",
      "Hechicería (UOM)",
      "Montar",
      "Oficio",
      "Percepción",
      "Profesión",
      "Supervivencia"
    ]
  },
  {
    "nombre": "Clérigo",
    "tipo": "básica",
    "descripcion": "Devoto lanzador divino y sanador.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Diplomacia",
      "Hechicería (UOM)",
      "Oficio",
      "Profesión",
      "Curar",
      "Sentir motivaciones"
    ]
  },
  {
    "nombre": "Druida",
    "tipo": "básica",
    "descripcion": "Lanzador divino con poder sobre la naturaleza y cambio de forma.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (naturaleza)",
      "Diplomacia",
      "Hechicería (UOM)",
      "Montar",
      "Nadar",
      "Oficio",
      "Percepción",
      "Profesión",
      "Saber (geografía)",
      "Supervivencia",
      "Trepar"
    ]
  },
  {
    "nombre": "Escaldo (Skald)",
    "tipo": "híbrida",
    "descripcion": "Bardo bárbaro que inspira furia.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Averiguar intenciones",
      "Conocimiento (todos)",
      "Diplomacia",
      "Disfraz",
      "Intimidar",
      "Interpretar",
      "Percepción",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Espiritualista (Spiritualist)",
    "tipo": "básica",
    "descripcion": "Lanzador que canaliza fantasmas.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Averiguar intenciones",
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Diplomacia",
      "Lingüística",
      "Percepción",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Explorador (Ranger)",
    "tipo": "básica",
    "descripcion": "Cazador y rastreador experto en el combate a distancia.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 6,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (geografía)",
      "Conocimiento (naturaleza)",
      "Conocimiento (los planos)",
      "Montar",
      "Nadar",
      "Oficio",
      "Percepción",
      "Profesión",
      "Sigilo",
      "Supervivencia",
      "Trepar"
    ]
  },
  {
    "nombre": "Guerrero",
    "tipo": "básica",
    "descripcion": "Combatiente experto en armas y armaduras.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Escalar",
      "Intimidar",
      "Montar",
      "Nadar",
      "Oficio",
      "Profesión"
    ]
  },
  {
    "nombre": "Hechicero",
    "tipo": "básica",
    "descripcion": "Lanzador arcano con magia innata.",
    "dadoGolpe": "d6",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (arcano)",
      "Oficio",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Hechicero Arquetipo (Arcanist)",
    "tipo": "híbrida",
    "descripcion": "Combinación de mago y hechicero.",
    "dadoGolpe": "d6",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Lingüística",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Inquisidor",
    "tipo": "básica",
    "descripcion": "Agente divino versátil y cazador de herejes.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 6,
    "habilidadesClase": [
      "Averiguar intenciones",
      "Conocimiento (arcano)",
      "Conocimiento (dungeons)",
      "Conocimiento (historia)",
      "Conocimiento (local)",
      "Conocimiento (naturaleza)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Diplomacia",
      "Disfraz",
      "Intimidar",
      "Percepción",
      "Profesión",
      "Sentir motivaciones",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Invocador (Summoner)",
    "tipo": "básica",
    "descripcion": "Lanzador arcano que invoca criaturas poderosas.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (arcano)",
      "Conocimiento (los planos)",
      "Hechicería (UOM)",
      "Profesión"
    ]
  },
  {
    "nombre": "Kineticista",
    "tipo": "básica",
    "descripcion": "Manipulador de energías elementales.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (arcano)",
      "Conocimiento (naturaleza)",
      "Conocimiento (los planos)",
      "Lingüística",
      "Percepción",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Ladrón (Pícaro)",
    "tipo": "básica",
    "descripcion": "Especialista en sigilo, trampas y habilidades.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 8,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Averiguar intenciones",
      "Engañar",
      "Lingüística",
      "Percepción",
      "Diplomacia",
      "Oficio",
      "Abrir cerraduras",
      "Sigilo",
      "Desarmar trampas",
      "Trepar"
    ]
  },
  {
    "nombre": "Mago",
    "tipo": "básica",
    "descripcion": "Lanzador arcano estudioso y versátil.",
    "dadoGolpe": "d6",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (arcano)",
      "Conocimiento (dungeons)",
      "Conocimiento (historia)",
      "Conocimiento (los planos)",
      "Conocimiento (religión)",
      "Lingüística",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Mesmerista",
    "tipo": "básica",
    "descripcion": "Hipnotizador y manipulador mental.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Averiguar intenciones",
      "Conocimiento (arcano)",
      "Conocimiento (local)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Disfraz",
      "Engañar",
      "Interpretar",
      "Lingüística",
      "Percepción",
      "Sentir motivaciones",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Monje",
    "tipo": "básica",
    "descripcion": "Guerrero disciplinado con habilidades sobrenaturales.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Acrobacias",
      "Escapismo",
      "Percepción",
      "Escalar",
      "Intimidar",
      "Saltar",
      "Sigilo",
      "Nadar",
      "Conocimiento (religión)",
      "Artesanía",
      "Profesión"
    ]
  },
  {
    "nombre": "Medium",
    "tipo": "básica",
    "descripcion": "Canalizador de espíritus y poderes ancestrales.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Averiguar intenciones",
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (local)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Diplomacia",
      "Percepción",
      "Sentir motivaciones",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Místico (Occultist)",
    "tipo": "básica",
    "descripcion": "Usuario de magia oculta y objetos mágicos.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Averiguar intenciones",
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (local)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Lingüística",
      "Percepción",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Ninja",
    "tipo": "alternativa",
    "descripcion": "Asesino sigiloso y maestro del disfraz.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 8,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Averiguar intenciones",
      "Engañar",
      "Disfraz",
      "Lingüística",
      "Percepción",
      "Oficio",
      "Abrir cerraduras",
      "Sigilo",
      "Desarmar trampas",
      "Trepidación (Escalar, Nadar, Trepar)"
    ]
  },
  {
    "nombre": "Orador (Skald)",
    "tipo": "híbrida",
    "descripcion": "Bardo bárbaro que inspira furia.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Averiguar intenciones",
      "Conocimiento (todos)",
      "Diplomacia",
      "Disfraz",
      "Intimidar",
      "Interpretar",
      "Percepción",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Oráculo",
    "tipo": "básica",
    "descripcion": "Lanzador divino con misteriosos poderes.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (naturaleza)",
      "Conocimiento (religión)",
      "Diplomacia",
      "Percepción",
      "Profesión",
      "Curar",
      "Sentir motivaciones",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Paladín",
    "tipo": "básica",
    "descripcion": "Guerrero sagrado con poderes divinos.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (nobleza)",
      "Conocimiento (religión)",
      "Diplomacia",
      "Sanar",
      "Montar",
      "Profesión",
      "Sentir motivaciones",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Pistolero (Gunslinger)",
    "tipo": "básica",
    "descripcion": "Experto en armas de fuego y puntería.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Intimidar",
      "Montar",
      "Percepción",
      "Profesión",
      "Saltar"
    ]
  },
  {
    "nombre": "Psíquico (Psychic)",
    "tipo": "básica",
    "descripcion": "Lanzador de magia psíquica.",
    "dadoGolpe": "d6",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Averiguar intenciones",
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (naturaleza)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Lingüística",
      "Percepción",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
    {
    "nombre": "Samurái",
    "tipo": "alternativa",
    "descripcion": "Guerrero honorable y maestro de la katana.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (historia)",
      "Conocimiento (nobleza)",
      "Diplomacia",
      "Intimidar",
      "Montar",
      "Percepción",
      "Profesión",
      "Sentir motivaciones"
    ]
  },
  {
    "nombre": "Shaman",
    "tipo": "básica",
    "descripcion": "Lanzador divino conectado con los espíritus.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Averiguar intenciones",
      "Conocimiento (arcano)",
      "Conocimiento (historia)",
      "Conocimiento (naturaleza)",
      "Conocimiento (religión)",
      "Conocimiento (los planos)",
      "Diplomacia",
      "Percepción",
      "Profesión",
      "Sanar",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Shifter",
    "tipo": "básica",
    "descripcion": "Guerrero cambiaformas con poderes naturales.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Conocimiento (naturaleza)",
      "Nadar",
      "Percepción",
      "Profesión",
      "Sigilo",
      "Supervivencia",
      "Trepar"
    ]
  },
  {
    "nombre": "Slayer",
    "tipo": "híbrida",
    "descripcion": "Combinación de pícaro y explorador.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 6,
    "habilidadesClase": [
      "Acrobacias",
      "Artesanía",
      "Averiguar intenciones",
      "Conocimiento (dungeons)",
      "Conocimiento (geografía)",
      "Conocimiento (local)",
      "Conocimiento (naturaleza)",
      "Escapismo",
      "Intimidar",
      "Percepción",
      "Oficio",
      "Sigilo",
      "Supervivencia"
    ]
  },
  {
    "nombre": "Swashbuckler",
    "tipo": "híbrida",
    "descripcion": "Espadachín ágil y carismático.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 4,
    "habilidadesClase": [
      "Acrobacias",
      "Averiguar intenciones",
      "Bluff (Engañar)",
      "Diplomacia",
      "Intimidar",
      "Percepción",
      "Profesión"
    ]
  },
  {
    "nombre": "Vigilante (Vigilante)",
    "tipo": "básica",
    "descripcion": "Héroe de doble identidad y habilidades versátiles.",
    "dadoGolpe": "d10",
    "puntosHabilidad": 6,
    "habilidadesClase": [
      "Acrobacias",
      "Averiguar intenciones",
      "Conocimiento (local)",
      "Diplomacia",
      "Disfraz",
      "Engañar",
      "Intimidar",
      "Percepción",
      "Sigilo",
      "Profesión",
      "Hechicería (UOM)"
    ]
  },
  {
    "nombre": "Warpriest",
    "tipo": "híbrida",
    "descripcion": "Guerrero sagrado con magia divina.",
    "dadoGolpe": "d8",
    "puntosHabilidad": 2,
    "habilidadesClase": [
      "Artesanía",
      "Conocimiento (religión)",
      "Conocimiento (historia)",
      "Diplomacia",
      "Intimidar",
      "Profesión",
      "Curar",
      "Hechicería (UOM)"
    ]
  }
];

