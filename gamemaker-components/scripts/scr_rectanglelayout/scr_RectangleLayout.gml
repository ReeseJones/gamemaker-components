/// @param {struct.Entity} _entity A reference to which thing this component is bound to.
function RectangleLayout(_entity) : Component(_entity) constructor {
    // Feather disable GM2017
    top = 0;
    left = 0;
    bottom = 0;
    right = 0;
    // Feather restore GM2017
}

/// @param {Struct.World} _world The world which this System operates in.
function RectangleLayoutSystem(_world) : ComponentSystem(_world) constructor {
    static componentConstructor = RectangleLayout;
    static componentName = string_lowercase_first(script_get_name(componentConstructor));

    ///@param {Struct.RectangleLayout} _rectLayout
    ///@param {Real} _dt
    static endStep = function(_rectLayout, _dt) {
        var _entity = _rectLayout.entityRef;
        var _rectSizing = _entity.component.rectangleSizing;
        var _entityTree = _entity.component.entityTree;
        if(!_entityTree || !_rectSizing) {
            return;
        }

        if(!_entityTree.parent) {
            return;
        }
        var _parent = world.getRef(_entityTree.parent);
        if(is_undefined(_parent)) {
            return;
        }
        var _parentRectSizing = _parent.component.rectangleSizing;
        if(is_undefined(_parentRectSizing)) {
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
