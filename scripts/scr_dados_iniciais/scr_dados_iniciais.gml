function scr_tipos_init()
{
    global.tipos = ["normal", "fogo", "agua", "planta", "eletrico", "terra", "voador", "veneno", "fantasma", "noturno", "fada", "metal", "lutador", "psiquico", "pedra", "dragao", "gelo", "inseto"];
}

function scr_efetividade_init()
{
    global.efetividade = {};

    global.efetividade.normal = { pedra: 0.5, metal: 0.5, fantasma: 0 };
    global.efetividade.fogo = { planta: 2, gelo: 2, inseto: 2, metal: 2, fogo: 0.5, agua: 0.5, pedra: 0.5, dragao: 0.5 };
    global.efetividade.agua = { fogo: 2, terra: 2, pedra: 2, agua: 0.5, planta: 0.5, dragao: 0.5 };
    global.efetividade.eletrico = { agua: 2, voador: 2, eletrico: 0.5, planta: 0.5, dragao: 0.5, terra: 0 };
    global.efetividade.planta = { agua: 2, terra: 2, pedra: 2, fogo: 0.5, planta: 0.5, veneno: 0.5, voador: 0.5, inseto: 0.5, dragao: 0.5, metal: 0.5 };
    global.efetividade.gelo = { planta: 2, terra: 2, voador: 2, dragao: 2, fogo: 0.5, agua: 0.5, gelo: 0.5, metal: 0.5 };
    global.efetividade.lutador = { normal: 2, gelo: 2, pedra: 2, noturno: 2, metal: 2, veneno: 0.5, voador: 0.5, psiquico: 0.5, inseto: 0.5, fada: 0.5, fantasma: 0 };
    global.efetividade.veneno = { planta: 2, fada: 2, veneno: 0.5, terra: 0.5, pedra: 0.5, fantasma: 0.5, metal: 0 };
    global.efetividade.terra = { fogo: 2, eletrico: 2, veneno: 2, pedra: 2, metal: 2, planta: 0.5, inseto: 0.5, voador: 0 };
    global.efetividade.voador = { planta: 2, lutador: 2, inseto: 2, eletrico: 0.5, pedra: 0.5, metal: 0.5 };
    global.efetividade.psiquico = { lutador: 2, veneno: 2, psiquico: 0.5, metal: 0.5, noturno: 0 };
    global.efetividade.inseto = { planta: 2, psiquico: 2, noturno: 2, fogo: 0.5, lutador: 0.5, veneno: 0.5, voador: 0.5, fantasma: 0.5, metal: 0.5, fada: 0.5 };
    global.efetividade.pedra = { fogo: 2, gelo: 2, voador: 2, inseto: 2, lutador: 0.5, terra: 0.5, metal: 0.5 };
    global.efetividade.fantasma = { fantasma: 2, psiquico: 2, noturno: 0.5, normal: 0 };
    global.efetividade.dragao = { dragao: 2, metal: 0.5, fada: 0 };
    global.efetividade.noturno = { fantasma: 2, psiquico: 2, lutador: 0.5, noturno: 0.5, fada: 0.5 };
    global.efetividade.metal = { gelo: 2, pedra: 2, fada: 2, fogo: 0.5, agua: 0.5, eletrico: 0.5, metal: 0.5 };
    global.efetividade.fada = { lutador: 2, dragao: 2, noturno: 2, fogo: 0.5, veneno: 0.5, metal: 0.5 };
}

