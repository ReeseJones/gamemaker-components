function ds_map_foreach(_id, _method) {
	array_foreach(ds_map_values_to_array(_id), _method);
}