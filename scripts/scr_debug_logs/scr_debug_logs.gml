function scr_batalha_dialogo_pop()
{
    if (!variable_global_exists("hud_batalha_dialogo_fila"))
    {
        global.hud_batalha_dialogo_fila = [];
    }

    if (array_length(global.hud_batalha_dialogo_fila) == 0)
    {
        return "";
    }

    var _item = global.hud_batalha_dialogo_fila[0];
    array_delete(global.hud_batalha_dialogo_fila, 0, 1);
    return _item;
}

function scr_batalha_dialogo_formatar_texto(texto)
{
    var _max_chars = (room == cena_batalha) ? 48 : 36;
    var _linhas = [];
    var _linha_atual = "";
    var _palavra = "";
    var _itens = string_length(texto);

    for (var _i = 1; _i <= _itens; _i++)
    {
        var _char = string_char_at(texto, _i);
        if (_char == " ")
        {
            if (string_length(_linha_atual) + string_length(_palavra) + 1 > _max_chars)
            {
                array_push(_linhas, _linha_atual);
                _linha_atual = _palavra;
                _palavra = "";
            }
            else
            {
                if (_linha_atual != "")
                {
                    _linha_atual += " ";
                }
                _linha_atual += _palavra;
                _palavra = "";
            }
        }
        else
        {
            _palavra += _char;
        }

        if (_i == _itens)
        {
            if (_palavra != "")
            {
                if (_linha_atual == "")
                {
                    _linha_atual = _palavra;
                }
                else if (string_length(_linha_atual) + 1 + string_length(_palavra) <= _max_chars)
                {
                    _linha_atual += " " + _palavra;
                }
                else
                {
                    array_push(_linhas, _linha_atual);
                    _linha_atual = _palavra;
                }
            }
            if (_linha_atual != "")
            {
                array_push(_linhas, _linha_atual);
            }
        }
    }

    if (array_length(_linhas) == 0)
    {
        return [texto];
    }

    return _linhas;
}

function scr_batalha_dialogo_pokeballs_snapshot(_treinador)
{
    var _estado = array_create(6, false);
    var _qtd = min(array_length(_treinador.monstros), 6);
    for (var _i = 0; _i < _qtd; _i++)
    {
        var _monstro = _treinador.monstros[_i];
        _estado[_i] = is_struct(_monstro) && !_monstro.esta_desmaiado && _monstro.hp_atual > 0;
    }
    return _estado;
}

function scr_batalha_dialogo_enfileirar_item(
    texto,
    acao,
    is_enemy,
    atualizar_hp = true,
    atualizar_icones = false,
    aguarda_xp_ao_avancar = false,
    xp_alvo = 0,
    xp_final = 0,
    xp_reiniciar = false,
    trocar_inimigo_indice = -1
)
{
    if (texto == "") return;

    var _eh_troca_jogador = is_struct(acao)
        && variable_struct_exists(acao, "tipo_acao")
        && acao.tipo_acao == "trocar"
        && !is_enemy;

    array_push(global.hud_batalha_dialogo_fila, {
        texto: texto,
        hp_jogador: variable_struct_exists(acao, "hp_jogador") ? acao.hp_jogador : 0,
        hp_inimigo: variable_struct_exists(acao, "hp_inimigo") ? acao.hp_inimigo : 0,
        is_enemy: is_enemy,
        atualizar_hp: atualizar_hp,
        atualizar_icones: atualizar_icones,
        aguarda_xp_ao_avancar: aguarda_xp_ao_avancar,
        xp_alvo: xp_alvo,
        xp_final: xp_final,
        xp_reiniciar: xp_reiniciar,
        trocar_inimigo_indice: trocar_inimigo_indice,
        eh_troca_jogador: _eh_troca_jogador
    });
}

function scr_batalha_dialogo_ativar_item(item)
{
    global.hud_batalha_dialogo_texto = item.texto;
    global.hud_batalha_dialogo_is_enemy = item.is_enemy;
    global.hud_batalha_dialogo_xp_ao_avancar = item.aguarda_xp_ao_avancar;
    global.hud_batalha_dialogo_xp_alvo = item.xp_alvo;
    global.hud_batalha_dialogo_xp_final = item.xp_final;
    global.hud_batalha_dialogo_xp_reiniciar = item.xp_reiniciar;

    if (variable_struct_exists(item, "eh_troca_jogador") && item.eh_troca_jogador)
    {
        global.hud_batalha_hp_anim.jogador.atual = item.hp_jogador;
        global.hud_batalha_hp_anim.jogador.alvo = item.hp_jogador;
        if (variable_instance_exists(id, "treinador_jogador"))
        {
            var _p_troca = scr_get_monstro_ativo(treinador_jogador);
            var _xp_troca = scr_progresso_xp_nivel(_p_troca);
            global.hud_batalha_xp_anim.jogador.atual = _xp_troca;
            global.hud_batalha_xp_anim.jogador.alvo = _xp_troca;
        }
    }
    else if (item.atualizar_hp)
    {
        global.hud_batalha_hp_anim.jogador.alvo = item.hp_jogador;
        global.hud_batalha_hp_anim.inimigo.alvo = item.hp_inimigo;
    }
    if (item.atualizar_icones)
    {
        global.hud_batalha_pokeballs_jogador =
            scr_batalha_dialogo_pokeballs_snapshot(treinador_jogador);
        global.hud_batalha_pokeballs_inimigo =
            scr_batalha_dialogo_pokeballs_snapshot(treinador_ia);
    }

    if (item.trocar_inimigo_indice >= 0)
    {
        var _antigo = scr_get_monstro_ativo(treinador_ia);
        scr_resetar_status_temporarios(_antigo);
        treinador_ia.indice_ativo = item.trocar_inimigo_indice;
        var _novo = scr_get_monstro_ativo(treinador_ia);
        global.hud_batalha_hp_anim.inimigo.atual = _novo.hp_atual;
        global.hud_batalha_hp_anim.inimigo.alvo = _novo.hp_atual;
        global.hud_batalha_pokeballs_inimigo =
            scr_batalha_dialogo_pokeballs_snapshot(treinador_ia);
    }
}

function scr_batalha_dialogo_nome_status(status_id)
{
    switch (status_id)
    {
        case "queimadura": return "queimando";
        case "envenenamento": return "envenenado";
        case "intoxicacao": return "intoxicado";
        case "paralisia": return "paralisado";
        case "sono": return "dormindo";
        case "congelamento": return "congelado";
        default: return string_lower(string(status_id));
    }
}

function scr_batalha_dialogo_nome_atributo(stat_id)
{
    switch (stat_id)
    {
        case "atk": return "Ataque";
        case "def": return "Defesa";
        case "atk_esp": return "Ataque Especial";
        case "def_esp": return "Defesa Especial";
        case "spd": return "Velocidade";
        case "precisao": return "Precisão";
        case "evasao": return "Evasão";
        default: return string(stat_id);
    }
}