function scr_especies_init()
{
   
    global.especies = {};

		global.especies[$ "charmander"] = {
			nome: "Charmander",
			tipo1: "fogo",
			tipo2: "nenhum",
			hp_base: 39,
			atk_base: 52,
			def_base: 43,
			atk_esp_base: 60,
			def_esp_base: 50,
			spd_base: 65,
			taxa_genero: 87.5,
			xp_base: 62,
            taxa_captura: 45,
			taxa_crescimento: "medium_slow",

    habilidades_comuns: ["chama"],
    habilidade_oculta: "poder do sol",

    move_tree: [
        { nivel: 1, movimento_id: "scratch" }, { nivel: 1, movimento_id: "growl" },
        { nivel: 6, movimento_id: "ember" }, { nivel: 8, movimento_id: "smokescreen" },
        { nivel: 12, movimento_id: "dragon_rage" }, { nivel: 17, movimento_id: "scary_face" },
        { nivel: 20, movimento_id: "fire_fang" }, { nivel: 24, movimento_id: "slash" },
        { nivel: 28, movimento_id: "flamethrower" }, { nivel: 32, movimento_id: "dragon_claw" },
        { nivel: 36, movimento_id: "fire_spin" }, { nivel: 40, movimento_id: "inferno" },
        { nivel: 44, movimento_id: "flare_blitz" }
    ],

    outros_movimentos: {
        tms_hms: ["flamethrower", "fire_blast", "toxic"],
        egg_moves: ["dragon_dance", "outrage"],
        tutor_moves: ["heat_wave"]
    },

    evolucoes: [
        { tipo: "nivel", valor: 16, especie_destino: "charmeleon" }
    ]
};


	global.especies[$ "charmeleon"] = {
		nome: "Charmeleon",
		tipo1: "fogo",
		tipo2: "nenhum",
		hp_base: 58,
		atk_base: 64,
		def_base: 58,
		atk_esp_base: 80,
		def_esp_base: 65,
		spd_base: 80,
		taxa_genero: 87.5,
		xp_base: 142,
        taxa_captura: 45,
		taxa_crescimento: "medium_slow",

		habilidades_comuns: ["chama"],
		habilidade_oculta: "poder do sol",

    outros_movimentos: {
        tms_hms: ["flamethrower", "fire_blast", "toxic"],
        egg_moves: ["dragon_dance", "outrage"],
        tutor_moves: ["heat_wave"]
    }
};

    
    global.especies[$ "squirtle"] = {
        nome: "Squirtle",
        tipo1: "agua",
        tipo2: "nenhum",
        hp_base: 44,
        atk_base: 48,
        def_base: 65,
        atk_esp_base: 50,
        def_esp_base: 64,
        spd_base: 43,
        taxa_genero: 87.5,
        xp_base: 63,
        taxa_captura: 45,
        taxa_crescimento: "medium_slow",
		
		habilidades_comuns: ["torrente"], 
		habilidade_oculta: "prato de chuva", 
        
        move_tree: [
            { nivel: 1, movimento_id: "tackle" }, { nivel: 1, movimento_id: "tail_whip" },
            { nivel: 6, movimento_id: "water_gun" }, { nivel: 6, movimento_id: "withdraw" },
            { nivel: 9, movimento_id: "bubble" }, { nivel: 12, movimento_id: "bite" },
            { nivel: 15, movimento_id: "rapid_spin" }, { nivel: 18, movimento_id: "protect" },
            { nivel: 21, movimento_id: "water_pulse" }, { nivel: 24, movimento_id: "aqua_tail" },
            { nivel: 27, movimento_id: "skull_bash" }, { nivel: 30, movimento_id: "iron_defense" },
            { nivel: 33, movimento_id: "rain_dance" }, { nivel: 36, movimento_id: "hydro_pump" }
        ],

        outros_movimentos: {
            tms_hms: ["surf", "ice_beam", "water_pulse", "toxic"],
            egg_moves: ["aqua_ring", "mirror_coat", "yawn"],
            tutor_moves: ["hydro_cannon", "water_pledge"]
        }
    };
    global.especies[$ "pidgey"] = {
        nome: "Pidgey", tipo1: "normal", tipo2: "voador",
        hp_base: 40, atk_base: 45, def_base: 40, atk_esp_base: 35, def_esp_base: 35, spd_base: 56,
        taxa_genero: 50, xp_base: 50, taxa_crescimento: "medium_slow",
        taxa_captura: 255,
        habilidades_comuns: ["rivalry"], habilidade_oculta: "",
        move_tree: [
            { nivel: 1, movimento_id: "tackle" }, { nivel: 1, movimento_id: "gust" },
            { nivel: 5, movimento_id: "sand_attack" }, { nivel: 9, movimento_id: "quick_attack" },
            { nivel: 13, movimento_id: "whirlwind" }, { nivel: 17, movimento_id: "twister" },
            { nivel: 21, movimento_id: "feather_dance" }, { nivel: 25, movimento_id: "agility" },
            { nivel: 29, movimento_id: "air_slash" }, { nivel: 33, movimento_id: "roost" },
            { nivel: 37, movimento_id: "tailwind" }
        ],
        outros_movimentos: { tms_hms: [], egg_moves: [], tutor_moves: [] }
    };

    global.especies[$ "caterpie"] = {
        nome: "Caterpie", tipo1: "inseto", tipo2: "nenhum",
        hp_base: 45, atk_base: 30, def_base: 35, atk_esp_base: 20, def_esp_base: 20, spd_base: 45,
        taxa_genero: 50, xp_base: 39, taxa_crescimento: "medium_fast",
        taxa_captura: 255,
        habilidades_comuns: ["cute_charm"], habilidade_oculta: "",
        move_tree: [
            { nivel: 1, movimento_id: "tackle" }, { nivel: 1, movimento_id: "string_shot" },
            { nivel: 9, movimento_id: "bug_bite" }
        ],
        outros_movimentos: { tms_hms: [], egg_moves: [], tutor_moves: [] }
    };

    global.especies.charmander.evolucoes = [{ tipo: "nivel", valor: 16, especie_destino: "charmeleon" }];
    global.especies.charmeleon.move_tree = global.especies.charmander.move_tree;
    global.especies.charmeleon.evolucoes = [{ tipo: "nivel", valor: 36, especie_destino: "charizard" }];
    global.especies.charmander.habilidades_comuns = ["blaze"];
    global.especies.charmander.habilidade_oculta = "solar_power";
    global.especies.charmeleon.habilidades_comuns = ["blaze"];
    global.especies.charmeleon.habilidade_oculta = "solar_power";
    global.especies.charizard = {
        nome: "Charizard", tipo1: "fogo", tipo2: "voador",
        hp_base: 78, atk_base: 84, def_base: 78, atk_esp_base: 109, def_esp_base: 85, spd_base: 100,
        taxa_genero: 87.5, xp_base: 267, taxa_captura: 45, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["blaze"], habilidade_oculta: "solar_power",
        move_tree: global.especies.charmander.move_tree,
        outros_movimentos: { tms_hms: ["flamethrower", "fire_blast", "fly", "toxic"], egg_moves: [], tutor_moves: ["heat_wave"] }
    };

    global.especies.bulbasaur = {
        nome: "Bulbasaur", tipo1: "planta", tipo2: "veneno",
        hp_base: 45, atk_base: 49, def_base: 49, atk_esp_base: 65, def_esp_base: 65, spd_base: 45,
        taxa_genero: 87.5, xp_base: 64, taxa_captura: 45, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["overgrow"], habilidade_oculta: "chlorophyll",
        move_tree: [
            { nivel: 1, movimento_id: "tackle" }, { nivel: 1, movimento_id: "growl" },
            { nivel: 6, movimento_id: "vine_whip" }, { nivel: 6, movimento_id: "growth" },
            { nivel: 9, movimento_id: "leech_seed" }, { nivel: 12, movimento_id: "razor_leaf" },
            { nivel: 15, movimento_id: "poison_powder" }, { nivel: 15, movimento_id: "sleep_powder" },
            { nivel: 18, movimento_id: "take_down" }, { nivel: 21, movimento_id: "sweet_scent" },
            { nivel: 24, movimento_id: "synthesis" }, { nivel: 27, movimento_id: "worry_seed" },
            { nivel: 30, movimento_id: "seed_bomb" }
        ],
        outros_movimentos: { tms_hms: ["toxic", "solar_beam"], egg_moves: [], tutor_moves: [] },
        evolucoes: [{ tipo: "nivel", valor: 16, especie_destino: "ivysaur" }]
    };
    global.especies.ivysaur = {
        nome: "Ivysaur", tipo1: "planta", tipo2: "veneno",
        hp_base: 60, atk_base: 62, def_base: 63, atk_esp_base: 80, def_esp_base: 80, spd_base: 60,
        taxa_genero: 87.5, xp_base: 142, taxa_captura: 45, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["overgrow"], habilidade_oculta: "chlorophyll",
        move_tree: global.especies.bulbasaur.move_tree,
        outros_movimentos: { tms_hms: ["toxic", "solar_beam"], egg_moves: [], tutor_moves: [] },
        evolucoes: [{ tipo: "nivel", valor: 32, especie_destino: "venusaur" }]
    };
    global.especies.venusaur = {
        nome: "Venusaur", tipo1: "planta", tipo2: "veneno",
        hp_base: 80, atk_base: 82, def_base: 83, atk_esp_base: 100, def_esp_base: 100, spd_base: 80,
        taxa_genero: 87.5, xp_base: 263, taxa_captura: 45, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["overgrow"], habilidade_oculta: "chlorophyll",
        move_tree: global.especies.bulbasaur.move_tree,
        outros_movimentos: { tms_hms: ["toxic", "solar_beam"], egg_moves: [], tutor_moves: [] }
    };

    global.especies.squirtle.evolucoes = [{ tipo: "nivel", valor: 16, especie_destino: "wartortle" }];
    global.especies.squirtle.habilidades_comuns = ["torrent"];
    global.especies.squirtle.habilidade_oculta = "rain_dish";
    global.especies.wartortle = {
        nome: "Wartortle", tipo1: "agua", tipo2: "nenhum",
        hp_base: 59, atk_base: 63, def_base: 80, atk_esp_base: 65, def_esp_base: 80, spd_base: 58,
        taxa_genero: 87.5, xp_base: 142, taxa_captura: 45, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["torrent"], habilidade_oculta: "rain_dish",
        move_tree: global.especies.squirtle.move_tree,
        outros_movimentos: { tms_hms: ["surf", "ice_beam", "water_pulse", "toxic"], egg_moves: [], tutor_moves: [] },
        evolucoes: [{ tipo: "nivel", valor: 36, especie_destino: "blastoise" }]
    };
    global.especies.blastoise = {
        nome: "Blastoise", tipo1: "agua", tipo2: "nenhum",
        hp_base: 79, atk_base: 83, def_base: 100, atk_esp_base: 85, def_esp_base: 105, spd_base: 78,
        taxa_genero: 87.5, xp_base: 265, taxa_captura: 45, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["torrent"], habilidade_oculta: "rain_dish",
        move_tree: global.especies.squirtle.move_tree,
        outros_movimentos: { tms_hms: ["surf", "ice_beam", "water_pulse", "toxic"], egg_moves: [], tutor_moves: ["hydro_cannon"] }
    };

    global.especies.caterpie.habilidades_comuns = ["shield_dust"];
    global.especies.caterpie.habilidade_oculta = "run_away";
    global.especies.caterpie.evolucoes = [{ tipo: "nivel", valor: 7, especie_destino: "metapod" }];
    global.especies.metapod = {
        nome: "Metapod", tipo1: "inseto", tipo2: "nenhum",
        hp_base: 50, atk_base: 20, def_base: 55, atk_esp_base: 25, def_esp_base: 25, spd_base: 30,
        taxa_genero: 50, xp_base: 72, taxa_captura: 120, taxa_crescimento: "medium_fast",
        habilidades_comuns: ["shed_skin"], habilidade_oculta: "",
        move_tree: [{ nivel: 1, movimento_id: "harden" }],
        outros_movimentos: { tms_hms: [], egg_moves: [], tutor_moves: [] },
        evolucoes: [{ tipo: "nivel", valor: 10, especie_destino: "butterfree" }]
    };
    global.especies.butterfree = {
        nome: "Butterfree", tipo1: "inseto", tipo2: "voador",
        hp_base: 60, atk_base: 45, def_base: 50, atk_esp_base: 90, def_esp_base: 80, spd_base: 70,
        taxa_genero: 50, xp_base: 198, taxa_captura: 45, taxa_crescimento: "medium_fast",
        habilidades_comuns: ["compound_eyes"], habilidade_oculta: "tinted_lens",
        move_tree: [
            { nivel: 1, movimento_id: "confusion" }, { nivel: 1, movimento_id: "gust" },
            { nivel: 12, movimento_id: "poison_powder" }, { nivel: 12, movimento_id: "stun_spore" },
            { nivel: 12, movimento_id: "sleep_powder" }, { nivel: 16, movimento_id: "psybeam" },
            { nivel: 20, movimento_id: "whirlwind" }, { nivel: 24, movimento_id: "supersonic" },
            { nivel: 28, movimento_id: "silver_wind" }, { nivel: 32, movimento_id: "air_slash" },
            { nivel: 36, movimento_id: "bug_buzz" }
        ],
        outros_movimentos: { tms_hms: ["toxic", "roost"], egg_moves: [], tutor_moves: [] }
    };

    global.especies.pidgey.habilidades_comuns = ["keen_eye", "tangled_feet"];
    global.especies.pidgey.habilidade_oculta = "big_pecks";
    global.especies.pidgey.evolucoes = [{ tipo: "nivel", valor: 18, especie_destino: "pidgeotto" }];
    global.especies.pidgeotto = {
        nome: "Pidgeotto", tipo1: "normal", tipo2: "voador",
        hp_base: 63, atk_base: 60, def_base: 55, atk_esp_base: 50, def_esp_base: 50, spd_base: 71,
        taxa_genero: 50, xp_base: 122, taxa_captura: 120, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["keen_eye", "tangled_feet"], habilidade_oculta: "big_pecks",
        move_tree: global.especies.pidgey.move_tree,
        outros_movimentos: { tms_hms: ["roost", "toxic"], egg_moves: [], tutor_moves: [] },
        evolucoes: [{ tipo: "nivel", valor: 36, especie_destino: "pidgeot" }]
    };
    global.especies.pidgeot = {
        nome: "Pidgeot", tipo1: "normal", tipo2: "voador",
        hp_base: 83, atk_base: 80, def_base: 75, atk_esp_base: 70, def_esp_base: 70, spd_base: 101,
        taxa_genero: 50, xp_base: 216, taxa_captura: 45, taxa_crescimento: "medium_slow",
        habilidades_comuns: ["keen_eye", "tangled_feet"], habilidade_oculta: "big_pecks",
        move_tree: global.especies.pidgey.move_tree,
        outros_movimentos: { tms_hms: ["roost", "toxic"], egg_moves: [], tutor_moves: [] }
    };
}

