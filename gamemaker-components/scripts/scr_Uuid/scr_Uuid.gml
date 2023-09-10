
function uuid_generate() {
  var _rnds = rng();

  _rnds[6] = (_rnds[6] & 0x0f) | 0x40;
  _rnds[8] = (_rnds[8] & 0x3f) | 0x80;

  return unsafe_uuid_stringify(_rnds);
}

function rng() {
    static rndsPool = array_create(256);
    static poolPointer = array_length(rndsPool);

    if(poolPointer > array_length(rndsPool) - 16) {
        array_map_ext(rndsPool, function() {
            return round(random(0xff));
        });
        poolPointer = 0;
    }

    var _array = array_create(16);
    array_copy(_array, 0, rndsPool, poolPointer, 16);
    poolPointer += 16;
    return _array;
}

function generate_byte_to_hex() {
    var _byteToHex = [];

    for (var i = 0; i < 256; ++i) {
        var _strHex = string_hex(i + 0x100);
        array_push(_byteToHex, string_copy(_strHex, 2, string_length(_strHex) - 1));
    }

    return _byteToHex;
}

function unsafe_uuid_stringify(_byteValues) {
  static byteToHex = generate_byte_to_hex();

  return (
    byteToHex[_byteValues[0]] +
    byteToHex[_byteValues[1]] +
    byteToHex[_byteValues[2]] +
    byteToHex[_byteValues[3]] +
    "-" +
    byteToHex[_byteValues[4]] +
    byteToHex[_byteValues[5]] +
    "-" +
    byteToHex[_byteValues[6]] +
    byteToHex[_byteValues[7]] +
    "-" +
    byteToHex[_byteValues[8]] +
    byteToHex[_byteValues[9]] +
    "-" +
    byteToHex[_byteValues[10]] +
    byteToHex[_byteValues[11]] +
    byteToHex[_byteValues[12]] +
    byteToHex[_byteValues[13]] +
    byteToHex[_byteValues[14]] +
    byteToHex[_byteValues[15]]
  );
}