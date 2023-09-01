// 256 / 16 = 16 cells

depth = 12;

controlMode = MECH_CONTROL_MODE.EDIT;

mechController = new MechController(id);

mechSystem = new MechSystem(16,9);
mechSystem.position.x = room_width / 2;
mechSystem.position.y = room_height / 2;

mechComponentGrid = new MechComponentGrid(mechSystem.gridWidth, mechSystem.gridHeight);



//TODO: Currently insets a component for testing purposes
//array_push(mechSystem.components, _newComponent.component);

//mechController.editorManager.beginPlacingComponent(id, _newComponent);