function scr_batalha_enfileirar_log(log)
{
    if (!is_array(log)) return;
    if (!variable_global_exists("hud_batalha_dialogo_fila")) global.hud_batalha_dialogo_fila = [];

    for (var _i = 0; _i < array_length(log); _i++)
    {
        var _acao = log[_i];
        if (!is_struct(_acao)) continue;

        var _is_enemy = variable_struct_exists(_acao, "is_enemy") ? _acao.is_enemy : false;
        var _nome_atk = variable_struct_exists(_acao, "atacante_nome") ? _acao.atacante_nome : "";
        var _nome_alvo = variable_struct_exists(_acao, "alvo_nome") ? _acao.alvo_nome : "";
        if (room != cena_batalha)
        {
            if (_is_enemy && _nome_atk != "") _nome_atk = "Oponente " + _nome_atk;
            if (!_is_enemy && _nome_alvo != "") _nome_alvo = "Oponente " + _nome_alvo;
        }

        if (variable_struct_exists(_acao, "tipo_acao"))
        {
            var _texto_acao = "";
            switch (_acao.tipo_acao)
            {
                case "item": _texto_acao = _acao.mensagem; break;
                case "trocar":
                    _texto_acao = (_acao.treinador_nome == "Jogador")
                        ? "Vai, " + _acao.entrou_nome + "!"
                        : _acao.treinador_nome + " enviou " + _acao.entrou_nome + "!";
                    break;
                case "status_dano":
                case "erro": _texto_acao = _acao.mensagem; break;
            }
            if (_texto_acao != "")
            {
                scr_batalha_dialogo_enfileirar_item(_texto_acao, _acao, _is_enemy, true, true);
                continue;
            }
        }

        var _movimento = variable_struct_exists(_acao, "movimento_nome") ? _acao.movimento_nome : "";
        var _tem_movimento = _movimento != "" && _movimento != "Nenhum";
        var _abertura = "";
        var _resultado = "";
        var _motivo = variable_struct_exists(_acao, "motivo") ? _acao.motivo : "";

        if (_tem_movimento)
        {
            _abertura = _nome_atk + (_acao.sucesso && _acao.acertou ? " usou " : " tentou usar ")
                + _movimento + (_nome_alvo != "" ? " em " + _nome_alvo : "") + "!";
        }

        if (!_acao.sucesso)
        {
            if (_motivo == "sem_pp") _resultado = _nome_atk + " não tem mais PP para esse golpe!";
            else if (_motivo == "alvo_desmaiado") _resultado = "O golpe falhou!";
            else _resultado = _nome_atk + " não conseguiu atacar!";
        }
        else if (!_acao.acertou)
        {
            if (_motivo == "apaixonado") _resultado = _nome_atk + " está apaixonado e não conseguiu atacar!";
            else if (_motivo == "desviou") _resultado = _nome_alvo + " desviou do golpe!";
            else if (_motivo == "evitou") _resultado = _nome_alvo + " evitou o ataque!";
            else _resultado = "O ataque errou!";
        }
        else if (_motivo == "protegido")
        {
            _resultado = "O golpe foi protegido!";
        }
        else if (variable_struct_exists(_acao, "categoria") && _acao.categoria == "status")
        {
            var _tipo_efeito = variable_struct_exists(_acao, "tipo_efeito") ? _acao.tipo_efeito : "nenhum";
            switch (_tipo_efeito)
            {
                case "status":
                    if (_acao.aplicou)
                        _resultado = _nome_alvo + " ficou " + scr_batalha_dialogo_nome_status(_acao.status_id) + "!";
                    else
                        _resultado = "Mas não aconteceu nada!";
                    break;
                case "cura":
                    _resultado = (variable_struct_exists(_acao, "valor_curado") && _acao.valor_curado > 0)
                        ? _nome_atk + " recuperou HP!"
                        : _nome_atk + " não pode recuperar mais HP!";
                    break;
                case "attract":
                    _resultado = _nome_alvo + " ficou apaixonado!";
                    break;
                case "buff":
                case "debuff":
                    var _stat = scr_batalha_dialogo_nome_atributo(_acao.stat);
                    var _nome_monstro_stat = (_tipo_efeito == "buff") ? _nome_atk : _nome_alvo;
                    if (_acao.mudou)
                    {
                        var _alteracao_grande = variable_struct_exists(_acao, "estagios_alterados")
                            && _acao.estagios_alterados > 1;
                        _resultado = "O " + _stat + " de " + _nome_monstro_stat
                            + ((_tipo_efeito == "buff")
                                ? (_alteracao_grande ? " aumentou muito!" : " aumentou!")
                                : (_alteracao_grande ? " diminuiu muito!" : " diminuiu!"));
                    }
                    else
                        _resultado = "O atributo de " + _nome_monstro_stat
                            + ((_tipo_efeito == "buff") ? " não pode mais aumentar!" : " não pode mais diminuir!");
                    break;
                case "volatil":
                    _resultado = _acao.aplicou ? _nome_alvo + " foi afetado pelo golpe!" : "Mas não aconteceu nada!";
                    break;
                case "perish_song":
                    _resultado = "A música da perdição ecoou!";
                    break;
                case "protecao":
                    _resultado = _nome_atk + " se protegeu!";
                    break;
                case "bloqueado":
                    _resultado = "O ataque foi bloqueado!";
                    break;
                case "falhou":
                    _resultado = "O golpe falhou! Mas não aconteceu nada!";
                    break;
                default:
                    _resultado = "Mas não aconteceu nada!";
                    break;
            }
        }
        else
        {
            _resultado = _nome_alvo + " foi atingido!";
            if (variable_struct_exists(_acao, "efetividade"))
            {
                if (_acao.efetividade == 0) _resultado = "O golpe não teve efeito sobre " + _nome_alvo + "...";
                else if (_acao.efetividade > 1) _resultado += " O ataque foi super efetivo!";
                else if (_acao.efetividade < 1) _resultado += " Não é muito eficaz...";
            }
            if (variable_struct_exists(_acao, "critico") && _acao.critico)
                _resultado += " Foi um acerto crítico!";
            if (variable_struct_exists(_acao, "dano_percentual") && _acao.dano_percentual > 0)
                _resultado += " " + _nome_alvo + " perdeu " + string(_acao.dano_percentual) + "% de HP.";
            if (variable_struct_exists(_acao, "ativou_cute_charm") && _acao.ativou_cute_charm)
                _resultado += " " + _nome_atk + " se apaixonou!";

            if (variable_struct_exists(_acao, "efeito_secundario_info"))
            {
                var _secundario = _acao.efeito_secundario_info;
                if (_secundario.ativou)
                {
                    switch (_secundario.tipo)
                    {
                        case "status":
                            _resultado += " " + _secundario.alvo_nome + " ficou "
                                + scr_batalha_dialogo_nome_status(_secundario.status_id) + "!";
                            break;
                        case "buff":
                        case "debuff":
                            var _alteracao_secundaria_grande =
                                variable_struct_exists(_secundario, "estagios_alterados")
                                && _secundario.estagios_alterados > 1;
                            _resultado += " O " + scr_batalha_dialogo_nome_atributo(_secundario.stat)
                                + " de " + _secundario.alvo_nome
                                + ((_secundario.tipo == "buff")
                                    ? (_alteracao_secundaria_grande ? " aumentou muito!" : " aumentou!")
                                    : (_alteracao_secundaria_grande ? " diminuiu muito!" : " diminuiu!"));
                            break;
                        case "volatil": _resultado += " " + _secundario.alvo_nome + " foi afetado pelo golpe!"; break;
                        case "flinch": _resultado += " " + _secundario.alvo_nome + " hesitou!"; break;
                    }
                }
                else if (variable_struct_exists(_secundario, "bloqueado") && _secundario.bloqueado)
                {
                    _resultado += " O efeito foi bloqueado!";
                }
            }
        }

        if (_abertura != "" && room == cena_batalha)
            scr_batalha_dialogo_enfileirar_item(_abertura, _acao, _is_enemy, false, false);
        else if (_abertura != "")
            _resultado = _abertura + " " + _resultado;
        scr_batalha_dialogo_enfileirar_item(
            _resultado,
            _acao,
            _is_enemy,
            true,
            room == cena_batalha
        );

    }

    if (global.hud_batalha_dialogo_texto == "" && array_length(global.hud_batalha_dialogo_fila) > 0)
    {
        var _primeiro = scr_batalha_dialogo_pop();
        if (is_struct(_primeiro))
        {
            scr_batalha_dialogo_ativar_item(_primeiro);
        }
    }
}

function scr_hud_batalha_desenhar_dialogo()
{
    if (!variable_global_exists("hud_batalha_dialogo_fila") || global.hud_batalha_dialogo_texto == "") return;

    if (room == cena_batalha)
    {
        draw_set_font(Font2);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        var _texto_cena = global.hud_batalha_dialogo_texto;
        var _largura_texto_cena = string_width(_texto_cena);
        var _escala_x_cena = min(1, 1840 / max(_largura_texto_cena, 1));
        draw_set_color(c_black);
        draw_text_transformed(960, 1047, _texto_cena, _escala_x_cena, 1, 0);
        draw_text_transformed(961, 1047, _texto_cena, _escala_x_cena, 1, 0);
        draw_set_color(c_white);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        return;
    }

    var _w = (room == cena_batalha) ? 900 : 760;
    var _h = (room == cena_batalha) ? 170 : 200;
    
    // CAIXAS SEPARADAS: Se for turno do inimigo, aparece na esquerda. Jogador na direita.
    var _is_enemy = variable_global_exists("hud_batalha_dialogo_is_enemy") ? global.hud_batalha_dialogo_is_enemy : false;
    var _x = (room == cena_batalha) ? (1920 - _w) * 0.5 : (_is_enemy ? 24 : 1150);
    var _y = (room == cena_batalha) ? 875 : (_is_enemy ? 260 : 1040);

    draw_set_color(c_white);
    draw_rectangle_color(_x, _y, _x + _w, _y + _h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_x, _y, _x + _w, _y + _h, c_white, c_white, c_white, c_white, true);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);

    var _linhas = scr_batalha_dialogo_formatar_texto(global.hud_batalha_dialogo_texto);
    var _max_linhas = (room == cena_batalha) ? 4 : 5;
    for (var _i = 0; _i < min(array_length(_linhas), _max_linhas); _i++)
    {
        draw_text(_x + 28, _y + 20 + (_i * 34), _linhas[_i]);
    }
}

function scr_exibir_turno_equipe(turno, treinador_jogador, treinador_ia)
{
    var _p1 = scr_get_monstro_ativo(treinador_jogador);
    var _p2 = scr_get_monstro_ativo(treinador_ia);

    var _st_p1 = (_p1.status != "nenhum") ? " [" + string_upper(_p1.status) + "]" : "";
    var _st_p2 = (_p2.status != "nenhum") ? " [" + string_upper(_p2.status) + "]" : "";

    show_debug_message("");
    show_debug_message("=======================================");
    show_debug_message("TURNO " + string(turno));
    show_debug_message("CLIMA: " + string_upper(global.campo.clima) + " (" + string(global.campo.turnos_clima) + "t) | TERRENO: " + string_upper(global.campo.terreno) + " (" + string(global.campo.turnos_terreno) + "t)");
    show_debug_message("=======================================");
    show_debug_message("SEU POKÉMON: " + _p1.nome + " [" + string(_p1.genero) + "]" + _st_p1 + " - HP: " + string(_p1.hp_atual) + "/" + string(_p1.hp_max) + " | Nv: " + string(_p1.nivel) + " | Hab: " + _p1.habilidade);
    show_debug_message("OPONENTE:    " + _p2.nome + " [" + string(_p2.genero) + "]" + _st_p2 + " - HP: " + string(_p2.hp_atual) + "/" + string(_p2.hp_max) + " | Nv: " + string(_p2.nivel) + " | Hab: " + _p2.habilidade);
    
    show_debug_message("--- Golpes (1-4) ---");
    for (var _i = 0; _i < array_length(_p1.movimentos); _i++)
    {
        var _mov_inst = _p1.movimentos[_i];
        var _mov_dados = global.movimentos[$ _mov_inst.movimento_id];
        show_debug_message(string(_i + 1) + ") " + _mov_dados.nome + " (PP: " + string(_mov_inst.pp_atual) + "/" + string(_mov_dados.pp_max) + ")");
    }

    show_debug_message("--- Trocar Pokémon da Equipe (5-9) ---");
    var _tecla_troca = 5;
    for (var _i = 0; _i < array_length(treinador_jogador.monstros); _i++)
    {
        var _m = treinador_jogador.monstros[_i];
        var _st_m = (_m.status != "nenhum") ? " [" + string_upper(_m.status) + "]" : "";
        var _status = _m.esta_desmaiado ? "[DESMAIADO]" : (_i == treinador_jogador.indice_ativo ? "[EM CAMPO]" : "[OK]");

        if (_i == treinador_jogador.indice_ativo)
        {
            show_debug_message("Em campo -> " + _m.nome + _st_m + " (HP: " + string(_m.hp_atual) + "/" + string(_m.hp_max) + ") " + _status);
        }
        else
        {
            show_debug_message("Tecla " + string(_tecla_troca) + " -> " + _m.nome + _st_m + " (HP: " + string(_m.hp_atual) + "/" + string(_m.hp_max) + ") " + _status);
            _tecla_troca++;
        }
    }

	show_debug_message("---------------------------------------");
    show_debug_message("Atalhos de Teste: [I] Info Completa | [C] Ciclar Clima | [K] Ciclar Terreno | [T] Ciclar Status | [R] Reset");
    show_debug_message("Escolha uma ação...");

}

