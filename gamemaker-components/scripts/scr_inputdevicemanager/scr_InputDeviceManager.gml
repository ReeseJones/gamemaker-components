function InputDeviceManager() constructor {
	allocatedDevices = [];
	availableDevices = [DeviceIndex.MouseAndKeyboard];
	
	function UpdateAvailableDevices() {
		var deviceCount = gamepad_get_device_count();
		//show_debug_message("Updating Available Devices: " + string(deviceCount));
		for(var i = 0; i < deviceCount; i += 1) {
			if(gamepad_is_connected(i)) {
				var isFree = DeviceIsAllocated(i);
				var isAllocated = DeviceIsAvailable(i);
				if(!isFree && !isAllocated) {
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
	function AllocateInputDevice(_deviceIndexPreference) {		
		if(DeviceIsAvailable(_deviceIndexPreference)) {
			array_push(allocatedDevices, _deviceIndexPreference);
			array_remove(availableDevices, _deviceIndexPreference);
			return _deviceIndexPreference;
		}
		
		return array_pop(availableDevices);
	}
	
	function FreeInputDevice(_deviceIndex) {
		if(!is_numeric(_deviceIndex)) {
			return;	
		}
		var isAvailable = DeviceIsAvailable(_deviceIndex);
		var isAllocated = DeviceIsAllocated(_deviceIndex);
		
		if(!isAvailable && isAllocated) {
			array_remove(allocatedDevices, _deviceIndex);
			array_push(availableDevices, _deviceIndex);
		}
	}
	
	function DeviceIsAvailable(_deviceIndex) {
		return array_find_index_by_value(availableDevices, _deviceIndex) != -1;
	}
	
	function DeviceIsAllocated(_deviceIndex) {
		return array_find_index_by_value(allocatedDevices, _deviceIndex) != -1;
	}
	
	function GetAllDevices(_arrayDest) {
		return array_concat_ext(availableDevices, allocatedDevices, _arrayDest);
	}
	
	UpdateAvailableDevices();
}

function input_device_manager_create() {
	return new InputDeviceManager();	
}

/**
 * @desc Destroys an input device manager
 * @param {Struct.InputDeviceManager} _inputDeviceManager
 */
function input_device_manager_destroy(_inputDeviceManager) {
	delete _inputDeviceManager;
}