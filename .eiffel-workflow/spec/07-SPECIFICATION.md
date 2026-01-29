# SPECIFICATION: simple_physics

## Overview
Type-safe 3D rigid body physics engine with Design by Contract verification. Provides RK4 integration for numerical simulation, sphere-sphere collision detection and impulse-based resolution, and energy computation. Optimized for scientific computing and education with full Eiffel type safety and concurrent SCOOP compatibility.

## Class Specifications

### SIMPLE_PHYSICS (Facade)

```eiffel
note
    description: "Facade for physics library. Single entry point."
    author: "Larry Rix"

class
    SIMPLE_PHYSICS

create
    make

feature {NONE} -- Initialization

    make
            -- Create uninitialized instance (no gravity set yet).
        do
            gravity := 0.0
            -- world remains Void until create_world
        ensure
            world_void: world = Void
            gravity_zero: gravity = 0.0
        end

feature -- Configuration

    set_gravity (a_gravity: REAL_64): like Current
            -- Set global gravity acceleration (e.g., 9.81 for Earth).
        require
            gravity_non_negative: a_gravity >= 0.0
        do
            gravity := a_gravity
            Result := Current
        ensure
            gravity_set: gravity = a_gravity
            result_current: Result = Current
        end

feature -- World Creation

    create_world: PHYSICS_WORLD
            -- Create new physics world with configured gravity.
        require
            gravity_configured: gravity >= 0.0
        do
            create Result.make (create {VECTOR_3D}.make (0.0, -gravity, 0.0))
            world := Result
        ensure
            result_not_void: Result /= Void
            world_set: world = Result
        end

feature -- Access

    world: detachable PHYSICS_WORLD
            -- Active physics world (may be Void if not yet created).

feature {NONE} -- Implementation

    gravity: REAL_64
            -- Global gravity magnitude (positive downward in -y direction).

end
```

### VECTOR_3D (Data)

```eiffel
note
    description: "Immutable 3D vector for positions, velocities, forces."
    author: "Larry Rix"

class
    VECTOR_3D

create
    make, zero

feature -- Creation

    make (a_x, a_y, a_z: REAL_64)
            -- Create vector with given components.
        do
            x := a_x
            y := a_y
            z := a_z
        ensure
            x_set: x = a_x
            y_set: y = a_y
            z_set: z = a_z
        end

    zero: VECTOR_3D
            -- Create zero vector.
        do
            create Result.make (0.0, 0.0, 0.0)
        ensure
            x_zero: Result.x = 0.0
            y_zero: Result.y = 0.0
            z_zero: Result.z = 0.0
        end

feature -- Access

    x, y, z: REAL_64
            -- Vector components.

    magnitude: REAL_64
            -- Vector length ||v|| = sqrt(x² + y² + z²).
        do
            Result := (x * x + y * y + z * z).sqrt
        ensure
            non_negative: Result >= 0.0
        end

feature -- Arithmetic Operations

    add (a_other: VECTOR_3D): VECTOR_3D
            -- Element-wise addition: this + other.
        require
            other_not_void: a_other /= Void
        do
            create Result.make (x + a_other.x, y + a_other.y, z + a_other.z)
        ensure
            result_x: Result.x = x + a_other.x
            result_y: Result.y = y + a_other.y
            result_z: Result.z = z + a_other.z
        end

    subtract (a_other: VECTOR_3D): VECTOR_3D
            -- Element-wise subtraction: this - other.
        require
            other_not_void: a_other /= Void
        do
            create Result.make (x - a_other.x, y - a_other.y, z - a_other.z)
        ensure
            result_x: Result.x = x - a_other.x
            result_y: Result.y = y - a_other.y
            result_z: Result.z = z - a_other.z
        end

    scale (a_scalar: REAL_64): VECTOR_3D
            -- Scalar multiplication: this * scalar.
        do
            create Result.make (x * a_scalar, y * a_scalar, z * a_scalar)
        ensure
            result_x: Result.x = x * a_scalar
            result_y: Result.y = y * a_scalar
            result_z: Result.z = z * a_scalar
        end

feature -- Dot and Cross Products

    dot_product (a_other: VECTOR_3D): REAL_64
            -- Dot product: this · other = x₁x₂ + y₁y₂ + z₁z₂.
        require
            other_not_void: a_other /= Void
        do
            Result := x * a_other.x + y * a_other.y + z * a_other.z
        ensure
            -- Result has semantic meaning as projection length
        end

    cross_product (a_other: VECTOR_3D): VECTOR_3D
            -- Cross product: this × other (perpendicular to both).
        require
            other_not_void: a_other /= Void
        do
            create Result.make (
                y * a_other.z - z * a_other.y,
                z * a_other.x - x * a_other.z,
                x * a_other.y - y * a_other.x
            )
        ensure
            result_not_void: Result /= Void
        end

feature -- Normalization

    normalize: VECTOR_3D
            -- Return unit vector in same direction (magnitude = 1).
        require
            not_zero: magnitude > 0.0001
        do
            Result := scale (1.0 / magnitude)
        ensure
            result_magnitude_one: abs(Result.magnitude - 1.0) < 0.001
        end

end
```

