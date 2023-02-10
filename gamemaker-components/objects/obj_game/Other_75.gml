var _eventType = async_load[? "event_type"];
switch(_eventType) {
	case "gamepad discovered":
	case "gamepad lost":
		inputDeviceManager.updateAvailableDevices();
		break;
	case "audio_system_status":
	case "virtual keyboard status":
	case "user signed in":
	case "user sign in failed":
	case "user signed out":
	default:
		show_debug_message("Unhandled system event: " + _eventType);
}