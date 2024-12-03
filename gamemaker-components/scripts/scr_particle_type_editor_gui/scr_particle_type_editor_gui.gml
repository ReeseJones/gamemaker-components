///@param {Struct.ParticleType} _particleType
function ParticleTypeEditorGui(_particleType) : DebugView() constructor {
    model = _particleType;
    modelRefs = ref_create_all(self, "model");
 
    spritePrev = undefined;
    shapePrev = undefined;
    
    static update = function() {
        if(spritePrev != model.sprite) {
            //spritePrev = model.sprite;
            //needsReRender = true;
        }
        
        if(shapePrev != model.shape) {
            //shapePrev = model.shape;
            //needsReRender = true;
        }
    }
    
    static renderViewControls = function() {
          var _shapesString = "Use sprite:-1," + array_join(global.particleShapes, ",");
          partManagementSection = dbg_section("Particle Management", true);
          
          dbg_button("Apply", method(self, function() {
              show_debug_message($"Pressed Apply button");
              model.applyProperties();
          }));
          dbg_same_line();
          dbg_button("Apply & Close", method(self, function() {
              model.applyProperties();
              close();
          }));
          dbg_same_line();
          dbg_button("Close", method(self, function() {
              show_debug_message($"Pressed Close button");
              close();
          }));
          
          dbg_watch(modelRefs.property.ind, "Particle ID");
          dbg_watch(modelRefs.property.name, "Particle Name");
          
          partTextureSection = dbg_section("Particle Texture", true);
      
          dbg_drop_down(modelRefs.property.shape, _shapesString, "Particle Shape");
          dbg_text_input(modelRefs.property.sprite, "Sprite", "f");
          dbg_text_input(modelRefs.property.frame, "Subimage", "f");
          dbg_checkbox(modelRefs.property.animate, "Animate");
          dbg_checkbox(modelRefs.property.stretch, "Stretch frames to lifetime");
          dbg_checkbox(modelRefs.property.random, "Use random subimage");
          dbg_checkbox(modelRefs.property.additive, "Additive blendmode");
          
          partColorSection = dbg_section("Color", true);
          
          dbg_color(modelRefs.property.color1, "Color 1");
          dbg_color(modelRefs.property.color2, "Color 2");
          dbg_color(modelRefs.property.color3, "Color 3");
          dbg_slider(modelRefs.property.alpha1, 0, 1, "Alpha 1");
          dbg_slider(modelRefs.property.alpha2, 0, 1, "Alpha 2");
          dbg_slider(modelRefs.property.alpha3, 0, 1, "Alpha 3");
          
          partImageAngleSection = dbg_section("Image Angle", true);
          dbg_text_input(modelRefs.property.ang_incr, $"Increment", "f");
          dbg_text_input(modelRefs.property.ang_wiggle, $"Wiggle", "f");
          dbg_slider_int(modelRefs.property.ang_min, -180, 180, $"Angle min");
          dbg_slider_int(modelRefs.property.ang_max, -180, 180, $"Angle max");
          dbg_checkbox(modelRefs.property.ang_relative, "Relative to direction");
      
          partSizeSection = dbg_section("Size", true);
          dbg_text_separator("X Size");
          dbg_text_input(modelRefs.property.size_xmin, "X min", "f");
          dbg_text_input(modelRefs.property.size_xmax, "X max", "f");
          dbg_text_input(modelRefs.property.size_xincr, "X increment", "f");
          dbg_text_input(modelRefs.property.size_xwiggle, "X wiggle", "f");
          dbg_text_separator("Y Size");
          dbg_text_input(modelRefs.property.size_ymin, "Y min", "f");
          dbg_text_input(modelRefs.property.size_ymax, "Y max", "f");
          dbg_text_input(modelRefs.property.size_yincr, "Y increment", "f");
          dbg_text_input(modelRefs.property.size_ywiggle, "Y wiggle", "f");
          
          partScaleSection = dbg_section("Scale", true);
          dbg_text_input(modelRefs.property.xscale, "Scale X", "f");
          dbg_text_input(modelRefs.property.yscale, "Scale Y", "f");
          
          partLifeSection = dbg_section("Life", true);
          dbg_text_separator("Life time in frames");
          dbg_text_input(modelRefs.property.life_min, "Life min", "f");
          dbg_text_input(modelRefs.property.life_max, "Life max", "f");
          
          partSpawningSection = dbg_section("Particle Spawning", true);
          dbg_text_input(modelRefs.property.death_type, "On Death Type", "f");
          dbg_text_input(modelRefs.property.death_number, "On Death Count", "f");
          dbg_text_input(modelRefs.property.step_type, "On Step Type", "f");
          dbg_text_input(modelRefs.property.step_number, "On Step Count", "f");
          
          partMovementSection = dbg_section("Movement", true);
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
    }

}