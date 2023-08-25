function mech_testing_data_get() {
    static testData = [
        new MechComponentData("TestTwoByThree", 2, 3, [new Vec2(0,0), new Vec2(1,0), new Vec2(0,2), new Vec2(1,2)]),
    ];

    return testData;
}