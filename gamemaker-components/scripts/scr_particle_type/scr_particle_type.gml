struct_save_static(nameof(ParticleType), ParticleType);
///@param {Id.ParticleType} _index
///@param {string} _name
function ParticleType(_index = -1, _name = "") constructor {
    ind = _index;
    name = _name;
    sprite = -1;
    frame = 0;
    animate = false;
    stretch = false;
    self.random = false;
    shape = pt_shape_pixel;
    size_xmin = 1;
    size_ymin = 1;
    size_xmax = 2;
    size_ymax = 2;
    size_xincr = 0;
    size_yincr = 0;
    size_xwiggle = 0;
    size_ywiggle = 0;
    xscale = 1;
    yscale = 1;
    life_min = 10
    life_max = 15;
    death_type = -1;
    death_number = 0;
    step_type = -1;
    step_number = 0;
    speed_min = 0;
    speed_max = 5;
    speed_incr = 0;
    speed_wiggle = 0;
    dir_min = -180;
    dir_max = 180;
    dir_incr = 0;
    dir_wiggle = 0;
    grav_amount = 0;
    grav_dir = 0;
    ang_min = -180;
    ang_max = 180;
    ang_incr = 0;
    ang_wiggle = 0;
    ang_relative = true;
    color1 = c_white;
    color2 = c_white;
    color3 = c_white;
    alpha1 = 1;
    alpha2 = 1;
    alpha3 = 1;
    additive = true;
    
    static isUsingSprite = function() {
        return sprite >= 0 && sprite_exists(sprite);
    }
    
    static isUsingShape = function() {
        return shape > -1 && shape < 15;
    }
    
    static emitsOnStep = function() {
        return step_type != 1 && step_number > 0 && part_type_exists(step_type);
    }
    
    static emitsOnDeath = function() {
        return death_type != 1 && death_number > 0 && part_type_exists(death_type);
    }
    
    static applyProperties = function() {
        if(!part_type_exists(ind)) {
            throw $"Cannot apply properties to particle with index: {ind}. Particle doesnt exist";
        } 
        
        if(isUsingSprite()) {
            part_type_sprite(ind, sprite, animate, stretch, self.random);
            part_type_subimage(ind, frame);
        } else if (isUsingShape()) {
            part_type_shape(ind, shape);
        } else {
            shape = pt_shape_pixel;
            part_type_shape(ind, shape);
        }
        
        part_type_size_x(ind, size_xmin, size_xmax, size_xincr, size_xwiggle);
        part_type_size_y(ind, size_ymin, size_ymax, size_yincr, size_ywiggle);

        part_type_scale(ind, xscale, yscale);

        part_type_life(ind, life_min, life_max);

        if(emitsOnDeath()) {
            part_type_death(ind, death_number, death_type);
        } else {
            part_type_death(ind, 0, -1);
        }
        
        if(emitsOnStep()) {
            part_type_step(ind, step_number, step_type);
        } else {
            part_type_step(ind, 0, -1);
        }
        
        part_type_speed(ind, speed_min, speed_max, speed_incr, speed_wiggle);
        part_type_direction(ind, dir_min, dir_max, dir_incr, dir_wiggle);
        part_type_gravity(ind, grav_amount, grav_dir);
        part_type_orientation(ind, ang_min, ang_max, ang_incr, ang_wiggle, ang_relative);

        part_type_color3(ind, color1, color2, color3);
        part_type_alpha3(ind, alpha1, alpha2, alpha3);
    }
}