function scr_exibir_log_turno_equipe(log)
{
    scr_batalha_enfileirar_log(log);

    for (var _i = 0; _i < array_length(log); _i++)
    {
        var _item = log[_i];

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "item")
        {
            show_debug_message(">> " + _item.mensagem);
            continue;
        }

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "trocar")
        {
            show_debug_message(">> " + _item.treinador_nome + " recolheu " + _item.saiu_nome + " e enviou " + _item.entrou_nome + "!");
            continue;
        }

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "status_dano")
        {
            show_debug_message(">> " + _item.mensagem);
            continue;
        }

        if (variable_struct_exists(_item, "tipo_acao") && _item.tipo_acao == "erro")
        {
            show_debug_message(">> " + _item.mensagem);
            continue;
        }

        scr_exibir_log_turno([_item]);
    }
}

function scr_exibir_ivs_nature(monstro)
{
    var _st = (monstro.status != "nenhum") ? " | Status: " + string_upper(monstro.status) : "";
    show_debug_message("--- " + monstro.nome + " ---");
    show_debug_message("Gênero: " + string(monstro.genero) + " | Habilidade: " + monstro.habilidade + _st);
    show_debug_message("Nature: " + monstro.nature.nome + " (Aumenta: " + monstro.nature.aumenta + " | Diminui: " + monstro.nature.diminui + ")");
    show_debug_message("IVs -> HP: " + string(monstro.ivs.hp) + " | ATK: " + string(monstro.ivs.atk) + " | DEF: " + string(monstro.ivs.def) + " | ATK ESP: " + string(monstro.ivs.atk_esp) + " | DEF ESP: " + string(monstro.ivs.def_esp) + " | SPD: " + string(monstro.ivs.spd));
}

function scr_exibir_log_turno(log)
{
    for (var _i = 0; _i < array_length(log); _i++)
    {
        var _acao = log[_i];

        if (!_acao.sucesso)
        {
            show_debug_message(_acao.atacante_nome + " tentou usar " + _acao.movimento_nome + ", mas não pôde (" + _acao.motivo + ")");
            continue;
        }

        if (!_acao.acertou)
        {
            if (variable_struct_exists(_acao, "motivo") && _acao.motivo == "apaixonado")
            {
                show_debug_message(_acao.atacante_nome + " está apaixonado e não conseguiu atacar!");
            }
            else
            {
                show_debug_message(_acao.atacante_nome + " usou " + _acao.movimento_nome + ", mas errou!");
            }
            continue;
        }

        if (_acao.categoria == "status")
        {
            show_debug_message(_acao.atacante_nome + " usou " + _acao.movimento_nome + "!");

            switch (_acao.tipo_efeito)
            {
                case "status":
                    show_debug_message(_acao.aplicou
                        ? ">> " + _acao.alvo_nome + " foi afetado por " + string_upper(_acao.status_id) + "!"
                        : ">> Não teve efeito em " + _acao.alvo_nome + ".");
                    break;

                case "cura":
                    show_debug_message(">> " + _acao.atacante_nome + " recuperou " + string(_acao.valor_curado) + " de HP!");
                    break;

                case "attract":
                    show_debug_message(">> " + _acao.alvo_nome + " ficou apaixonado!");
                    break;

                case "buff":
                    show_debug_message(_acao.mudou
                        ? ">> " + _acao.stat + " de " + _acao.atacante_nome + " aumentou! (estágio " + string(_acao.estagio_novo) + ")"
                        : ">> Não teve efeito (estágio já máximo).");
                    break;

                case "debuff":
                    show_debug_message(_acao.mudou
                        ? ">> " + _acao.stat + " do oponente diminuiu! (estágio " + string(_acao.estagio_novo) + ")"
                        : ">> Não teve efeito (estágio já mínimo).");
                    break;

                case "volatil":
                    show_debug_message(_acao.aplicou
                        ? ">> " + _acao.alvo_nome + " foi afetado (" + _acao.estado_id + ")!"
                        : ">> Não teve efeito em " + _acao.alvo_nome + ".");
                    break;

                case "perish_song":
                    show_debug_message(">> Todos os Pokémon em campo que ouviram a música vão desmaiar em 3 turnos!");
                    break;

                case "falhou":
                    show_debug_message(">> Mas o movimento falhou!");
                    break;
            }

            continue;
        }

        show_debug_message(_acao.atacante_nome + " usou " + _acao.movimento_nome + " em " + _acao.alvo_nome + " causando " + string(_acao.dano) + " de dano.");

        if (_acao.critico) show_debug_message(">> Foi um golpe crítico!");
        if (_acao.efetividade > 1) show_debug_message(">> Foi super efetivo!");
        else if (_acao.efetividade < 1 && _acao.efetividade > 0) show_debug_message(">> Não foi muito efetivo...");
        else if (_acao.efetividade == 0) show_debug_message(">> Não afetou o alvo...");

        if (variable_struct_exists(_acao, "ativou_cute_charm") && _acao.ativou_cute_charm)
        {
            show_debug_message(">> " + _acao.atacante_nome + " se apaixonou por causa de Cute Charm!");
        }

        if (variable_struct_exists(_acao, "efeito_secundario_info") && _acao.efeito_secundario_info.ativou)
        {
            var _es = _acao.efeito_secundario_info;
            switch (_es.tipo)
            {
                case "status":  show_debug_message(">> " + _es.alvo_nome + " foi afetado por " + string_upper(_es.status_id) + "! (efeito secundário)"); break;
                case "buff":    show_debug_message(">> " + _es.stat + " de " + _es.alvo_nome + " aumentou! (efeito secundário)"); break;
                case "debuff":  show_debug_message(">> " + _es.stat + " de " + _es.alvo_nome + " diminuiu! (efeito secundário)"); break;
                case "volatil": show_debug_message(">> " + _es.alvo_nome + " foi afetado (" + _es.estado_id + ")! (efeito secundário)"); break;
                case "flinch":  show_debug_message(">> " + _es.alvo_nome + " hesitou! (efeito secundário)"); break;
            }
        }

        if (_acao.subiu_nivel) show_debug_message(">> " + _acao.atacante_nome + " subiu para o nível " + string(_acao.nivel_novo) + "! (XP: " + string(_acao.xp_atual) + "/" + string(_acao.xp_prox_nivel) + ")");

        if (variable_struct_exists(_acao, "evoluiu") && _acao.evoluiu)
        {
            show_debug_message(">> O que? " + _acao.evolucao_info.nome_antigo + " está evoluindo...");
            show_debug_message(">> Parabéns! Seu " + _acao.evolucao_info.nome_antigo + " se tornou " + _acao.evolucao_info.nome_novo + "!");

            for (var _n = 0; _n < array_length(_acao.evolucao_info.novos_movimentos); _n++)
            {
                var _nome_mov = global.movimentos[$ _acao.evolucao_info.novos_movimentos[_n]].nome;
                show_debug_message(">> " + _acao.evolucao_info.nome_novo + " aprendeu " + _nome_mov + "!");
            }
        }

        if (_acao.desmaiou) show_debug_message(">> " + _acao.alvo_nome + " desmaiou!");
    }
}

function scr_exibir_info_completa(monstro)
{
    show_debug_message("");
    show_debug_message("========== INFORMAÇÕES COMPLETAS ==========");
    show_debug_message("NOME: " + monstro.nome + " | GÊNERO: " + string(monstro.genero));
    show_debug_message("NÍVEL: " + string(monstro.nivel) + " | XP: " + string(monstro.xp) + " / " + string(monstro.xp_prox_nivel));
    show_debug_message("HABILIDADE: " + monstro.habilidade);
    show_debug_message("NATURE: " + monstro.nature.nome + " (+ " + monstro.nature.aumenta + " / - " + monstro.nature.diminui + ")");
    
    var _st_nocivo = (monstro.status != "nenhum") ? string_upper(monstro.status) : "Nenhum";
    var _apaixonado = (variable_struct_exists(monstro, "apaixonado") && monstro.apaixonado) ? "Sim" : "Não";
    show_debug_message("STATUS NOCIVO: " + _st_nocivo + " | APAIXONADO: " + _apaixonado);
    
    show_debug_message("--- STATUS DE BATALHA ---");
    show_debug_message("HP:  " + string(monstro.hp_atual) + " / " + string(monstro.hp_max) + " (IV: " + string(monstro.ivs.hp) + ")");
    
    // Calcula os status efetivos puxando as funções que aplicam os multiplicadores de estágio
    var _atk_efetivo = scr_get_stat_efetivo(monstro, "atk");
    var _def_efetivo = scr_get_stat_efetivo(monstro, "def");
    var _spa_efetivo = scr_get_stat_efetivo(monstro, "atk_esp");
    var _spd_efetivo = scr_get_stat_efetivo(monstro, "def_esp");
    var _spe_efetiva = scr_get_spd_com_status(monstro); // Função que você já possui que checa paralisia
    
    show_debug_message("ATK: " + string(_atk_efetivo) + " (Base mod: Estágio " + string(monstro.estagios.atk) + " | IV: " + string(monstro.ivs.atk) + ")");
    show_debug_message("DEF: " + string(_def_efetivo) + " (Base mod: Estágio " + string(monstro.estagios.def) + " | IV: " + string(monstro.ivs.def) + ")");
    show_debug_message("SPA: " + string(_spa_efetivo) + " (Base mod: Estágio " + string(monstro.estagios.atk_esp) + " | IV: " + string(monstro.ivs.atk_esp) + ")");
    show_debug_message("SPD: " + string(_spd_efetivo) + " (Base mod: Estágio " + string(monstro.estagios.def_esp) + " | IV: " + string(monstro.ivs.def_esp) + ")");
    show_debug_message("SPE: " + string(_spe_efetiva) + " (Base mod: Estágio " + string(monstro.estagios.spd) + " | IV: " + string(monstro.ivs.spd) + ")");
    
    show_debug_message("--- MOVIMENTOS ---");
    for (var _i = 0; _i < array_length(monstro.movimentos); _i++)
    {
        var _mov_inst = monstro.movimentos[_i];
        var _mov_dados = global.movimentos[$ _mov_inst.movimento_id];
        show_debug_message(string(_i + 1) + ") " + _mov_dados.nome + " | PP: " + string(_mov_inst.pp_atual) + "/" + string(_mov_dados.pp_max) + " | Categoria: " + _mov_dados.categoria);
    }
    show_debug_message("===========================================");
    show_debug_message("");
}

