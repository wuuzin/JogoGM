function scr_calcular_dano(atacante, alvo, movimento_id)
{
    var _mov = global.movimentos[$ movimento_id];

    var _poder = _mov.poder;
    if (movimento_id == "return") _poder = max(1, floor(atacante.felicidade / 2.5));
    else if (movimento_id == "frustration") _poder = max(1, floor((255 - atacante.felicidade) / 2.5));

    var _atk, _def;

    if (_mov.categoria == "fisico")
    {
        _atk = scr_get_stat_efetivo(atacante, "atk");
        if (atacante.status == "queimadura") _atk = floor(_atk * 0.5);
        _def = scr_get_stat_efetivo(alvo, "def");
    }
    else
    {
        _atk = scr_get_stat_efetivo(atacante, "atk_esp");
        _def = scr_get_stat_efetivo(alvo, "def_esp");
    }

    var _dano = floor(((2 * atacante.nivel / 5 + 2) * _poder * (_atk / _def)) / 50) + 2;

    var _stab = scr_get_stab(atacante, _mov.tipo);
    var _efet = scr_get_efetividade(_mov.tipo, alvo.tipo1, alvo.tipo2);
    var _mult_campo = scr_get_multiplicador_campo(atacante, _mov);

	var _estagio_critico = scr_get_estagio_critico(atacante, _mov);
	var _critico = scr_rolar_critico(_estagio_critico);
    var _mult_critico = _critico ? 1.5 : 1;

    var _variacao = random_range(0.85, 1);

    _dano = floor(_dano * _stab * _efet * _mult_campo * _mult_critico * _variacao);

    if (_dano < 1 && _efet > 0) _dano = 1;

    var _contexto = { golpe: _mov, dano: _dano, atacante: atacante, alvo: alvo };
    _dano = scr_aplicar_habilidade(atacante, _contexto);

    return {
        dano: _dano,
        critico: _critico,
        efetividade: _efet
    };
}

function scr_estimar_dano(atacante, alvo, movimento_id)
{
    var _mov = global.movimentos[$ movimento_id];

    var _poder = _mov.poder;
    if (movimento_id == "return") _poder = max(1, floor(atacante.felicidade / 2.5));
    else if (movimento_id == "frustration") _poder = max(1, floor((255 - atacante.felicidade) / 2.5));

    var _atk, _def;

    if (_mov.categoria == "fisico")
    {
        _atk = scr_get_stat_efetivo(atacante, "atk");
        if (atacante.status == "queimadura") _atk = floor(_atk * 0.5);
        _def = scr_get_stat_efetivo(alvo, "def");
    }
    else
    {
        _atk = scr_get_stat_efetivo(atacante, "atk_esp");
        _def = scr_get_stat_efetivo(alvo, "def_esp");
    }

    var _dano = floor(((2 * atacante.nivel / 5 + 2) * _poder * (_atk / _def)) / 50) + 2;

    var _stab = scr_get_stab(atacante, _mov.tipo);
    var _efet = scr_get_efetividade(_mov.tipo, alvo.tipo1, alvo.tipo2);
    var _mult_campo = scr_get_multiplicador_campo(atacante, _mov);

    _dano = floor(_dano * _stab * _efet * _mult_campo);

    return { dano: _dano, efetividade: _efet };
}

function scr_get_efetividade(tipo_ataque, tipo1_alvo, tipo2_alvo)
{
    var _mult = 1;
    var _tabela = global.efetividade[$ tipo_ataque];

    if (is_undefined(_tabela)) return 1;

    if (variable_struct_exists(_tabela, tipo1_alvo)) _mult *= _tabela[$ tipo1_alvo];
    if (tipo2_alvo != "none" && variable_struct_exists(_tabela, tipo2_alvo)) _mult *= _tabela[$ tipo2_alvo];

    return _mult;
}

function scr_get_stab(atacante, tipo_golpe)
{
    return (tipo_golpe == atacante.tipo1 || tipo_golpe == atacante.tipo2) ? 1.5 : 1;
}

function scr_get_prioridade_movimento(monstro, indice_movimento)
{
    var _mov_instancia = monstro.movimentos[indice_movimento];
    var _mov_dados = global.movimentos[$ _mov_instancia.movimento_id];

    return variable_struct_exists(_mov_dados, "prioridade") ? _mov_dados.prioridade : 0;
}

