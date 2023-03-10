tag_script(world_tests, [TAG_UNIT_TEST_SPEC]);
function world_tests() {
    return [
    describe("Worlds", function() {
        before_each(function() {
            timeProvider = {
                getDeltaSeconds: function() {
                    return 0.1
                }
            };

            logger = new LoggingService();
            logWarningSpy = spy_on(logger, "logWarning");

            timeManager = new WorldTimeManager(timeProvider);

            testSystem = new ComponentSystem();
            rectangleSizingSystem = new RectangleSizingSystem();
            testSystemStartSpy = spy_on(testSystem, "systemStart");
            rectSystemStartSpy = spy_on(rectangleSizingSystem, "systemStart");

            systems = [testSystem, rectangleSizingSystem];
        });

        describe("Creation: ", function() {
            it("World systems have their systemStart method called.", function() {
                var _world = new World(timeManager, systems, logger);
                testSystemStartSpy.toBeCalled();
                testSystemStartSpy.toBeCalledWith();
                _world.cleanup();
            });
        });
        describe("", function() {
            before_each(function() {
                world = new World(timeManager, systems, logger);
            });
            after_each(function() {
                world.cleanup();
            });
            describe("addComponent: ", function() {
                it("will log a warning if you try and add a component to something that doesnt exist.", function() {
                    var _badId = 1337;
                    world.addComponent(_badId, "component");
                    logWarningSpy.toBeCalledWith(LOG_LEVEL.IMPORTANT, "Tried to add component '", "component", "' to non existant instance with id: ", _badId);
                });
                it("should add the component", function() {
                    var _entityId = 1337;
                    var _newEntity = world.createEntity(_entityId);
                    world.addComponent(_entityId, "component");
                    matcher_struct_property_exists(_newEntity.component, "component");
                });
                it("should throw if your try and add a duplicate component", function() {
                    var _newEntity = world.createEntity(1337);
                    world.addComponent(1337, "component");
                    matcher_should_throw(function() {
                        world.addComponent(1337, "component");
                    });
                });
            });
            describe("destroyComponent: ", function() {
                it("Will log a warning if you try to remove a component from a non existant entity",
                function() {
                    world.destroyComponent(1337, "component");
                    logWarningSpy.toBeCalled();
                });
                it("should immediately mark the component for descruction", function() {
                    var _eId = 1337;
                    var _newEntity = world.createEntity(_eId);
                    var _comp = world.addComponent(_eId, "component");

                    matcher_struct_property_exists(_newEntity.component, "component");

                    world.destroyComponent(_eId, "component");

                    matcher_is_true(_comp.componentIsDestroyed);
                    matcher_is_false(_comp.visible);
                    matcher_is_false(_comp.enabled);
                });
                it("should immediately call the systems destroy method with the component as a parameter", function() {
                    var _eId = 1337;
                    var _destroySpy = spy_on(testSystem, "destroy");
                    var _newEntity = world.createEntity(_eId);
                    var _comp = world.addComponent(_eId, "component");

                    world.destroyComponent(_eId, "component");

                    _destroySpy.toBeCalledWith(_comp);
                });
            });
            describe("createEntity", function() {
                it("short hand for creating new Entity and registring it", function() {
                    var _ent = world.createEntity(1337);
                    matcher_is_instanceof(_ent, Entity);
                    var _entExists = world.entityExists(1337);
                    matcher_is_true(_entExists);
                });
                it("throws if entity with id exists already", function() {
                    var _ent = world.createEntity(1337);

                    matcher_should_throw(function() {
                        world.createEntity(1337);
                    });
                });
            });
            describe("destroyEntity", function() {
                it("will log a warning if the entity does not exist", function() {
                    world.destroyEntity(1337);
                    logWarningSpy.toBeCalled();
                });
                it("will mark all components for removal", function() {
                    var _compRemoveSpy = spy_on(testSystem, "removeComponent", true);
                    var _rectRemoveSpy = spy_on(rectangleSizingSystem, "removeComponent", true);
                    var _entity = world.createEntity(1337);
                    world.addComponent(1337, "component");
                    world.addComponent(1337, "rectangleSizing");
                    world.destroyEntity(1337);

                    _compRemoveSpy.toBeCalledWith(_entity);
                    _rectRemoveSpy.toBeCalledWith(_entity);
                });
                it("will mark the instance for removal", function() {
                    var _sysSpy = spy_on(testSystem, "removeComponent", true);
                    var _entity = world.createEntity(1337);
                    world.destroyEntity(1337);

                    matcher_is_true(_entity.entityIsDestroyed);
                    matcher_array_contains(world.instanceRemoveQueue, 1337);
                });
            });
            describe("getRef", function() {
                it("will return the instance if it exists", function() {
                    var _ent = world.createEntity(1337);
                    
                    matcher_value_equal(world.getRef(1337), _ent);
                });
                it("will return undefined if it does not", function() {
                    matcher_value_equal(world.getRef(1337), undefined);
                });
            });
            describe("entityIsAlive", function() {
                it("it will return false if the entity does not exist", function() {
                    matcher_value_equal(world.entityIsAlive(1337), false);
                });
                it("it will return false if the entity is marked for destruction", function() {
                    world.createEntity(1337);
                    world.destroyEntity(1337);
                    matcher_value_equal(world.entityIsAlive(1337), false);
                });
                it("it will return true if the entity is not marked for destruction", function() {
                    world.createEntity(1337);
                    matcher_value_equal(world.entityIsAlive(1337), true);
                });
            });
            describe("entityExists", function() {
                it("it will return false if the entity does not exist", function() {
                    matcher_value_equal(world.entityExists(1337), false);
                });
                it("it will return true if the entity exisits", function() {
                    world.createEntity(1337);
                    matcher_value_equal(world.entityExists(1337), true);
                });
                it("it will return true if the entity exisits even if marked for desctruction", function() {
                    world.createEntity(1337);
                    world.destroyEntity(1337);
                    matcher_value_equal(world.entityExists(1337), true);
                });
            });
            describe("registerEntity", function() {
                it("it will throw if no id is provided.", function() {
                    matcher_should_throw(function(){
                        world.registerEntity({}, undefined);
                    })
                });
                it("it will throw if the id is already in use.", function() {
                    world.registerEntity({}, 1337);
                    matcher_should_throw(function(){
                        world.registerEntity({}, 1337);
                    })
                });
                it("it should register the entity to the world instances list.", function() {
                    var _ent = {};
                    world.registerEntity(_ent, 1337);
                    var _testEnt = world.getRef(1337);
                    matcher_value_equal(_ent, _testEnt);
                });
            });
            describe("removeDestroyedEntities", function() {
                it("it should remove destroyed entities from the world.", function() {
                    var _entId = 1337;
                    var _ent1 = world.createEntity(_entId);
                    
                    world.destroyEntity(_entId);
                    world.removeDestroyedEntities();
                    
                    matcher_is_false(world.entityExists(_entId));
                });
                it("entity should have no components.", function() {
                    var _ent1 = world.createEntity(1);
                    
                    world.destroyEntity(1);
                    world.removeDestroyedEntities();
                    
                    matcher_value_equal(_ent1.component, undefined); 
                });
                it("entity should have no world.", function() {
                    var _ent1 = world.createEntity(1);
                    
                    world.destroyEntity(1);
                    world.removeDestroyedEntities();
                    
                    matcher_value_equal(_ent1.world, undefined); 
                });
            });
            describe("step", function() {
                before_each(function(){
                    testSystemStepSpy = spy_on(testSystem, "systemStep");
                    rectSystemStepSpy = spy_on(rectangleSizingSystem, "systemStep");
                });
                
                it("should not progress world if timeManager does not increment step", function() {
                    var _stepClockSpy = spy_on(timeManager, "stepClock").andReturn(false);
                    var _removeDestroyedEntitiesSpy = spy_on(world, "removeDestroyedEntities", true);
                    
                    world.step();
                    
                    _removeDestroyedEntitiesSpy.toBeCalledTimes(0);
                });
                 it("should call removeDestroyedEntities", function() {
                    var _stepClockSpy = spy_on(timeManager, "stepClock").andReturn(true);
                    var _removeDestroyedEntitiesSpy = spy_on(world, "removeDestroyedEntities", true);
                    
                    world.step();
                    
                    _removeDestroyedEntitiesSpy.toBeCalled();
                });
                it("should call system step events", function() {
                    var _stepClockSpy = spy_on(timeManager, "stepClock").andReturn(true);
                    
                    world.step();

                    testSystemStepSpy.toBeCalled();
                    rectSystemStepSpy.toBeCalled();
                });
                it("should call not call system step events on disabled systems", function() {
                    var _stepClockSpy = spy_on(timeManager, "stepClock").andReturn(true);
                    testSystem.enabled = false;
                    
                    world.step();
                    
                    testSystemStepSpy.toBeCalledTimes(0);
                    rectSystemStepSpy.toBeCalled();
                });
            });
        });
        describe("cleanup", function() {
            before_each(function() {
                world = new World(timeManager, systems, logger);
            });
            after_each(function() {
                world.cleanup();
            });
            it("can cleanup world multiple times", function() {
                world.cleanup();
                world.cleanup();
            });
            it("should call system cleanup for all systems", function() {
                var _clean1 = spy_on(testSystem, "systemCleanup");
                var _clean2 = spy_on(rectangleSizingSystem, "systemCleanup");
                
                world.cleanup();
                
                _clean1.toBeCalled();
                _clean2.toBeCalled();
            });
            it("should call cleanComponentList for all systems", function() {
                var _clean1 = spy_on(testSystem, "cleanComponentList");
                var _clean2 = spy_on(rectangleSizingSystem, "cleanComponentList");
                
                world.cleanup();
                
                _clean1.toBeCalled();
                _clean2.toBeCalled();
            });
            it("should cleanup all registered entities", function() {
                for(var i = 0; i < 100; i += 1 ) {
                    world.createEntity(i);
                }
                
                world.cleanup();
                
                matcher_is_false(ds_exists(world.instances, ds_type_map));
            });
        });
    })];
}