//Find: ^([a-zA-Z0-9]*),?$
//Replace: names[? EventType.$1] = "$1";

enum EventType {
	InstanceCreated,
	InstanceDestroyed,
	InstanceAddedComponent,
	InstanceRemovedComponent,
	ActionPauseGame,
	ActionMove,
	ActionShoot,
	ActionShootSecondary,
	ActionThrowGrenade,
	ActionJump,
	ActionUseEquipment,
	ActionToggleInventory,
	ActionNextWeapon,
	ActionPreviousWeapon,
	ActionCrouch,
	ActionLook,
	InputAny,
	GamepadConnected,
	GamepadDisconnected,
	WorldCreated,
}

global.EventTypeName = ds_map_create();

var names = global.EventTypeName;
ds_map_set(names, EventType.InstanceCreated, "InstanceCreated");
names[? EventType.InstanceDestroyed] = "InstanceDestroyed";
names[? EventType.InstanceAddedComponent] = "InstanceAddedComponent";
names[? EventType.InstanceRemovedComponent] = "InstanceRemovedComponent";
names[? EventType.ActionPauseGame] = "ActionPauseGame";
names[? EventType.ActionMove] = "ActionMove";
names[? EventType.ActionShoot] = "ActionShoot";
names[? EventType.ActionShootSecondary] = "ActionShootSecondary";
names[? EventType.ActionThrowGrenade] = "ActionThrowGrenade";
names[? EventType.ActionJump] = "ActionJump";
names[? EventType.ActionUseEquipment] = "ActionUseEquipment";
names[? EventType.ActionToggleInventory] = "ActionToggleInventory";
names[? EventType.ActionNextWeapon] = "ActionNextWeapon";
names[? EventType.ActionPreviousWeapon] = "ActionPreviousWeapon";
names[? EventType.ActionCrouch] = "ActionCrouch";
names[? EventType.ActionLook] = "ActionLook";
names[? EventType.InputAny] = "InputAny";
names[? EventType.GamepadConnected] = "GamepadConnected";
names[? EventType.GamepadDisconnected] = "GamepadDisconnected";


function EventName(_eventType) {
	return 	global.EventTypeName[?_eventType];
}