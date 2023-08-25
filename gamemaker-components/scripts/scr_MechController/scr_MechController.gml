/// @function MechController(_mechObj)
/// @param {Id.Instance}   _mechObj
function MechController(_mechObj) constructor {
    mech = _mechObj;
    mode = MECH_CONTROL_MODE.EDIT;
    editorManager = new MechEditorManager();
    
    static update = function() {
        switch(mode) {
            case MECH_CONTROL_MODE.EDIT: {
                editorManager.update();
            }
        }
        
    }

}