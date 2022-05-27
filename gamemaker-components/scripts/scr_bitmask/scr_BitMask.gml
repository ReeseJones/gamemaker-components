function BitCheckPresent(_value, _mask) {
	return (_value & _mask == _mask)
}

function BitCheckAbsent(_value, _mask) {
	return (~_value & _mask == _mask)
}