function scr_movimentos_init()
{
    global.movimentos = {};

    global.movimentos.tackle = { nome: "Tackle", tipo: "normal", categoria: "fisico", poder: 35, precisao: 100, pp_max: 35 };
    global.movimentos.water_gun = { nome: "Water Gun", tipo: "agua", categoria: "especial", poder: 40, precisao: 100, pp_max: 25 };
    global.movimentos.scratch = { nome: "Scratch", tipo: "normal", categoria: "fisico", poder: 40, precisao: 100, pp_max: 35 };
    global.movimentos.vine_whip = { nome: "Vine Whip", tipo: "planta", categoria: "fisico", poder: 45, precisao: 100, pp_max: 25 };
    global.movimentos.growl = { nome: "Growl", tipo: "normal", categoria: "status", precisao: 100, pp_max: 40, efeito: { tipo: "debuff", stat: "atk", estagios: 1, alvo: "oponente" } };
    global.movimentos.recover = { nome: "Recover", tipo: "normal", categoria: "status", precisao: 100, pp_max: 10, efeito: { tipo: "cura", valor: 0.5 } };
    global.movimentos.quick_attack = { nome: "Quick Attack", tipo: "normal", categoria: "fisico", poder: 40, precisao: 100, pp_max: 30, prioridade: 1 };
    global.movimentos[$ "return"] = { nome: "Return", tipo: "normal", categoria: "fisico", poder: 0, precisao: 100, pp_max: 20 };
    global.movimentos.frustration = { nome: "Frustration", tipo: "normal", categoria: "fisico", poder: 0, precisao: 100, pp_max: 20 };
    global.movimentos.attract = { nome: "Attract", tipo: "normal", categoria: "status", precisao: 100, pp_max: 15, efeito: { tipo: "attract", alvo: "oponente" } };
    global.movimentos.captivate = { nome: "Captivate", tipo: "normal", categoria: "status", precisao: 100, pp_max: 20, efeito: { tipo: "captivate", alvo: "oponente" } };
	global.movimentos.tail_whip = { nome: "Tail Whip", tipo: "normal", categoria: "status", precisao: 100, pp_max: 30, efeito: { tipo: "debuff", stat: "def", estagios: 1, alvo: "oponente" } };
	global.movimentos.bubble = { nome: "Bubble", tipo: "agua", categoria: "especial", poder: 40, precisao: 100, pp_max: 30 };
	global.movimentos.dragon_breath = { nome: "Dragon Breath", tipo: "dragao", categoria: "especial", poder: 60, precisao: 100, pp_max: 20 };
	global.movimentos.slash = { nome: "Slash", tipo: "normal", categoria: "fisico", poder: 70, precisao: 100, pp_max: 20, alta_chance_critico: true };
	global.movimentos.sand_attack = { nome: "Sand Attack", tipo: "terra", categoria: "status", precisao: 100, pp_max: 15, efeito: { tipo: "debuff", stat: "precisao", estagios: 1, alvo: "oponente" } };
	global.movimentos.ember = { nome: "Ember", tipo: "fogo", categoria: "especial", poder: 40, precisao: 100, pp_max: 25,
    efeito_secundario: { chance: 10, tipo: "status", status_id: "queimadura", alvo: "oponente" } };
	global.movimentos.confuse_ray = { nome: "Confuse Ray", tipo: "fantasma", categoria: "status", precisao: 100, pp_max: 10,
    efeito: { tipo: "volatil", estado_id: "confuso", alvo: "oponente" } };
	global.movimentos.leech_seed = { nome: "Leech Seed", tipo: "planta", categoria: "status", precisao: 90, pp_max: 10,
    efeito: { tipo: "volatil", estado_id: "leech_seed", alvo: "oponente" } };
	global.movimentos.perish_song = { nome: "Perish Song", tipo: "normal", categoria: "status", precisao: 0, pp_max: 5,
    efeito: { tipo: "perish_song" } };
    global.movimentos.smokescreen = { nome: "Smokescreen", tipo: "normal", categoria: "status", precisao: 100, pp_max: 20, efeito: { tipo: "debuff", stat: "precisao", estagios: 1, alvo: "oponente" } };
    global.movimentos.dragon_rage = { nome: "Dragon Rage", tipo: "dragao", categoria: "especial", poder: 40, precisao: 100, pp_max: 10 };
    global.movimentos.scary_face = { nome: "Scary Face", tipo: "normal", categoria: "status", precisao: 100, pp_max: 10, efeito: { tipo: "debuff", stat: "spd", estagios: 2, alvo: "oponente" } };
    global.movimentos.fire_fang = { nome: "Fire Fang", tipo: "fogo", categoria: "fisico", poder: 65, precisao: 95, pp_max: 15, efeito_secundario: { chance: 10, tipo: "status", status_id: "queimadura", alvo: "oponente" } };
    global.movimentos.flamethrower = { nome: "Flamethrower", tipo: "fogo", categoria: "especial", poder: 90, precisao: 100, pp_max: 15, efeito_secundario: { chance: 10, tipo: "status", status_id: "queimadura", alvo: "oponente" } };
    global.movimentos.fire_blast = { nome: "Fire Blast", tipo: "fogo", categoria: "especial", poder: 110, precisao: 85, pp_max: 5, efeito_secundario: { chance: 10, tipo: "status", status_id: "queimadura", alvo: "oponente" } };
    global.movimentos.fire_spin = { nome: "Fire Spin", tipo: "fogo", categoria: "especial", poder: 35, precisao: 85, pp_max: 15, efeito_secundario: { chance: 100, tipo: "volatil", estado_id: "preso", alvo: "oponente" } };
    global.movimentos.inferno = { nome: "Inferno", tipo: "fogo", categoria: "especial", poder: 100, precisao: 50, pp_max: 5, efeito_secundario: { chance: 100, tipo: "status", status_id: "queimadura", alvo: "oponente" } };
    global.movimentos.flare_blitz = { nome: "Flare Blitz", tipo: "fogo", categoria: "fisico", poder: 120, precisao: 100, pp_max: 15, efeito_secundario: { chance: 10, tipo: "status", status_id: "queimadura", alvo: "oponente" } };
    global.movimentos.dragon_claw = { nome: "Dragon Claw", tipo: "dragao", categoria: "fisico", poder: 80, precisao: 100, pp_max: 15 };
    global.movimentos.growth = { nome: "Growth", tipo: "normal", categoria: "status", precisao: 0, pp_max: 20, efeito: { tipo: "buff", stat: "atk_esp", estagios: 1, alvo: "self" } };
    global.movimentos.razor_leaf = { nome: "Razor Leaf", tipo: "planta", categoria: "fisico", poder: 55, precisao: 95, pp_max: 25, alta_chance_critico: true };
    global.movimentos.poison_powder = { nome: "Poison Powder", tipo: "veneno", categoria: "status", precisao: 75, pp_max: 35, efeito: { tipo: "status", status_id: "envenenamento", alvo: "oponente" } };
    global.movimentos.sleep_powder = { nome: "Sleep Powder", tipo: "planta", categoria: "status", precisao: 75, pp_max: 15, efeito: { tipo: "status", status_id: "sono", alvo: "oponente" } };
    global.movimentos.take_down = { nome: "Take Down", tipo: "normal", categoria: "fisico", poder: 90, precisao: 85, pp_max: 20 };
    global.movimentos.sweet_scent = { nome: "Sweet Scent", tipo: "normal", categoria: "status", precisao: 100, pp_max: 20, efeito: { tipo: "debuff", stat: "evasao", estagios: 1, alvo: "oponente" } };
    global.movimentos.synthesis = { nome: "Synthesis", tipo: "normal", categoria: "status", precisao: 0, pp_max: 5, efeito: { tipo: "cura", valor: 0.5 } };
    global.movimentos.worry_seed = { nome: "Worry Seed", tipo: "planta", categoria: "status", precisao: 100, pp_max: 10, efeito: { tipo: "habilidade", habilidade: "insomnia", alvo: "oponente" } };
    global.movimentos.seed_bomb = { nome: "Seed Bomb", tipo: "planta", categoria: "fisico", poder: 80, precisao: 100, pp_max: 15 };
    global.movimentos.withdraw = { nome: "Withdraw", tipo: "agua", categoria: "status", precisao: 0, pp_max: 40, efeito: { tipo: "buff", stat: "def", estagios: 1, alvo: "self" } };
    global.movimentos.bite = { nome: "Bite", tipo: "noturno", categoria: "fisico", poder: 60, precisao: 100, pp_max: 25, efeito_secundario: { chance: 30, tipo: "flinch", alvo: "oponente" } };
    global.movimentos.rapid_spin = { nome: "Rapid Spin", tipo: "normal", categoria: "fisico", poder: 50, precisao: 100, pp_max: 40 };
    global.movimentos.protect = { nome: "Protect", tipo: "normal", categoria: "status", precisao: 0, pp_max: 10, efeito: { tipo: "protecao", alvo: "self" } };
    global.movimentos.water_pulse = { nome: "Water Pulse", tipo: "agua", categoria: "especial", poder: 60, precisao: 100, pp_max: 20, efeito_secundario: { chance: 20, tipo: "volatil", estado_id: "confuso", alvo: "oponente" } };
    global.movimentos.aqua_tail = { nome: "Aqua Tail", tipo: "agua", categoria: "fisico", poder: 90, precisao: 90, pp_max: 10 };
    global.movimentos.skull_bash = { nome: "Skull Bash", tipo: "normal", categoria: "fisico", poder: 130, precisao: 100, pp_max: 10 };
    global.movimentos.iron_defense = { nome: "Iron Defense", tipo: "metal", categoria: "status", precisao: 0, pp_max: 15, efeito: { tipo: "buff", stat: "def", estagios: 2, alvo: "self" } };
    global.movimentos.rain_dance = { nome: "Rain Dance", tipo: "agua", categoria: "status", precisao: 0, pp_max: 5, efeito: { tipo: "clima", clima: "chuva", alvo: "self" } };
    global.movimentos.hydro_pump = { nome: "Hydro Pump", tipo: "agua", categoria: "especial", poder: 110, precisao: 80, pp_max: 5 };
    global.movimentos.string_shot = { nome: "String Shot", tipo: "inseto", categoria: "status", precisao: 95, pp_max: 40, efeito: { tipo: "debuff", stat: "spd", estagios: 2, alvo: "oponente" } };
    global.movimentos.bug_bite = { nome: "Bug Bite", tipo: "inseto", categoria: "fisico", poder: 60, precisao: 100, pp_max: 20 };
    global.movimentos.harden = { nome: "Harden", tipo: "normal", categoria: "status", precisao: 0, pp_max: 30, efeito: { tipo: "buff", stat: "def", estagios: 1, alvo: "self" } };
    global.movimentos.confusion = { nome: "Confusion", tipo: "psiquico", categoria: "especial", poder: 50, precisao: 100, pp_max: 25, efeito_secundario: { chance: 10, tipo: "volatil", estado_id: "confuso", alvo: "oponente" } };
    global.movimentos.gust = { nome: "Gust", tipo: "voador", categoria: "especial", poder: 40, precisao: 100, pp_max: 35 };
    global.movimentos.stun_spore = { nome: "Stun Spore", tipo: "planta", categoria: "status", precisao: 75, pp_max: 30, efeito: { tipo: "status", status_id: "paralisia", alvo: "oponente" } };
    global.movimentos.psybeam = { nome: "Psybeam", tipo: "psiquico", categoria: "especial", poder: 65, precisao: 100, pp_max: 20, efeito_secundario: { chance: 10, tipo: "volatil", estado_id: "confuso", alvo: "oponente" } };
    global.movimentos.whirlwind = { nome: "Whirlwind", tipo: "normal", categoria: "status", precisao: 100, pp_max: 20, efeito: { tipo: "debuff", stat: "evasao", estagios: 1, alvo: "oponente" } };
    global.movimentos.supersonic = { nome: "Supersonic", tipo: "normal", categoria: "status", precisao: 55, pp_max: 20, efeito: { tipo: "volatil", estado_id: "confuso", alvo: "oponente" } };
    global.movimentos.silver_wind = { nome: "Silver Wind", tipo: "inseto", categoria: "especial", poder: 60, precisao: 100, pp_max: 5 };
    global.movimentos.air_slash = { nome: "Air Slash", tipo: "voador", categoria: "especial", poder: 75, precisao: 95, pp_max: 15, efeito_secundario: { chance: 30, tipo: "flinch", alvo: "oponente" } };
    global.movimentos.bug_buzz = { nome: "Bug Buzz", tipo: "inseto", categoria: "especial", poder: 90, precisao: 100, pp_max: 10, efeito_secundario: { chance: 10, tipo: "debuff", stat: "def_esp", estagios: 1, alvo: "oponente" } };
    global.movimentos.focus_energy = { nome: "Focus Energy", tipo: "normal", categoria: "status", precisao: 0, pp_max: 30, efeito: { tipo: "foco", alvo: "self" } };
    global.movimentos.pursuit = { nome: "Pursuit", tipo: "noturno", categoria: "fisico", poder: 40, precisao: 100, pp_max: 20 };
    global.movimentos.hyper_fang = { nome: "Hyper Fang", tipo: "normal", categoria: "fisico", poder: 80, precisao: 90, pp_max: 15, efeito_secundario: { chance: 10, tipo: "flinch", alvo: "oponente" } };
    global.movimentos.sucker_punch = { nome: "Sucker Punch", tipo: "noturno", categoria: "fisico", poder: 70, precisao: 100, pp_max: 5, prioridade: 1 };
    global.movimentos.crunch = { nome: "Crunch", tipo: "noturno", categoria: "fisico", poder: 80, precisao: 100, pp_max: 15, efeito_secundario: { chance: 20, tipo: "debuff", stat: "def_esp", estagios: 1, alvo: "oponente" } };
    global.movimentos.super_fang = { nome: "Super Fang", tipo: "normal", categoria: "fisico", poder: 1, precisao: 90, pp_max: 10 };
    global.movimentos.twister = { nome: "Twister", tipo: "dragao", categoria: "especial", poder: 40, precisao: 100, pp_max: 20, efeito_secundario: { chance: 20, tipo: "flinch", alvo: "oponente" } };
    global.movimentos.feather_dance = { nome: "Feather Dance", tipo: "voador", categoria: "status", precisao: 100, pp_max: 15, efeito: { tipo: "debuff", stat: "atk", estagios: 2, alvo: "oponente" } };
    global.movimentos.agility = { nome: "Agility", tipo: "psiquico", categoria: "status", precisao: 0, pp_max: 30, efeito: { tipo: "buff", stat: "spd", estagios: 2, alvo: "self" } };
    global.movimentos.roost = { nome: "Roost", tipo: "voador", categoria: "status", precisao: 0, pp_max: 10, efeito: { tipo: "cura", valor: 0.5 } };
    global.movimentos.tailwind = { nome: "Tailwind", tipo: "voador", categoria: "status", precisao: 0, pp_max: 15, efeito: { tipo: "buff", stat: "spd", estagios: 2, alvo: "self" } };
    global.movimentos.fly = { nome: "Fly", tipo: "voador", categoria: "fisico", poder: 90, precisao: 95, pp_max: 15 };
    global.movimentos.solar_beam = { nome: "Solar Beam", tipo: "planta", categoria: "especial", poder: 120, precisao: 100, pp_max: 10 };
    global.movimentos.toxic = { nome: "Toxic", tipo: "veneno", categoria: "status", precisao: 90, pp_max: 10, efeito: { tipo: "status", status_id: "intoxicacao", alvo: "oponente" } };
    global.movimentos.surf = { nome: "Surf", tipo: "agua", categoria: "especial", poder: 90, precisao: 100, pp_max: 15 };
    global.movimentos.ice_beam = { nome: "Ice Beam", tipo: "gelo", categoria: "especial", poder: 90, precisao: 100, pp_max: 10, efeito_secundario: { chance: 10, tipo: "status", status_id: "congelamento", alvo: "oponente" } };
    global.movimentos.water_pledge = { nome: "Water Pledge", tipo: "agua", categoria: "especial", poder: 80, precisao: 100, pp_max: 10 };
    global.movimentos.hydro_cannon = { nome: "Hydro Cannon", tipo: "agua", categoria: "especial", poder: 150, precisao: 90, pp_max: 5 };
    global.movimentos.heat_wave = { nome: "Heat Wave", tipo: "fogo", categoria: "especial", poder: 95, precisao: 90, pp_max: 10, efeito_secundario: { chance: 10, tipo: "status", status_id: "queimadura", alvo: "oponente" } };
    global.movimentos.dragon_dance = { nome: "Dragon Dance", tipo: "dragao", categoria: "status", precisao: 0, pp_max: 20, efeito: { tipo: "buff", stat: "atk", estagios: 1, alvo: "self" } };
    global.movimentos.outrage = { nome: "Outrage", tipo: "dragao", categoria: "fisico", poder: 120, precisao: 100, pp_max: 10 };
    global.movimentos.aqua_ring = { nome: "Aqua Ring", tipo: "agua", categoria: "status", precisao: 0, pp_max: 20, efeito: { tipo: "cura", valor: 0.25 } };
    global.movimentos.mirror_coat = { nome: "Mirror Coat", tipo: "psiquico", categoria: "especial", poder: 90, precisao: 100, pp_max: 20 };
    global.movimentos.yawn = { nome: "Yawn", tipo: "normal", categoria: "status", precisao: 0, pp_max: 10, efeito: { tipo: "status", status_id: "sono", alvo: "oponente" } };
}

