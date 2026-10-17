if (global.em_batalha || ja_derrotado) exit;

var _dist = point_distance(x, y, obj_player.x, obj_player.y);

if (_dist <= raio_interacao && keyboard_check_pressed(vk_space))
{
    show_debug_message(">> Tentando iniciar batalha...");

    with (obj_game)
    {
        show_debug_message(">> Instância obj_game encontrada, chamando scr_iniciar_batalha");
        scr_iniciar_batalha(other.equipe_ids, other.nivel_treinador, other.id);
    }
}
var _dist = point_distance(x, y, obj_player.x, obj_player.y);

if (_dist <= raio_interacao && keyboard_check_pressed(vk_space))
{
    with (obj_game)
    {
        scr_iniciar_batalha(other.equipe_ids, other.nivel_treinador, other.id);
    }
}