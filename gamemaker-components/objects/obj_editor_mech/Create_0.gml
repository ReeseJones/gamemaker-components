// 256 / 16 = 16 cells

gridPixelSize = 16;
componentLayoutGrid = ds_grid_create(32, 32);
depth = 12;

sock1 = new MechSocket();

comp1 = new MechComponent(2, 3, [sock1]);
comp1.position.x = 4;
comp1.position.y = 1;

mechSystem = new MechSystem(16,9, [comp1]);
mechSystem.position.x = room_width / 2;
mechSystem.position.y = room_height / 2;