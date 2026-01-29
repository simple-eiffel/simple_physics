# CONTRACT DESIGN: simple_physics

## MML Model Queries

For collection handling and frame conditions:

| Attribute | Type | Model Query | MML Type |
|-----------|------|-------------|----------|
| bodies | LIST [PHYSICS_BODY] | bodies_model | MML_SEQUENCE |
| collisions (in results) | LIST [COLLISION_INFO] | collisions_model | MML_SEQUENCE |

## Class Contracts

### SIMPLE_PHYSICS

**Creation Contract:**
```eiffel
make
    ensure
        world_void: world = Void
        -- Start with no active world; must create_world explicitly
```

**Command Contracts:**
```eiffel
set_gravity (a_gravity: REAL_64): like Current
    require
        gravity_positive: a_gravity >= 0.0
        -- Gravity should be non-negative (Earth: 9.81)
    ensure
        gravity_set: gravity = a_gravity
        result_current: Result = Current
        -- For fluent API chaining
```

**Query Contracts:**
```eiffel
world: detachable PHYSICS_WORLD
    ensure
        -- No postcondition: query returns current or Void
```

### PHYSICS_WORLD

**Creation Contract:**
```eiffel
make
    ensure
        not_void_bodies: bodies /= Void
        bodies_empty: bodies.is_empty
        gravity_set: gravity /= Void
        -- World starts with no bodies, gravity initialized
```

**Command Contracts:**
```eiffel
add_body (a_body: PHYSICS_BODY): like Current
    require
        body_not_void: a_body /= Void
        not_already_added: not bodies.has (a_body)
    ensure
        body_added: bodies.count = old bodies.count + 1
        contains_body: bodies.has (a_body)
        result_current: Result = Current
        other_bodies_unchanged: old bodies.count > 0 implies
            bodies.removed (a_body) |=| old bodies
            -- Frame condition: only new body added, others unchanged
```

```eiffel
integrate_step (a_dt: REAL_64): PHYSICS_RESULT
    require
        positive_dt: a_dt > 0.0
        dt_reasonable: a_dt <= 0.1
        -- Time step should be small for stability (RK4)
        world_has_bodies: bodies.count > 0
    ensure
        result_not_void: Result /= Void
        result_body_count: Result.bodies.count = bodies.count
        step_time_recorded: Result.step_time = a_dt
        energy_conservation_approx:
            abs(Result.total_energy - old total_energy) /
            (old total_energy + 1.0) < 0.001
            -- Energy conserved to within 0.1% (elastic, no friction)
```

```eiffel
apply_force_to_body (a_body: PHYSICS_BODY; a_force: VECTOR_3D)
    require
        body_in_world: bodies.has (a_body)
        force_not_void: a_force /= Void
    ensure
        force_accumulated: a_body.accumulated_force =
            old a_body.accumulated_force + a_force
```

**Invariant:**
```eiffel
invariant
    gravity_not_void: gravity /= Void
    bodies_not_void: bodies /= Void
    all_bodies_valid: across bodies as b all
        b.item.mass > 0.0 and b.item.radius > 0.0
    end
    no_duplicate_ids: across bodies as b1 all
        across bodies as b2 all
            b1.item /= b2.item implies b1.item.id /= b2.item.id
        end
    end
```

### PHYSICS_BODY

**Creation Contract:**
```eiffel
make (a_mass, a_radius: REAL_64; a_position: VECTOR_3D)
    require
        mass_positive: a_mass > 0.0
        radius_positive: a_radius > 0.0
        position_not_void: a_position /= Void
    ensure
        mass_set: mass = a_mass
        radius_set: radius = a_radius
        position_set: position.x = a_position.x and
                      position.y = a_position.y and
                      position.z = a_position.z
        velocity_zero: velocity.x = 0.0 and
                       velocity.y = 0.0 and
                       velocity.z = 0.0
        kinetic_energy_zero: kinetic_energy < 0.00001
```

**Command Contracts:**
```eiffel
set_position (a_position: VECTOR_3D)
    require
        position_not_void: a_position /= Void
    ensure
        position_updated: position.x = a_position.x and
                          position.y = a_position.y and
                          position.z = a_position.z
        mass_unchanged: mass = old mass
        velocity_unchanged: velocity.x = old velocity.x and
                            velocity.y = old velocity.y and
                            velocity.z = old velocity.z
```

**Query Contracts:**
```eiffel
kinetic_energy: REAL_64
    ensure
        non_negative: Result >= 0.0
        correct_formula:
            abs(Result - 0.5 * mass * (velocity.magnitude ^ 2)) < 0.001
            -- KE = 0.5 * m * v²
```

```eiffel
potential_energy (a_gravity: REAL_64): REAL_64
    require
        gravity_non_negative: a_gravity >= 0.0
    ensure
        result_correct: Result = mass * a_gravity * position.y
        -- PE = m * g * h (with h = position.y)
```

**Invariant:**
```eiffel
invariant
    mass_positive: mass > 0.0
    radius_positive: radius > 0.0
    position_not_void: position /= Void
    velocity_not_void: velocity /= Void
    no_nan_position: not position.x.is_nan and
                     not position.y.is_nan and
                     not position.z.is_nan
    no_nan_velocity: not velocity.x.is_nan and
                     not velocity.y.is_nan and
                     not velocity.z.is_nan
```

