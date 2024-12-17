///@param {Struct.LoggingService} _logger
function CommandLineParams(_logger, _flags = {}) constructor {
    paramsCount = parameter_count();
    launchParams = {};
    flags = _flags;
    logger = _logger;
    
    launchParams[$ "filepath"] = parameter_string(0);
    
    for(var i = 1; i < paramsCount; i += 1) {
        var _param = parameter_string(i);
        var _strLength =string_length(_param);
        var _firstPos = string_pos("=",_param);
        
        //If there is an equal sign
        if(_firstPos > 0) {
            var _name = string_copy(_param, 1, _firstPos - 1);
            var _value = string_copy(_param, _firstPos + 1, _strLength - _firstPos);
            var _lowerValue = string_lower(_value);
            
            if( (string_starts_with(_value, "\"") || string_starts_with(_value, "'"))  && (string_ends_with(_value, "\"") || string_ends_with(_value, "'")) ) {
                //It is a string arg
                _value = string_copy(_value, 2, _strLength - 2);
            } else if(_lowerValue == "true") {
                //is bool arg
                _value = true;
            } else if(_lowerValue == "false") {
                //is bool arg
                _value = false;
            } else if(_lowerValue == "undefined") {
                //is undefined arg
                _value = undefined;
            } else if(string_length(string_digits(_value)) > 0)  {
                //is number arg
                try {
                    var _numVal = real(_value);
                    if(!is_nan(_numVal)) {
                        _value = _numVal;
                    }
                } catch(_error) {
                    
                }
            } else {
                logger.logWarning(LOG_LEVEL.INFORMATIONAL, $"cmd line param with name: {_name} was not parsed as a string, bool or number so leaving as {_value}");
            }
            
            launchParams[$ _name] = _value
            logger.log(LOG_LEVEL.INFORMATIONAL, $"cmd line param: {_name}={_value}");
            
        } else {
            //Just interpetting it as a flag
            logger.log(LOG_LEVEL.INFORMATIONAL, $"cmd line flag: {_param}=true");
            launchParams[$ _param] = true;
        }
    }
}