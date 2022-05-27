/// @function            CircularBuffer(size)
/// @description         A datastructure which will store an infinite amount of data writing over old data as size is reached
/// @param {int} _size   The number of values that may be written before it writes over old data
function CircularBuffer(_size) constructor {
	size = _size;
	buffer = array_create(size, undefined);
	head = 0;
	
	static Push = function(_value) {
		var next = head + 1;
		if( next == size ) {
			next = 0;
		}
		
		buffer[head] = _value;
		head = next;
	}
	
/// @function            Read(offset)
/// @description         Read the last inserted data into the buffer
/// @param {int} _offset Offset indicates a number indicies back in history to read from the buffer
	static Read = function(_offset) {
		if(is_undefined(_offset)) {
			_offset = 0;
		}
		var index = head - _offset;
		index = ((index % size) + size) % size;
		return buffer[index];
	}
	
	static Resize = function(_size) {
		size = _size;
		array_resize(buffer, size);
		head = clamp(head, 0, size - 1);
	}
	
	static Reset = function() {
		head = 0;
		buffer = array_create(size, undefined);
	}
}