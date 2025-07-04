// Base class for a game maker built in debug view. Extend this base class with custom debug views.
// Use in conjunction with the DebugViewManager. Custom debug views may in some cases need to rerender
// (such as when debug view controls change) or to update other static elements of a debug view.
// The debugViewManager will call the DebugView's disposeMethod to cleanup and resources when its closed.

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