function scr_hud_batalha_status_padrao(status)
{
    if (status == "nenhum" || status == "normal") return "";

    switch (status)
    {
        case "queimadura": return "BRN";
        case "envenenamento": return "PSN";
        case "intoxicacao": return "TOX";
        case "paralisia": return "PAR";
        case "sono": return "SLP";
        case "congelamento": return "FRZ";
        default: return string_upper(status);
    }
}

function scr_hud_batalha_cor_status(status)
{
    switch (status)
    {
        case "queimadura": return make_color_rgb(255, 110, 50);
        case "envenenamento": return make_color_rgb(180, 80, 255);
        case "intoxicacao": return make_color_rgb(190, 70, 255);
        case "paralisia": return make_color_rgb(255, 240, 80);
        case "sono": return make_color_rgb(130, 180, 255);
        case "congelamento": return make_color_rgb(120, 220, 255);
        default: return make_color_rgb(90, 220, 110);
    }
}

function scr_hud_batalha_desenhar_barra_hp(x, y, largura, hp_atual, hp_max, cor_fundo, cor_fill)
{
    var _pct = (hp_max > 0) ? clamp(hp_atual / hp_max, 0, 1) : 0;
    var _w_fill = max(0, floor((largura - 2) * _pct));

    draw_set_alpha(1);
    draw_rectangle_color(x, y, x + largura, y + 14, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(x + 2, y + 2, x + largura - 2, y + 12, cor_fundo, cor_fundo, cor_fundo, cor_fundo, false);

    if (_w_fill > 0)
    {
        draw_rectangle_color(x + 2, y + 2, x + 2 + _w_fill, y + 12, cor_fill, cor_fill, cor_fill, cor_fill, false);
    }
}

function scr_hud_batalha_get_hp_visivel(monstro, lado)
{
    if (!is_struct(monstro))
    {
        return 0;
    }

    if (!variable_global_exists("hud_batalha_hp_anim"))
    {
        return monstro.hp_atual;
    }

    if (variable_struct_exists(global.hud_batalha_hp_anim, lado))
    {
        var _anim = global.hud_batalha_hp_anim[$ lado];
        if (is_struct(_anim))
        {
            return max(0, _anim.atual);
        }
    }

    return monstro.hp_atual;
}

function scr_hud_batalha_desenhar_painel(x, y, largura, alto, titulo, nivel, nome, hp_atual, hp_max, status, cor_fundo, especie, monstro_exp)
{
    var _status = scr_hud_batalha_status_padrao(status);
    var _status_cor = scr_hud_batalha_cor_status(status);
    var _barra_w = max(160, largura - 190);

    var _pad = 15;
    var _linha = 40;

    var _row1_y = y + _pad;
    var _row2_y = _row1_y + _linha;
    var _barra_h = 14;
    var _barra_x = x + 62;
    var _barra_y = _row2_y + ((_linha - _barra_h) / 2);
    var _barra_centro_y = _barra_y + (_barra_h / 2);
    var _row3_y = _row2_y + _linha;
    var _exp_y = _row3_y + 2;
    var _exp_h = 10;
    var _exp_max = 1;
    var _exp_inicio = 0;
    var _exp_atual = 0;
    var _mostrar_exp = is_struct(monstro_exp) && variable_struct_exists(monstro_exp, "xp");
    if (_mostrar_exp)
    {
        var _exp_monstro = monstro_exp;
        _exp_atual = max(0, _exp_monstro.xp);
        _exp_max = max(1, _exp_monstro.xp_prox_nivel);
        _exp_inicio = scr_xp_para_nivel(_exp_monstro.taxa_crescimento, _exp_monstro.nivel);
        _exp_atual = max(0, _exp_atual - _exp_inicio);
        _exp_max = max(1, _exp_max - _exp_inicio);
    }

    draw_rectangle_color(x, y, x + largura, y + alto, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(x, y, x + largura, y + alto, c_white, c_white, c_white, c_white, true);

    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(x + 18, _row1_y, nome);

    draw_set_halign(fa_right);
    draw_text(x + largura - 18, _row1_y, "Lv." + string(nivel));

    draw_set_halign(fa_left);
    draw_set_valign(fa_middle);
    draw_text(x + 18, _barra_centro_y, "HP");

    scr_hud_batalha_desenhar_barra_hp(_barra_x, _barra_y, _barra_w, hp_atual, hp_max, make_color_rgb(70, 70, 70), make_color_rgb(90, 220, 110));

    draw_set_halign(fa_right);
    draw_text(x + largura - 18, _barra_centro_y, string(hp_atual) + "/" + string(hp_max));

    if (_mostrar_exp)
    {
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(make_color_rgb(80, 170, 210));
        draw_text(x + 18, _exp_y + (_exp_h / 2), "XP");
        scr_hud_batalha_desenhar_barra_hp(_barra_x, _exp_y, _barra_w, _exp_atual, _exp_max,
            make_color_rgb(35, 45, 55), make_color_rgb(80, 170, 210));
        draw_set_halign(fa_right);
        draw_set_color(c_white);
        draw_text(x + largura - 18, _exp_y + (_exp_h / 2),
            string(_exp_atual) + "/" + string(_exp_max));
        draw_set_color(c_white);
    }

    var _status_y = _row3_y + 22;
    if (_status != "")
    {
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(_status_cor);
        draw_rectangle_color(x + 18, _status_y, x + 118, _status_y + 26, _status_cor, _status_cor, _status_cor, _status_cor, false);
        draw_set_color(c_black);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(x + 68, _status_y + 13, _status);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

function scr_hud_batalha_desenhar_menu_central(index_selecao)
{
    var _menu_w = 580;
    var _menu_h = 150;
    var _menu_x = 1920 - 24 - _menu_w;
    var _menu_y = 1280 - 24 - _menu_h;

    var _option_w = 120;
    var _option_h = 74;
    var _gap = 16;
    var _start_x = _menu_x + 24;
    var _start_y = _menu_y + 38;
    var _labels = ["LUTAR", "POKEMON", "MOCHILA", "FUGIR"];

    draw_set_color(c_white);
    draw_rectangle_color(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_menu_x, _menu_y, _menu_x + _menu_w, _menu_y + _menu_h, c_white, c_white, c_white, c_white, true);

    for (var _i = 0; _i < 4; _i++)
    {
        var _x = _start_x + (_i * (_option_w + _gap));
        var _selecionado = (_i == index_selecao);

        if (_selecionado)
        {
            draw_rectangle_color(_x, _start_y, _x + _option_w, _start_y + _option_h, c_white, c_white, c_white, c_white, false);
            draw_rectangle_color(_x, _start_y, _x + _option_w, _start_y + _option_h, c_black, c_black, c_black, c_black, true);
            draw_set_color(c_black);
        }
        else
        {
            draw_rectangle_color(_x, _start_y, _x + _option_w, _start_y + _option_h, c_black, c_black, c_black, c_black, false);
            draw_rectangle_color(_x, _start_y, _x + _option_w, _start_y + _option_h, c_white, c_white, c_white, c_white, true);
            draw_set_color(c_black);
        }

        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_text(_x + (_option_w * 0.5), _start_y + (_option_h * 0.5), _labels[_i]);
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

function scr_hud_batalha_desenhar_submenu(estado)
{
    var _panel_w = 290;
    var _panel_h = 120;
    var _panel_x = 1920 - 24 - _panel_w;
    var _panel_y = 1280 - 24 - _panel_h;

    draw_rectangle_color(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, c_white, c_white, c_white, c_white, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var _titulo = "MENU";
    var _texto = "OPÇÃO";

    switch (estado)
    {
        case "bag":
            _titulo = "BAG";
            _texto = "ITENS";
            break;
        case "pokemon":
            _titulo = "POKÉMON";
            _texto = "TIME";
            break;
        case "run":
            _titulo = "RUN";
            _texto = "FUGIR";
            break;
        default:
            _titulo = "FIGHT";
            _texto = "ATAQUES";
            break;
    }

    draw_text(_panel_x + (_panel_w * 0.5), _panel_y + 32, _titulo);
    draw_text(_panel_x + (_panel_w * 0.5), _panel_y + 78, _texto);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function scr_hud_batalha_desenhar_menu_pokemon(treinador_jogador)
{
    var _panel_x = 90;
    var _panel_y = 90;
    var _panel_w = 1740;
    var _panel_h = 950;

    draw_set_color(c_white);
    draw_rectangle_color(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, c_white, c_white, c_white, c_white, true);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    var _titulo_menu = "CHOOSE A POKEMON";
    if (variable_global_exists("hud_batalha_item_pendente") && global.hud_batalha_item_pendente != "")
        _titulo_menu = "USE ITEM ON WHICH POKEMON?";
    draw_text(_panel_x + (_panel_w * 0.5), _panel_y + 34, _titulo_menu);

    var _card_w = 720;
    var _card_h = 170;
    var _gap_x = 34;
    var _gap_y = 24;
    var _start_x = _panel_x + 56;
    var _start_y = _panel_y + 92;
    var _icon_w = 118;
    var _qtd = array_length(treinador_jogador.monstros);

    for (var _i = 0; _i < _qtd; _i++)
    {
        var _m = treinador_jogador.monstros[_i];
        var _col = _i mod 2;
        var _row = floor(_i / 2);
        var _x = _start_x + (_col * (_card_w + _gap_x));
        var _y = _start_y + (_row * (_card_h + _gap_y));
        var _selecionado = (_i == global.hud_batalha_pokemon_index);
        var _fill = _selecionado ? c_white : c_black;
        var _border = _selecionado ? c_black : c_white;
        var _text_col = _selecionado ? c_black : c_white;

        draw_set_color(_fill);
        draw_rectangle_color(_x, _y, _x + _card_w, _y + _card_h, _fill, _fill, _fill, _fill, false);
        draw_rectangle_color(_x, _y, _x + _card_w, _y + _card_h, _border, _border, _border, _border, true);

        var _icon_x = _x + 18;
        var _icon_y = _y + 18;
        draw_set_color(_fill);
        draw_rectangle_color(_icon_x, _icon_y, _icon_x + _icon_w, _icon_y + _icon_w, _fill, _fill, _fill, _fill, false);
        draw_rectangle_color(_icon_x, _icon_y, _icon_x + _icon_w, _icon_y + _icon_w, _border, _border, _border, _border, true);

        var _spr_card = scr_batalha_sprite_pokemon_resolver(_m, false);
        if (_spr_card != -1)
        {
            var _spr_w = max(1, sprite_get_width(_spr_card));
            var _spr_h = max(1, sprite_get_height(_spr_card));
            var _escala_spr = min((_icon_w - 12) / _spr_w, (_icon_w - 12) / _spr_h);
            var _draw_sx = _icon_x + (_icon_w * 0.5) - ((_spr_w * 0.5 - sprite_get_xoffset(_spr_card)) * _escala_spr);
            var _draw_sy = _icon_y + (_icon_w * 0.5) - ((_spr_h * 0.5 - sprite_get_yoffset(_spr_card)) * _escala_spr);
            draw_sprite_ext(_spr_card, 0, _draw_sx, _draw_sy, _escala_spr, _escala_spr, 0, c_white, 1);
        }
        else
        {
            draw_set_color(_text_col);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_icon_x + (_icon_w * 0.5), _icon_y + (_icon_w * 0.5), "PK");
        }

        var _genero = "";
        if (variable_struct_exists(_m, "genero"))
        {
            if (_m.genero == "macho") _genero = "♂";
            else if (_m.genero == "femea") _genero = "♀";
            else if (_m.genero == "sem_genero") _genero = "?";
        }

        var _info_x = _x + 156;
        var _info_y = _y + 18;
        draw_set_color(_text_col);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_text(_info_x, _info_y, string_upper(_m.nome));

        draw_set_halign(fa_left);
        draw_text(_info_x + 210, _info_y, _genero);

        draw_set_halign(fa_right);
        draw_text(_x + _card_w - 18, _info_y, "Lv." + string(_m.nivel));

        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_text(_info_x, _y + 72, "HP");

        var _hp_x = _info_x + 46;
        var _hp_y = _y + 60;
        var _hp_w = max(220, _card_w - 290);
        scr_hud_batalha_desenhar_barra_hp(_hp_x, _hp_y, _hp_w, _m.hp_atual, _m.hp_max, make_color_rgb(70, 70, 70), make_color_rgb(90, 220, 110));

        draw_set_color(_text_col);
        draw_set_halign(fa_right);
        draw_text(_x + _card_w - 18, _y + 72, string(_m.hp_atual) + "/" + string(_m.hp_max));

        if (!_m.esta_desmaiado && variable_struct_exists(_m, "status") && _m.status != "nenhum")
        {
            var _sigla_st = string_upper(string_copy(_m.status, 1, 3));
            if (_m.status == "queimadura") _sigla_st = "BRN";
            else if (_m.status == "envenenamento") _sigla_st = "PSN";
            else if (_m.status == "intoxicacao") _sigla_st = "TOX";
            else if (_m.status == "paralisia") _sigla_st = "PAR";
            else if (_m.status == "sono") _sigla_st = "SLP";
            else if (_m.status == "congelamento") _sigla_st = "FRZ";

            draw_set_color(make_color_rgb(220, 120, 40));
            draw_rectangle_color(_info_x, _y + 122, _info_x + 84, _y + 148, make_color_rgb(220, 120, 40), make_color_rgb(220, 120, 40), make_color_rgb(220, 120, 40), make_color_rgb(220, 120, 40), false);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_info_x + 42, _y + 135, _sigla_st);
        }

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        draw_set_color(_text_col);

        if (_m.esta_desmaiado)
        {
            draw_set_color(c_red);
            draw_rectangle_color(_x + _card_w - 92, _y + 122, _x + _card_w - 16, _y + 148, c_red, c_red, c_red, c_red, false);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_x + _card_w - 54, _y + 135, "KO");
        }
        else if (_i == treinador_jogador.indice_ativo)
        {
            draw_set_color(c_yellow);
            draw_rectangle_color(_x + _card_w - 118, _y + 122, _x + _card_w - 16, _y + 148, c_yellow, c_yellow, c_yellow, c_yellow, false);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_x + _card_w - 67, _y + 135, "ATIVO");
        }
        else
        {
            draw_set_color(c_white);
            draw_rectangle_color(_x + _card_w - 118, _y + 122, _x + _card_w - 16, _y + 148, c_white, c_white, c_white, c_white, false);
            draw_set_color(c_black);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            draw_text(_x + _card_w - 67, _y + 135, "READY");
        }

        draw_set_color(c_white);
    }

    if (variable_global_exists("hud_batalha_pokemon_aviso") && global.hud_batalha_pokemon_aviso != "")
    {
        draw_set_halign(fa_left);
        draw_set_valign(fa_middle);
        draw_set_color(c_yellow);
        draw_text(_panel_x + 56, _panel_y + _panel_h - 65, global.hud_batalha_pokemon_aviso);
    }

    if (!global.hud_batalha_substituicao_obrigatoria)
    {
        var _btn_x1 = _panel_x + _panel_w - 250;
        var _btn_y1 = _panel_y + _panel_h - 105;
        var _btn_x2 = _panel_x + _panel_w - 56;
        var _btn_y2 = _panel_y + _panel_h - 25;
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_rectangle_color(_btn_x1, _btn_y1, _btn_x2, _btn_y2, c_black, c_black, c_black, c_black, false);
        draw_rectangle_color(_btn_x1, _btn_y1, _btn_x2, _btn_y2, c_white, c_white, c_white, c_white, true);
        draw_set_color(c_white);
        draw_text((_btn_x1 + _btn_x2) * 0.5, (_btn_y1 + _btn_y2) * 0.5, "B VOLTAR");
    }

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

function scr_hud_batalha_desenhar_opcoes_pokemon(treinador_jogador)
{
    var _m = treinador_jogador.monstros[global.hud_batalha_pokemon_index];
    var _ativo_atual = scr_get_monstro_ativo(treinador_jogador);
    var _bloqueado_preso = !global.hud_batalha_substituicao_obrigatoria
        && !_ativo_atual.esta_desmaiado
        && variable_struct_exists(_ativo_atual, "estados_volateis")
        && _ativo_atual.estados_volateis.preso.ativo;
    var _troca_indisponivel = _m.esta_desmaiado
        || (global.hud_batalha_pokemon_index == treinador_jogador.indice_ativo)
        || _bloqueado_preso;

    var _x = 1360;
    var _y = 300;
    var _w = 420;
    var _h = 300;
    var _labels = ["SUMARIO", "SWITCH", "CANCEL"];

    draw_set_color(c_black);
    draw_rectangle_color(_x, _y, _x + _w, _y + _h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_x, _y, _x + _w, _y + _h, c_white, c_white, c_white, c_white, true);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_x + 24, _y + 24, string_upper(_m.nome));

    for (var _i = 0; _i < 3; _i++)
    {
        var _linha_y = _y + 78 + (_i * 60);
        var _selecionado = (_i == global.hud_batalha_pokemon_opcao);
        var _desabilitado = (_i == 1 && _troca_indisponivel);
        if (_selecionado)
        {
            draw_set_color(c_white);
            draw_rectangle_color(_x + 18, _linha_y, _x + _w - 18, _linha_y + 44,
                c_white, c_white, c_white, c_white, false);
            draw_set_color(_desabilitado ? make_color_rgb(110, 110, 110) : c_black);
        }
        else
        {
            draw_set_color(_desabilitado ? c_gray : c_white);
        }
        draw_text(_x + 34, _linha_y + 12, _labels[_i]);
    }
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function scr_hud_batalha_desenhar_sumario_pokemon(treinador_jogador)
{
    var _m = treinador_jogador.monstros[global.hud_batalha_pokemon_index];
    var _x = 180;
    var _y = 100;
    var _w = 1560;
    var _h = 920;

    draw_set_color(c_black);
    draw_rectangle_color(_x, _y, _x + _w, _y + _h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_x, _y, _x + _w, _y + _h, c_white, c_white, c_white, c_white, true);
    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_text(_x + 32, _y + 28, "SUMARIO");

    var _spr_sumario = scr_batalha_sprite_pokemon_resolver(_m, false);
    if (_spr_sumario != -1)
    {
        var _box_x = _x + 520;
        var _box_y = _y + 84;
        var _box_s = 140;
        draw_rectangle_color(_box_x, _box_y, _box_x + _box_s, _box_y + _box_s, c_white, c_white, c_white, c_white, true);
        var _sw = max(1, sprite_get_width(_spr_sumario));
        var _sh = max(1, sprite_get_height(_spr_sumario));
        var _esc = min((_box_s - 16) / _sw, (_box_s - 16) / _sh);
        var _sx = _box_x + (_box_s * 0.5) - ((_sw * 0.5 - sprite_get_xoffset(_spr_sumario)) * _esc);
        var _sy = _box_y + (_box_s * 0.5) - ((_sh * 0.5 - sprite_get_yoffset(_spr_sumario)) * _esc);
        draw_sprite_ext(_spr_sumario, 0, _sx, _sy, _esc, _esc, 0, c_white, 1);
    }

    var _tipo_str = string_upper(_m.tipo1);
    if (_m.tipo2 != "nenhum" && _m.tipo2 != "")
        _tipo_str += " / " + string_upper(_m.tipo2);

    var _item_nome = "NENHUM";
    if (variable_struct_exists(_m, "held_item") && _m.held_item != "" && _m.held_item != "nenhum")
    {
        _item_nome = (variable_global_exists("itens") && variable_struct_exists(global.itens, _m.held_item))
            ? string_upper(global.itens[$ _m.held_item].nome)
            : string_upper(string(_m.held_item));
    }

    draw_text(_x + 32, _y + 90, string_upper(_m.nome) + "  Lv." + string(_m.nivel));
    draw_text(_x + 32, _y + 140, "TIPO: " + _tipo_str);
    draw_text(_x + 32, _y + 190, "GENERO: " + string_upper(_m.genero));
    draw_text(_x + 32, _y + 240, "HABILIDADE: " + string_upper(_m.habilidade));
    draw_text(_x + 32, _y + 290, "NATUREZA: " + string_upper(_m.nature.nome));
    draw_text(_x + 32, _y + 340, "STATUS: " + string_upper(_m.status));
    draw_text(_x + 32, _y + 390, "ITEM: " + _item_nome);
    draw_text(_x + 32, _y + 440, "HP: " + string(_m.hp_atual) + "/" + string(_m.hp_max));
    draw_text(_x + 32, _y + 490, "EXP: " + string(_m.xp) + "/" + string(_m.xp_prox_nivel));

    draw_text(_x + 32, _y + 560, "ATRIBUTOS");
    draw_text(_x + 32, _y + 610, "ATK: " + string(_m.atk) + "   DEF: " + string(_m.def));
    draw_text(_x + 32, _y + 660, "SPA: " + string(_m.atk_esp) + "   SPD: " + string(_m.def_esp));
    draw_text(_x + 32, _y + 710, "SPE: " + string(_m.spd));

    draw_text(_x + 780, _y + 90, "ATAQUES");
    for (var _i = 0; _i < array_length(_m.movimentos); _i++)
    {
        var _mov = _m.movimentos[_i];
        var _dados = global.movimentos[$ _mov.movimento_id];
        draw_text(_x + 780, _y + 140 + (_i * 70),
            _dados.nome + "  (" + string_upper(_dados.tipo) + ")  PP " + string(_mov.pp_atual) + "/" + string(_dados.pp_max));
    }

    var _btn_x1 = _x + _w - 240;
    var _btn_y1 = _y + _h - 95;
    var _btn_x2 = _x + _w - 40;
    var _btn_y2 = _y + _h - 25;
    draw_rectangle_color(_btn_x1, _btn_y1, _btn_x2, _btn_y2, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_btn_x1, _btn_y1, _btn_x2, _btn_y2, c_white, c_white, c_white, c_white, true);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(c_white);
    draw_text((_btn_x1 + _btn_x2) * 0.5, (_btn_y1 + _btn_y2) * 0.5, "B VOLTAR");
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function scr_hud_batalha_desenhar_info_avancada(treinador_jogador, treinador_ia, turno)
{
    if (is_undefined(treinador_jogador) || is_undefined(treinador_ia))
    {
        return;
    }

    var _p1 = scr_get_monstro_ativo(treinador_jogador);
    var _p2 = scr_get_monstro_ativo(treinador_ia);

    var _panel_x = 190;
    var _panel_y = 140;
    var _panel_w = 1540;
    var _panel_h = 980;
    var _lh = 30;

    draw_set_color(c_white);
    draw_rectangle_color(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_panel_x, _panel_y, _panel_x + _panel_w, _panel_y + _panel_h, c_white, c_white, c_white, c_white, true);

    draw_set_halign(fa_left);
    draw_text(_panel_x + 26, _panel_y + 20, "INFORMAÇÕES AVANÇADAS");

    var _top_y = _panel_y + 72;
    draw_text(_panel_x + 26, _top_y, "TURNO " + string(turno));
    draw_text(_panel_x + 400, _top_y, "CLIMA: " + string_upper(global.campo.clima) + " (" + string(global.campo.turnos_clima) + ")");
    draw_text(_panel_x + 850, _top_y, "TERRENO: " + string_upper(global.campo.terreno) + " (" + string(global.campo.turnos_terreno) + ")");

    var _left_x = _panel_x + 40;
    var _right_x = _panel_x + 770;
    var _col_w = 680;
    var _base_y = _top_y + 56;

    draw_text(_left_x, _base_y, "ATIVO: " + _p1.nome + " | NÍVEL: " + string(_p1.nivel) + " | HP: " + string(_p1.hp_atual) + "/" + string(_p1.hp_max));
    draw_text(_left_x, _base_y + (_lh * 1), "HABILIDADE: " + _p1.habilidade);
    draw_text(_left_x, _base_y + (_lh * 2), "STATUS: " + ((_p1.status == "nenhum") ? "Nenhum" : scr_hud_batalha_status_padrao(_p1.status)));
    draw_text(_left_x, _base_y + (_lh * 3), "NATURE: " + _p1.nature.nome + " (+" + _p1.nature.aumenta + " / -" + _p1.nature.diminui + ")");
    draw_text(_left_x, _base_y + (_lh * 4), "ATK: " + string(scr_get_stat_efetivo(_p1, "atk")) + "  DEF: " + string(scr_get_stat_efetivo(_p1, "def")) + "  SPA: " + string(scr_get_stat_efetivo(_p1, "atk_esp")) + "  SPD: " + string(scr_get_stat_efetivo(_p1, "def_esp")) + "  SPE: " + string(scr_get_spd_com_status(_p1)));
    draw_text(_left_x, _base_y + (_lh * 5), "IVS: HP " + string(_p1.ivs.hp) + " | ATK " + string(_p1.ivs.atk) + " | DEF " + string(_p1.ivs.def) + " | SPA " + string(_p1.ivs.atk_esp) + " | SPD " + string(_p1.ivs.def_esp) + " | SPE " + string(_p1.ivs.spd));

    draw_text(_right_x, _base_y, "OPONENTE: " + _p2.nome + " | NÍVEL: " + string(_p2.nivel) + " | HP: " + string(_p2.hp_atual) + "/" + string(_p2.hp_max));
    draw_text(_right_x, _base_y + (_lh * 1), "HABILIDADE: " + _p2.habilidade);
    draw_text(_right_x, _base_y + (_lh * 2), "STATUS: " + ((_p2.status == "nenhum") ? "Nenhum" : scr_hud_batalha_status_padrao(_p2.status)));
    draw_text(_right_x, _base_y + (_lh * 3), "ATK: " + string(scr_get_stat_efetivo(_p2, "atk")) + "  DEF: " + string(scr_get_stat_efetivo(_p2, "def")) + "  SPA: " + string(scr_get_stat_efetivo(_p2, "atk_esp")) + "  SPD: " + string(scr_get_stat_efetivo(_p2, "def_esp")) + "  SPE: " + string(scr_get_spd_com_status(_p2)));

    var _moves_y = _base_y + (_lh * 7) + 10;
    draw_text(_left_x, _moves_y, "MOVIMENTOS:");
    for (var _i = 0; _i < min(array_length(_p1.movimentos), 4); _i++)
    {
        var _mov_inst = _p1.movimentos[_i];
        var _mov_dados = global.movimentos[$ _mov_inst.movimento_id];
        draw_text(_left_x + 18, _moves_y + 26 + (_i * _lh), string(_i + 1) + ") " + _mov_dados.nome + " | PP " + string(_mov_inst.pp_atual) + "/" + string(_mov_dados.pp_max) + " | CAT " + string_upper(_mov_dados.categoria));
    }

    var _team_y = _base_y + (_lh * 7) + 10;
    draw_text(_right_x, _team_y, "EQUIPE:");
    for (var _i = 0; _i < array_length(treinador_jogador.monstros); _i++)
    {
        var _m = treinador_jogador.monstros[_i];
        var _ativo = (_i == treinador_jogador.indice_ativo) ? "[ATIVO]" : "[RESERVA]";
        draw_text(_right_x + 18, _team_y + 26 + (_i * _lh), _m.nome + " " + _ativo + " | HP " + string(_m.hp_atual) + "/" + string(_m.hp_max) + " | " + ((_m.status == "nenhum") ? "SEM STATUS" : string_upper(_m.status)));
    }
}

function scr_batalha_sprite_pokemon_resolver(monstro, costas)
{
    if (!is_struct(monstro))
        return -1;

    var _prefixo = costas ? "spr_back_" : "spr_";
    var _candidatos = [];
    if (!variable_global_exists("batalha_sprites_cache"))
        global.batalha_sprites_cache = {};

    if (variable_struct_exists(monstro, "especie_id"))
        array_push(_candidatos, string_lower(string(monstro.especie_id)));
    if (variable_struct_exists(monstro, "nome"))
        array_push(_candidatos, string_lower(string(monstro.nome)));

    for (var _i = 0; _i < array_length(_candidatos); _i++)
    {
        var _id = string_replace_all(string_replace_all(_candidatos[_i], " ", "_"), "-", "_");
        var _chave = _prefixo + _id;
        if (!variable_struct_exists(global.batalha_sprites_cache, _chave))
            global.batalha_sprites_cache[$ _chave] = asset_get_index(_chave);

        var _sprite = global.batalha_sprites_cache[$ _chave];
        if (_sprite != -1)
            return _sprite;
    }

    return -1;
}

function scr_batalha_sprite_posicao_manual(especie_id, costas)
{
    var _lado = costas ? "aliado" : "rival";
    var _id = string_lower(string(especie_id));

    if (!variable_global_exists("batalha_posicoes_sprites"))
    {
        global.batalha_posicoes_sprites = {};
        global.batalha_posicoes_sprites.aliado = {};
        global.batalha_posicoes_sprites.rival = {};
    }

    if (variable_struct_exists(global.batalha_posicoes_sprites[$ _lado], _id))
        return global.batalha_posicoes_sprites[$ _lado][$ _id];

    if (_id == "charmander")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 512, y: 576 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1280, y: 224 };
    }
    else if (_id == "caterpie")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 579.5, y: 645 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1321, y: 298 };
    }
    else if (_id == "metapod")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 579.5, y: 578 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1308, y: 285 };
    }
    else if (_id == "butterfree")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 459.5, y: 371 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1254, y: 127 };
    }
    else if (_id == "pidgey")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 522.5, y: 556 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1304, y: 235 };
    }
    else if (_id == "pidgeotto")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 390, y: 364.5 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1233, y: 21 };
    }
    else if (_id == "pidgeot")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 382, y: 427.5 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1299, y: 146 };
    }
    else if (_id == "squirtle")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 558.5, y: 587 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1323, y: 261.5 };
    }
    else if (_id == "wartortle")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 454.5, y: 441 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1252, y: 130 };
    }
    else if (_id == "blastoise")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 471.5, y: 424 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1186, y: 119 };
    }
    else if (_id == "bulbasaur")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 570.5, y: 642 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1305, y: 257 };
    }
    else if (_id == "charmeleon")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 367.5, y: 469 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1297, y: 148 };
    }
    else if (_id == "charizard")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 196.5, y: 291 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1214, y: 30 };
    }
    else if (_id == "ivysaur")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 458.5, y: 612 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1240, y: 196 };
    }
    else if (_id == "venusaur")
    {
        if (!variable_struct_exists(global.batalha_posicoes_sprites.aliado, _id))
            global.batalha_posicoes_sprites.aliado[$ _id] = { x: 354.5, y: 461 };
        if (!variable_struct_exists(global.batalha_posicoes_sprites.rival, _id))
            global.batalha_posicoes_sprites.rival[$ _id] = { x: 1179, y: 114 };
    }

    if (variable_struct_exists(global.batalha_posicoes_sprites[$ _lado], _id))
        return global.batalha_posicoes_sprites[$ _lado][$ _id];

    var _posicao_padrao = costas
        ? { x: 432, y: 411 }
        : { x: 1376, y: 96 };
    global.batalha_posicoes_sprites[$ _lado][$ _id] = _posicao_padrao;
    return _posicao_padrao;
}

