game = instance_create_layer(0,0, "instances", obj_game);

world = obj_game.gameManager.createWorld(0);
var _player = world.createEntity(7);
var _entityInst = world.addComponent(7, "entityInstance");

_entityInst.x = 300;
_entityInst.y = 300;
_entityInst.objectIndex = obj_player;
_entityInst.maskIndex = spr_mask_circle
_entityInst.spriteIndex = spr_circle;

world.system.entityInstance.setObject(7, obj_player, "instances");