tag_asset(struct_test, [TAG_UNIT_TEST_SPEC]);
function struct_test() {
    return [
        describe("struct test", function() {
            it("struct handles can be converted", function() {
                var _a = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};
                var _b = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};
                var _c = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};
                var _d = {a: { b: "c"}, d: 0, e: ["", 90, { tim: "likes food"}, ["this", 1]]};

                //Note: Struct refs must be cast to ptr before int64 casts
                var _int64OfPtrA = int64(ptr(_a));
                var _bIsPointer = is_ptr(_b);
                var _int64OfC = int64(ptr(_c));
                var _int64OfD = int64(ptr(_d));
                show_debug_message($"struct test int: a:{_int64OfPtrA} b{_bIsPointer} c{_int64OfC} d{_int64OfD}");
            });
        })
    ];
}