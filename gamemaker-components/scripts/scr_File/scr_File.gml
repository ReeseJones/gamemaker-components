function file_text_read_string_all(_fileid) {
    var _stringContents = "";

    while( !file_text_eof(_fileid) ) {
         _stringContents += string_trim(file_text_read_string(_fileid)) + "\n";
        file_text_readln(_fileid);
    }
    return _stringContents;
}

function file_json_read(_filename) {
    var _openFile = file_text_open_read(_filename);

    var _stringContents = "";

    while( !file_text_eof(_openFile) ) {
         _stringContents += string_trim(file_text_read_string(_openFile)) + "\n";
        file_text_readln(_openFile);
    }

    var _rawJsonStruct = json_parse(_stringContents);
    var _parsed = struct_static_hydrate(_rawJsonStruct);
    file_text_close(_openFile);
    return _parsed;
}

function file_json_write(_filename, _jsonObj) {
    var _openFile = file_text_open_write(_filename);

    var _stringContents = json_stringify(_jsonObj, true);

    file_text_write_string(_openFile, _stringContents);
    file_text_writeln(_openFile);
    file_text_close(_openFile);
}