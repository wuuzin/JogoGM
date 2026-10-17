function scr_campo_init()
{
    global.campo = {
        clima: "nenhum",       // "sol", "chuva", "tempestade_areia", "neve"
        turnos_clima: 0,
        terreno: "nenhum",     // "eletrico", "herbaceo", "psiquico", "nebuloso"
        turnos_terreno: 0
    };
}

function scr_definir_clima(clima_id, duracao = 5)
{
    global.campo.clima = clima_id;
    global.campo.turnos_clima = duracao;
}

function scr_definir_terreno(terreno_id, duracao = 5)
{
    global.campo.terreno = terreno_id;
    global.campo.turnos_terreno = duracao;
}

function scr_processar_fim_turno_campo(equipe_p1, equipe_p2)
{
    var _log_campo = [];

    // 1. Dano Residual de Clima (Tempestade de Areia / Granizo-Neve)
    var _monstros_ativos = [scr_get_monstro_ativo(equipe_p1), scr_get_monstro_ativo(equipe_p2)];
    
    for (var _i = 0; _i < array_length(_monstros_ativos); _i++)
    {
        var _mon = _monstros_ativos[_i];
        if (_mon.esta_desmaiado) continue;

        if (global.campo.clima == "tempestade_areia")
        {
            if (_mon.tipo1 != "pedra" && _mon.tipo1 != "terra" && _mon.tipo1 != "metal" &&
                _mon.tipo2 != "pedra" && _mon.tipo2 != "terra" && _mon.tipo2 != "metal")
            {
                var _dano_clima = max(1, floor(_mon.hp_max / 16));
                _mon.hp_atual = max(0, _mon.hp_atual - _dano_clima);
                if (_mon.hp_atual <= 0) _mon.esta_desmaiado = true;
                array_push(_log_campo, { mensagem: _mon.nome + " sofreu dano da Tempestade de Areia!" });
            }
        }

        if (global.campo.clima == "neve" && _mon.tipo1 != "gelo" && _mon.tipo2 != "gelo")
        {
            var _dano_neve = max(1, floor(_mon.hp_max / 16));
            _mon.hp_atual = max(0, _mon.hp_atual - _dano_neve);
            if (_mon.hp_atual <= 0) _mon.esta_desmaiado = true;
            array_push(_log_campo, { mensagem: _mon.nome + " sofreu dano da Nevasca!" });
        }

        if (_mon.esta_desmaiado) continue;
        
        // Cura no Terreno Herbáceo
        if (global.campo.terreno == "herbaceo" && _mon.hp_atual < _mon.hp_max)
        {
            var _cura_terreno = max(1, floor(_mon.hp_max / 16));
            _mon.hp_atual = min(_mon.hp_max, _mon.hp_atual + _cura_terreno);
            array_push(_log_campo, { mensagem: _mon.nome + " recuperou vida no Terreno Herbáceo!" });
        }
    }

    // 2. Decremento de Turnos de Clima
    if (global.campo.turnos_clima > 0)
    {
        global.campo.turnos_clima--;
        if (global.campo.turnos_clima == 0)
        {
            global.campo.clima = "nenhum";
            array_push(_log_campo, { mensagem: "O clima voltou ao normal." });
        }
    }

    // 3. Decremento de Turnos de Terreno
    if (global.campo.turnos_terreno > 0)
    {
        global.campo.turnos_terreno--;
        if (global.campo.turnos_terreno == 0)
        {
            global.campo.terreno = "nenhum";
            array_push(_log_campo, { mensagem: "O terreno voltou ao normal." });
        }
    }

    return _log_campo;
}

function scr_get_multiplicador_campo(atacante, movimento)
{
    var _mult = 1.0;
    
    // --- CLIMAS ---
    if (global.campo.clima == "sol")
    {
        if (movimento.tipo == "fogo") _mult *= 1.5;
        if (movimento.tipo == "agua") _mult *= 0.5;
    }
    else if (global.campo.clima == "chuva")
    {
        if (movimento.tipo == "agua") _mult *= 1.5;
        if (movimento.tipo == "fogo") _mult *= 0.5;
    }

    // --- TERRENOS ---
    if (global.campo.terreno == "eletrico" && movimento.tipo == "eletrico") _mult *= 1.3;
    if (global.campo.terreno == "herbaceo" && movimento.tipo == "planta") _mult *= 1.3;
    if (global.campo.terreno == "psiquico" && movimento.tipo == "psiquico") _mult *= 1.3;
    if (global.campo.terreno == "nebuloso" && movimento.tipo == "dragao") _mult *= 0.5;

    return _mult;
}