function scr_aplicar_habilidade(monstro, contexto)
{
    var _atacante = monstro;
    var _alvo = variable_struct_exists(contexto, "alvo") ? contexto.alvo : undefined;

    switch (_atacante.habilidade)
    {
        case "chama":
            if (_atacante.hp_atual <= _atacante.hp_max * 0.33 && contexto.golpe.tipo == "fogo") contexto.dano *= 1.5;
            break;

        case "torrente":
            if (_atacante.hp_atual <= _atacante.hp_max * 0.33 && contexto.golpe.tipo == "agua") contexto.dano *= 1.5;
            break;

        case "rivalry":
            if (_alvo != undefined && _atacante.genero != "sem_genero" && _alvo.genero != "sem_genero")
            {
                if (_atacante.genero == _alvo.genero) contexto.dano *= 1.25;
                else contexto.dano *= 0.75;
            }
            break;
    }

    return contexto.dano;
}

function scr_aplicar_habilidade_defensor(defensor, atacante, mov_dados)
{
    if (defensor.esta_desmaiado) return false;

    switch (defensor.habilidade)
    {
        case "cute_charm":
            if (mov_dados.categoria == "fisico" &&
                defensor.genero != "sem_genero" && atacante.genero != "sem_genero" &&
                defensor.genero != atacante.genero)
            {
                if (random(1) < 0.3)
                {
                    atacante.apaixonado = true;
                    return true;
                }
            }
            break;
    }

    return false;
}

function scr_get_estagio_critico(atacante, mov_dados)
{
    var _estagio = 0;

    if (variable_struct_exists(mov_dados, "alta_chance_critico") && mov_dados.alta_chance_critico)
    {
        _estagio += 1;
    }

    // GANCHO: habilidades/itens que aumentam a chance de crítico entram aqui
    if (atacante.habilidade == "super_sorte") _estagio += 1;

    return _estagio;
}

function scr_rolar_critico(estagio)
{
    var _chance;

    switch (estagio)
    {
        case 0:  _chance = 1 / 24; break;
        case 1:  _chance = 1 / 8;  break;
        case 2:  _chance = 1 / 2;  break;
        default: _chance = 1;      break; // estágio 3+ = sempre crítico
    }

    return (random(1) < _chance);
}

function scr_get_multiplicador_precisao_evasao(estagio)
{
    estagio = clamp(estagio, -6, 6);
    return (estagio >= 0) ? ((3 + estagio) / 3) : (3 / (3 - estagio));
}

function scr_get_precisao_final(atacante, alvo, mov_dados)
{
    if (mov_dados.precisao <= 0) return 100; // golpes com precisao: 0 = nunca erram, ignoram estágios

    var _estagio_total = clamp(atacante.estagios.precisao - alvo.estagios.evasao, -6, 6);
    var _mult = scr_get_multiplicador_precisao_evasao(_estagio_total);

    return mov_dados.precisao * _mult;
}

function scr_movimento_tem_efeito_secundario(mov_dados)
{
    return variable_struct_exists(mov_dados, "efeito_secundario");
}

function scr_processar_efeito_secundario(atacante, alvo, mov_dados)
{
    if (!scr_movimento_tem_efeito_secundario(mov_dados)) return { ativou: false };

    var _ef = mov_dados.efeito_secundario;
    if (random(100) >= _ef.chance) return { ativou: false };

    var _alvo_efeito = (_ef.alvo == "self") ? atacante : alvo;

    switch (_ef.tipo)
    {
        case "status":
            var _aplicou = scr_aplicar_status(_alvo_efeito, _ef.status_id);
            return { ativou: _aplicou, tipo: "status", status_id: _ef.status_id, alvo_nome: _alvo_efeito.nome };

        case "buff":
        case "debuff":
            var _sinal = (_ef.tipo == "buff") ? 1 : -1;
            var _antigo = _alvo_efeito.estagios[$ _ef.stat];
            var _novo = clamp(_antigo + (_sinal * _ef.estagios), -6, 6);
            _alvo_efeito.estagios[$ _ef.stat] = _novo;
            return { ativou: (_novo != _antigo), tipo: _ef.tipo, stat: _ef.stat, estagio_novo: _novo, alvo_nome: _alvo_efeito.nome };

        case "volatil":
            var _aplicou_vol = scr_aplicar_estado_volatil(atacante, _alvo_efeito, _ef.estado_id);
            return { ativou: _aplicou_vol, tipo: "volatil", estado_id: _ef.estado_id, alvo_nome: _alvo_efeito.nome };

        case "flinch":
            var _aplicou_flinch = scr_aplicar_estado_volatil(atacante, _alvo_efeito, "hesitacao");
            return { ativou: _aplicou_flinch, tipo: "flinch", alvo_nome: _alvo_efeito.nome };
    }

    return { ativou: false };
}