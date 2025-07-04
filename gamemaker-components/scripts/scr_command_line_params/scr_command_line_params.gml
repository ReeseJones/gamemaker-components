function CmdLineParamsRetriever() constructor {
    ///@description Total count of parameters
    static count = function() {
        return parameter_count();
    }

    ///@description Get nth parameter passed to the program
    ///@param {real} _index
    static getParam = function(_index) {
        return parameter_string(_index);
    }
}

///@param {Array<string>} _params
function ManualCmdLineParamsRetriever(_params) : CmdLineParamsRetriever() constructor {
    params = _params;
    ///@description Total count of parameters
    static count = function() {
        return array_length(params);
    }

    ///@description Get nth parameter passed to the program
    ///@param {real} _index
    static getParam = function(_index) {
        return params[_index];
    }
}

///@param {Struct.LoggingService} _logger
///@param {Struct.CmdLineParamsRetriever} _cmdLineParamsRetriever
function CmdLineParamsParser(_logger, _cmdLineParamsRetriever) constructor {
    paramsCount = _cmdLineParamsRetriever.count();
    launchParams = {};
    logger = _logger;

    launchParams.filepath = _cmdLineParamsRetriever.getParam(0);

    for(var i = 1; i < paramsCount; i += 1) {
        var _param = _cmdLineParamsRetriever.getParam(i);
        var _strLength = string_length(_param);
        var _firstPos = string_pos("=",_param);
        
        //If there is an equal sign
        if(_firstPos > 0) {
            var _name = string_copy(_param, 1, _firstPos - 1);
            var _value = string_copy(_param, _firstPos + 1, _strLength - _firstPos);
            var _lowerValue = string_lower(_value);
            
            if( (string_starts_with(_value, "\"") || string_starts_with(_value, "'"))  && (string_ends_with(_value, "\"") || string_ends_with(_value, "'")) ) {
                //It is a string arg
                var _valStrLen = string_length(_value);
                _value = string_copy(_value, 2, _valStrLen - 2);
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
                    // failing to parse number will result in fallback to string value below
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