### PHYSICS_BODY (Data)

```eiffel
note
    description: "Rigid body with mass, position, velocity."
    author: "Larry Rix"

class
    PHYSICS_BODY

create
    make, make_static

feature -- Creation

    make (a_mass, a_radius: REAL_64; a_position: VECTOR_3D)
            -- Create dynamic body.
        require
            mass_positive: a_mass > 0.0
            radius_positive: a_radius > 0.0
            position_not_void: a_position /= Void
        do
            mass := a_mass
            radius := a_radius
            position := a_position
            create velocity.zero
            body_type := create {BODY_TYPE}.dynamic
            id := next_id
            next_id := next_id + 1
        ensure
            mass_set: mass = a_mass
            radius_set: radius = a_radius
            position_set: position = a_position
            velocity_zero: velocity.x = 0.0 and velocity.y = 0.0 and velocity.z = 0.0
            is_dynamic: body_type.is_dynamic
        end

    make_static (a_radius: REAL_64; a_position: VECTOR_3D)
            -- Create static (immovable) body.
        require
            radius_positive: a_radius > 0.0
            position_not_void: a_position /= Void
        do
            mass := 1000000.0  -- Very large mass
            radius := a_radius
            position := a_position
            create velocity.zero
            body_type := create {BODY_TYPE}.static
            id := next_id
            next_id := next_id + 1
        ensure
            radius_set: radius = a_radius
            position_set: position = a_position
            velocity_zero: velocity.x = 0.0 and velocity.y = 0.0
            is_static: body_type.is_static
        end

feature -- Properties

    id: INTEGER
            -- Unique identifier.

    mass: REAL_64
            -- Body mass (kilograms).

    radius: REAL_64
            -- Collision sphere radius.

    position: VECTOR_3D
            -- Center of mass position (meters).

    velocity: VECTOR_3D
            -- Linear velocity (m/s).

    body_type: BODY_TYPE
            -- STATIC or DYNAMIC.

feature -- Modification (during integration)

    set_position (a_position: VECTOR_3D)
            -- Update position to a_position.
        require
            position_not_void: a_position /= Void
        do
            position := a_position
        ensure
            position_updated: position = a_position
        end

    set_velocity (a_velocity: VECTOR_3D)
            -- Update velocity to a_velocity.
        require
            velocity_not_void: a_velocity /= Void
        do
            velocity := a_velocity
        ensure
            velocity_updated: velocity = a_velocity
        end

feature -- Energy Computation

    kinetic_energy: REAL_64
            -- Kinetic energy: KE = 0.5 * mass * ||velocity||².
        do
            Result := 0.5 * mass * (velocity.magnitude ^ 2)
        ensure
            non_negative: Result >= 0.0
        end

    potential_energy (a_gravity: REAL_64): REAL_64
            -- Potential energy: PE = mass * gravity * y_position.
        require
            gravity_non_negative: a_gravity >= 0.0
        do
            Result := mass * a_gravity * position.y
        ensure
            result_equals_formula: Result = mass * a_gravity * position.y
        end

invariant
    mass_positive: mass > 0.0
    radius_positive: radius > 0.0
    position_not_void: position /= Void
    velocity_not_void: velocity /= Void
    body_type_not_void: body_type /= Void

end
```

