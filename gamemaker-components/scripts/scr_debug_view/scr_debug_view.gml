function DebugView() : Disposable() constructor {
    
    needsReRender = true;
    view = undefined;
    viewName = "";
    viewManager = undefined;
    shouldClose = false;
    initialViewSettings = {
        x: undefined,
        y: undefined,
        width: undefined,
        height: undefined
    }
    
    static update = function() {
        
    }
    
    static renderViewControls = function() {
        dbg_text("Default Debug View");
    }
    
    ///@desc Closes the debug view
    static close = function() {
        shouldClose = true;
    }
}