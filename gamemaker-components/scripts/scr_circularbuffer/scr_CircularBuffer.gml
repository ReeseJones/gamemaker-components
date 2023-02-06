/// @function            CircularBuffer(size)
/// @description         A datastructure which will store an infinite amount of data writing over old data as size is reached
/// @param {Real}        _size   The number of values that may be written before it writes over old data
function CircularBuffer(_size) constructor {
    size = _size;
    buffer = array_create(size);
    head = 0;
    
    static push = function(_value) {
        var _next = head + 1;
        if( _next == size ) {
            _next = 0;
        }
        
        buffer[head] = _value;
        head = _next;
    }
    
/// @function            Read(offset)
/// @description         Read the last inserted data into the buffer
/// @param {Real}        _offset Offset indicates a number indicies back in history to read from the buffer
    static read = function(_offset) {
        if(is_undefined(_offset)) {
            _offset = 0;
        }
        var _index = head - _offset;
        _index = ((_index % size) + size) % size;
        return buffer[_index];
    }
    
    static resize = function(_size) {
        size = _size;
        array_resize(buffer, size);
        head = clamp(head, 0, size - 1);
    }
    
    static reset = function() {
        head = 0;
        buffer = array_create(size);
    }
}