### VECTOR_3D

**Creation Contract:**
```eiffel
make (a_x, a_y, a_z: REAL_64)
    ensure
        x_set: x = a_x
        y_set: y = a_y
        z_set: z = a_z
```

**Query Contracts:**
```eiffel
magnitude: REAL_64
    ensure
        non_negative: Result >= 0.0
        correct_formula: abs(Result - sqrt(x*x + y*y + z*z)) < 0.0001
        -- Magnitude = ||v|| = sqrt(x² + y² + z²)
```

```eiffel
add (a_other: VECTOR_3D): VECTOR_3D
    require
        other_not_void: a_other /= Void
    ensure
        result_not_void: Result /= Void
        result_x: Result.x = x + a_other.x
        result_y: Result.y = y + a_other.y
        result_z: Result.z = z + a_other.z
        self_unchanged: x = old x and y = old y and z = old z
        -- Vector addition is immutable
```

```eiffel
dot_product (a_other: VECTOR_3D): REAL_64
    require
        other_not_void: a_other /= Void
    ensure
        result_correct: abs(Result - (x * a_other.x +
                                      y * a_other.y +
                                      z * a_other.z)) < 0.0001
        -- dot = x₁x₂ + y₁y₂ + z₁z₂
```

```eiffel
cross_product (a_other: VECTOR_3D): VECTOR_3D
    require
        other_not_void: a_other /= Void
    ensure
        result_not_void: Result /= Void
        result_x: abs(Result.x - (y * a_other.z - z * a_other.y)) < 0.0001
        result_y: abs(Result.y - (z * a_other.x - x * a_other.z)) < 0.0001
        result_z: abs(Result.z - (x * a_other.y - y * a_other.x)) < 0.0001
        -- cross product perpendicular to both inputs
        dot_product_zero:
            abs(Result.dot_product (Current)) < 0.0001 and
            abs(Result.dot_product (a_other)) < 0.0001
```

### PHYSICS_INTEGRATOR

**Command Contracts:**
```eiffel
rk4_step (a_body: PHYSICS_BODY;
          a_forces: LIST [VECTOR_3D];
          a_dt: REAL_64): PHYSICS_BODY
    require
        body_not_void: a_body /= Void
        forces_not_void: a_forces /= Void
        positive_dt: a_dt > 0.0
        dt_reasonable: a_dt <= 0.1
    ensure
        result_not_void: Result /= Void
        mass_unchanged: Result.mass = a_body.mass
        radius_unchanged: Result.radius = a_body.radius
        position_advanced:
            Result.position.magnitude > a_body.position.magnitude or
            Result.position.y < a_body.position.y
            -- Position should have moved
        error_bounded: estimate_error (a_dt) < 0.0001 * a_body.mass * a_dt
            -- Local truncation error bounded
```

### COLLISION_DETECTOR

**Query Contracts:**
```eiffel
detect_collision (a_body1, a_body2: PHYSICS_BODY): detachable COLLISION_INFO
    require
        body1_not_void: a_body1 /= Void
        body2_not_void: a_body2 /= Void
        bodies_different: a_body1 /= a_body2
    ensure
        collision_implies_overlap:
            Result /= Void implies
            a_body1.position.distance_to (a_body2.position) <
            a_body1.radius + a_body2.radius + 0.0001
        no_collision_implies_separation:
            Result = Void implies
            a_body1.position.distance_to (a_body2.position) >=
            a_body1.radius + a_body2.radius - 0.0001
```

### COLLISION_RESOLVER

**Command Contracts:**
```eiffel
resolve_collision (a_collision: COLLISION_INFO): COLLISION_RESULT
    require
        collision_not_void: a_collision /= Void
        bodies_not_void: a_collision.body1 /= Void and
                         a_collision.body2 /= Void
    ensure
        result_not_void: Result /= Void
        velocities_not_void: Result.body1_velocity_after /= Void and
                             Result.body2_velocity_after /= Void
        -- Momentum conserved: m1*v1 + m2*v2 = m1*v1' + m2*v2'
        momentum_conserved:
            (a_collision.body1.mass * a_collision.body1.velocity.x +
             a_collision.body2.mass * a_collision.body2.velocity.x) =
            (a_collision.body1.mass * Result.body1_velocity_after.x +
             a_collision.body2.mass * Result.body2_velocity_after.x)
        -- For elastic collision: kinetic energy approximately conserved
```

### PHYSICS_RESULT

**Invariant:**
```eiffel
invariant
    bodies_not_void: bodies /= Void
    collisions_not_void: collisions /= Void
    step_time_positive: step_time > 0.0
    energy_non_negative: total_kinetic_energy >= 0.0
    potential_energy_real: not total_potential_energy.is_nan
```

## Contract Completeness Checklist

For each postcondition:

- [x] **What changed?** (direct effect)
  - Body position advanced
  - Collision normal computed
  - Impulse applied (velocity updated)

- [x] **How did it change?** (relationship to `old` state)
  - Position = old position + RK4 step
  - Velocity = old velocity + impulse/mass

- [x] **What did NOT change?** (frame conditions via MML |=|)
  - Mass unchanged
  - Radius unchanged
  - Other bodies' states unchanged
