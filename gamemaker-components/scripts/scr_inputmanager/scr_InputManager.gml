enum DeviceIndex {
	MouseAndKeyboard = -1,
	//The rest are gamepads 0 to n
	Gamepad0 = 0,
	Gamepad1 = 1,
	Gamepad2 = 2,
	Gamepad3 = 3,
	Gamepad4 = 4,
	Gamepad5 = 5,
	Gamepad6 = 6,
	Gamepad7 = 7,
	Gamepad8 = 8,
	Gamepad9 = 9
}

enum InputType {
	MouseAndKeyboard,
	Gamepad
}

enum BindingType {
	KeyboardKey,
	MouseButton,
	MouseWheel,
	GamepadButton,
	GamepadAxis
}

enum MouseWheelDirection {
	Up,
	Down
}

enum ButtonPressType {
	Held,
	Press,
	Release
}

enum ActionInput {
	MoveUp,
	MoveDown,
	MoveLeft,
	MoveRight,
	MoveHorizontal,
	MoveVertical,
	Shoot,
	ShootSecondary,
	ThrowGrenade,
	Jump,
	UseEquipment,
	ToggleInventory,
	Pause,
	NextWeapon,
	PreviousWeapon,
	Crouch,
	LookVertical,
	LookHorizontal
}

function InputManager(_inputDeviceManager) constructor {
	keyboardCheckMethod = os_type == os_windows ? keyboard_check_direct : keyboard_check;
	bindings = ds_map_create();
	inputDeviceManager = _inputDeviceManager;
	ds_map_add_map(bindings, InputType.MouseAndKeyboard, ds_map_create());
	ds_map_add_map(bindings, InputType.Gamepad, ds_map_create());
	
	functionsMap = ds_map_create();
	ds_map_add_map(functionsMap, ButtonPressType.Held, ds_map_create());
	ds_map_add_map(functionsMap, ButtonPressType.Press, ds_map_create());
	ds_map_add_map(functionsMap, ButtonPressType.Release, ds_map_create());
	
	function GetInputTypeFromDeviceIndex(_deviceIndex) {
		return	_deviceIndex == DeviceIndex.MouseAndKeyboard 
		? InputType.MouseAndKeyboard
		: InputType.Gamepad;
	}
	
	function CheckPressed(_deviceIndex, _actionInput) {
		var inputType = GetInputTypeFromDeviceIndex(_deviceIndex)
		var actionInputMap = bindings[? inputType];
		var actionSetting = actionInputMap[? _actionInput];
		var checkMethod = functionsMap[? ButtonPressType.Press][? actionSetting.type];
		return checkMethod(_deviceIndex, actionSetting.value);
	}
	
	function CheckReleased(_deviceIndex, _actionInput) {
		var inputType = GetInputTypeFromDeviceIndex(_deviceIndex)
		var actionInputMap = bindings[? inputType];
		var actionSetting = actionInputMap[? _actionInput];
		var checkMethod = functionsMap[? ButtonPressType.Release][? actionSetting.type];
		return checkMethod(_deviceIndex, actionSetting.value);
	}
	
	function CheckHeld(_deviceIndex, _actionInput) {
		var inputType = GetInputTypeFromDeviceIndex(_deviceIndex)
		var actionInputMap = bindings[? inputType];
		var actionSetting = actionInputMap[? _actionInput];
		var checkMethod = functionsMap[? ButtonPressType.Held][? actionSetting.type];
		return checkMethod(_deviceIndex, actionSetting.value);
	}
	
	function ReadAxis(_deviceIndex, _actionInput) {
		var inputType = GetInputTypeFromDeviceIndex(_deviceIndex)
		var actionInputMap = bindings[? inputType];
		var actionSetting = actionInputMap[? _actionInput];
		return gamepad_axis_value(_deviceIndex, actionSetting.value);
	}
	
	function CheckAllDeviceInput() {
		var static deviceArray = [];
		var static gamepadBindingsArray = [];
		
		var devices = inputDeviceManager.GetAllDevices(deviceArray);
		var deviceCount = array_length(devices);
		for(var i = 0; i < deviceCount; i += 1) {
			var deviceIndex = devices[i];
			
			if(deviceIndex == DeviceIndex.MouseAndKeyboard) {
				if(keyboard_check_pressed(vk_anykey)
				|| device_mouse_check_button_pressed(0, mb_any)) {
					return DeviceIndex.MouseAndKeyboard;	
				}
			} else {
				var gamepadBindings = bindings[? InputType.Gamepad];
				var gamepadActions = ds_map_keys_to_array(gamepadBindings, gamepadBindingsArray);
				var actionCount = array_length(gamepadActions);
		
				for(var j = 0; j < actionCount; j += 1) {
					var actionSetting = gamepadBindings[? gamepadActions[j]];
					if(actionSetting.type == BindingType.GamepadButton) {
						var isPressed = gamepad_button_check_pressed(deviceIndex, actionSetting.value);
						if(isPressed) {
							return deviceIndex;	
						}
					}
				}
			}
		}
		
		//no device input detected
		return undefined;
	}
	
	function InitializeFunctionMap() {
		var heldMap = functionsMap[? ButtonPressType.Held];
		var pressMap = functionsMap[? ButtonPressType.Press];
		var releaseMap = functionsMap[? ButtonPressType.Release];
		
		heldMap[? BindingType.KeyboardKey] = function(_device, _key) { return keyboardCheckMethod(_key); };
		heldMap[? BindingType.MouseButton] = device_mouse_check_button;
		heldMap[? BindingType.GamepadButton] = gamepad_button_check;
		heldMap[? BindingType.MouseWheel] = function(_device, _key) { return _key == MouseWheelDirection.Up ? mouse_wheel_up() : mouse_wheel_down() };
		
		pressMap[? BindingType.KeyboardKey] = function(_device, _key) { return keyboard_check_pressed(_key); };
		pressMap[? BindingType.MouseButton] = device_mouse_check_button_pressed;
		pressMap[? BindingType.GamepadButton] = gamepad_button_check_pressed;
		pressMap[? BindingType.MouseWheel] = function(_device, _key) { return _key == MouseWheelDirection.Up ? mouse_wheel_up() : mouse_wheel_down() };
		
		releaseMap[? BindingType.KeyboardKey] = function(_device, _key) { return keyboard_check_released(_key); };
		releaseMap[? BindingType.MouseButton] = device_mouse_check_button_released;
		releaseMap[? BindingType.GamepadButton] = gamepad_button_check_released;
		releaseMap[? BindingType.MouseWheel] = function() { return false };
	}
	
	function InitializeBindings() {
		var keyboardBindings = bindings[? InputType.MouseAndKeyboard];
		var gamepadBindings = bindings[? InputType.Gamepad];
	
		keyboardBindings[? ActionInput.Crouch] = {
			type: BindingType.KeyboardKey,
			value: vk_control
		};
		keyboardBindings[? ActionInput.UseEquipment] = {
			type: BindingType.KeyboardKey,
			value:  ord("Q")
		};
		keyboardBindings[? ActionInput.Jump] = {
			type: BindingType.KeyboardKey,
			value:  vk_space
		};
		keyboardBindings[? ActionInput.MoveDown] = {
			type: BindingType.KeyboardKey,
			value:  ord("S")
		};
		keyboardBindings[? ActionInput.MoveLeft] = {
			type: BindingType.KeyboardKey,
			value:  ord("A")
		};
		keyboardBindings[? ActionInput.MoveRight] = {
			type: BindingType.KeyboardKey,
			value:  ord("D")
		};
		keyboardBindings[? ActionInput.MoveUp] = {
			type: BindingType.KeyboardKey,
			value: ord("W")
		};
		keyboardBindings[? ActionInput.Shoot] = {
			type: BindingType.MouseButton,
			value: mb_left
		};
		keyboardBindings[? ActionInput.ShootSecondary] = {
			type: BindingType.MouseButton,
			value: mb_right
		};
		keyboardBindings[? ActionInput.ThrowGrenade] = {
			type: BindingType.KeyboardKey,
			value: ord("G")
		};
		keyboardBindings[? ActionInput.ToggleInventory] = {
			type: BindingType.KeyboardKey,
			value: ord("T")
		};
		keyboardBindings[? ActionInput.NextWeapon] = {
			type: BindingType.MouseWheel,
			value: MouseWheelDirection.Up
		};
		keyboardBindings[? ActionInput.PreviousWeapon] = {
			type: BindingType.MouseWheel,
			value: MouseWheelDirection.Down
		};
		keyboardBindings[? ActionInput.Pause] = {
			type: BindingType.KeyboardKey,
			value: vk_escape
		};
	
		//Gamepad Bindings
		gamepadBindings[? ActionInput.Crouch] = {
			type: BindingType.GamepadButton,
			value: gp_stickl
		};
		gamepadBindings[? ActionInput.UseEquipment] = {
			type: BindingType.GamepadButton,
			value:  gp_face3
		};
		gamepadBindings[? ActionInput.Jump] = {
			type: BindingType.GamepadButton,
			value:  gp_face1
		};
		gamepadBindings[? ActionInput.MoveVertical] = {
			type: BindingType.GamepadAxis,
			value:  gp_axislv
		};
		gamepadBindings[? ActionInput.MoveHorizontal] = {
			type: BindingType.GamepadAxis,
			value:  gp_axislh
		};
		gamepadBindings[? ActionInput.Shoot] = {
			type: BindingType.GamepadButton,
			value: gp_shoulderrb
		};
		gamepadBindings[? ActionInput.ShootSecondary] = {
			type: BindingType.GamepadButton,
			value: gp_shoulderlb
		};
		gamepadBindings[? ActionInput.ThrowGrenade] = {
			type: BindingType.GamepadButton,
			value: gp_shoulderl
		};
		gamepadBindings[? ActionInput.ToggleInventory] = {
			type: BindingType.GamepadButton,
			value: gp_select
		};
		gamepadBindings[? ActionInput.NextWeapon] = {
			type: BindingType.GamepadButton,
			value: gp_padu
		};
		gamepadBindings[? ActionInput.PreviousWeapon] = {
			type: BindingType.GamepadButton,
			value: gp_padd
		};
		gamepadBindings[? ActionInput.LookVertical] = {
			type: BindingType.GamepadAxis,
			value: gp_axisrv
		};
		gamepadBindings[? ActionInput.LookHorizontal] = {
			type: BindingType.GamepadAxis,
			value: gp_axisrh
		};
		gamepadBindings[? ActionInput.Pause] = {
			type: BindingType.GamepadButton,
			value: gp_start
		};
	}
		
	InitializeFunctionMap();
	InitializeBindings();
}

function input_manager_create(_inputDeviceManager) {
	return new InputManager(_inputDeviceManager);	
}

function input_manager_destroy(_inputManager) {
	ds_map_destroy(_inputManager.bindings);
	ds_map_destroy(_inputManager.functionsMap);
	delete _inputManager;
}