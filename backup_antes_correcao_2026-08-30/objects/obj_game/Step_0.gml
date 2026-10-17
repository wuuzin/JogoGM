if (!global.em_batalha) exit; // só processa batalha quando uma está ativa

// ATALHOS DE TESTE DE CLIMA/TERRENO/STATUS (mantidos pra debug durante o desenvolvimento)
if (keyboard_check_pressed(ord("C")))
{
    if (global.campo.clima == "nenhum") scr_definir_clima("sol", 5);
    else if (global.campo.clima == "sol") scr_definir_clima("chuva", 5);
    else if (global.campo.clima == "chuva") scr_definir_clima("tempestade_areia", 5);
    else if (global.campo.clima == "tempestade_areia") scr_definir_clima("neve", 5);
    else scr_definir_clima("nenhum", 0);

    show_debug_message(">> [TESTE] Clima alterado para: " + string_upper(global.campo.clima));
    scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
}

if (keyboard_check_pressed(ord("K")))
{
    if (global.campo.terreno == "nenhum") scr_definir_terreno("eletrico", 5);
    else if (global.campo.terreno == "eletrico") scr_definir_terreno("herbaceo", 5);
    else if (global.campo.terreno == "herbaceo") scr_definir_terreno("psiquico", 5);
    else if (global.campo.terreno == "psiquico") scr_definir_terreno("nebuloso", 5);
    else scr_definir_terreno("nenhum", 0);

    show_debug_message(">> [TESTE] Terreno alterado para: " + string_upper(global.campo.terreno));
    scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
}

// ESTADO: PENDENTE DE SUBSTITUIÇÃO DE GOLPE
if (pendente_substituicao)
{
    var _slot_escolhido = -1;
    if (keyboard_check_pressed(vk_f1)) _slot_escolhido = 0;
    if (keyboard_check_pressed(vk_f2)) _slot_escolhido = 1;
    if (keyboard_check_pressed(vk_f3)) _slot_escolhido = 2;
    if (keyboard_check_pressed(vk_f4)) _slot_escolhido = 3;

    if (_slot_escolhido != -1)
    {
        var _res = scr_aprender_movimento(monstro_pendente, movimento_pendente_id, _slot_escolhido);
        show_debug_message(">> " + monstro_pendente.nome + " esqueceu " + global.movimentos[$ _res.antigo_id].nome + " e aprendeu " + global.movimentos[$ movimento_pendente_id].nome + "!");
        pendente_substituicao = false;

        if (!teste_batalha_acabou) scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
    }
    else if (keyboard_check_pressed(vk_escape))
    {
        show_debug_message(">> " + monstro_pendente.nome + " não aprendeu " + global.movimentos[$ movimento_pendente_id].nome + ".");
        pendente_substituicao = false;

        if (!teste_batalha_acabou) scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
    }
    exit;
}

// LOOP DA BATALHA
if (!teste_batalha_acabou)
{
    var _acao = scr_jogador_escolher_acao(treinador_jogador);

    if (_acao.tipo != "nenhum")
    {
        var _log = scr_resolver_turno_equipe(treinador_jogador, treinador_ia, _acao);
        scr_exibir_log_turno_equipe(_log);

        var _p1_ativo = scr_get_monstro_ativo(treinador_jogador);

        for (var _l = 0; _l < array_length(_log); _l++)
        {
            var _item = _log[_l];
            if (variable_struct_exists(_item, "novos_movimentos") && array_length(_item.novos_movimentos) > 0)
            {
                for (var _m = 0; _m < array_length(_item.novos_movimentos); _m++)
                {
                    var _novo_id = _item.novos_movimentos[_m];
                    if (scr_pokemon_tem_movimento(_p1_ativo, _novo_id)) continue;

                    var _nome_golpe = global.movimentos[$ _novo_id].nome;

                    if (array_length(_p1_ativo.movimentos) < 4)
                    {
                        scr_aprender_movimento(_p1_ativo, _novo_id);
                        show_debug_message(">> " + _p1_ativo.nome + " aprendeu " + _nome_golpe + "!");
                    }
                    else
                    {
                        pendente_substituicao = true;
                        movimento_pendente_id = _novo_id;
                        monstro_pendente = _p1_ativo;

                        show_debug_message("");
                        show_debug_message("==================================================");
                        show_debug_message(_p1_ativo.nome + " quer aprender " + _nome_golpe + "!");
                        show_debug_message("Pressione F1-F4 para substituir ou ESC para cancelar.");
                        show_debug_message("==================================================");
                    }
                }
            }
        }

        // Checagem de Fim de Batalha
        if (!scr_equipe_tem_vivos(treinador_ia))
        {
            teste_batalha_acabou = true;
            global.em_batalha = false;

            if (instance_exists(treinador_atual_id))
            {
                with (treinador_atual_id) { ja_derrotado = true; }
            }

            show_debug_message("");
            show_debug_message("=============================================");
            show_debug_message("   VITÓRIA! O treinador adversário perdeu!   ");
            show_debug_message("=============================================");
        }
        else if (!scr_equipe_tem_vivos(treinador_jogador))
        {
            teste_batalha_acabou = true;
            global.em_batalha = false;

            show_debug_message("");
            show_debug_message("=============================================");
            show_debug_message("   DERROTA! Todos os seus Pokémon desmaiaram.");
            show_debug_message("=============================================");
        }
        else if (!pendente_substituicao)
        {
            teste_turno += 1;
            scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
        }
    }
}