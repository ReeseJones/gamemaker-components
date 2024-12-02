///@param {Struct.ParticleTypeManager} _particleManager
function ParticleTypeEditorGui(_particleManager) : Disposable() constructor {
    particleTypeManager = _particleManager;
    view = dbg_view("ParticleTypeEditorGui", false, 0, 0, 600, 750);
    currentKnownParticles = particleTypeManager.getAllParticles();
    model = currentKnownParticles[0];

    modelRefs = ref_create_all(self, "model");

    partPropSection = dbg_section("Particle Properties", true);

    var _shapesString = "Use sprite:-1," + array_join(global.particleShapes, ",");

    dbg_button("Apply", method(self, function() {
        show_debug_message($"Pressed Apply button");
        part_type_apply_properties(model);
    }));
    dbg_same_line();
    dbg_button("Apply & Close", function() {
        show_debug_message($"Pressed Apply & Close button");
    });
    dbg_same_line();
    dbg_button("Close", function() {
        show_debug_message($"Pressed Close button");
    });
    
    dbg_watch(modelRefs.property.ind, "Particle ID");
    dbg_watch(modelRefs.property.name, "Particle Name");
    dbg_text_separator("Texture");
    dbg_drop_down(modelRefs.property.shape, _shapesString, "Particle Shape");
    dbg_text_input(modelRefs.property.sprite, "Sprite", "f");
    dbg_text_input(modelRefs.property.frame, "Subimage", "f");
    dbg_checkbox(modelRefs.property.animate, "Animate");
    dbg_checkbox(modelRefs.property.stretch, "Stretch frames to lifetime");
    dbg_checkbox(modelRefs.property.random, "Use random subimage");
    dbg_checkbox(modelRefs.property.additive, "Additive blendmode");
    
    dbg_text_separator("Color");
    dbg_color(modelRefs.property.color1, "Color 1");
    dbg_color(modelRefs.property.color2, "Color 2");
    dbg_color(modelRefs.property.color3, "Color 3");
    dbg_slider(modelRefs.property.alpha1, 0, 1, "Alpha 1");
    dbg_slider(modelRefs.property.alpha2, 0, 1, "Alpha 2");
    dbg_slider(modelRefs.property.alpha3, 0, 1, "Alpha 3");
    
    dbg_text_separator("Image Angle");
    dbg_text_input(modelRefs.property.ang_incr, $"Increment", "f");
    dbg_text_input(modelRefs.property.ang_wiggle, $"Wiggle", "f");
    dbg_slider_int(modelRefs.property.ang_min, -180, 180, $"Angle min");
    dbg_slider_int(modelRefs.property.ang_max, -180, 180, $"Angle max");
    dbg_checkbox(modelRefs.property.ang_relative, "Relative to direction");

    dbg_text_separator("Size");
    dbg_text_input(modelRefs.property.size_xmin, "X min", "f");
    dbg_text_input(modelRefs.property.size_xmax, "X max", "f");
    dbg_text_input(modelRefs.property.size_xincr, "X increment", "f");
    dbg_text_input(modelRefs.property.size_xwiggle, "X wiggle", "f");

    dbg_text_input(modelRefs.property.size_ymin, "Y min", "f");
    dbg_text_input(modelRefs.property.size_ymax, "Y max", "f");
    dbg_text_input(modelRefs.property.size_yincr, "Y increment", "f");
    dbg_text_input(modelRefs.property.size_ywiggle, "Y wiggle", "f");
    
    dbg_text_separator("Scale");
    dbg_text_input(modelRefs.property.xscale, "Scale X", "f");
    dbg_text_input(modelRefs.property.yscale, "Scale Y", "f");
    
    dbg_text_separator("Life time in frames");
    dbg_text_input(modelRefs.property.life_min, "Life min", "f");
    dbg_text_input(modelRefs.property.life_max, "Life max", "f");
    
    dbg_text_separator("Particle Spawning");
    dbg_text_input(modelRefs.property.death_type, "On Death Type", "f");
    dbg_text_input(modelRefs.property.death_number, "On Death Count", "f");
    dbg_text_input(modelRefs.property.step_type, "On Step Type", "f");
    dbg_text_input(modelRefs.property.step_number, "On Step Count", "f");
    
    dbg_text_separator("Speed");
    dbg_text_input(modelRefs.property.speed_min, "Speed min", "f");
    dbg_text_input(modelRefs.property.speed_max, "Speed max", "f");
    dbg_text_input(modelRefs.property.speed_incr, "Speed increment", "f");
    dbg_text_input(modelRefs.property.speed_wiggle, "Speed wiggle", "f");
    
    dbg_text_separator("Direction");
    dbg_text_input(modelRefs.property.dir_incr, $"Direction increment", "f");
    dbg_text_input(modelRefs.property.dir_wiggle, $"Direction wiggle", "f");
    dbg_slider_int(modelRefs.property.dir_min, -180, 180, $"Direction min");
    dbg_slider_int(modelRefs.property.dir_max, -180, 180, $"Direction max");
    
    dbg_text_separator("Gravity");
    dbg_text_input(modelRefs.property.grav_amount, "Acceleration", "f");
    dbg_slider_int(modelRefs.property.grav_dir, -180, 180, $"Direction");
    
    static updateControls = function() {
        
    }


    static disposeFunc = function() {
        if(dbg_view_exists(view)) {
            dbg_view_delete(view);
            view = undefined;
            isDisposed = true;
        }
    }

}