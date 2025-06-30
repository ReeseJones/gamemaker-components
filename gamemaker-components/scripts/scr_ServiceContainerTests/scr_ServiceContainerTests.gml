function EmptyTestConstructor() constructor {
    mango = false;
}

function ComplexTestConstructor(_stuffConst, _secondOption) constructor {
     // Feather disable GM2017
    mango = false;
    stuffConst = _stuffConst;
    testMethod = method(self, _secondOption);
    // Feather restore GM2017

    static doStuff = function() {
        mango = stuffConst;
    }
}

function TestConstructorA(_b) constructor {
    b = _b;
    ///@returns {String}
    static toString = function to_string() {
        return "A in the house. Bs text is: " + b.toString();
    }
}

function TestConstructorB(_c) constructor {
    c = _c
    
    ///@returns {String}
    static toString = function to_string() {
        return " I am B and Cs text is:" + c.toString();
    }
}

function TestConstructorC(_text) constructor {
    // Feather disable once GM2017
    myText = _text;
    
    ///@returns {String}
    static toString = function to_string() {
        return myText;
    }
}

tag_asset(service_container_tests, [TAG_UNIT_TEST_SPEC]);
function service_container_tests() {
    return [
        describe("ServiceContainer", function() {
            it("should be able to bind a value and retrieve it", function(){
                var _serviceContainer = new ServiceContainer();
                
                _serviceContainer.value("myValue", 4);
                
                var _val = _serviceContainer.get("myValue");
                matcher_value_equal(_val, 4);
            });
            it("should be able to bind a value to objects and return the same one", function() {
                var _serviceContainer = new ServiceContainer();
                var _testObj = {testObj: ""};
                _serviceContainer.value("myValue", _testObj);
                
                var _val = _serviceContainer.get("myValue");
                matcher_value_equal(_testObj, _val);
            });
            it("should be able to instantiate constructors", function() {
                var _serviceContainer = new ServiceContainer();

                _serviceContainer.service("myService", EmptyTestConstructor, []);
                
                var _val = _serviceContainer.get("myService");
                matcher_is_instanceof(_val, EmptyTestConstructor);
                matcher_value_equal(_val.mango, false);
            });
            it("should be able to instantiate constructors with complicated bindings", function() {
                var _serviceContainer = new ServiceContainer();
                _serviceContainer.value("stuffConst", true);
                _serviceContainer.value("doStuff", function() { myParam = "set"; });
                _serviceContainer.service("myService", ComplexTestConstructor, ["stuffConst", "doStuff"]);
                
                var _val = _serviceContainer.get("myService");
                matcher_is_instanceof(_val, ComplexTestConstructor);
                matcher_value_equal(_val.mango, false);
                _val.doStuff();
                matcher_value_equal(_val.mango, true);
                _val.testMethod();
                matcher_value_equal(_val.myParam, "set");
            });
            it("should be able to get values with deep dependencies", function() {
                var _serviceContainer = new ServiceContainer();
                _serviceContainer.value("neat_text", "Reese Is Cool");
                _serviceContainer.service("serviceA", TestConstructorA, ["serviceB"]);
                _serviceContainer.service("serviceB", TestConstructorB, ["serviceC"]);
                _serviceContainer.service("serviceC", TestConstructorC, ["neat_text"]);
                
                var _val = _serviceContainer.get("serviceA");
                matcher_is_instanceof(_val, TestConstructorA);
                var _printedText = _val.toString();
                matcher_value_equal(_printedText, "A in the house. Bs text is:  I am B and Cs text is:Reese Is Cool");
            });
            it("should only make one instance of each service", function() {
                var _serviceContainer = new ServiceContainer();
                _serviceContainer.value("neat_text", "Reese Is Cool");
                _serviceContainer.service("serviceA", TestConstructorA, ["serviceB"]);
                _serviceContainer.service("serviceB", TestConstructorB, ["serviceC"]);
                _serviceContainer.service("serviceC", TestConstructorC, ["neat_text"]);
                
                var _c = _serviceContainer.get("serviceC");
                var _a = _serviceContainer.get("serviceA");
                var _b = _serviceContainer.get("serviceB");

                matcher_value_equal(_b, _a.b);
                matcher_value_equal(_c, _b.c);
                matcher_is_instanceof(_a, TestConstructorA)
                matcher_is_instanceof(_b, TestConstructorB)
                matcher_is_instanceof(_c, TestConstructorC)
            });
            it("factory method should be called and the result saved", function() {
                var _serviceContainer = new ServiceContainer();
                _serviceContainer.value("name", "Reese");
                _serviceContainer.value("qualifier", "Is Cool");
                _serviceContainer.factory("stringVal", function(_name, _qual){
                    return _name + _qual;
                }, ["name", "qualifier"]);
                
                var _str = _serviceContainer.get("stringVal");
                var _name = _serviceContainer.get("name");
                var _qual = _serviceContainer.get("qualifier");

                matcher_value_equal(_str, _name + _qual);
            });
            it("if a service is requested that is not registered it throws", function() {
                var _serviceContainer = new ServiceContainer();
                _serviceContainer.value("name", "Reese");
                _serviceContainer.value("qualifier", "Is Cool");
                _serviceContainer.factory("stringVal", function(_name, _qual){
                    return _name + _qual;
                }, ["name", "qualifier"]);

                myTestServiceContainer = _serviceContainer;

                matcher_should_throw(function() {
                    myTestServiceContainer.get("nonExistant");
                });
            });
            it("if a value is already registered it throws", function() {
                myTestServiceContainer = new ServiceContainer();
                matcher_should_throw(function() {
                    myTestServiceContainer.value("name", "Reese");
                    myTestServiceContainer.value("name", "Reese");
                });
            });
            it("if a service is already registered it throws", function() {
                myTestServiceContainer = new ServiceContainer();
                matcher_should_throw(function() {
                    myTestServiceContainer.service("myService", EmptyTestConstructor, []);
                    myTestServiceContainer.service("myService", EmptyTestConstructor, []);
                });
            });
            it("if a factory is already registered it throws", function() {
                myTestServiceContainer = new ServiceContainer();
                matcher_should_throw(function() {
                    var _facMethod = function(){ return true };
                    
                    myTestServiceContainer.factory("myService", _facMethod, []);
                    myTestServiceContainer.factory("myService", _facMethod, []);
                });
            });
            it("should make a new instance if scope is transient", function() {
                var _serviceContainer = new ServiceContainer();
                _serviceContainer.value("neat_text", "Reese Is Cool");
                _serviceContainer.service("serviceA", TestConstructorA, ["serviceB"]).inTransientScope();
                _serviceContainer.service("serviceB", TestConstructorB, ["serviceC"]);
                _serviceContainer.service("serviceC", TestConstructorC, ["neat_text"]).inTransientScope();
                
                var _a = _serviceContainer.get("serviceA");
                var _a2 = _serviceContainer.get("serviceA");
                var _b = _serviceContainer.get("serviceB");
                var _c = _serviceContainer.get("serviceC");
                
                
                matcher_is_true(_a != _a2);
                matcher_value_equal(_b, _a.b);
                matcher_value_equal(_b, _a2.b);
                matcher_is_true(_c != _b.c);
                matcher_is_true(_a.b.c = _a2.b.c);
                matcher_is_instanceof(_a, TestConstructorA)
                matcher_is_instanceof(_b, TestConstructorB)
                matcher_is_instanceof(_c, TestConstructorC)
            });
        })
    ];
}

