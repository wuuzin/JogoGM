function scr_enfermeira_restaurar_equipe()
{
    if (!variable_global_exists("equipe_jogador") || !is_struct(global.equipe_jogador))
        return false;

    for (var _i = 0; _i < array_length(global.equipe_jogador.monstros); _i++)
    {
        var _monstro = global.equipe_jogador.monstros[_i];
        _monstro.hp_atual = _monstro.hp_max;
        _monstro.esta_desmaiado = false;
        _monstro.status = "nenhum";
        _monstro.turnos_status = 0;
        scr_resetar_status_temporarios(_monstro);
        for (var _m = 0; _m < array_length(_monstro.movimentos); _m++)
        {
            var _movimento = global.movimentos[$ _monstro.movimentos[_m].movimento_id];
            _monstro.movimentos[_m].pp_atual = _movimento.pp_max;
        }
    }
    global.equipe_jogador.indice_ativo = 0;
    return true;
}

function scr_enfermeira_interagir(enfermeira)
{
    if (!instance_exists(enfermeira) || !instance_exists(obj_player))
        return false;
    if (variable_global_exists("em_batalha") && global.em_batalha)
        return false;
    if (variable_global_exists("enfermeira_dialogo_ativo") && global.enfermeira_dialogo_ativo)
        return false;
    if (point_distance(enfermeira.x, enfermeira.y, obj_player.x, obj_player.y) > enfermeira.raio_interacao)
        return false;

    global.ultima_enfermeira_room = room;
    global.ultima_enfermeira_x = enfermeira.x;
    global.ultima_enfermeira_y = enfermeira.y;
    scr_enfermeira_restaurar_equipe();
    global.enfermeira_dialogo_texto = "Prontinho! Seus Pokemon estao totalmente restaurados.";
    global.enfermeira_dialogo_ativo = true;
    return true;
}
