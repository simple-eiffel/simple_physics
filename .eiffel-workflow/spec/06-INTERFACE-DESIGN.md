# INTERFACE DESIGN: simple_physics

## Public API Summary

### Entry Point: SIMPLE_PHYSICS

| Feature | Purpose | Typical Use |
|---------|---------|-------------|
| make | Default creation | `create sim.make` |
| set_gravity | Configure gravity acceleration | `sim.set_gravity (9.81)` |
| create_world | Create new physics world | `world := sim.create_world` |

### Creation

```eiffel
create sim.make
sim.set_gravity (9.81)
world := sim.create_world
```

### Configuration (Builder Pattern)

| Feature | Returns | Purpose |
|---------|---------|---------|
| set_gravity (a_g: REAL_64) | like Current | Configure global gravity |

### Core Operations (PHYSICS_WORLD)

| Feature | Returns | Purpose |
|---------|---------|---------|
| add_body (a_body: PHYSICS_BODY) | like Current | Add body to simulation |
| remove_body (a_body: PHYSICS_BODY) | like Current | Remove body |
| integrate_step (a_dt: REAL_64) | PHYSICS_RESULT | Advance simulation one step |
| apply_force_to_body (a_body: PHYSICS_BODY; a_force: VECTOR_3D) | Void | Apply force to body |

### Body Creation

| Feature | Returns | Purpose |
|---------|---------|---------|
| PHYSICS_BODY.make (mass, radius, position) | PHYSICS_BODY | Create dynamic body |
| PHYSICS_BODY.make_static (radius, position) | PHYSICS_BODY | Create static (unmovable) body |

### Data Creation

| Feature | Returns | Purpose |
|---------|---------|---------|
| VECTOR_3D.make (x, y, z) | VECTOR_3D | Create 3D vector |
| VECTOR_3D.zero | VECTOR_3D | Create zero vector |

### Query Operations (PHYSICS_BODY)

| Feature | Returns | Purpose |
|---------|---------|---------|
| mass | REAL_64 | Body mass |
| position | VECTOR_3D | Current position |
| velocity | VECTOR_3D | Current velocity |
| radius | REAL_64 | Collision radius |
| kinetic_energy | REAL_64 | KE = 0.5 * m * v² |
| potential_energy (gravity) | REAL_64 | PE = m * g * h |
| body_type | BODY_TYPE | STATIC or DYNAMIC |

### Vector Operations

| Feature | Returns | Purpose |
|---------|---------|---------|
| add (other: VECTOR_3D) | VECTOR_3D | v1 + v2 |
| subtract (other: VECTOR_3D) | VECTOR_3D | v1 - v2 |
| scale (scalar: REAL_64) | VECTOR_3D | v * s |
| dot_product (other: VECTOR_3D) | REAL_64 | v1 · v2 |
| cross_product (other: VECTOR_3D) | VECTOR_3D | v1 × v2 |
| magnitude | REAL_64 | \|\|v\|\| |
| normalize | VECTOR_3D | v / \|\|v\|\| |

### Query Results (PHYSICS_RESULT)

| Feature | Returns | Purpose |
|---------|---------|---------|
| bodies | LIST [PHYSICS_BODY] | All bodies after step |
| collisions | LIST [COLLISION_INFO] | Collisions detected |
| total_kinetic_energy | REAL_64 | Sum of all KE |
| total_potential_energy | REAL_64 | Sum of all PE |
| step_time | REAL_64 | Time step integrated |

### Status Queries

| Feature | Returns | Purpose |
|---------|---------|---------|
| body_count (world) | INTEGER | Number of bodies |
| collision_count (result) | INTEGER | Number of collisions detected |

## Fluent API Example

```eiffel
local
    sim: SIMPLE_PHYSICS
    world: PHYSICS_WORLD
    result: PHYSICS_RESULT
    body1, body2: PHYSICS_BODY
    gravity_vec: VECTOR_3D
do
    create sim.make
    world := sim.set_gravity (9.81).create_world

    create body1.make (1.0, 0.5, VECTOR_3D.make (0.0, 5.0, 0.0))
    world.add_body (body1)

    create body2.make (2.0, 0.5, VECTOR_3D.make (0.0, 0.0, 0.0))
        .set_velocity (VECTOR_3D.zero)
    world.add_body (body2)

    -- Integrate 100 steps with dt=0.01
    from i := 1 until i > 100 loop
        create gravity_vec.make (0.0, -9.81, 0.0)
        world.apply_force_to_body (body1, gravity_vec)
        world.apply_force_to_body (body2, gravity_vec)
        result := world.integrate_step (0.01)
        i := i + 1
    end
end
```

## Error Handling Pattern

