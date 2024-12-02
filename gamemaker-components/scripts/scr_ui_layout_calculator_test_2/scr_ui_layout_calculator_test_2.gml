/*
tag_script(ui_layout_calculator_tests_two, [TAG_UNIT_TEST_SPEC]);
function ui_layout_calculator_tests_two() {
    return [
        describe("UI layout calculator", function() {
            before_each(function() {
               testLayer = layer_create(-300, "invisible_test");
               layer_set_visible(testLayer, false);
               uiRoot = instance_create_layer(0, 0 , testLayer, obj_ui_element);
               panel = instance_create_layer(0, 0 , testLayer, obj_ui_element);
               header = instance_create_layer(0, 0 , testLayer, obj_ui_element);
               content = instance_create_layer(0, 0 , testLayer, obj_ui_element);
               item = instance_create_layer(0, 0 , testLayer, obj_ui_element);
            });
            after_each(function() {
               //instance_destroy(uiRoot);
               //instance_destroy(panel);
               //instance_destroy(header);
               //instance_destroy(content);
               //instance_destroy(item);
               layer_destroy(testLayer)
            });
            describe("ui_calculate_layout", function() {
               it("should set the size of all elements in a heirarchy starting from the root", function(){
                    ui_calculate_layout(uiRoot, 1000, 1000);

                    matcher_value_equal(uiRoot.calculatedSize.width, 1000);
                    matcher_value_equal(uiRoot.calculatedSize.height, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.width, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.height, 1000);
               });
               it("panel should be 50% of the size of the ui root", function() {
                    node_append_child(uiRoot, panel);
                    panel.sizeProperties.width = 0.5;
                    panel.sizeProperties.height = 1;
                    ui_calculate_layout(uiRoot, 1000, 1000);

                    matcher_value_equal(uiRoot.calculatedSize.width, 1000);
                    matcher_value_equal(uiRoot.calculatedSize.height, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.width, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.height, 1000);
                    
                    matcher_value_equal(panel.calculatedSize.width, 500);
                    matcher_value_equal(panel.calculatedSize.height, 1000);
                    matcher_value_equal(panel.sizeProperties.width, 0.5);
                    matcher_value_equal(panel.sizeProperties.height, 1);
               });
               it("header should be use left and right to be width of parent and fixed height", function() {
                    node_append_child(uiRoot, panel);
                    node_append_child(panel, header);

                    panel.sizeProperties.width = 0.5;
                    panel.sizeProperties.height = 1;
                    header.sizeProperties.position.left = 0;
                    header.sizeProperties.position.right = 0;
                    header.sizeProperties.width = undefined;
                    header.sizeProperties.height = 128;

                    ui_calculate_layout(uiRoot, 1000, 1000);

                    matcher_value_equal(uiRoot.calculatedSize.width, 1000);
                    matcher_value_equal(uiRoot.calculatedSize.height, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.width, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.height, 1000);
                    
                    matcher_value_equal(panel.calculatedSize.width, 500);
                    matcher_value_equal(panel.calculatedSize.height, 1000);
                    matcher_value_equal(panel.sizeProperties.width, 0.5);
                    matcher_value_equal(panel.sizeProperties.height, 1);
                    
                    matcher_value_equal(header.calculatedSize.width, 500);
                    matcher_value_equal(header.calculatedSize.height, 128);
                    matcher_value_equal(header.sizeProperties.width, undefined);
                    matcher_value_equal(header.sizeProperties.height, 128);
               });
               it("if the border of a child element is larger than the calculated width, it uses the border size instead.", function() {
                    node_append_child(uiRoot, panel);
                    node_append_child(panel, header);

                    panel.sizeProperties.width = 0.5;
                    panel.sizeProperties.height = 1;
                    header.sizeProperties.position.left = 0;
                    header.sizeProperties.position.right = 0;
                    header.sizeProperties.width = undefined;
                    header.sizeProperties.height = 128;
                    header.sizeProperties.border.left = 300;
                    header.sizeProperties.border.right = 300;

                    ui_calculate_layout(uiRoot, 1000, 1000);

                    matcher_value_equal(uiRoot.calculatedSize.width, 1000);
                    matcher_value_equal(uiRoot.calculatedSize.height, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.width, 1000);
                    matcher_value_equal(uiRoot.sizeProperties.height, 1000);
                    
                    matcher_value_equal(panel.calculatedSize.width, 500);
                    matcher_value_equal(panel.calculatedSize.height, 1000);
                    matcher_value_equal(panel.sizeProperties.width, 0.5);
                    matcher_value_equal(panel.sizeProperties.height, 1);
                    
                    matcher_value_equal(header.calculatedSize.width, 600);
                    matcher_value_equal(header.calculatedSize.height, 128);
                    matcher_value_equal(header.sizeProperties.width, undefined);
                    matcher_value_equal(header.sizeProperties.height, 128);
                });
                it("The border can be a fractional size based on the parents width.", function() {
                    node_append_child(uiRoot, panel);
                    node_append_child(panel, header);

                    panel.sizeProperties.width = 0.5;
                    panel.sizeProperties.height = 1;
                    
                    header.sizeProperties.width = 1;
                    header.sizeProperties.height = 100;
                    header.sizeProperties.border.left = 0.1;
                    header.sizeProperties.border.right = 0.2;
                    header.sizeProperties.border.top = 0.025;
                    header.sizeProperties.border.bottom = 0.025;

                    ui_calculate_layout(uiRoot, 1000, 1000);

                    matcher_value_equal(panel.sizeProperties.width, 0.5);
                    matcher_value_equal(panel.sizeProperties.height, 1);
                    matcher_value_equal(panel.calculatedSize.width, 500);
                    matcher_value_equal(panel.calculatedSize.height, 1000);

                    matcher_value_equal(header.sizeProperties.width, 1);
                    matcher_value_equal(header.sizeProperties.height, 100);
                    matcher_value_equal(header.calculatedSize.width, 500);
                    matcher_value_equal(header.calculatedSize.height, 100);
                    matcher_value_equal(header.calculatedSize.border.left, 50);
                    matcher_value_equal(header.calculatedSize.border.right, 100);
                    matcher_value_equal(header.calculatedSize.border.top, 25);
                    matcher_value_equal(header.calculatedSize.border.bottom, 25);
                });
                it("The border can be a fractional size based on the parents width. Accounts for padding and border.", function() {
                    node_append_child(uiRoot, panel);
                    node_append_child(panel, header);

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

                    ui_calculate_layout(uiRoot, 1000, 1000);

                    matcher_value_equal(panel.sizeProperties.width, 0.5);
                    matcher_value_equal(panel.sizeProperties.height, 1);
                    matcher_value_equal(panel.calculatedSize.width, 500);
                    matcher_value_equal(panel.calculatedSize.height, 1000);

                    matcher_value_equal(header.sizeProperties.width, 1);
                    matcher_value_equal(header.sizeProperties.height, 100);
                    /// the inner width of the panel is 460 because padding and border are added inside width.
                    matcher_value_equal(header.calculatedSize.width, 460);
                    matcher_value_equal(header.calculatedSize.height, 100);
                    matcher_value_equal(header.calculatedSize.border.left, 46);
                    matcher_value_equal(header.calculatedSize.border.right, 92);
                    matcher_value_equal(header.calculatedSize.border.top, 25);
                    matcher_value_equal(header.calculatedSize.border.bottom, 25);
                });
                it("Deeply nested uis can be saved!.", function() {
                    node_append_child(uiRoot, panel);
                    node_append_child(panel, header);

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

                    ui_calculate_layout(uiRoot, 1000, 1000);

                    matcher_value_equal(panel.sizeProperties.width, 0.5);
                    matcher_value_equal(panel.sizeProperties.height, 1);
                    matcher_value_equal(panel.calculatedSize.width, 500);
                    matcher_value_equal(panel.calculatedSize.height, 1000);

                    matcher_value_equal(header.sizeProperties.width, 1);
                    matcher_value_equal(header.sizeProperties.height, 100);
                    /// the inner width of the panel is 460 because padding and border are added inside width.
                    matcher_value_equal(header.calculatedSize.width, 460);
                    matcher_value_equal(header.calculatedSize.height, 100);
                    matcher_value_equal(header.calculatedSize.border.left, 46);
                    matcher_value_equal(header.calculatedSize.border.right, 92);
                    matcher_value_equal(header.calculatedSize.border.top, 25);
                    matcher_value_equal(header.calculatedSize.border.bottom, 25);
                });
            });
        })
    ];
}
*/