drawDebugOverlay = !drawDebugOverlay;
show_debug_overlay(drawDebugOverlay, true, 2);

if(drawDebugOverlay && is_undefined(particleManagerView)) {
    particleManagerView = new ParticleManagerEditorGui(debugViewManager, particleTypeManager);
    debugViewManager.manageView("Particle Manager", particleManagerView, false);
}
