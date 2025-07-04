tag_asset(test_command_line_parameters_tests, [TAG_UNIT_TEST_SPEC]);
function test_command_line_parameters_tests() {
    return [
        describe("Command Line Parser", function() {
            before_each(function() {
                testLogger = new LoggingService();
                paramsRetriever = new ManualCmdLineParamsRetriever([]);
            });
            it("tim=3 should result in param with real value 3", function() {
                paramsRetriever.params = [
                    "C:/file/path/here",
                    "tim=3"
                ];

                paramsParser = new CmdLineParamsParser(testLogger, paramsRetriever);
                matcher_value_equal(paramsParser.launchParams.tim, 3);
            });
            it("tim=\"a longer sentance\" should result in param with string value \"a longer sentance\"", function() {
                paramsRetriever.params = [
                    "C:/file/path/here",
                    "tim=\"a longer sentance\""
                ];

                paramsParser = new CmdLineParamsParser(testLogger, paramsRetriever);
                matcher_value_equal(paramsParser.launchParams.tim, "a longer sentance");
            });
            it("tim=True should result in param with boolean value true", function() {
                paramsRetriever.params = [
                    "C:/file/path/here",
                    "tim=True"
                ];

                paramsParser = new CmdLineParamsParser(testLogger, paramsRetriever);
                matcher_value_equal(paramsParser.launchParams.tim, true);
            });
            it("boolean params are case insensitive", function() {
                paramsRetriever.params = [
                    "C:/file/path/here",
                    "tim=TruE",
                    "otherParam=fALSE"
                ];

                paramsParser = new CmdLineParamsParser(testLogger, paramsRetriever);
                matcher_value_equal(paramsParser.launchParams.tim, true);
                matcher_value_equal(paramsParser.launchParams.otherParam, false);
            });
            it("params may be set to undefined", function() {
                paramsRetriever.params = [
                    "C:/file/path/here",
                    "otherParam=undefined"
                ];

                paramsParser = new CmdLineParamsParser(testLogger, paramsRetriever);
                matcher_is_undefined(paramsParser.launchParams.otherParam);
            });
            it("params without equal signs are interpreted as flags", function() {
                paramsRetriever.params = [
                    "C:/file/path/here",
                    "otherParam"
                ];

                paramsParser = new CmdLineParamsParser(testLogger, paramsRetriever);
                matcher_is_true(paramsParser.launchParams.otherParam);
            });
            it("if weird spaces are in it the whole thing is treated like a flag", function() {
                paramsRetriever.params = [
                    "C:/file/path/here",
                    "other Param here"
                ];

                paramsParser = new CmdLineParamsParser(testLogger, paramsRetriever);
                matcher_is_true(paramsParser.launchParams[$"other Param here"]);
            });
        })
    ];
}