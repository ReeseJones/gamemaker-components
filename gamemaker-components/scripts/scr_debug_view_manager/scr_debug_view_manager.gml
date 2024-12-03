///@param {Pointer} _viewPointer
///@param {Any} _viewOwner A reference to the thing that determines the life of the view.
function DebugViewEntry(_viewPointer, _viewOwner) constructor {
    viewPointer = _viewPointer;
    viewOwner = _viewOwner;
}

function DebugViewManager() : Disposable() constructor {
    
    views = [];
    
    ///@param {string} _viewName
    ///@param {Struct.DebugView} _debugView
    ///@param {bool} _visible
    ///@param {real} _x
    ///@param {real} _y
    ///@param {real} _width
    ///@param {real} _height
    static manageView = function(_viewName, _debugView, _visible = false, _x = undefined, _y = undefined, _width = undefined, _height = undefined ) {
        _debugView.viewName = _viewName;
        _debugView.viewManager = self;
        _debugView.initialViewSettings.x = _x;
        _debugView.initialViewSettings.y = _y;
        _debugView.initialViewSettings.width = _width;
        _debugView.initialViewSettings.height = _height;
        
        array_push(views, _debugView);
        
        rerenderView(_debugView, _visible);
        
    }

    ///@param {Struct.DebugView} _debugView
    static deleteView = function(_debugView) {
        
        if(dbg_view_exists(_debugView.view)) {
            dbg_view_delete(_debugView.view);
            _debugView.view = undefined;
        }
        
        _debugView.initialViewSettings = undefined;
        _debugView.needsReRender = false;
        _debugView.viewManager = undefined;
        _debugView.disposeFunc();
    }
    
    static update = function() {
        for(var i = array_length(views) - 1; i >= 0; i -= 1) {
            var _view = views[i];

            _view.update();
            
            if(_view.needsReRender) {
                rerenderView(_view, true);
            }
            
            if(_view.shouldClose) {
                deleteView( _view);
                array_delete(views, i, 1);
            }
            
        }
    }
    
    ///@desc iternal only
    ///@param {Struct.DebugView} _debugView
    ///@param {bool} _visible
    static rerenderView = function(_debugView, _visible) {
        _debugView.needsReRender = false;
        
        if(dbg_view_exists(_debugView.view)) {
            dbg_view_delete(_debugView.view);
        }

        _debugView.view = dbg_view(
            _debugView.viewName,
            true,
            _debugView.initialViewSettings.x,
            _debugView.initialViewSettings.y,
            _debugView.initialViewSettings.width,
            _debugView.initialViewSettings.height
        );
        _debugView.renderViewControls();

    }
    
    ///@param {Struct.DebugView} _debugView
    static viewExists = function(_debugView) {
        return array_contains(views, _debugView);
    }
    
    static disposeFunc = function() {
        array_foreach(views, method(self, function(_view) {
            deleteView(_view);
        }));
        views = [];
        
        isDisposed = true;
    }

}