# CLASS DESIGN: simple_physics

## Class Inventory

| Class | Role | Single Responsibility |
|-------|------|----------------------|
| SIMPLE_PHYSICS | Facade | Coordinate library usage, provide entry point |
| PHYSICS_WORLD | Engine | Manage bodies, apply forces, coordinate simulation |
| PHYSICS_BODY | Data | Represent single rigid body with mass, position, velocity |
| VECTOR_3D | Data | 3D vector arithmetic (add, subtract, dot, cross) |
| PHYSICS_INTEGRATOR | Engine | RK4 numerical integration |
| COLLISION_DETECTOR | Engine | Detect sphere-sphere collisions |
| COLLISION_RESOLVER | Engine | Compute impulse response |
| PHYSICS_RESULT | Data | Hold simulation results (immutable) |
| BODY_TYPE | Enumeration | Distinguish static/dynamic bodies |

## Facade Design: SIMPLE_PHYSICS

**Purpose:** Single entry point for library functionality
**Responsibility:** Coordinate world creation, integrate, query results

**Public Interface:**
```eiffel
class SIMPLE_PHYSICS

create
    make

feature -- Configuration

    set_gravity (a_gravity: REAL_64): like Current
        -- Set global gravity acceleration. Returns Current for chaining.

    create_world: PHYSICS_WORLD
        -- Create new physics world with configured gravity

feature -- World Management

    world: detachable PHYSICS_WORLD
        -- Active physics world
```

**Hides:**
- PHYSICS_INTEGRATOR: integration algorithm details
- COLLISION_DETECTOR: broad/narrow phase strategy
- COLLISION_RESOLVER: impulse computation

## Engine Design: PHYSICS_WORLD

**Purpose:** Container for bodies and orchestrator of simulation
**Responsibility:** Manage bodies, apply forces, integrate time, detect/resolve collisions

```eiffel
class PHYSICS_WORLD

create
    make

feature -- Body Management

    add_body (a_body: PHYSICS_BODY): like Current
        -- Add body to world. Returns Current for chaining.

    remove_body (a_body: PHYSICS_BODY): like Current
        -- Remove body from world

    body_count: INTEGER
        -- Number of bodies in world

feature -- Simulation

    integrate_step (a_dt: REAL_64): PHYSICS_RESULT
        -- Advance simulation by time a_dt using RK4 integration
        -- Returns result containing all bodies' new states

feature -- Forces

    apply_force_to_body (a_body: PHYSICS_BODY; a_force: VECTOR_3D)
        -- Accumulate force on body for next integration step

    set_gravity (a_gravity: VECTOR_3D): like Current
        -- Set global gravity vector

invariant
    gravity_set: gravity /= Void
    bodies_not_void: bodies /= Void
```

## Data Class Design: PHYSICS_BODY

**Purpose:** Represent single rigid body
**Immutable:** NO (state changes during integration)

```eiffel
class PHYSICS_BODY

create
    make

feature -- Properties

    id: INTEGER
        -- Unique identifier for this body

    mass: REAL_64
        -- Body mass (must be positive)

    position: VECTOR_3D
        -- Center of mass position

    velocity: VECTOR_3D
        -- Linear velocity

    radius: REAL_64
        -- Sphere collision radius

    body_type: BODY_TYPE
        -- STATIC (unmoved), DYNAMIC (moved by forces)

feature -- Modification (during integration)

    set_position (a_position: VECTOR_3D)
    set_velocity (a_velocity: VECTOR_3D)

feature -- Computed Properties

    kinetic_energy: REAL_64
        -- 0.5 * mass * velocity²

    potential_energy (a_gravity: REAL_64): REAL_64
        -- mass * gravity * position.y

invariant
    mass_positive: mass > 0.0
    radius_positive: radius > 0.0
    position_not_void: position /= Void
    velocity_not_void: velocity /= Void
```

## Data Class Design: VECTOR_3D

