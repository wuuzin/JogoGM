if (variable_global_exists("em_batalha") && global.em_batalha) exit;

move_and_collide(spdh, spdv, all);
if (obj_grama_verificar_passo()) exit;
