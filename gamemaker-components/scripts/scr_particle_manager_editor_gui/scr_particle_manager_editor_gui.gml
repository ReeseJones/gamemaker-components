///@param {Struct.DebugViewManager} _debugViewManager
///@param {Struct.ParticleTypeManager} _particleManager
function ParticleManagerEditorGui(_debugViewManager, _particleManager) : DebugView() constructor {
    debugViewManager = _debugViewManager;
    particleTypeManager = _particleManager;
    
    var _currentParticles = particleTypeManager.getParticleNameArray();
    
    currentParticleName = _currentParticles[0];
    newParticleName = $"particle_{array_length(_currentParticles)}";

    static renderViewControls = function() {
        dbg_section("Select particle to edit", true);
        
        var _particleNames = particleTypeManager.getParticleNameArray();
        dbg_drop_down(ref_create(self, nameof(currentParticleName)), _particleNames, "Particle");

        var _buttonControl = dbg_button("Open", method(self, function() {
            show_debug_message("Opened pressed");
           
            var _particle = particleTypeManager.getParticle(currentParticleName);
            if(_particle == undefined) {
                show_message($"Particle with name {currentParticleName} does not exist.");
                return;
            }
            var _newParticleEditor = new ParticleTypeEditorGui(_particle);
            debugViewManager.manageView(currentParticleName, _newParticleEditor, true);
            
        }));

        dbg_text_separator("Create New Particle Type");

        dbg_text_input(ref_create(self, nameof(newParticleName)), "Particle Name");
        
        dbg_button("Create New", method(self, function() {
            show_debug_message($"Create new particle: {newParticleName}");

            if(newParticleName == "") {
                show_message($"Particle with no name is invalid");
                return;
            }

            if(string_length(newParticleName) < 3) {
                show_message($"Particle with name {newParticleName} is to short");
                return;
            }

            if(!particleTypeManager.particleExists(newParticleName)) {
                var _newParticle = particleTypeManager.createParticle(newParticleName);
                currentParticleName = newParticleName;
                needsReRender = true;
                var _currentParticles = particleTypeManager.getParticleNameArray();
                newParticleName = $"particle_{array_length(_currentParticles)}";
            } else {
                show_message($"Particle with name {newParticleName} already exists");
            }
        }));
    }
}