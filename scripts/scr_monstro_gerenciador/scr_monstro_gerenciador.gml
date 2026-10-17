function scr_criar_monstro(especie_id, nivel)
{
    var _base = global.especies[$ especie_id];
    var _ivs = scr_gerar_ivs();
    var _nature = scr_sortear_nature();

    var _genero = "sem_genero";
    if (variable_struct_exists(_base, "taxa_genero") && _base.taxa_genero >= 0)
    {
        _genero = (random(100) < _base.taxa_genero) ? "macho" : "femea";
    }

    // SORTEIO DE HABILIDADE 
    var _hab_sorteada = "";
    if (variable_struct_exists(_base, "habilidades_comuns") && array_length(_base.habilidades_comuns) > 0)
    {
        var _rand_index = irandom(array_length(_base.habilidades_comuns) - 1);
        _hab_sorteada = _base.habilidades_comuns[_rand_index];
    }
    else if (variable_struct_exists(_base, "habilidade"))
    {
        _hab_sorteada = _base.habilidade; // Suporte a espécies antigas
    }

    if (variable_struct_exists(_base, "habilidade_oculta")
        && _base.habilidade_oculta != ""
        && random(100) < 10)
    {
        _hab_sorteada = _base.habilidade_oculta;
    }

    var _hab_oculta = variable_struct_exists(_base, "habilidade_oculta") ? _base.habilidade_oculta : "";

	var _monstro = {
    especie_id: especie_id,
    nome: _base.nome,
    nivel: nivel,
    estagios: { atk: 0, def: 0, atk_esp: 0, def_esp: 0, spd: 0, precisao: 0, evasao: 0 },
	estados_volateis: {
    confuso: { ativo: false, turnos: 0 },
    hesitacao: false,
    preso: { ativo: false, turnos: 0 },
    leech_seed: false,
    leech_seed_de: undefined,
    perish_song: { ativo: false, turnos: 0 },
    foco: false,
    protegido: false
},
    tipo1: _base.tipo1,
    tipo2: _base.tipo2,
    ivs: _ivs,
    nature: _nature,
    genero: _genero,
    felicidade: 70,
    apaixonado: false,
    xp: 0,
    taxa_crescimento: _base.taxa_crescimento,
    esta_desmaiado: false,
    habilidade: _hab_sorteada,
    habilidade_oculta: _hab_oculta,
    held_item: "",
    status: "nenhum",
    turnos_status: 0
};

    _monstro.hp_max = scr_calcular_stats(_base.hp_base, nivel, _ivs.hp, 1, true);
    _monstro.atk = scr_calcular_stats(_base.atk_base, nivel, _ivs.atk, scr_get_nature_mult(_nature, "atk"));
    _monstro.def = scr_calcular_stats(_base.def_base, nivel, _ivs.def, scr_get_nature_mult(_nature, "def"));
    _monstro.atk_esp = scr_calcular_stats(_base.atk_esp_base, nivel, _ivs.atk_esp, scr_get_nature_mult(_nature, "atk_esp"));
    _monstro.def_esp = scr_calcular_stats(_base.def_esp_base, nivel, _ivs.def_esp, scr_get_nature_mult(_nature, "def_esp"));
    _monstro.spd = scr_calcular_stats(_base.spd_base, nivel, _ivs.spd, scr_get_nature_mult(_nature, "spd"));

    _monstro.hp_atual = _monstro.hp_max;
    _monstro.movimentos = [];

    // Preenche os golpes conhecidos até o nível atual 
    if (variable_struct_exists(_base, "move_tree"))
    {
        for (var _i = 0; _i < array_length(_base.move_tree); _i++)
        {
            var _no = _base.move_tree[_i];
            if (_no.nivel <= nivel)
            {
                scr_aprender_movimento(_monstro, _no.movimento_id);
            }
        }
    }

    _monstro.xp = scr_xp_para_nivel(_monstro.taxa_crescimento, nivel);
    _monstro.xp_prox_nivel = scr_xp_para_nivel(_monstro.taxa_crescimento, nivel + 1);

    return _monstro;
}

