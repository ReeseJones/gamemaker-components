#macro TAG_COMMAND "c_command"
#macro TAG_UNIT_TEST_SPEC "unit_test_spec"
#macro TAG_GEOMETRY "geometry"
#macro TAG_MATH "math"


/// @function tag_asset(script_index, tags)
/// @desc tag_asset adds tags to game maker assets.
/// @param {Any} _asset The asset handle OR name to add tags to.
/// @param {Array<String>} _tags The tag or tags to add the the script index.
/// @param {Constant.AssetType} _specificAssetType
function tag_asset(_asset, _tags = undefined) {
    var _assetType = asset_get_type(_asset);
    if(_assetType == asset_unknown) {
        throw $"Cannot tag asset. Asset ${_asset} does not exist or type is unknown.";
    }
    
    var _assetTypeName = asset_type_get_name(_assetType);
     var _currentTags = [_assetTypeName];
 
    if(is_array(_tags)) {
        array_concat_ext(_currentTags, _tags, _currentTags);
    } else if(is_string(_tags)) {
        array_push(_currentTags, _tags);
    }

    asset_add_tags( _asset, _currentTags);
}

tag_asset(get_script_ids, [TAG_COMMAND]);
function get_script_ids(_tags) {
    return tag_get_asset_ids(_tags, asset_script);
}

tag_asset(get_script_names, [TAG_COMMAND]);
function get_script_names(_tags) {
    var _scriptIds = get_script_ids(_tags);
    return array_map_ext(_scriptIds, function(_scriptId) {
        return script_get_name(_scriptId);
    });
}

tag_asset(get_all_scripts, [TAG_COMMAND]);
function get_all_scripts() {
    var _allScripts = tag_get_asset_ids("script", asset_script);
    array_foreach(_allScripts, function(_scrIndex) {
        show_debug_message(script_get_name(_scrIndex));
    });
    return _allScripts;
}