function scr_habilidades_init()
{
    global.habilidades = {};

    global.habilidades.blaze = { nome: "Blaze", descricao: "Aumenta o poder de golpes de fogo quando o HP está baixo." };
    global.habilidades.torrent = { nome: "Torrent", descricao: "Aumenta o poder de golpes de água quando o HP está baixo." };
    global.habilidades.chama = global.habilidades.blaze;
    global.habilidades.torrente = global.habilidades.torrent;
    global.habilidades.solar_power = { nome: "Solar Power", descricao: "Aumenta o poder especial quando o HP está baixo." };
    global.habilidades.overgrow = { nome: "Overgrow", descricao: "Aumenta o poder de golpes de planta quando o HP está baixo." };
    global.habilidades.chlorophyll = { nome: "Chlorophyll", descricao: "Aumenta a velocidade em condições favoráveis." };
    global.habilidades.rain_dish = { nome: "Rain Dish", descricao: "Recupera HP ao fim do turno." };
    global.habilidades.shield_dust = { nome: "Shield Dust", descricao: "Impede efeitos secundários de golpes." };
    global.habilidades.shed_skin = { nome: "Shed Skin", descricao: "Pode remover um status ao fim do turno." };
    global.habilidades.compound_eyes = { nome: "Compound Eyes", descricao: "Aumenta a precisão dos golpes." };
    global.habilidades.tinted_lens = { nome: "Tinted Lens", descricao: "Aumenta golpes pouco efetivos." };
    global.habilidades.run_away = { nome: "Run Away", descricao: "Permite fugir de batalhas selvagens." };
    global.habilidades.guts = { nome: "Guts", descricao: "Aumenta o ataque quando afetado por status." };
    global.habilidades.hustle = { nome: "Hustle", descricao: "Aumenta o dano físico, reduzindo a precisão." };
    global.habilidades.keen_eye = { nome: "Keen Eye", descricao: "Impede a redução de precisão." };
    global.habilidades.tangled_feet = { nome: "Tangled Feet", descricao: "Aumenta a evasão quando confuso." };
    global.habilidades.big_pecks = { nome: "Big Pecks", descricao: "Impede a redução da defesa." };
    global.habilidades.rivalry = { nome: "Rivalry", descricao: "Causa mais dano a oponentes do mesmo gênero, mas menos ao gênero oposto." };
    global.habilidades.cute_charm = { nome: "Cute Charm", descricao: "Pode fascinar oponentes de gênero oposto ao receber contato." };
}

