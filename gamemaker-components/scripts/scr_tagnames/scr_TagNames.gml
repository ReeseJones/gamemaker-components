#macro TAG_COMMAND "c_command"
#macro TAG_SCRIPT "script"
#macro TAG_UNIT_TEST "unit_test"
#macro TAG_UNIT_TEST_SPEC "unit_test_spec"
#macro TAG_GEOMETRY "geometry"
#macro TAG_MATH "math"

tag_script(tag_script, [TAG_COMMAND]);
/// @function tag_script(script_index, tags)
/// @desc tag_script adds tags to game maker assets.
/// @param {Function} _scrIndex The script to add tags to.
/// @param {Array} _tags The tag or tags to add the the script index.
function tag_script(_scrIndex, _tags = undefined) {
    var _currentTags = [TAG_SCRIPT];

    if(is_array(_tags)) {
        array_concat_ext(_currentTags, _tags, _currentTags);
    } else if(is_string(_tags)) {
        array_push(_currentTags, _tags);
    }

    asset_add_tags( _scrIndex, _currentTags, asset_script);
}

tag_script(get_script_ids, [TAG_COMMAND]);
function get_script_ids(_tags) {
    return tag_get_asset_ids(_tags, asset_script);
}

tag_script(get_script_names, [TAG_COMMAND]);
function get_script_names(_tags) {
    var _scriptIds = get_script_ids(_tags);
    return array_map_ext(_scriptIds, function(_scriptId){
        return script_get_name(_scriptId);
    });
}

tag_script(get_all_scripts, [TAG_COMMAND]);
function get_all_scripts() {
    var _allScripts = tag_get_asset_ids(TAG_SCRIPT, asset_script);
    array_foreach(_allScripts, function(_scrIndex) {
        show_debug_message(script_get_name(_scrIndex));
    });
    return _allScripts;
}