tag_script(struct_test, [TAG_UNIT_TEST_SPEC]);
function struct_test() {
    return [
        describe("struct test", function() {
            it("struct handles can be converted", function() {
                var _a = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};
                var _b = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};
                var _c = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};
                var _d = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};

                show_debug_message($"struct test int: a:{int64(ptr(_a))} b{is_ptr(_a)} c{int64(_c)} d{int64(_d)}");
            });
        })
    ];
}