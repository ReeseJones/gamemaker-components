tag_script(serializer_tests, [TAG_UNIT_TEST_SPEC]);
function serializer_tests() {
    return [
        describe("serialize", function() {
            before_each(function() {
                filename = file_get_save_directory() + "serialize_asset_graph_test.json";
                uiRoot = instance_create_depth(0, 0 , 0, obj_ui_element);
                panel = instance_create_depth(0, 0 , 0, obj_ui_element);
                header = instance_create_depth(0, 0 , 0, obj_ui_element);
                content = instance_create_depth(0, 0 , 0, obj_ui_element);
                items = [];
                for(var i = 0; i < 5; i += 1) {
                    var _item = instance_create_depth(0, 0 , 0, obj_ui_element);
                    node_append_child(content, _item);
                    array_push(items, _item);
                    _item.sizeProperties.width = 1;
                    _item.sizeProperties.height = 0.1;
                }

                node_append_child(uiRoot, panel);
                node_append_child(panel, header);
                node_append_child(panel, content);

                panel.sizeProperties.width = 0.5;
                panel.sizeProperties.height = 1;
                panel.sizeProperties.padding.left = 10;
                panel.sizeProperties.padding.right = 10;
                panel.sizeProperties.border.left = 10;
                panel.sizeProperties.border.right = 10;

                header.sizeProperties.width = 1;
                header.sizeProperties.height = 100;
                header.sizeProperties.border.left = 0.1;
                header.sizeProperties.border.right = 0.2;
                header.sizeProperties.border.top = 0.025;
                header.sizeProperties.border.bottom = 0.025;
                
                content.sizeProperties.width = 1;
                content.sizeProperties.height = 0.8;
                content.sizeProperties.padding.left = 0.1;
                content.sizeProperties.padding.right = 0.2;
                content.sizeProperties.border.top = 0.025;
                content.sizeProperties.border.bottom = 0.025;

                ui_calculate_layout(uiRoot, 1000, 1000);
            });
            after_each(function() {
                instance_destroy(uiRoot);
                instance_destroy(panel);
                instance_destroy(header);
                instance_destroy(content);
                array_foreach(items, function(_inst) {
                    instance_destroy(_inst);
                });
            });

            it("should work", function() {
                var _assetGraph = new AssetGraph();
                serialize(_assetGraph, uiRoot);
                var _assetJson = struct_static_dehydrate(_assetGraph);
                file_json_write(filename, _assetJson);
            });
            
            it("should work to restore all asset graph from file", function() {
                var _assetGraph = file_json_read(filename);
                
                matcher_is_instanceof(_assetGraph, AssetGraph);
                matcher_value_equal(array_length(_assetGraph.ids), 9) 
            });
            
            it("asset graph can be deserialized into useable stuff", function() {
                var _assetGraph = file_json_read(filename);

                var _assetGroup = deserialize(_assetGraph);
                
                matcher_is_instanceof(_assetGroup, AssetGroup);
                matcher_value_equal(array_length(_assetGroup.ids), 9);
                
                struct_foreach(_assetGroup.instances, function(_key, _value) {
                    matcher_instance_is_object(_value, obj_ui_element);
                });
            });
            
            it("asset graph can be deserialized into useable stuff, then calculate ui layout", function() {
                var _assetGraph = file_json_read(filename);

                var _assetGroup = deserialize(_assetGraph);
                
                //Get the root ui element from here.
                var _first = _assetGroup.instances[$ _assetGroup.ids[0]];
                while( is_defined(_first.parentNode) ) {
                    _first = _first.parentNode;
                }

                ui_calculate_layout(_first, 1000, 1000);
            });
        })
    ];
}