function scr_natures_init()
{
    global.natures = [
        { nome: "Hardy",   aumenta: "none",     diminui: "none" },
        { nome: "Lonely",  aumenta: "atk",      diminui: "def" },
        { nome: "Brave",   aumenta: "atk",      diminui: "spd" },
        { nome: "Adamant", aumenta: "atk",      diminui: "atk_esp" },
        { nome: "Naughty", aumenta: "atk",      diminui: "def_esp" },
        { nome: "Bold",    aumenta: "def",      diminui: "atk" },
        { nome: "Docile",  aumenta: "none",     diminui: "none" },
        { nome: "Relaxed", aumenta: "def",      diminui: "spd" },
        { nome: "Impish",  aumenta: "def",      diminui: "atk_esp" },
        { nome: "Lax",     aumenta: "def",      diminui: "def_esp" },
        { nome: "Timid",   aumenta: "spd",      diminui: "atk" },
        { nome: "Hasty",   aumenta: "spd",      diminui: "def" },
        { nome: "Serious", aumenta: "none",     diminui: "none" },
        { nome: "Jolly",   aumenta: "spd",      diminui: "atk_esp" },
        { nome: "Naive",   aumenta: "spd",      diminui: "def_esp" },
        { nome: "Modest",  aumenta: "atk_esp",  diminui: "atk" },
        { nome: "Mild",    aumenta: "atk_esp",  diminui: "def" },
        { nome: "Quiet",   aumenta: "atk_esp",  diminui: "spd" },
        { nome: "Bashful", aumenta: "none",     diminui: "none" },
        { nome: "Rash",    aumenta: "atk_esp",  diminui: "def_esp" },
        { nome: "Calm",    aumenta: "def_esp",  diminui: "atk" },
        { nome: "Gentle",  aumenta: "def_esp",  diminui: "def" },
        { nome: "Sassy",   aumenta: "def_esp",  diminui: "spd" },
        { nome: "Careful", aumenta: "def_esp",  diminui: "atk_esp" },
        { nome: "Quirky",  aumenta: "none",     diminui: "none" }
    ];
}