function scr_ganhar_xp(monstro, xp_ganho)
{
    if (monstro.esta_desmaiado) return { subiu: false, novos_movimentos: [], evoluiu: false, evolucao_info: undefined };

    monstro.xp = max(0, monstro.xp) + max(0, xp_ganho);
    var _subiu_nivel = false;
    var _novos_movimentos = [];
    var _evoluiu = false;
    var _info_evolucao = undefined;

    while (monstro.xp >= monstro.xp_prox_nivel && monstro.nivel < 100)
    {
        monstro.nivel += 1;
        scr_recalcular_stats(monstro);
        monstro.xp_prox_nivel = scr_xp_para_nivel(monstro.taxa_crescimento, monstro.nivel + 1);
        _subiu_nivel = true;
        scr_alterar_felicidade(monstro, 5);

        var _aprendidos = scr_checar_movimentos_novos_nivel(monstro);
        for (var _m = 0; _m < array_length(_aprendidos); _m++)
        {
            array_push(_novos_movimentos, _aprendidos[_m]);
        }

        // --- CHECAGEM DE EVOLUÇÃO (a cada nível ganho, funciona no meio da batalha) ---
        var _resultado_evolucao = scr_tentar_evoluir(monstro);
        if (_resultado_evolucao.evoluiu)
        {
            _evoluiu = true;
            _info_evolucao = _resultado_evolucao.evolucao_info;

            for (var _n = 0; _n < array_length(_info_evolucao.novos_movimentos); _n++)
            {
                array_push(_novos_movimentos, _info_evolucao.novos_movimentos[_n]);
            }
        }
    }

    return {
        subiu: _subiu_nivel,
        novos_movimentos: _novos_movimentos,
        evoluiu: _evoluiu,
        evolucao_info: _info_evolucao
    };
}

function scr_criar_equipe(array_especies, nivel)
{
    var _equipe = [];
    var _qtd = min(array_length(array_especies), 6);

    for (var _i = 0; _i < _qtd; _i++)
    {
        array_push(_equipe, scr_criar_monstro(array_especies[_i], nivel));
    }

    return {
        monstros: _equipe,
        indice_ativo: 0
    };
}

function scr_get_monstro_ativo(treinador)
{
    return treinador.monstros[treinador.indice_ativo];
}

function scr_equipe_tem_vivos(treinador)
{
    for (var _i = 0; _i < array_length(treinador.monstros); _i++)
    {
        if (!treinador.monstros[_i].esta_desmaiado)
        {
            return true;
        }
    }
    return false;
}

function scr_resetar_status_temporarios(monstro)
{
    monstro.estagios = { atk: 0, def: 0, atk_esp: 0, def_esp: 0, spd: 0, precisao: 0, evasao: 0 };
    monstro.apaixonado = false;
    monstro.estados_volateis = {
        confuso: { ativo: false, turnos: 0 },
        hesitacao: false,
        preso: { ativo: false, turnos: 0 },
        leech_seed: false,
        leech_seed_de: undefined,
        perish_song: { ativo: false, turnos: 0 },
        foco: false,
        protegido: false
    };
}
function scr_criar_movimento_instancia(movimento_id)
{
    var _base = global.movimentos[$ movimento_id];
    return {
        movimento_id: movimento_id,
        pp_atual: _base.pp_max
    };
}

function scr_calcular_stats(stat_base, nivel, iv, nature_mult = 1, is_hp = false)
{
   
    var _base_calc = (2 * stat_base) + iv;
    
    if (is_hp)
    {
       
        return floor((_base_calc * nivel) / 100) + nivel + 10;
    }
    else
    {
       
        var _valor = floor((_base_calc * nivel) / 100) + 5;
        return floor(_valor * nature_mult);
    }
}

