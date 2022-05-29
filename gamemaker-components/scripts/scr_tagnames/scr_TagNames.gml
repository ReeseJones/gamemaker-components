#macro tag_command "c_command"
#macro tag_script "script"
#macro tag_unit_test "unit_test"

TagScript(TagScript, [tag_command]);
/// @desc TagScript adds tags to game maker assets.
/// @param {Function} _scrIndex The script to add tags to.
/// @param {Array} _tags The tag or tags to add the the script index.
function TagScript(_scrIndex, _tags) {
	
	var tags = [tag_script];
	
	if(is_array(_tags)) {
		array_concat(tags, _tags, tags);
	} else if(is_string(_tags)) {
		array_push(tags, _tags);	
	}
	
	asset_add_tags( _scrIndex, tags, asset_script);
}

TagScript(GetScriptIds, [tag_command]);
function GetScriptIds(_tags) {
	return tag_get_asset_ids(_tags, asset_script);	
}

TagScript(GetScriptNames, [tag_command]);
function GetScriptNames(_tags) {
	var scriptIds = GetScriptIds(_tags);
	return array_map(scriptIds, function(_scriptId){
		return script_get_name(_scriptId);
	}, undefined, scriptIds);
}
