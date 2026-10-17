function scr_ia_escolher_movimento(monstro_ia, alvo)
{
    var _indices_disponiveis = [];
    var _pesos = [];

    for (var _i = 0; _i < array_length(monstro_ia.movimentos); _i++)
    {
        var _mov_instancia = monstro_ia.movimentos[_i];
        if (_mov_instancia.pp_atual <= 0) continue;

        var _score = scr_ia_pontuar_movimento(monstro_ia, alvo, _mov_instancia.movimento_id);
        var _peso = max(_score, 1);

        array_push(_indices_disponiveis, _i);
        array_push(_pesos, _peso);
    }

    if (array_length(_indices_disponiveis) == 0) return -1;

    var _chance_erro = 0.15;
    if (random(1) < _chance_erro)
    {
        var _indice_aleatorio = irandom(array_length(_indices_disponiveis) - 1);
        return _indices_disponiveis[_indice_aleatorio];
    }

    return scr_escolha_aleatoria_ponderada(_indices_disponiveis, _pesos);
}

function scr_ia_pontuar_movimento(monstro_ia, alvo, movimento_id)
{
    var _mov = global.movimentos[$ movimento_id];
    var _score = 0;

    if (_mov.categoria == "status" && variable_struct_exists(_mov, "efeito"))
    {
        var _efeito = _mov.efeito;

        switch (_efeito.tipo)
        {
            case "cura":
                var _vida_faltando = 1 - (monstro_ia.hp_atual / monstro_ia.hp_max);
                _score = _vida_faltando * 120;
                break;

            case "buff": _score = abs(_efeito.estagios) * 15; break;
            case "debuff": _score = abs(_efeito.estagios) * 12; break;
            default: _score = 10; break;
        }

        return _score;
    }

    var _estimativa = scr_estimar_dano(monstro_ia, alvo, movimento_id);
    _score = (_estimativa.dano / alvo.hp_max) * 100;

    if (_estimativa.dano >= alvo.hp_atual) _score += 50;
    if (variable_struct_exists(_mov, "prioridade") && _mov.prioridade > 0) _score += _mov.prioridade * 20;
    if (variable_struct_exists(_mov, "alta_chance_critico") && _mov.alta_chance_critico) _score += 15;
    if (_estimativa.efetividade == 0) _score = 0;

    return _score;
}