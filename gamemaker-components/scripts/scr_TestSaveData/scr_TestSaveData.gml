tag_script(test_save_data_tests, [TAG_UNIT_TEST_SPEC]);
function test_save_data_tests() {
    return [
        describe("game save data", function() {
            before_each(function(){
                componentList = [
                    new MechComponentData("doodad01", 2, 3, spr_mech_doodad01, [new Vec2(0,0), new Vec2(1,0), new Vec2(0,2), new Vec2(1,2)]),
                    new MechComponentData("doodad02", 4, 1, spr_mech_doodad02, [new Vec2(0,0), new Vec2(3,0)]),
                    new MechComponentData("doodad03", 4, 4, spr_mech_doodad03, [new Vec2(0,0), new Vec2(1,0), new Vec2(2,0), new Vec2(3,0), new Vec2(0,1), new Vec2(3,1), new Vec2(0,2), new Vec2(3,2), new Vec2(0,3), new Vec2(1,3), new Vec2(2,3), new Vec2(3,3)]),
                    new MechComponentData("doodad04", 1, 1, spr_mech_doodad04, [new Vec2(0,0)]),
                    new MechComponentData("doodad05", 2, 2, spr_mech_doodad05, [new Vec2(0,1), new Vec2(1,1)]),
                    new MechComponentData("doodad06", 5, 5, spr_mech_doodad06, [new Vec2(4,0), new Vec2(0,1), new Vec2(0,2), new Vec2(0,3), new Vec2(4,4)]),
                ];
            });

            it("should be able to save component data json", function() {
                var _fileName = file_get_save_directory() + "test.json";
                var _openFile = file_text_open_write(_fileName);
                
                var _text = json_stringify(componentList, true);
                file_text_write_string(_openFile, _text);
                file_text_writeln(_openFile);
                file_text_close(_openFile);
                
                matcher_is_true(file_exists(_fileName));
            });

            it("will remove and restore struct prototype", function() {
                var _fileName = file_get_save_directory() + "test.json";
                var _openFile = file_text_open_write(_fileName);

                var _text = json_serialize(componentList, true);
                file_text_write_string(_openFile, _text);
                file_text_writeln(_openFile);
                file_text_close(_openFile);

                var _parsed = file_json_read(_fileName);
                matcher_is_array(_parsed);
                matcher_is_instanceof(_parsed[0], MechComponentData);
            });
        })
    ];
}