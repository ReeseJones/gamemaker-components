struct_save_static(nameof(Boid), Boid);
function Boid() constructor {
    position = new Vec2();
    velocity = new Vec2();
}

struct_save_static(nameof(BoidSteeringProperties), BoidSteeringProperties);
function BoidSteeringProperties() constructor {
    maxSpeed = 2;
    maxForce = 0.03;
    viewRadius = 75;
    seperationDistance = 55;
    alignmentDistance = 70;

    weightForward = 1;
    weightCohesion = 0.4;
    weightSeparation = 1.4;
    weightAlignment = 0.7;
}