### PHYSICS_WORLD (Engine)

```eiffel
note
    description: "Container for bodies and orchestrator of physics simulation."
    author: "Larry Rix"

class
    PHYSICS_WORLD

create
    make

feature {NONE} -- Initialization

    make (a_gravity: VECTOR_3D)
            -- Create world with gravity vector.
        require
            gravity_not_void: a_gravity /= Void
        do
            gravity := a_gravity
            create {ARRAYED_LIST [PHYSICS_BODY]} bodies.make
            create {ARRAYED_LIST [COLLISION_INFO]} last_collisions.make
        ensure
            gravity_set: gravity = a_gravity
            bodies_empty: bodies.count = 0
        end

feature -- Body Management

    add_body (a_body: PHYSICS_BODY): like Current
            -- Add body to world.
        require
            body_not_void: a_body /= Void
            not_duplicate: not bodies.has (a_body)
        do
            bodies.force (a_body, bodies.count + 1)
            Result := Current
        ensure
            body_added: bodies.has (a_body)
            count_increased: bodies.count = old bodies.count + 1
            result_current: Result = Current
        end

    remove_body (a_body: PHYSICS_BODY): like Current
            -- Remove body from world.
        require
            body_not_void: a_body /= Void
            body_exists: bodies.has (a_body)
        do
            bodies.prune (a_body)
            Result := Current
        ensure
            body_removed: not bodies.has (a_body)
            count_decreased: bodies.count = old bodies.count - 1
            result_current: Result = Current
        end

    body_count: INTEGER
            -- Number of bodies in world.
        do
            Result := bodies.count
        ensure
            result_consistent: Result = bodies.count
        end

feature -- Simulation

    integrate_step (a_dt: REAL_64): PHYSICS_RESULT
            -- Advance simulation by time a_dt.
        require
            positive_dt: a_dt > 0.0
            dt_reasonable: a_dt <= 0.1
            has_bodies: bodies.count > 0
        do
            -- RK4 integration (implementation in Phase 4)
            -- Collision detection and resolution (implementation in Phase 4)
            create Result.make (bodies, last_collisions, a_dt,
                compute_total_kinetic_energy,
                compute_total_potential_energy)
        ensure
            result_not_void: Result /= Void
            body_count_unchanged: Result.bodies.count = bodies.count
        end

feature -- Forces

    apply_force_to_body (a_body: PHYSICS_BODY; a_force: VECTOR_3D)
            -- Accumulate force for next integration step.
        require
            body_in_world: bodies.has (a_body)
            force_not_void: a_force /= Void
        do
            -- Force accumulation (implementation in Phase 4)
        end

    set_gravity (a_gravity: VECTOR_3D): like Current
            -- Update gravity vector.
        require
            gravity_not_void: a_gravity /= Void
        do
            gravity := a_gravity
            Result := Current
        ensure
            gravity_updated: gravity = a_gravity
            result_current: Result = Current
        end

feature -- Queries

    total_kinetic_energy: REAL_64
            -- Sum of kinetic energy of all bodies.
        do
            Result := compute_total_kinetic_energy
        ensure
            non_negative: Result >= 0.0
        end

    total_potential_energy: REAL_64
            -- Sum of potential energy of all bodies.
        do
            Result := compute_total_potential_energy
        ensure
            result_valid: not Result.is_nan
        end

feature {NONE} -- Implementation

    gravity: VECTOR_3D
            -- Global gravity vector.

    bodies: LIST [PHYSICS_BODY]
            -- All bodies in simulation.

    last_collisions: LIST [COLLISION_INFO]
            -- Collisions from last integration step.

    compute_total_kinetic_energy: REAL_64
            -- Helper: sum of all body kinetic energies.
        do
            from bodies.start until bodies.exhausted loop
                Result := Result + bodies.item.kinetic_energy
                bodies.forth
            end
        end

    compute_total_potential_energy: REAL_64
            -- Helper: sum of all body potential energies.
        do
            from bodies.start until bodies.exhausted loop
                Result := Result + bodies.item.potential_energy (gravity.magnitude)
                bodies.forth
            end
        end

invariant
    gravity_not_void: gravity /= Void
    bodies_not_void: bodies /= Void
    all_bodies_valid: across bodies as b all b.item.mass > 0.0 end

end
```

