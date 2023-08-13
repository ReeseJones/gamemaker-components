event_inherited();

onMouseOver = function() {
    image_blend = c_red;
}

onMouseOut = function() {
    image_blend = c_white;
}

onClicked = function() {
    x = random(room_width);
    y = random(room_height);
}