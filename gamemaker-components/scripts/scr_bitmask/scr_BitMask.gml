function bit_check_present(_value, _mask) {
	return (_value & _mask == _mask)
}

function bit_check_absent(_value, _mask) {
	return (~_value & _mask == _mask)
}