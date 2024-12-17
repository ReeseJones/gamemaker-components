///@param {Struct.DfaState} _defaultEdge
///@param {bool} _acceptingToken
function DfaState(_defaultEdge = undefined, _acceptingToken = false) constructor {
    defaultEdge = _defaultEdge;
    acceptingToken = _acceptingToken;
    edges = {};
    
    ///@param {string} _character,
    ///@param {Struct.DfaState} _newEdge
    static addEdge = function(_character, _newEdge) {
        struct_set(edges, _character, _newEdge);
    }
    
    ///@param {Struct.DfaState} _defaultEdge
    static addDefaultEdge = function(_defaultEdge) {
        defaultEdge = _defaultEdge;
    }
    
    static getToken = function() {
        return acceptingToken;
    }
    
    ///@param {string} _c
    static findEdge = function(_c) {
        if(struct_exists(edges, _c)) {
            return struct_get(edges, _c);
        }
        
        return defaultEdge;
    }
}

///@param {real} _acceptingToken
function dfa_add_state(_acceptingToken) {
    return new DfaState(undefined, _acceptingToken);
}

///@param {Struct.DfaState} _from
///@param {Struct.DfaState} _to
///@param {string} _character
function dfa_add_edge(_from, _to, _character) {
    _from.addEdge(_character, _to);
}

///@param {Struct.DfaState} _from
///@param {Struct.DfaState} _to
function dfa_add_default_edge(_from, _to) {
    _from.addDefaultEdge(_to);
}

function dfa_add_edge_range(_charStart, _charEnd, _from, _to) {
    var _ordStart = ord(_charStart);
    var _ordEnd = ord(_charEnd);
    var _min = min(_ordStart, _ordEnd);
    var _max = max(_ordStart, _ordEnd);
    var _range = _max - _min;
    
    for(var i = 0; i <= _range; i += 1) {
        dfa_add_edge(_from, _to, chr(_min + i))
    }
}


///@param {Struct.DfaState} _startingState
///@param {string} _string
///@return {bool}
function dfa_read(_startingState, _string) {
    
    var _strLen = string_length(_string) + 1;
    var _currentState = _startingState;
    var _lastAcceptedPosition = undefined;
    var _lastAcceptedState = undefined;
    var _currentStringLocation = 1;
    
    for(; _currentStringLocation < _strLen; _currentStringLocation += 1) {
        var _currentChar = string_char_at(_string, _currentStringLocation);
        
        var _edge = _currentState.findEdge(_currentChar);
        
        if(is_undefined(_edge)) {
            break;
        } else {
            _currentState = _edge;
            
            if( _currentState.getToken()) {
                _lastAcceptedPosition = _currentStringLocation;
                _lastAcceptedState = _currentState;
            }
        }
    }
    
    return !is_undefined( _lastAcceptedPosition);
}