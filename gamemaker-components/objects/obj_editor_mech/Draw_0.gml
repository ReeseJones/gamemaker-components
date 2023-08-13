var _col = draw_get_color();

var _offsetX = ds_grid_get_pixel_width(componentLayoutGrid, gridPixelSize) / 2;
var _offsetY = ds_grid_get_pixel_height(componentLayoutGrid, gridPixelSize) / 2;

draw_set_color(c_white);
ds_grid_draw(componentLayoutGrid, x - _offsetX, y - _offsetY, gridPixelSize);
draw_set_color(_col);