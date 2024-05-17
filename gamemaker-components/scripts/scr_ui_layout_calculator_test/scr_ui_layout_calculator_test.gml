tag_script(ui_layout_calculator_tests, [TAG_UNIT_TEST_SPEC]);
function ui_layout_calculator_tests() {
    return [
        describe("UI layout calculator", function() {
            before_each(function() {
                uiRoot = instance_create_depth(0, 0 , 0, obj_ui_element);
                panel = instance_create_depth(0, 0 , 0, obj_ui_element);
                header = instance_create_depth(0, 0 , 0, obj_ui_element);
                content = instance_create_depth(0, 0 , 0, obj_ui_element);
                item = instance_create_depth(0, 0 , 0, obj_ui_element);
                
                // UI root has hardcoded size for test, but typically would be the size of the window or UI space.
                uiRoot.sizeProperties.width = 1000;
                uiRoot.sizeProperties.height = 1000;
                uiRoot.calculatedSize.width = uiRoot.sizeProperties.width;
                uiRoot.calculatedSize.height = uiRoot.sizeProperties.height;
            });
            after_each(function() {
                instance_destroy(uiRoot);
                instance_destroy(panel);
                instance_destroy(header);
                instance_destroy(content);
                instance_destroy(item);
            });
            describe("ui_calculate_dimension", function() {
                it("If dimension is a real number greater than 1 dimension is returned", function() {
                    var _val = ui_calculate_dimension(10, 100);
                    matcher_value_equal(_val, 10);
                });
                it("If dimension is a real number greater than 1 dimension is returned even if parent dimension is undefined", function() {
                    var _val = ui_calculate_dimension(10, undefined);
                    matcher_value_equal(_val, 10);
                });
                it("If dimension is <= 1 then dimension is interpreted as a % of parent dimension", function() {
                    var _val = ui_calculate_dimension(1, 100);
                    matcher_value_equal(_val, 100);
                });
                it("If dimension is <= 1 and parent dimension is not a number, then dimension is returned", function() {
                    var _val = ui_calculate_dimension(1, undefined);
                    matcher_value_equal(_val, 1);
                });
                it("scaled dimensions work for negative numbers", function() {
                    var _val = ui_calculate_dimension(-1, 100);
                    matcher_value_equal(_val, -100);
                });
                describe("if dimension is undefined and parent dimension is a real number and a begin and end are numbers", function() {
                    it("dimension is calculated from the parents dimension by subtracting the begin and end values from parentDimension", function() {
                        var _val = ui_calculate_dimension(undefined, 100, 10, 10);
                        matcher_value_equal(_val, 80);
                    });
                    it("dimension is calculated from the parents dimension by subtracting the begin and end values as percentages from parentDimension", function() {
                        var _val = ui_calculate_dimension(undefined, 100, 0.1, 0.1);
                        matcher_value_equal(_val, 80);
                    });
                    it("will not calculate a dimension less than zero (such as when begin and end are larger than parentDimension)", function() {
                        var _val = ui_calculate_dimension(undefined, 100, 0.6, 0.6);
                        matcher_value_equal(_val, 0);
                    });
                });
                describe("if dimension is undefined", function() {
                    it("and begin is undefined then it returns 0", function() {
                        var _val = ui_calculate_dimension(undefined, 100, undefined, 0);
                        matcher_value_equal(_val, 0);
                    });
                    it("and end is undefined then it returns 0", function() {
                        var _val = ui_calculate_dimension(undefined, 100, 0, undefined);
                        matcher_value_equal(_val, 0);
                    });
                    it("and parentDimension is undefined then it returns 0", function() {
                        var _val = ui_calculate_dimension(undefined, undefined, 0, 0);
                        matcher_value_equal(_val, 0);
                    });
                });
            });
            describe("ui_calculate_element_size", function() {
                describe("calculates an elements border size", function() {
                    it("using parent percentages", function() {
                        panel.sizeProperties.border.left = 0.1;
                        panel.sizeProperties.border.right = 0.2;
                        panel.sizeProperties.border.top = 0.3;
                        panel.sizeProperties.border.bottom = 0.4;

                        ui_calculate_element_size(panel, uiRoot);

                        matcher_value_equal(panel.calculatedSize.border.left, 100);
                        matcher_value_equal(panel.calculatedSize.border.right, 200);
                        matcher_value_equal(panel.calculatedSize.border.top, 300);
                        matcher_value_equal(panel.calculatedSize.border.bottom, 400);
                    });
                    it("using fixed sizes", function() {
                        panel.sizeProperties.border.left = 123;
                        panel.sizeProperties.border.right = 321;
                        panel.sizeProperties.border.top = 432;
                        panel.sizeProperties.border.bottom = 234;

                        ui_calculate_element_size(panel, uiRoot);

                        matcher_value_equal(panel.calculatedSize.border.left, 123);
                        matcher_value_equal(panel.calculatedSize.border.right, 321);
                        matcher_value_equal(panel.calculatedSize.border.top, 432);
                        matcher_value_equal(panel.calculatedSize.border.bottom, 234);
                    });
                });
                describe("calculates an elements padding size", function() {
                    it("using parent percentages", function() {
                        panel.sizeProperties.padding.left = 0.1;
                        panel.sizeProperties.padding.right = 0.2;
                        panel.sizeProperties.padding.top = 0.3;
                        panel.sizeProperties.padding.bottom = 0.4;

                        ui_calculate_element_size(panel, uiRoot);

                        matcher_value_equal(panel.calculatedSize.padding.left, 100);
                        matcher_value_equal(panel.calculatedSize.padding.right, 200);
                        matcher_value_equal(panel.calculatedSize.padding.top, 300);
                        matcher_value_equal(panel.calculatedSize.padding.bottom, 400);
                    });
                    it("using fixed sizes", function() {
                        panel.sizeProperties.padding.left = 123;
                        panel.sizeProperties.padding.right = 321;
                        panel.sizeProperties.padding.top = 432;
                        panel.sizeProperties.padding.bottom = 234;

                        ui_calculate_element_size(panel, uiRoot);

                        matcher_value_equal(panel.calculatedSize.padding.left, 123);
                        matcher_value_equal(panel.calculatedSize.padding.right, 321);
                        matcher_value_equal(panel.calculatedSize.padding.top, 432);
                        matcher_value_equal(panel.calculatedSize.padding.bottom, 234);
                    });
                });
                describe("calculates an elements positioning sizes", function() {
                    it("using parent percentages", function() {
                        panel.sizeProperties.position.left = 0.1;
                        panel.sizeProperties.position.right = 0.2;
                        panel.sizeProperties.position.top = 0.3;
                        panel.sizeProperties.position.bottom = 0.4;

                        ui_calculate_element_size(panel, uiRoot);

                        matcher_value_equal(panel.calculatedSize.position.left, 100);
                        matcher_value_equal(panel.calculatedSize.position.right, 200);
                        matcher_value_equal(panel.calculatedSize.position.top, 300);
                        matcher_value_equal(panel.calculatedSize.position.bottom, 400);
                    });
                    it("using fixed sizes", function() {
                        panel.sizeProperties.position.left = 123;
                        panel.sizeProperties.position.right = 321;
                        panel.sizeProperties.position.top = 432;
                        panel.sizeProperties.position.bottom = 234;

                        ui_calculate_element_size(panel, uiRoot);

                        matcher_value_equal(panel.calculatedSize.position.left, 123);
                        matcher_value_equal(panel.calculatedSize.position.right, 321);
                        matcher_value_equal(panel.calculatedSize.position.top, 432);
                        matcher_value_equal(panel.calculatedSize.position.bottom, 234);
                    });
                });
                describe("Calculates an elements width", function() {
                    describe("by infering size from the parent", function() {
                        before_each(function() {
                            panel.sizeProperties.width = undefined;
                        });
                        it("it should be the width of the parent minus the left and right offset from the parent", function() {
                            panel.sizeProperties.position.left = 100;
                            panel.sizeProperties.position.right = 150;

                            ui_calculate_element_size(panel, uiRoot);

                            matcher_value_equal(panel.calculatedSize.width, 1000 - 100 - 150);
                        });
                        it("it should be the width of the parent minus the left and right offset from the parent calculated from %", function() {
                            panel.sizeProperties.position.left = 0.2;
                            panel.sizeProperties.position.right = 0.25;

                            ui_calculate_element_size(panel, uiRoot);

                            matcher_value_equal(panel.calculatedSize.width, 1000 - 200 - 250);
                        });
                        it("by being a percentage of the size of the parent", function() {
                            panel.sizeProperties.width = 0.4;

                            ui_calculate_element_size(panel, uiRoot);

                            matcher_value_equal(panel.calculatedSize.width, 400);
                        });
                        it("width will be calculated width or border+padding size, which ever is larger", function() {
                            // 40% of 1000 is 400, but with padding and border adding up to 100% total size will be 100% of 1000
                            panel.sizeProperties.width = 0.4;
                            panel.sizeProperties.border.left = 0.2;
                            panel.sizeProperties.border.right = 0.2;
                            panel.sizeProperties.padding.left = 0.3;
                            panel.sizeProperties.padding.right = 0.3;

                            ui_calculate_element_size(panel, uiRoot);

                            matcher_value_equal(panel.calculatedSize.width, 1000);
                        });
                    });
                });
            });
        })
    ];
}