function scr_hud_cena_batalha_desenhar_pokeballs(_treinador, _estado_slots, _x)
{
    var _qtd_pokemon = array_length(_treinador.monstros);
    for (var _slot = 0; _slot < 6; _slot++)
    {
        var _sprite_pokeball = hud_pokeball2;
        var _pokemon_vivo = false;
        if (_slot < _qtd_pokemon)
        {
            var _monstro_slot = _treinador.monstros[_slot];
            _pokemon_vivo = is_struct(_monstro_slot)
                && !_monstro_slot.esta_desmaiado && _monstro_slot.hp_atual > 0;
        }
        if (is_array(_estado_slots) && _slot < array_length(_estado_slots))
            _pokemon_vivo = _estado_slots[_slot];
        if (_pokemon_vivo) _sprite_pokeball = hud_pokeball;

        draw_sprite_ext(_sprite_pokeball, 0, _x + (_slot * 38.8), 1029.5999,
            0.4, 0.4, 0, c_white, 1);
    }
}

function scr_hud_cena_batalha_desenhar_nome_nivel(_monstro, _x, _y)
{
    var _nome = _monstro.nome;
    var _nivel = string(_monstro.nivel);
    var _y_texto = _y - 38;

    draw_set_font(Pokemon);
    draw_set_valign(fa_top);
    draw_set_halign(fa_left);

    draw_set_color(c_black);
    draw_text_transformed(_x + 30, _y_texto, _nome, 1.15, 1.15, 0);

    draw_set_halign(fa_right);
    draw_set_color(c_black);
    draw_text_transformed(_x + 630, _y_texto + 2, "Lv.", 0.75, 0.75, 0);
    draw_text_transformed(_x + 704, _y_texto, _nivel, 1.15, 1.15, 0);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
}

