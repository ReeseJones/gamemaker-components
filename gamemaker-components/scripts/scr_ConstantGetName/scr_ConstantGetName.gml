/// @param {Constant.AssetType} _assetType
function asset_type_get_name(_assetType) {
    switch(_assetType) {
        case asset_object: return "object";
        case asset_sprite: return "sprite";
        case asset_sound: return "sound";
        case asset_room: return "room";
        case asset_tiles: return "tiles";
        case asset_path: return "path";
        case asset_script: return "script";
        case asset_font: return "font";
        case asset_timeline: return "timeline";
        case asset_shader: return "shader";
        case asset_animationcurve: return "animationcurve";
        case asset_sequence: return "sequence";
        case asset_particlesystem: return "particlesystem";
        default: return "unknown";
    }
}