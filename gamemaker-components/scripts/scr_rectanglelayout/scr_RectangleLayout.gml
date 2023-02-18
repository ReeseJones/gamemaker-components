function RectangleLayout(_instance) : Component(_instance) constructor {
    // Feather disable GM2017
    top = 0;
    left = 0;
    bottom = 0;
    right = 0;
    // Feather restore GM2017
}

function RectangleLayoutSystem() : ComponentSystem() constructor {

    static endStep = function end_step(_rectLayout, _dt) {
        var _inst = _rectLayout.instance;
        var _rectSizing = _inst.components.rectangleSizing;
        var _entityTree = _inst.components._entityTree;
        if(!_entityTree || !_rectSizing) {
            return;
        }
        if(!_entityTree.parent) {
            return;
        }
        var _parent = entity.getRef(_entityTree.parent);
        if(!_parent) {
            return;
        }
        var _parentRectSizing = _parent.components.rectangleSizing;
        if(!_parentRectSizing) {
            return;
        }

        var _top = _parentRectSizing.y + (_rectLayout.top * _parentRectSizing.height);
        var _left = _parentRectSizing.x + (_rectLayout.left * _parentRectSizing.width);
        var _bottom = _parentRectSizing.y + _parentRectSizing.height - (_rectLayout.bottom * _parentRectSizing.height);
        var _right = _parentRectSizing.x + _parentRectSizing.width - (_rectLayout.right * _parentRectSizing.width);

        _rectSizing.x = _left;
        _rectSizing.y = _top;
        _rectSizing.width = _right - _left;
        _rectSizing.height = _bottom - _top;
    }

}