function scr_itens_init()
{
    global.itens = {};
    global.itens.pocao = {
        nome: "Pocao",
        divisao: "medicina",
        max_stack: 99,
        descricao: "Recupera 20 pontos de HP.",
        utilidade: "cura",
        valor: 20,
        seguravel: true,
        usavel_batalha: true,
        seguravel: false
    };
    global.itens.super_pocao = {
        nome: "Super Pocao",
        divisao: "medicina",
        max_stack: 99,
        descricao: "Recupera 50 pontos de HP.",
        utilidade: "cura",
        valor: 50,
        seguravel: true,
        usavel_batalha: true
    };
    global.itens.antidoto = {
        nome: "Antidoto",
        divisao: "medicina",
        max_stack: 99,
        descricao: "Cura envenenamento.",
        utilidade: "cura_status",
        status: "envenenamento",
        seguravel: true,
        usavel_batalha: true
    };
    global.itens.pokebola = {
        nome: "Pokebola",
        divisao: "bolas",
        max_stack: 99,
        descricao: "Usada para tentar capturar um Pokemon selvagem.",
        utilidade: "captura",
        usavel_batalha: true,
        seguravel: false
    };
    global.itens.greatball = { nome: "Great Ball", divisao: "bolas", max_stack: 99, descricao: "Taxa de captura 1.5x.", utilidade: "captura", multiplicador_captura: 1.5, usavel_batalha: true, seguravel: false };
    global.itens.ultraball = { nome: "Ultra Ball", divisao: "bolas", max_stack: 99, descricao: "Taxa de captura 2x.", utilidade: "captura", multiplicador_captura: 2, usavel_batalha: true, seguravel: false };
    global.itens.masterball = { nome: "Master Ball", divisao: "bolas", max_stack: 1, descricao: "Captura qualquer Pokemon sem falhar.", utilidade: "captura", multiplicador_captura: 255, captura_garantida: true, usavel_batalha: true, seguravel: false };
    global.itens.premierball = { nome: "Premier Ball", divisao: "bolas", max_stack: 99, descricao: "Uma Pokebola comemorativa.", utilidade: "captura", multiplicador_captura: 1, usavel_batalha: true, seguravel: false };
    global.itens.luxuryball = { nome: "Luxury Ball", divisao: "bolas", max_stack: 99, descricao: "Aumenta a felicidade do Pokemon capturado.", utilidade: "captura", multiplicador_captura: 1, felicidade_bonus: 20, usavel_batalha: true, seguravel: false };
    global.itens.safariball = { nome: "Safari Ball", divisao: "bolas", max_stack: 30, descricao: "Usada na Zona Safari.", utilidade: "captura", multiplicador_captura: 1.5, usavel_batalha: true, seguravel: false };
    global.itens.netball = { nome: "Net Ball", divisao: "bolas", max_stack: 99, descricao: "Melhor contra Pokemon inseto ou agua.", utilidade: "captura", multiplicador_captura: 1, bonus_tipos: ["inseto", "agua"], bonus_tipo_multiplicador: 3, usavel_batalha: true, seguravel: false };
    global.itens.diveball = { nome: "Dive Ball", divisao: "bolas", max_stack: 99, descricao: "Melhor contra Pokemon aquaticos.", utilidade: "captura", multiplicador_captura: 1, bonus_tipos: ["agua"], bonus_tipo_multiplicador: 3.5, usavel_batalha: true, seguravel: false };
    global.itens.duskball = { nome: "Dusk Ball", divisao: "bolas", max_stack: 99, descricao: "Melhor em cavernas ou a noite.", utilidade: "captura", multiplicador_captura: 3.5, usavel_batalha: true, seguravel: false };
    global.itens.timerball = { nome: "Timer Ball", divisao: "bolas", max_stack: 99, descricao: "Fica melhor quanto mais turnos passam.", utilidade: "captura", multiplicador_captura: 1, usavel_batalha: true, seguravel: false };
    global.itens.quickball = { nome: "Quick Ball", divisao: "bolas", max_stack: 99, descricao: "Muito eficaz no primeiro turno.", utilidade: "captura", multiplicador_captura: 1, usavel_batalha: true, seguravel: false };
    global.itens.repeatball = { nome: "Repeat Ball", divisao: "bolas", max_stack: 99, descricao: "Melhor contra especies ja capturadas.", utilidade: "captura", multiplicador_captura: 3.5, usavel_batalha: true, seguravel: false };
    global.itens.fugir = {
        nome: "Fugir",
        divisao: "batalha",
        max_stack: 1,
        descricao: "Encerra uma batalha contra um Pokemon selvagem.",
        utilidade: "fuga",
        usavel_batalha: true,
        seguravel: false
    };

    var _ids_itens = variable_struct_get_names(global.itens);
    for (var _i = 0; _i < array_length(_ids_itens); _i++)
    {
        var _id_item = _ids_itens[_i];
        if (!variable_struct_exists(global.itens[$ _id_item], "descartavel"))
            global.itens[$ _id_item].descartavel = (_id_item != "fugir");
    }
}

