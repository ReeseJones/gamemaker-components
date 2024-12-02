global.particleShapes = [
    $"pt_shape_pixel:{pt_shape_pixel}",
    $"pt_shape_disk:{pt_shape_disk}",
    $"pt_shape_square:{pt_shape_square}",
    $"pt_shape_line:{pt_shape_line}",
    $"pt_shape_star:{pt_shape_star}",
    $"pt_shape_circle:{pt_shape_circle}",
    $"pt_shape_ring:{pt_shape_ring}",
    $"pt_shape_sphere:{pt_shape_sphere}",
    $"pt_shape_flare:{pt_shape_flare}",
    $"pt_shape_spark:{pt_shape_spark}",
    $"pt_shape_explosion:{pt_shape_explosion}",
    $"pt_shape_cloud:{pt_shape_cloud}",
    $"pt_shape_smoke:{pt_shape_smoke}",
    $"pt_shape_snow:{pt_shape_snow}",
];

/// @param {Constant.ParticleShape} _particleShape
function particle_shape_get_name(_particleShape) {
    switch(_particleShape) {
        case pt_shape_pixel: return "pt_shape_pixel";
        case pt_shape_disk: return "pt_shape_disk";
        case pt_shape_square: return "pt_shape_square";
        case pt_shape_line: return "pt_shape_line";
        case pt_shape_star: return "pt_shape_star";
        case pt_shape_circle: return "pt_shape_circle";
        case pt_shape_ring: return "pt_shape_ring";
        case pt_shape_sphere: return "pt_shape_sphere";
        case pt_shape_spark: return "pt_shape_spark";
        case pt_shape_explosion: return "pt_shape_explosion";
        case pt_shape_cloud: return "pt_shape_cloud";
        case pt_shape_smoke: return "pt_shape_smoke";
        case pt_shape_snow: return "pt_shape_snow";
        default: return "unknown";
    }
}