function scr_recalcular_stats(monstro)
{
    var _base = global.especies[$ monstro.especie_id];
    var _hp_max_antigo = monstro.hp_max;

    monstro.hp_max = scr_calcular_stats(_base.hp_base, monstro.nivel, monstro.ivs.hp, 1, true);
    monstro.atk = scr_calcular_stats(_base.atk_base, monstro.nivel, monstro.ivs.atk, scr_get_nature_mult(monstro.nature, "atk"));
    monstro.def = scr_calcular_stats(_base.def_base, monstro.nivel, monstro.ivs.def, scr_get_nature_mult(monstro.nature, "def"));
    monstro.atk_esp = scr_calcular_stats(_base.atk_esp_base, monstro.nivel, monstro.ivs.atk_esp, scr_get_nature_mult(monstro.nature, "atk_esp"));
    monstro.def_esp = scr_calcular_stats(_base.def_esp_base, monstro.nivel, monstro.ivs.def_esp, scr_get_nature_mult(monstro.nature, "def_esp"));
    monstro.spd = scr_calcular_stats(_base.spd_base, monstro.nivel, monstro.ivs.spd, scr_get_nature_mult(monstro.nature, "spd"));

    var _diferenca_hp = monstro.hp_max - _hp_max_antigo;
    monstro.hp_atual += _diferenca_hp;
    monstro.hp_atual = clamp(monstro.hp_atual, 0, monstro.hp_max);
}

function scr_gerar_ivs()
{
    return {
        hp: irandom(31),
        atk: irandom(31),
        def: irandom(31),
        atk_esp: irandom(31),
        def_esp: irandom(31),
        spd: irandom(31)
    };
}

function scr_sortear_nature()
{
    var _indice = irandom(array_length(global.natures) - 1);
    return global.natures[_indice];
}

function scr_get_nature_mult(nature, stat_nome)
{
    if (nature.aumenta == stat_nome) return 1.1;
    if (nature.diminui == stat_nome) return 0.9;
    return 1;
}

function scr_calcular_xp_ganho(derrotado, nivel_vencedor)
{
    var _base = global.especies[$ derrotado.especie_id];
    return floor((_base.xp_base * derrotado.nivel) / 7);
}

function scr_xp_para_nivel(taxa, nivel)
{
    var _n = nivel;
    var _xp = 0;

    switch (taxa)
    {
        case "fast": _xp = floor((4 * power(_n, 3)) / 5); break;
        case "medium_fast": _xp = power(_n, 3); break;
        case "medium_slow": _xp = floor((6 / 5) * power(_n, 3) - 15 * power(_n, 2) + 100 * _n - 140); break;
        case "slow": _xp = floor((5 * power(_n, 3)) / 4); break;
        case "erratic":
            if (_n < 50) _xp = floor((power(_n, 3) * (100 - _n)) / 50);
            else if (_n < 68) _xp = floor((power(_n, 3) * (150 - _n)) / 100);
            else if (_n < 98) _xp = floor((power(_n, 3) * floor((1911 - 10 * _n) / 3)) / 500);
            else _xp = floor((power(_n, 3) * (160 - _n)) / 100);
            break;
        case "fluctuating":
            if (_n < 15) _xp = floor((power(_n, 3) * (floor((_n + 1) / 3) + 24)) / 50);
            else if (_n < 36) _xp = floor((power(_n, 3) * (_n + 14)) / 50);
            else _xp = floor((power(_n, 3) * (floor(_n / 2) + 32)) / 50);
            break;
        default: _xp = power(_n, 3); break;
    }

    return max(_xp, 0);
}

function scr_progresso_xp_nivel(monstro)
{
    if (!is_struct(monstro))
        return 0;

    if (monstro.nivel >= 100)
        return 1;

    var _xp_inicio = scr_xp_para_nivel(monstro.taxa_crescimento, monstro.nivel);
    var _xp_fim = monstro.xp_prox_nivel;
    var _xp_necessario = _xp_fim - _xp_inicio;
    if (_xp_necessario <= 0)
        return 0;

    return clamp((monstro.xp - _xp_inicio) / _xp_necessario, 0, 1);
}

function scr_alterar_felicidade(monstro, quantidade)
{
    monstro.felicidade = clamp(monstro.felicidade + quantidade, 0, 255);
}

function scr_pode_evoluir_por_felicidade(monstro, limite_minimo = 220)
{
    return (monstro.felicidade >= limite_minimo);
}

