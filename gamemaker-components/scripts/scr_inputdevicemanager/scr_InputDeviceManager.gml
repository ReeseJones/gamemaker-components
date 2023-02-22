function InputDeviceManager() constructor 
{
    // Feather disable GM2017
    allocatedDevices = [];
    availableDevices = [DEVICE_INDEX.MOUSE_AND_KEYBOARD];
    // Feather restore GM2017
    
    static updateAvailableDevices = function update_available_devices() {
        var _deviceCount = gamepad_get_device_count();
        //show_debug_message("Updating Available Devices: " + string(_deviceCount));
        for(var i = 0; i < _deviceCount; i += 1) {
            if(gamepad_is_connected(i)) {
                var _isFree = deviceIsAllocated(i);
                var _isAllocated = deviceIsAvailable(i);
                if(!_isFree && !_isAllocated) {
                    show_debug_message("Found Available gamepad#" + string(i));
                    array_push(availableDevices, i);
                }
            } else {
                array_remove(allocatedDevices, i);
                array_remove(availableDevices, i);
            }
        }
    }
    
    //Attempts to get the requested device id, but otherwise will give the first available.
    //Will return undefined if its unable to return an available device.
    static allocateInputDevice = function allocate_input_device(_deviceIndexPreference) {        
        if(deviceIsAvailable(_deviceIndexPreference)) {
            array_push(allocatedDevices, _deviceIndexPreference);
            array_remove(availableDevices, _deviceIndexPreference);
            return _deviceIndexPreference;
        }

        return array_pop(availableDevices);
    }
    
    static freeInputDevice = function free_input_device(_deviceIndex) {
        if(!is_numeric(_deviceIndex)) {
            return;
        }
        var _isAvailable = deviceIsAvailable(_deviceIndex);
        var _isAllocated = deviceIsAllocated(_deviceIndex);
        
        if(!_isAvailable && _isAllocated) {
            array_remove(allocatedDevices, _deviceIndex);
            array_push(availableDevices, _deviceIndex);
        }
    }
    
   static deviceIsAvailable = function device_is_available(_deviceIndex) {
        return array_get_index(availableDevices, _deviceIndex) != -1;
    }
    
    static deviceIsAllocated = function device_is_allocated(_deviceIndex) {
        return array_get_index(allocatedDevices, _deviceIndex) != -1;
    }
    
    static getAllDevices = function get_all_devices(_arrayDest) {
        return array_concat_ext(availableDevices, allocatedDevices, _arrayDest);
    }

    updateAvailableDevices();
}