**Purpose:** 3D vector with arithmetic operations
**Immutable:** YES (functional programming style)

```eiffel
class VECTOR_3D

create
    make

feature -- Creation

    make (a_x, a_y, a_z: REAL_64)
        -- Create vector with components

    zero: VECTOR_3D
        -- Zero vector

feature -- Access

    x, y, z: REAL_64
        -- Vector components

    magnitude: REAL_64
        -- Length ||v|| = sqrt(x² + y² + z²)

feature -- Operations

    add (a_other: VECTOR_3D): VECTOR_3D
        -- Element-wise addition

    subtract (a_other: VECTOR_3D): VECTOR_3D
        -- Element-wise subtraction

    scale (a_scalar: REAL_64): VECTOR_3D
        -- Scalar multiplication

    dot_product (a_other: VECTOR_3D): REAL_64
        -- Dot product: x₁x₂ + y₁y₂ + z₁z₂

    cross_product (a_other: VECTOR_3D): VECTOR_3D
        -- Cross product (returns new vector perpendicular to both)

    normalize: VECTOR_3D
        -- Return unit vector in same direction

invariant
    -- No special invariants for immutable vector
```

## Engine Design: PHYSICS_INTEGRATOR

**Purpose:** Implement RK4 numerical integration
**Responsibility:** Advance body state over small time step

```eiffel
class PHYSICS_INTEGRATOR

feature -- Integration

    rk4_step (a_body: PHYSICS_BODY;
              a_forces: LIST [VECTOR_3D];
              a_dt: REAL_64): PHYSICS_BODY
        -- Perform single RK4 step, return new body state
        -- Computes 4 stages to estimate next position/velocity

feature -- Error Estimation

    estimate_error (a_dt: REAL_64): REAL_64
        -- Estimate local truncation error for given time step
```

## Engine Design: COLLISION_DETECTOR

**Purpose:** Find collisions between bodies
**Responsibility:** Detect sphere-sphere overlaps

```eiffel
class COLLISION_DETECTOR

feature -- Detection

    detect_collision (a_body1, a_body2: PHYSICS_BODY): detachable COLLISION_INFO
        -- If bodies collide, return collision details; else Void

feature -- Batch Detection

    detect_all_collisions (a_bodies: LIST [PHYSICS_BODY]): LIST [COLLISION_INFO]
        -- Return list of all colliding pairs
```

## Data Class Design: COLLISION_INFO

**Purpose:** Hold collision detection results
**Immutable:** YES

```eiffel
class COLLISION_INFO

feature -- Access

    body1, body2: PHYSICS_BODY
        -- Bodies in collision

    collision_point: VECTOR_3D
        -- Contact point (for sphere-sphere: midpoint)

    collision_normal: VECTOR_3D
        -- Normal direction from body1 to body2

    penetration_depth: REAL_64
        -- How far spheres overlap
```

## Engine Design: COLLISION_RESOLVER

**Purpose:** Compute impulse response to collision
**Responsibility:** Calculate and apply collision impulse

```eiffel
class COLLISION_RESOLVER

feature -- Resolution

    resolve_collision (a_collision: COLLISION_INFO): COLLISION_RESULT
        -- Compute impulse and new velocities
        -- Assumes elastic collision (energy-conserving)
```

## Data Class Design: COLLISION_RESULT

**Purpose:** Hold collision resolution results
**Immutable:** YES

```eiffel
class COLLISION_RESULT

feature -- Access

    body1_velocity_after: VECTOR_3D
    body2_velocity_after: VECTOR_3D
        -- Velocities after collision impulse
```

## Data Class Design: PHYSICS_RESULT

**Purpose:** Hold simulation step results
**Immutable:** YES (safe for SCOOP)