function scr_mochila_init()
{
    if (variable_global_exists("mochila") && is_struct(global.mochila)) return;
    global.mochila = {};
    global.mochila.itens = {};
    global.mochila.divisoes = ["medicina", "bolas", "frutas", "batalha", "chaves", "tm"];
    global.mochila.lista = [];
    scr_mochila_adicionar("pocao", 3);
    scr_mochila_adicionar("pokebola", 5);
    scr_mochila_adicionar("greatball", 1);
    scr_mochila_adicionar("ultraball", 1);
    scr_mochila_adicionar("masterball", 1);
    scr_mochila_adicionar("premierball", 1);
    scr_mochila_adicionar("luxuryball", 1);
    scr_mochila_adicionar("safariball", 1);
    scr_mochila_adicionar("netball", 1);
    scr_mochila_adicionar("diveball", 1);
    scr_mochila_adicionar("duskball", 1);
    scr_mochila_adicionar("timerball", 1);
    scr_mochila_adicionar("quickball", 1);
    scr_mochila_adicionar("repeatball", 1);
}

function scr_mochila_adicionar(item_id, quantidade)
{
    if (!variable_struct_exists(global.itens, item_id)) return false;
    var _item = global.itens[$ item_id];
    var _atual = variable_struct_exists(global.mochila.itens, item_id) ? global.mochila.itens[$ item_id] : 0;
    global.mochila.itens[$ item_id] = min(_item.max_stack, _atual + max(0, quantidade));
    if (scr_mochila_indice_item(item_id) < 0) array_push(global.mochila.lista, item_id);
    return true;
}