```eiffel
result := world.integrate_step (0.01)
if result /= Void then
    print ("Simulation step succeeded")
    print ("Total kinetic energy: " + result.total_kinetic_energy.out)
    print ("Collisions: " + result.collision_count.out)
else
    print ("Integration failed (should not happen with contracts)")
end
```

## Command-Query Separation

| Feature | Type | Modifies State? | Returns Value? |
|---------|------|-----------------|-----------------|
| set_gravity | Command | YES | like Current (for chaining) |
| add_body | Command | YES | like Current (for chaining) |
| apply_force_to_body | Command | YES | Void |
| integrate_step | Command | YES | PHYSICS_RESULT (exception: CQS OK) |
| body_count | Query | NO | INTEGER |
| position | Query | NO | VECTOR_3D |
| mass | Query | NO | REAL_64 |
| kinetic_energy | Query | NO | REAL_64 |

## Builder Pattern Examples

### Example 1: Configure World
```eiffel
world := sim.set_gravity (9.81)
          .create_world
          .add_body (body1)
          .add_body (body2)
```

### Example 2: Create and Configure Body
```eiffel
body := (create {PHYSICS_BODY}.make (mass, radius, position))
        .set_velocity (initial_velocity)
world.add_body (body)
```

## Immutability Pattern

Vector operations return new vectors (immutable):
```eiffel
v1: VECTOR_3D
v2: VECTOR_3D
v3: VECTOR_3D

v3 := v1.add (v2)
-- v1 and v2 unchanged; v3 is new object
```

Body state changes during integration (mutable):
```eiffel
body: PHYSICS_BODY
body.set_position (new_position)
-- Modifies body in-place (OK because bodies in physics world)
```

## API Consistency

| Pattern | Example | Purpose |
|---------|---------|---------|
| Getter | position, mass, velocity | Query state |
| Setter | set_position, set_velocity | Modify state |
| Boolean query | is_static, is_dynamic | Test properties |
| Computed property | kinetic_energy, magnitude | Derived values |
| Builder method | add_body, set_gravity | Returns Current |
| Factory | make, make_static | Create objects |

## Eiffel Idioms

### Command Returns like Current for Chaining
```eiffel
world.add_body (b1).add_body (b2).add_body (b3)
```

### Uniform Access (attribute vs function transparent)
```eiffel
-- Both appear same to client:
body.position
body.velocity
-- May be functions or attributes; client doesn't know
```

### Named Parameters (optional documentation)
```eiffel
create body.make (a_mass := 1.0, a_radius := 0.5,
                  a_position := pos)
```

## Summary of Public Classes and Methods

**SIMPLE_PHYSICS** (facade entry point)
- make
- set_gravity (a_gravity: REAL_64): like Current
- create_world: PHYSICS_WORLD

**PHYSICS_WORLD** (simulation engine)
- add_body (a_body: PHYSICS_BODY): like Current
- remove_body (a_body: PHYSICS_BODY): like Current
- integrate_step (a_dt: REAL_64): PHYSICS_RESULT
- apply_force_to_body (a_body: PHYSICS_BODY; a_force: VECTOR_3D): Void
- set_gravity (a_gravity: VECTOR_3D): like Current
- body_count: INTEGER
- gravity: VECTOR_3D

**PHYSICS_BODY** (rigid body)
- make (a_mass, a_radius: REAL_64; a_position: VECTOR_3D)
- make_static (a_radius: REAL_64; a_position: VECTOR_3D)
- set_position (a_position: VECTOR_3D)
- set_velocity (a_velocity: VECTOR_3D)
- mass: REAL_64
- position: VECTOR_3D
- velocity: VECTOR_3D
- radius: REAL_64
- kinetic_energy: REAL_64
- potential_energy (a_gravity: REAL_64): REAL_64
- body_type: BODY_TYPE
- id: INTEGER

**VECTOR_3D** (3D vector)
- make (a_x, a_y, a_z: REAL_64)
- zero: VECTOR_3D (factory)
- add (a_other: VECTOR_3D): VECTOR_3D
- subtract (a_other: VECTOR_3D): VECTOR_3D
- scale (a_scalar: REAL_64): VECTOR_3D
- dot_product (a_other: VECTOR_3D): REAL_64
- cross_product (a_other: VECTOR_3D): VECTOR_3D
- magnitude: REAL_64
- normalize: VECTOR_3D
- x, y, z: REAL_64

**PHYSICS_RESULT** (step results)
- bodies: LIST [PHYSICS_BODY]
- collisions: LIST [COLLISION_INFO]
- total_kinetic_energy: REAL_64
- total_potential_energy: REAL_64
- step_time: REAL_64

**COLLISION_INFO** (collision data)
- body1, body2: PHYSICS_BODY
- collision_point: VECTOR_3D
- collision_normal: VECTOR_3D
- penetration_depth: REAL_64
