
function scr_checar_movimentos_novos_nivel(monstro)
{
    var _base = global.especies[$ monstro.especie_id];
    var _novos = [];

    if (variable_struct_exists(_base, "move_tree"))
    {
        for (var _i = 0; _i < array_length(_base.move_tree); _i++)
        {
            var _no = _base.move_tree[_i];
            
            if (_no.nivel == monstro.nivel)
            {
                // Só aprende se o Pokémon já não possuir esse movimento
                if (!scr_pokemon_tem_movimento(monstro, _no.movimento_id))
                {
                    array_push(_novos, _no.movimento_id);
                }
            }
        }
    }

    return _novos;
}

function scr_pokemon_tem_movimento(monstro, movimento_id)
{
    for (var _i = 0; _i < array_length(monstro.movimentos); _i++)
    {
        if (monstro.movimentos[_i].movimento_id == movimento_id) return true;
    }
    return false;
}

function scr_aprender_movimento(monstro, movimento_id, slot_substituir = -1)
{
    var _nova_instancia = scr_criar_movimento_instancia(movimento_id);

    // Slot livre disponível (< 4 golpes)
    if (array_length(monstro.movimentos) < 4)
    {
        array_push(monstro.movimentos, _nova_instancia);
        return { aprendeu: true, substituido: false };
    }

    // Substituição de golpe existente (slot_substituir de 0 a 3)
    if (slot_substituir >= 0 && slot_substituir < 4)
    {
        var _antigo = monstro.movimentos[slot_substituir].movimento_id;
        monstro.movimentos[slot_substituir] = _nova_instancia;
        return { aprendeu: true, substituido: true, antigo_id: _antigo };
    }

    // Caso o jogador recuse a substituição
    return { aprendeu: false, substituido: false };
}

function scr_ensinar_movimento_especial(monstro, movimento_id, origem, slot_substituir = -1)
{
    var _base = global.especies[$ monstro.especie_id];
    var _permitidos = [];

    switch (origem)
    {
        case "tm": _permitidos = _base.outros_movimentos.tms_hms; break;
        case "egg": _permitidos = _base.outros_movimentos.egg_moves; break;
        case "tutor": _permitidos = _base.outros_movimentos.tutor_moves; break;
    }

    // Valida se o movimento é compatível com a espécie
    var _compativel = false;
    for (var _i = 0; _i < array_length(_permitidos); _i++)
    {
        if (_permitidos[_i] == movimento_id) { _compativel = true; break; }
    }

    if (!_compativel) return { erro: "incompativel" };

    return scr_aprender_movimento(monstro, movimento_id, slot_substituir);
}