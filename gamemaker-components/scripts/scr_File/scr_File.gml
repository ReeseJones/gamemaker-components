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

    var _parsed = json_deserialize(_stringContents);
    return _parsed;
}