function scr_mochila_indice_item(item_id)
{
    for (var _i = 0; _i < array_length(global.mochila.lista); _i++)
    {
        if (global.mochila.lista[_i] == item_id) return _i;
    }
    return -1;
}

function scr_mochila_remover(item_id, quantidade)
{
    if (!variable_struct_exists(global.mochila.itens, item_id)) return false;
    if (global.mochila.itens[$ item_id] < quantidade) return false;
    global.mochila.itens[$ item_id] -= quantidade;
    if (global.mochila.itens[$ item_id] <= 0)
    {
        global.mochila.itens[$ item_id] = 0;
        var _indice = scr_mochila_indice_item(item_id);
        if (_indice >= 0) array_delete(global.mochila.lista, _indice, 1);
    }
    return true;
}

function scr_mochila_usar_item_em_batalha(item_id, monstro)
{
    if (!variable_struct_exists(global.itens, item_id)) return { sucesso: false, mensagem: "Item inexistente." };
    var _item = global.itens[$ item_id];
    if (!variable_struct_exists(global.mochila.itens, item_id) || global.mochila.itens[$ item_id] <= 0)
        return { sucesso: false, mensagem: "Voce nao possui esse item." };
    if (monstro.esta_desmaiado || monstro.hp_atual <= 0)
        return { sucesso: false, mensagem: monstro.nome + " esta desmaiado e nao pode usar este item." };
    if (_item.utilidade == "cura")
    {
        if (monstro.hp_atual >= monstro.hp_max) return { sucesso: false, mensagem: monstro.nome + " ja esta com HP cheio." };
        var _cura = min(_item.valor, monstro.hp_max - monstro.hp_atual);
        monstro.hp_atual += _cura;
        scr_mochila_remover(item_id, 1);
        return { sucesso: true, mensagem: "Voce usou " + _item.nome + ". " + monstro.nome + " recuperou " + string(_cura) + " HP." };
    }
    if (_item.utilidade == "cura_status")
    {
        if (monstro.status != _item.status) return { sucesso: false, mensagem: "Esse item nao pode ser usado agora." };
        monstro.status = "nenhum";
        monstro.turnos_status = 0;
        scr_mochila_remover(item_id, 1);
        return { sucesso: true, mensagem: "Voce usou " + _item.nome + ". O status de " + monstro.nome + " foi curado." };
    }
    return { sucesso: false, mensagem: "Esse item nao pode ser usado nesta batalha." };
}