function scr_hud_cena_batalha_desenhar_pokemon(treinador_jogador, treinador_ia)
{
    if (!is_struct(treinador_jogador) || !is_struct(treinador_ia))
        return;

    if (!variable_global_exists("hud_batalha_pokeballs_jogador")
        || !is_array(global.hud_batalha_pokeballs_jogador))
        global.hud_batalha_pokeballs_jogador = scr_batalha_dialogo_pokeballs_snapshot(treinador_jogador);
    if (!variable_global_exists("hud_batalha_pokeballs_inimigo")
        || !is_array(global.hud_batalha_pokeballs_inimigo))
        global.hud_batalha_pokeballs_inimigo = scr_batalha_dialogo_pokeballs_snapshot(treinador_ia);

    scr_hud_cena_batalha_desenhar_pokeballs(
        treinador_jogador, global.hud_batalha_pokeballs_jogador, 1673.4);
    if (!variable_struct_exists(treinador_ia, "eh_selvagem") || !treinador_ia.eh_selvagem)
        scr_hud_cena_batalha_desenhar_pokeballs(
            treinador_ia, global.hud_batalha_pokeballs_inimigo, 18.2);

    var _aliado = scr_get_monstro_ativo(treinador_jogador);
    var _rival = scr_get_monstro_ativo(treinador_ia);
    if (!is_struct(_aliado) || !is_struct(_rival))
        return;

    scr_hud_cena_batalha_desenhar_nome_nivel(_rival, 47, 82);
    scr_hud_cena_batalha_desenhar_nome_nivel(_aliado, 1161, 691);

    var _hp_maximo = max(0, _aliado.hp_max);
    var _hp_visivel = clamp(scr_hud_batalha_get_hp_visivel(_aliado, "jogador"), 0, _hp_maximo);
    var _hp_progresso = (_hp_maximo > 0) ? _hp_visivel / _hp_maximo : 0;
    var _hp_rival_maximo = max(0, _rival.hp_max);
    var _hp_rival_visivel = clamp(scr_hud_batalha_get_hp_visivel(_rival, "inimigo"), 0, _hp_rival_maximo);
    var _hp_rival_progresso = (_hp_rival_maximo > 0) ? _hp_rival_visivel / _hp_rival_maximo : 0;
    var _xp_progresso = scr_progresso_xp_nivel(_aliado);
    if (variable_global_exists("hud_batalha_xp_anim")
        && is_struct(global.hud_batalha_xp_anim)
        && variable_struct_exists(global.hud_batalha_xp_anim, "jogador"))
    {
        _xp_progresso = clamp(global.hud_batalha_xp_anim.jogador.atual, 0, 1);
    }

    var _hpbar_x = 1216.5;
    var _hpbar_y = 741.5;
    var _hpbar_rival_x = 102.5;
    var _hpbar_rival_y = 122.5;
    var _expbar_x = 1217;
    var _expbar_y = 720;
    var _barra_hp_largura = floor(sprite_get_width(hud_hpbar) * _hp_progresso);
    var _barra_hp_rival_largura = floor(sprite_get_width(hud_hpbar) * _hp_rival_progresso);
    var _barra_xp_largura = floor(sprite_get_width(hud_expbar) * _xp_progresso);

    if (_barra_hp_rival_largura > 0)
        draw_sprite_part_ext(hud_hpbar, 0, 0, 0, _barra_hp_rival_largura, sprite_get_height(hud_hpbar),
            _hpbar_rival_x, _hpbar_rival_y, 1, 1, c_white, 1);
    if (_barra_hp_largura > 0)
        draw_sprite_part_ext(hud_hpbar, 0, 0, 0, _barra_hp_largura, sprite_get_height(hud_hpbar),
            _hpbar_x, _hpbar_y, 1, 1, c_white, 1);
    if (_barra_xp_largura > 0)
        draw_sprite_part_ext(hud_expbar, 0, 0, 0, _barra_xp_largura, sprite_get_height(hud_expbar),
            _expbar_x, _expbar_y, 1, 1, c_white, 1);

    draw_set_font(Pokemon);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_color(c_black);
    var _hp_percentual = (_hp_maximo > 0)
        ? round(clamp(_hp_visivel / _hp_maximo, 0, 1) * 100)
        : 0;
    draw_text_transformed(_hpbar_x + (sprite_get_width(hud_hpbar) / 2),
        _hpbar_y + sprite_get_height(hud_hpbar) + 2,
        string(_hp_percentual) + "%",
        0.9, 0.9, 0);
    draw_set_halign(fa_left);

    var _sprite_efeito = -1;
    switch (_aliado.status)
    {
        case "queimadura": _sprite_efeito = hud_burn; break;
        case "congelamento": _sprite_efeito = hud_freeze; break;
        case "sono": _sprite_efeito = hud_sleep; break;
        case "envenenamento":
        case "intoxicacao": _sprite_efeito = hud_poison; break;
    }
    if (_sprite_efeito != -1)
        draw_sprite(_sprite_efeito, 0, 1184, 725);

    var _sprite_efeito_rival = -1;
    switch (_rival.status)
    {
        case "queimadura": _sprite_efeito_rival = hud_burn; break;
        case "congelamento": _sprite_efeito_rival = hud_freeze; break;
        case "sono": _sprite_efeito_rival = hud_sleep; break;
        case "envenenamento":
        case "intoxicacao": _sprite_efeito_rival = hud_poison; break;
    }
    if (_sprite_efeito_rival != -1)
        draw_sprite(_sprite_efeito_rival, 0, 70, 123);

    var _sprite_aliado = scr_batalha_sprite_pokemon_resolver(_aliado, true);
    var _sprite_rival = scr_batalha_sprite_pokemon_resolver(_rival, false);

    var _escala_aliado = 8.5;
    var _escala_rival   = 5;
    if (string_lower(string(_aliado.especie_id)) == "pidgeotto")
        _escala_aliado = 6;
    if (string_lower(string(_rival.especie_id)) == "pidgeotto")
        _escala_rival = 4;
    var _fps_animacao_pokemon = 12;
    var _posicao_aliado = scr_batalha_sprite_posicao_manual(_aliado.especie_id, true);
    var _posicao_rival = scr_batalha_sprite_posicao_manual(_rival.especie_id, false);

    if (_sprite_aliado != -1)
    {
        var _qtd_frames_aliado = sprite_get_number(_sprite_aliado);
        var _frame_aliado = (_qtd_frames_aliado > 1)
            ? floor((current_time / 1000) * _fps_animacao_pokemon) mod _qtd_frames_aliado
            : 0;
        draw_sprite_ext(_sprite_aliado, _frame_aliado, _posicao_aliado.x, _posicao_aliado.y, _escala_aliado, _escala_aliado, 0, c_white, 1);
    }
    if (_sprite_rival != -1)
    {
        var _qtd_frames_rival = sprite_get_number(_sprite_rival);
        var _frame_rival = (_qtd_frames_rival > 1)
            ? floor((current_time / 1000) * _fps_animacao_pokemon) mod _qtd_frames_rival
            : 0;
        draw_sprite_ext(_sprite_rival, _frame_rival, _posicao_rival.x, _posicao_rival.y, _escala_rival, _escala_rival, 0, c_white, 1);
    }

}

