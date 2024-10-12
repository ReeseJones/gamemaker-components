struct_save_static(nameof(Boid), Boid);
function Boid() constructor {
    position = new Vec2();
    velocity = new Vec2();
}

function BoidSteeringProperties() constructor {
    maxSpeed = 2;
    maxForce = 0.03;
    viewRadius = 100;
    seperationDistance = 50;
    alignmentDistance = 80;

    weightForward = 1;
    weightCohesion = 1.5;
    weightSeparation = 1;
    weightAlignment = 1;
}