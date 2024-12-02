
struct_save_static(nameof(Vec2), Vec2);
function Vec2(_x = 0, _y = 0) constructor {
    x = _x;
    y = _y;

    static toString = function() {
        return $"({x}, {y})";
    }
    static Zero = new Vec2(0,0);
}

struct_save_static(nameof(Vec3), Vec3);
function Vec3(_x = 0, _y = 0, _z = 0) : Vec2(_x, _y) constructor {
    z = _z;
    
    static toString = function() {
        return $"({x}, {y}, {z})";
    }
    static Zero = new Vec3(0,0,0);
}