///@param {Struct.Entity} _entity
function DebugTools(_entity) : Component(_entity) constructor
{
    static staticIntialization();

    timer = 0;
}

function DebugToolsSystem() : ComponentSystem() constructor {
    static componentConstructor = DebugTools;
    static staticIntialization();
    
    static systemStart = function() {
        
    }
    
    static systemCleanup = function() {
        
    }
    
    static systemStep = function(_dt) {
        if(mouse_check_button(mb_left)) {
            //var _wallInst = world.entity.InstanceCreateLayer(obj_solid_static, mouse_x, mouse_y, "Instances");
        }
        
        if(mouse_check_button(mb_right)) {
            //var _playerInst = world.entity.InstanceCreateLayer(obj_solid_dynamic, 900, 540, "Instances");
            // world.entity.addComponent(_playerInst, KinematicMovement);
            //world.kinematicMovement.SetDirectionAngle(_playerInst, 45);
            //world.kinematicMovement.SetSpeed(_playerInst, 20);
        }
    }
    
}