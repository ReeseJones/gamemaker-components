function TestItem () constructor {}
function TestPotion () : TestItem () constructor {}

function TestOnlyItem () constructor {
    static testString = "testABC";
}

function TestOnlyPotion () : TestOnlyItem () constructor {
    static testString = "test123";
}

tag_script(game_maker_tests, [TAG_UNIT_TEST_SPEC]);
function game_maker_tests() {
    return [
        describe("GameMaker", function() {
            before_each(function() {

            });
            after_each(function() {

            });
            describe("Static Structs", function() {
                it("have their own static struct", function() {
                    var _potion = new TestOnlyItem();
                    var _staticPotion = static_get(TestOnlyPotion);

                    matcher_value_equal(static_get(TestOnlyItem) == static_get(_staticPotion), false);
                });
                it("can override static struct properties", function() {
                    var _staticPotion = static_get(TestOnlyPotion);
                    var _staticItem = static_get(TestOnlyItem);
                    
                    var _potion = new TestOnlyPotion();
                    var _item = new TestOnlyItem();

                    matcher_value_equal(_potion.testString == _item.testString, false);
                });
                it("can be added to a parent and inherited on a child", function() {
                    var _staticPotion = static_get(TestOnlyPotion);
                    var _staticItem = static_get(TestOnlyItem);
                    
                    _staticItem.testAdd ="newProp";

                    var _newPotion = new TestOnlyPotion();
                    matcher_value_equal(_newPotion.testAdd == _staticItem.testAdd, true);
                });
                it("inheriting from empty constructors result in same static ref", function(){
                    var _potion = new TestPotion();
                    var _staticPotion = static_get(TestPotion);

                    var _result = static_get(TestItem) == static_get(_staticPotion);
                    matcher_value_equal(_result, true);
                });
            });
        })
    ];
}

