function scr_jogador_escolher_acao(treinador_jogador)
{
    // Teclas 1 a 4 -> Usar Golpes
    if (keyboard_check_pressed(ord("1"))) return { tipo: "atacar", indice: 0 };
    if (keyboard_check_pressed(ord("2"))) return { tipo: "atacar", indice: 1 };
    if (keyboard_check_pressed(ord("3"))) return { tipo: "atacar", indice: 2 };
    if (keyboard_check_pressed(ord("4"))) return { tipo: "atacar", indice: 3 };

    // Teclas 5 a 9 -> Trocar de Pokémon 
    var _teclas = [ord("5"), ord("6"), ord("7"), ord("8"), ord("9")];

    for (var _i = 0; _i < array_length(treinador_jogador.monstros); _i++)
    {
        // Pula o Pokémon que já está em campo 
        if (_i == treinador_jogador.indice_ativo) continue;

        // Associa a escolha do Pokémon de índice _i à sua respectiva tecla
        if (_i < array_length(_teclas) && keyboard_check_pressed(_teclas[_i]))
        {
            var _alvo_troca = treinador_jogador.monstros[_i];

            // Só permite se o Pokémon de destino NÃO estiver desmaiado
            if (!_alvo_troca.esta_desmaiado)
            {
                return { tipo: "trocar", novo_indice: _i };
            }
        }
    }

    return { tipo: "nenhum" };
}

function scr_escolha_aleatoria_ponderada(array_indices, array_pesos)
{
    var _soma = 0;
    for (var _i = 0; _i < array_length(array_pesos); _i++)
    {
        _soma += array_pesos[_i];
    }

    var _valor_sorteado = random(_soma);
    var _acumulado = 0;

    for (var _i = 0; _i < array_length(array_pesos); _i++)
    {
        _acumulado += array_pesos[_i];
        if (_valor_sorteado <= _acumulado)
        {
            return array_indices[_i];
        }
    }

    return array_indices[array_length(array_indices) - 1];
}

function scr_get_multiplicador_estagio(estagio)
{
    estagio = clamp(estagio, -6, 6);
    return (estagio >= 0) ? ((2 + estagio) / 2) : (2 / (2 - estagio));
}

function scr_get_stat_efetivo(monstro, stat_nome)
{
    var _base = monstro[$ stat_nome];
    var _estagio = monstro.estagios[$ stat_nome];
    var _mult = scr_get_multiplicador_estagio(_estagio);
    return floor(_base * _mult);
}

function scr_iniciar_batalha(equipe_ia_ids, nivel_ia, id_treinador)
{
    treinador_jogador = global.equipe_jogador;
    treinador_ia = scr_criar_equipe(equipe_ia_ids, nivel_ia);
    treinador_atual_id = id_treinador; // guarda quem chamou, pra avisar quando a batalha acabar

    teste_turno = 1;
    teste_batalha_acabou = false;
    pendente_substituicao = false;
    movimento_pendente_id = "";
    monstro_pendente = undefined;

    global.em_batalha = true;

    show_debug_message("");
    show_debug_message("=============================================");
    show_debug_message("           UM TREINADOR TE DESAFIOU!          ");
    show_debug_message("=============================================");
    scr_exibir_turno_equipe(teste_turno, treinador_jogador, treinador_ia);
}