### PHYSICS_RESULT (Data)

```eiffel
note
    description: "Immutable results from physics integration step."
    author: "Larry Rix"

class
    PHYSICS_RESULT

create
    make

feature {NONE} -- Initialization

    make (a_bodies: LIST [PHYSICS_BODY];
          a_collisions: LIST [COLLISION_INFO];
          a_step_time: REAL_64;
          a_kinetic_energy, a_potential_energy: REAL_64)
            -- Create result from integration data.
        do
            bodies := a_bodies
            collisions := a_collisions
            step_time := a_step_time
            total_kinetic_energy := a_kinetic_energy
            total_potential_energy := a_potential_energy
        ensure
            bodies_set: bodies = a_bodies
            collisions_set: collisions = a_collisions
            step_time_set: step_time = a_step_time
        end

feature -- Access

    bodies: LIST [PHYSICS_BODY]
            -- All bodies after integration step.

    collisions: LIST [COLLISION_INFO]
            -- All collisions detected during step.

    step_time: REAL_64
            -- Time step that was integrated.

    total_kinetic_energy: REAL_64
            -- Sum of kinetic energy of all bodies.

    total_potential_energy: REAL_64
            -- Sum of potential energy of all bodies.

    total_energy: REAL_64
            -- Total mechanical energy (KE + PE).
        do
            Result := total_kinetic_energy + total_potential_energy
        ensure
            non_nan: not Result.is_nan
        end

invariant
    bodies_not_void: bodies /= Void
    collisions_not_void: collisions /= Void
    step_time_positive: step_time > 0.0
    kinetic_non_negative: total_kinetic_energy >= 0.0

end
```

## Dependencies

| Library | Purpose | Version |
|---------|---------|---------|
| simple_math | sqrt, sin, cos for RK4 and vector operations | 1.0.0+ |
| ISE base | fundamental types (LIST, ARRAY, etc.) | 25.02+ |

## File Structure

```
src/
├── simple_physics.e         (Facade)
├── vector_3d.e              (3D vector data)
├── physics_body.e           (Rigid body data)
├── physics_world.e          (Simulation engine)
├── physics_integrator.e     (RK4 integration)
├── collision_detector.e     (Sphere collision detection)
├── collision_resolver.e     (Impulse response)
├── collision_info.e         (Collision data)
├── physics_result.e         (Step results)
└── body_type.e              (Enumeration)

test/
├── test_vector_3d.e         (Vector tests)
├── test_physics_body.e      (Body tests)
├── test_physics_world.e     (World tests)
├── test_rk4_integration.e   (Integration tests)
├── test_collision.e         (Collision tests)
└── test_app.e               (Test runner)
```

## Phase 1 Implementation Notes

- Linear motion only (no rotation)
- Sphere-sphere collisions only
- RK4 integration with ~1e-4 error tolerance
- Impulse-based elastic collision response
- Target: 50 bodies, 5ms per frame
- Energy conservation tested to 0.1% tolerance