function scr_verificar_evolucao(monstro)
{
    var _base = global.especies[$ monstro.especie_id];

    if (!variable_struct_exists(_base, "evolucoes")) return "";

    for (var _i = 0; _i < array_length(_base.evolucoes); _i++)
    {
        var _cond = _base.evolucoes[_i];

        switch (_cond.tipo)
        {
            case "nivel":
                if (monstro.nivel >= _cond.valor) return _cond.especie_destino;
                break;

            case "felicidade":
                if (scr_pode_evoluir_por_felicidade(monstro, _cond.valor)) return _cond.especie_destino;
                break;

            // GANCHOS FUTUROS: "item", "troca", "hora_dia", "local", etc.
            // basta adicionar um novo "case" aqui quando o gatilho existir.
        }
    }

    return "";
}

function scr_evoluir_monstro(monstro, especie_destino_id)
{
    var _nova_base = global.especies[$ especie_destino_id];
    var _especie_antiga = monstro.especie_id;
    var _nome_antigo = monstro.nome;

    // --- HABILIDADE: mantém se a nova espécie também a possuir, senão sorteia entre as da nova espécie ---
    var _manter_habilidade = false;
    if (variable_struct_exists(_nova_base, "habilidades_comuns"))
    {
        for (var _h = 0; _h < array_length(_nova_base.habilidades_comuns); _h++)
        {
            if (_nova_base.habilidades_comuns[_h] == monstro.habilidade)
            {
                _manter_habilidade = true;
                break;
            }
        }
    }

    if (!_manter_habilidade && variable_struct_exists(_nova_base, "habilidades_comuns") && array_length(_nova_base.habilidades_comuns) > 0)
    {
        var _idx = irandom(array_length(_nova_base.habilidades_comuns) - 1);
        monstro.habilidade = _nova_base.habilidades_comuns[_idx];
    }

    monstro.habilidade_oculta = variable_struct_exists(_nova_base, "habilidade_oculta") ? _nova_base.habilidade_oculta : "";

    // --- ESPÉCIE, NOME E TIPOS ATUALIZAM; GÊNERO, IVS, NATURE, FELICIDADE, MOVIMENTOS E ESTÁGIOS NÃO MUDAM ---
    monstro.especie_id = especie_destino_id;
    monstro.nome = _nova_base.nome;
    monstro.tipo1 = _nova_base.tipo1;
    monstro.tipo2 = _nova_base.tipo2;
    monstro.taxa_crescimento = _nova_base.taxa_crescimento;

    // --- RECALCULA STATS (preserva a diferença absoluta de HP, como no ganho de nível) ---
    scr_recalcular_stats(monstro);
    monstro.xp_prox_nivel = scr_xp_para_nivel(monstro.taxa_crescimento, monstro.nivel + 1);

    // --- APRENDE GOLPES DA NOVA ESPÉCIE QUE JÁ DEVERIA SABER NO NÍVEL ATUAL ---
    var _novos_movimentos = scr_verificar_movimentos_evolucao(monstro);

    return {
        especie_antiga: _especie_antiga,
        nome_antigo: _nome_antigo,
        nome_novo: monstro.nome,
        novos_movimentos: _novos_movimentos
    };
}

function scr_tentar_evoluir(monstro)
{
    var _especie_destino = scr_verificar_evolucao(monstro);
    if (_especie_destino == "") return { evoluiu: false };

    var _info = scr_evoluir_monstro(monstro, _especie_destino);
    return { evoluiu: true, evolucao_info: _info };
}

function scr_verificar_movimentos_evolucao(monstro)
{
    var _base = global.especies[$ monstro.especie_id]; // já é a espécie NOVA nesse ponto
    var _novos = [];

    if (variable_struct_exists(_base, "move_tree"))
    {
        for (var _i = 0; _i < array_length(_base.move_tree); _i++)
        {
            var _no = _base.move_tree[_i];

            if (_no.nivel <= monstro.nivel && !scr_pokemon_tem_movimento(monstro, _no.movimento_id))
            {
                scr_aprender_movimento(monstro, _no.movimento_id);
                // O chamador decide a substituição quando os quatro espaços já estão ocupados.
                // Se houver espaço, o movimento já foi aprendido e será ignorado pelo chamador.
                array_push(_novos, _no.movimento_id);
            }
        }
    }

    return _novos;
}
