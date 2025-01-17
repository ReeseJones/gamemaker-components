function difficulty_curve(_x) {
    // Starts at 0 and has 5 increasing peaks towards 1
    return _x + (sin(8*pi*_x) / 7);
}