function scr_hud_batalha_desenhar(treinador_jogador, treinador_ia, turno)
{
    if (is_undefined(treinador_jogador) || is_undefined(treinador_ia))
    {
        return;
    }

    if (!variable_global_exists("hud_batalha_info_avancada"))
    {
        global.hud_batalha_info_avancada = false;
    }

    var _p1 = scr_get_monstro_ativo(treinador_jogador);
    var _p2 = scr_get_monstro_ativo(treinador_ia);
    var _hp_p1_vis = scr_hud_batalha_get_hp_visivel(_p1, "jogador");
    var _hp_p2_vis = scr_hud_batalha_get_hp_visivel(_p2, "inimigo");

    draw_set_font(Pokemon);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    var _gui_w = 1920;
    var _gui_h = 1280;

    var _turno_x = 24;
    var _turno_y = 24;
    var _turno_w = 200;
    var _turno_h = 48;

    var _enemy_x = 24;
    var _enemy_y = _turno_y + _turno_h + 14;
    var _enemy_w = 580;
    var _enemy_h = 150;

    var _player_w = 580;
    var _player_h = 150;
    var _player_x = 24;
    var _player_y = _gui_h - 24 - _player_h;

    var _painel_w = _gui_w - (_player_x + _player_w) - 40;
    var _painel_h = 150;
    var _painel_y = _gui_h - 24 - _painel_h;

    var _golpes_x = _player_x + _player_w + 16;

    draw_set_color(c_white);
    draw_rectangle_color(_turno_x, _turno_y, _turno_x + _turno_w, _turno_y + _turno_h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_turno_x, _turno_y, _turno_x + _turno_w, _turno_y + _turno_h, c_white, c_white, c_white, c_white, true);
    draw_set_valign(fa_middle);
    draw_text(_turno_x + 16, _turno_y + (_turno_h / 2), "TURNO " + string(turno));
    draw_set_valign(fa_top);

    scr_hud_batalha_desenhar_painel(_enemy_x, _enemy_y, _enemy_w, _enemy_h, "", _p2.nivel, _p2.nome, _hp_p2_vis, _p2.hp_max, _p2.status, c_black, _p2.habilidade, noone);
    scr_hud_batalha_desenhar_painel(_player_x, _player_y, _player_w, _player_h, "", _p1.nivel, _p1.nome, _hp_p1_vis, _p1.hp_max, _p1.status, c_black, _p1.habilidade, _p1);

    if (global.hud_batalha_info_avancada)
    {
        scr_hud_batalha_desenhar_info_avancada(treinador_jogador, treinador_ia, turno);
    }

    if (global.hud_batalha_menu_estado == "derrota")
    {
        var _derrota_x = 520;
        var _derrota_y = 430;
        var _derrota_w = 880;
        var _derrota_h = 260;
        draw_set_color(c_black);
        draw_rectangle_color(_derrota_x, _derrota_y, _derrota_x + _derrota_w, _derrota_y + _derrota_h, c_black, c_black, c_black, c_black, false);
        draw_rectangle_color(_derrota_x, _derrota_y, _derrota_x + _derrota_w, _derrota_y + _derrota_h, c_white, c_white, c_white, c_white, true);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        draw_set_color(c_white);
        draw_text(_derrota_x + _derrota_w * 0.5, _derrota_y + 82, "VOCE FOI DERROTADO");
        draw_text(_derrota_x + _derrota_w * 0.5, _derrota_y + 148, "Pressione ENTER para voltar ao mundo");
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        return;
    }

    if (global.hud_batalha_dialogo_texto != "" || array_length(global.hud_batalha_dialogo_fila) > 0)
    {
        scr_hud_batalha_desenhar_dialogo();
        return;
    }

    if (!variable_global_exists("hud_batalha_menu_estado"))
    {
        global.hud_batalha_menu_estado = "menu";
    }

    if (!variable_global_exists("hud_batalha_menu_index"))
    {
        global.hud_batalha_menu_index = 0;
    }

    if (!variable_global_exists("hud_batalha_pokemon_index"))
    {
        global.hud_batalha_pokemon_index = 0;
    }

    if (global.hud_batalha_menu_estado == "menu")
    {
        scr_hud_batalha_desenhar_menu_central(global.hud_batalha_menu_index);
        return;
    }

    if (global.hud_batalha_menu_estado == "pokemon")
    {
        scr_hud_batalha_desenhar_menu_pokemon(treinador_jogador);
        return;
    }

    if (global.hud_batalha_menu_estado == "pokemon_opcoes")
    {
        scr_hud_batalha_desenhar_menu_pokemon(treinador_jogador);
        scr_hud_batalha_desenhar_opcoes_pokemon(treinador_jogador);
        return;
    }

    if (global.hud_batalha_menu_estado == "pokemon_sumario")
    {
        scr_hud_batalha_desenhar_sumario_pokemon(treinador_jogador);
        return;
    }

    if (global.hud_batalha_menu_estado == "bag")
    {
        scr_menu_bag_batalha_desenhar();
        return;
    }

    if (global.hud_batalha_menu_estado != "fight")
    {
        scr_hud_batalha_desenhar_submenu(global.hud_batalha_menu_estado);
        return;
    }

    var _linha_lista = 58;
    var _ataque_h = 48;
    var _golpes_w = _painel_w - 348;
    var _detalhes_w = _painel_w - _golpes_w - 8;
    var _detalhes_x = _golpes_x + _golpes_w + 8;

    // Layout inspirado na tela clássica de seleção: golpes em grade e
    // informações do golpe selecionado em um painel separado.
    draw_set_color(c_white);
    draw_rectangle_color(_golpes_x, _painel_y, _golpes_x + _golpes_w, _painel_y + _painel_h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_golpes_x, _painel_y, _golpes_x + _golpes_w, _painel_y + _painel_h, c_white, c_white, c_white, c_white, true);

    var _qtd_movimentos = min(array_length(_p1.movimentos), 4);
    var _movimento_info = undefined;
    var _movimento_selecionado = clamp(global.hud_batalha_golpe_index, 0, max(0, _qtd_movimentos - 1));
    for (var _i = 0; _i < _qtd_movimentos; _i++)
    {
        var _mov_inst = _p1.movimentos[_i];
        var _mov_dados = global.movimentos[$ _mov_inst.movimento_id];
        var _coluna = _i mod 2;
        var _linha = floor(_i / 2);
        var _mov_x = _golpes_x + 18 + (_coluna * (_golpes_w * 0.5));
        var _mov_y = _painel_y + 14 + (_linha * _linha_lista);

        if (_i == _movimento_selecionado)
        {
            draw_set_color(c_white);
            draw_rectangle_color(_mov_x - 8, _mov_y - 6, _mov_x + (_golpes_w * 0.5) - 12, _mov_y + _ataque_h,
                c_white, c_white, c_white, c_white, false);
            draw_set_color(c_black);
        }

        draw_text(_mov_x, _mov_y, _mov_dados.nome);
        draw_set_halign(fa_right);
        draw_text(_mov_x + (_golpes_w * 0.5) - 18, _mov_y, string(_mov_inst.pp_atual) + "/" + string(_mov_dados.pp_max));
        draw_set_halign(fa_left);
        draw_set_color(c_white);

        if (_i == _movimento_selecionado) _movimento_info = { dados: _mov_dados, instancia: _mov_inst };
    }

    draw_rectangle_color(_detalhes_x, _painel_y, _detalhes_x + _detalhes_w, _painel_y + _painel_h, c_black, c_black, c_black, c_black, false);
    draw_rectangle_color(_detalhes_x, _painel_y, _detalhes_x + _detalhes_w, _painel_y + _painel_h, c_white, c_white, c_white, c_white, true);
    draw_text(_detalhes_x + 18, _painel_y + 22, "PP");

    if (!is_undefined(_movimento_info))
    {
        var _detalhe_mov = _movimento_info.dados;
        var _detalhe_inst = _movimento_info.instancia;
        draw_set_halign(fa_right);
        draw_text(_detalhes_x + _detalhes_w - 18, _painel_y + 22,
            string(_detalhe_inst.pp_atual) + "/" + string(_detalhe_mov.pp_max));
        draw_set_halign(fa_left);
        draw_text(_detalhes_x + 18, _painel_y + 112, "TYPE/" + string_upper(_detalhe_mov.tipo));
    }

    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}