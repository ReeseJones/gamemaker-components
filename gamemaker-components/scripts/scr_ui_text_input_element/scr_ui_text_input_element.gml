///@param {Struct} _flexpanelStyle
function UITextInput(_flexpanelStyle): UIElement(_flexpanelStyle) constructor {
    cursorPosition = 1;
    textEnd = "";

    handleFocusChanged = method(self, function(_event) {
        if(_event.data.currentFocus != self) {
            updateTextInput();
            return;
        }
        
        var _textLength = string_length(textDescription.text);
        setCursorPosition(_textLength);
    });
    
    handleClick = method(self, function(_event) {
        show_debug_message($"Handling input click: {_event} data: {_event.data}");
    });

    event_add_listener(obj_game.id, EVENT_FOCUS_CHANGED, handleFocusChanged);
    event_add_listener(self, EVENT_CLICKED, handleClick);

    static updateTextInput = function () {
        textDescription.text = keyboard_string + textEnd;
    }

    static setCursorPosition = function(_position) {
        updateTextInput();
        var _textLength = string_length(textDescription.text);
        
        _position = clamp(_position, 0, _textLength);
        
        if(_position == 0 ) {
            keyboard_string = "";
            textEnd = textDescription.text;
        } else if(_position == _textLength ) {
            keyboard_string = textDescription.text;
            textEnd = "";
        } else {
            keyboard_string = string_copy(textDescription.text, 1, _position);
            textEnd = string_copy(textDescription.text, _position + 1, _textLength - _position);
        }
        show_debug_message($"cursor changed: {_position}, ks: {keyboard_string}, textEnd: {textEnd}");
    }

    static draw = function() {
        var _isFocused = obj_game.focus == self;
        var _text =  _isFocused ? keyboard_string + textEnd : textDescription.text;
        var _isString = is_string(_text);
        var _textWidth = _isString ? string_width(_text) : string_width("O");
        var _textHeight = _isString ? string_height(_text) : string_height("O");
        var _cursorHorizontalOffset = string_width(textEnd);
        
        var _col = c_white;
        var _alpha = 1;
        if(mouseIsOver && !_isFocused) {
            _col = merge_color(c_white, c_black, 0.2);
        }

        draw_sprite_stretched_ext(spriteIndex, 0, left, top, width, height, _col, _alpha);

        if(_isFocused) {
            draw_set_color(c_black);
            draw_rectangle(left, top, right, bottom, true);
        }

        var _xx = 0;
        var _yy = 0;
        var _xxAnchor = 0;
        var _yyAnchor = 0;

        switch(textDescription.halign) {
            case fa_right:
                _xx = right;
                _xxAnchor = right - _textWidth - _cursorHorizontalOffset;
            break;
            case fa_center:
                _xx = (left + right) / 2;
                _xxAnchor = _xx + (_textWidth/2) - _cursorHorizontalOffset;
                break;
            case fa_left:
            default:
                _xx = left;
                _xxAnchor = left + _textWidth - _cursorHorizontalOffset;
                break;
        }
        switch(textDescription.valign) {
            case fa_bottom:
                _yy = bottom;
                _yyAnchor = bottom - _textHeight;
            break;
            case fa_middle:
                _yy = (top + bottom) / 2;
                _yyAnchor = _yy - (_textHeight/2);
                break;
            case fa_top:
            default:
                _yy = top;
                _yyAnchor = top;
                break;
        }
        
        _xx = round(_xx);
        _yy = round(_yy);

        draw_set_color(mouseIsOver ? c_white : textDescription.color);
        draw_set_alpha(textDescription.alpha);
        draw_set_font(textDescription.font);
        draw_set_halign(textDescription.halign);
        draw_set_valign(textDescription.valign);

        if( _isString ) {
            draw_text_ext(_xx, _yy, _text, textDescription.lineSpacing, width);
        }

        if(_isFocused) {
            var _currentTimeInterval = get_timer() % 1_000_000;
            var _isBlinked = _currentTimeInterval < 500_000;
            if(_isBlinked) {
                draw_rectangle(_xxAnchor, _yyAnchor, _xxAnchor + 1, _yyAnchor + _textHeight, false);
            }
        }
    }
}