```eiffel
class PHYSICS_RESULT

feature -- Access

    bodies: LIST [PHYSICS_BODY]
        -- All bodies with updated state

    collisions: LIST [COLLISION_INFO]
        -- All collisions detected this step

    total_kinetic_energy: REAL_64
    total_potential_energy: REAL_64
        -- Energy metrics for validation

    step_time: REAL_64
        -- Time step that was integrated

invariant
    bodies_not_void: bodies /= Void
    collisions_not_void: collisions /= Void
```

## Enumeration: BODY_TYPE

```eiffel
class BODY_TYPE

create
    make

feature
    STATIC: BODY_TYPE
        -- Non-moving (ground, walls)

    DYNAMIC: BODY_TYPE
        -- Affected by forces
```

## Class Diagram

```
┌─────────────────────────────────────────────────────────┐
│                  SIMPLE_PHYSICS                         │
│                  (Facade)                               │
├─────────────────────────────────────────────────────────┤
│ + set_gravity: like Current                             │
│ + create_world: PHYSICS_WORLD                           │
├─────────────────────────────────────────────────────────┤
│ - world: PHYSICS_WORLD                                  │
│ - gravity: REAL_64                                      │
└────────────────┬────────────────────────────────────────┘
                 │ creates
                 ▼
    ┌────────────────────────────────────────┐
    │         PHYSICS_WORLD                  │
    │         (Engine)                       │
    ├────────────────────────────────────────┤
    │ + add_body: like Current               │
    │ + integrate_step: PHYSICS_RESULT       │
    ├────────────────────────────────────────┤
    │ - bodies: LIST [PHYSICS_BODY]          │
    │ - gravity: VECTOR_3D                   │
    └────────┬────────────────┬──────────────┘
             │ contains       │ uses
             │                │
             ▼                ▼
    ┌─────────────────┐  ┌──────────────────────────┐
    │  PHYSICS_BODY   │  │ PHYSICS_INTEGRATOR       │
    │  (Data)         │  │ COLLISION_DETECTOR       │
    │                 │  │ COLLISION_RESOLVER       │
    │ • mass          │  └──────────────────────────┘
    │ • position      │
    │ • velocity      │
    │ • radius        │
    └────────┬────────┘
             │ uses
             ▼
    ┌─────────────────┐
    │   VECTOR_3D     │
    │   (Data)        │
    │                 │
    │ • x, y, z       │
    │ + add           │
    │ + subtract      │
    │ + dot_product   │
    │ + cross_product │
    └─────────────────┘
```

## Inheritance Hierarchy

**No inheritance used in Phase 1.**

Rationale: PHYSICS_BODY, VECTOR_3D are concrete data classes. No abstract base classes needed yet. Phase 2 may introduce INTEGRATOR_ALGORITHM base class if multiple methods needed.

## Generic Classes

| Class | Type Parameter | Constraint | Purpose |
|-------|----------------|-----------|---------|
| PHYSICS_WORLD | None yet | N/A | May be generic [T -> PHYSICS_BODY] in Phase 2 |

## Design Patterns Used

| Pattern | Where | Rationale |
|---------|-------|-----------|
| Facade | SIMPLE_PHYSICS | Single entry point hides complexity |
| Data Transfer Object | PHYSICS_RESULT | Immutable results for SCOOP safety |
| Immutable Value Object | VECTOR_3D | Functional style reduces side effects |
| Command | COLLISION_INFO | Encapsulates collision as first-class object |
| Enumeration | BODY_TYPE | Type-safe alternatives to magic numbers |

## OOSC2 Compliance

| Principle | Status | Implementation |
|-----------|--------|-----------------|
| Single Responsibility | ✓ | Each class has one clear purpose |
| Open/Closed | ✓ | Extensible via Phase 2 without modifying Phase 1 |
| Liskov Substitution | N/A | No inheritance in Phase 1 |
| Interface Segregation | ✓ | Public interfaces are focused |
| Dependency Inversion | ✓ | High-level code depends on abstractions (VECTOR_3D) |
