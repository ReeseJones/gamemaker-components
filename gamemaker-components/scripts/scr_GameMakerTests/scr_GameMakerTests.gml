
tag_script(game_maker_tests, [TAG_UNIT_TEST_SPEC]);
function game_maker_tests() {
    return [
        describe("GameMaker", function() {
            before_each(function() {

            });
            after_each(function() {

            });
            it(" Functions can have properties", function() {
                testText = "I am a property on a function";
                testFunc = function() {};
                testFunc.newVar = testText;
                testFunc();
            });
        })
    ];
}

