event_make_event_node_like(id);

editorManager = new MechEditorManager();

node_append_child(root_get(), id);

//TODO Better target selection
mechEditTarget = obj_mech.id;
node_append_child(id, mechEditTarget);

componentCreationButtons = [];

var _components = global.mechComponentDataProvider.getComponents();
var _compCount = array_length(_components);


for(var i = 0; i < _compCount; i += 1) {
    var _compData = _components[i];

    var _newButton = instance_create_depth(room_width - 128, 64 + 100 * i, 0, obj_editor_drag_button, {
        sprite_index: _compData.spriteIndex,
        componentName: _compData.name
    });
    array_push(componentCreationButtons, _newButton);
    node_append_child(id, _newButton);

    event_add_listener(_newButton, EVENT_MOUSE_OVER, method(_newButton, function() {
        image_blend = c_red;
    }));

    event_add_listener(_newButton, EVENT_MOUSE_OUT, method(_newButton, function() {
        image_blend = c_white;
    }));
}

event_add_listener(root_get(), EVENT_CLICKED, method(id, function(_event) {
    if(_event.target == root_get()) {
        if(editorManager.isPlacingComponent()) {
            editorManager.endPlacingComponent(obj_mech.id, editorManager.component);
        }
        return;
    }

    if(_event.target.object_index == obj_editor_drag_button) {
        if(!editorManager.isPlacingComponent()) {
            var _compName = _event.target.componentName;
            var _newComponent = global.mechComponentFactory.createComponent(_compName);
            node_append_child(mechEditTarget, _newComponent);
            editorManager.beginPlacingComponent(obj_mech.id, _newComponent);
        }
    } else if(_event.target.object_index == obj_mech_component) {
        if(!editorManager.isPlacingComponent()) {
            editorManager.beginPlacingComponent(obj_mech.id, _event.target);
        } else if(editorManager.component == _event.target) {
            editorManager.endPlacingComponent(obj_mech.id, editorManager.component);
        }
    }

}));