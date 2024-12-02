disposeableManager = new DisposableManager();
disposeFunc = method(disposeableManager, disposeableManager.disposeFunc);

weaponAttributes = new WeaponAttributes();
style = new WeaponStyle();

state1 = new WeaponState();
state2 = new WeaponState();

disposeableManager.registerDisposable(state1);
disposeableManager.registerDisposable(state2);



