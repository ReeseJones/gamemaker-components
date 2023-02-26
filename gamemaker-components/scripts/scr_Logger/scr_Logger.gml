enum LOG_LEVEL {
    URGENT = 0,
    IMPORTANT = 1,
    INFORMATIONAL = 2,
    DETAILED = 3,
    SHOW_ALL
}

function LoggingService() constructor {
    // Feather disable GM2017
    logLevel = LOG_LEVEL.SHOW_ALL;
    // Feather restore GM2017
 
    ///@param {Real} _level
    static log = function(_level) {
        var _message = "";
        for(var i = 1; i < argument_count; i += 1) {
            _message += string(argument[i]);
        }

        if(_level <= logLevel) {
            show_debug_message(_message);
        }
    }
    
    static logWarning = function(_level) {
        COPY_PARAMS;
        array_insert(_params, 1, "Warning: ");
        method_call(log, _params);
    }
    
    static logError = function(_level) {
        COPY_PARAMS;
        array_insert(_params, 1, "Error: ");
        method_call(log, _params);
    }
}