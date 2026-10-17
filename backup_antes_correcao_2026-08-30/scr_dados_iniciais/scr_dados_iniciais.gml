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
			taxa_crescimento: "medium_slow",

    habilidades_comuns: ["chama"],
    habilidade_oculta: "poder do sol",

    move_tree: [
        { nivel: 1, movimento_id: "scratch" },
        { nivel: 1, movimento_id: "growl" },
        { nivel: 4, movimento_id: "ember" },
        { nivel: 7, movimento_id: "dragon_breath" }
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
		taxa_crescimento: "medium_slow",

		habilidades_comuns: ["chama"],
		habilidade_oculta: "poder do sol",

    move_tree: [
        { nivel: 16, movimento_id: "quick_attack" }
    ],

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
        taxa_crescimento: "medium_slow",
		
		habilidades_comuns: ["torrente"], 
		habilidade_oculta: "prato de chuva", 
        
        move_tree: [
            { nivel: 1, movimento_id: "tackle" },
            { nivel: 1, movimento_id: "tail_whip" },
            { nivel: 3, movimento_id: "water_gun" },
            { nivel: 6, movimento_id: "bubble" }
        ],

        outros_movimentos: {
            tms_hms: ["surf", "ice_beam", "water_pulse", "toxic"],
            egg_moves: ["aqua_ring", "mirror_coat", "yawn"],
            tutor_moves: ["hydro_cannon", "water_pledge"]
        }
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
}

function scr_habilidades_init()
{
    global.habilidades = {};

    global.habilidades.chama = { nome: "Chama", descricao: "Aumenta o poder de golpes de fogo quando o HP está baixo." };
    global.habilidades.torrente = { nome: "Torrente", descricao: "Aumenta o poder de golpes de água quando o HP está baixo." };
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