# DOMAIN MODEL: simple_physics

## Domain Concepts

### Concept: Physical Body
**Definition:** An object with mass, position, velocity, and forces acting on it
**Attributes:** mass, position (VECTOR_3D), velocity (VECTOR_3D), force accumulator
**Behaviors:** Integrate state over time, compute acceleration from forces, apply impulse
**Related to:** Physics World (container), Gravity (force source), Collision (event)
**Will become:** PHYSICS_BODY

### Concept: Vector (3D)
**Definition:** Position, velocity, acceleration, or force in 3D space
**Attributes:** x, y, z components (REAL_64)
**Behaviors:** Add, subtract, scale, dot product, cross product, magnitude, normalize
**Related to:** Physical Body (properties), Quaternion (rotation axis)
**Will become:** VECTOR_3D

### Concept: Quaternion
**Definition:** Rotation representation (axis-angle encoded compactly)
**Attributes:** w, x, y, z components (normalized REAL_64)
**Behaviors:** Multiply (compose rotations), conjugate, integrate over time
**Related to:** Physical Body (orientation), Rotation Rate (angular velocity)
**Will become:** QUATERNION

### Concept: Rotation Rate (Angular Velocity)
**Definition:** How fast an object rotates in 3D
**Attributes:** Angular velocity vector (VECTOR_3D as axis-angle)
**Behaviors:** Integrate to compute new orientation via quaternion
**Related to:** Physical Body (rotation state), Quaternion (representation)
**Will become:** Part of PHYSICS_BODY

### Concept: Physics World
**Definition:** Container for all bodies and orchestrator of physics simulation
**Attributes:** List of bodies, global gravity acceleration
**Behaviors:** Integrate all bodies, detect collisions, apply forces
**Related to:** Physical Body (contains many), Collision Detector (uses)
**Will become:** PHYSICS_WORLD

### Concept: Collision Detection
**Definition:** Finding which bodies are in contact
**Attributes:** Spheres (position, radius)
**Behaviors:** Check if two spheres overlap, compute collision normal
**Related to:** Physical Body (pairs to test), Collision Resolver (provides data)
**Will become:** COLLISION_DETECTOR

### Concept: Collision Resolution
**Definition:** Computing response when bodies collide (impulse, velocity reversal)
**Attributes:** Collision normal, relative velocity, masses
**Behaviors:** Compute impulse, apply to both bodies
**Related to:** Collision Detection (input), Physical Body (effect)
**Will become:** COLLISION_RESOLVER

### Concept: Integrator
**Definition:** Algorithm advancing state over small time step
**Attributes:** Current state (position, velocity), derivatives (RK4 coefficients)
**Behaviors:** Compute RK4 stages, advance state, estimate error
**Related to:** Physics Body (state to integrate)
**Will become:** PHYSICS_INTEGRATOR

### Concept: Energy
**Definition:** Kinetic and potential energy of a body
**Attributes:** Mass, velocity magnitude, height in gravity field
**Behaviors:** Compute KE and PE from state
**Related to:** Physical Body (owned)
**Will become:** ENERGY (or methods in PHYSICS_BODY)

## Concept Relationships

```
┌─────────────────────────────────────────────────────────────┐
│                    PHYSICS_WORLD                            │
│  (contains, orchestrates, manages lifetime of bodies)       │
└────────────────────────────┬────────────────────────────────┘
                             │
             ┌───────────────┴───────────────┐
             ▼                               ▼
    ┌─────────────────────┐      ┌──────────────────────┐
    │   PHYSICS_BODY      │      │ GRAVITY_FORCE        │
    │   (position, vel)   │      │ (mass * g)           │
    │                     │      └──────────────────────┘
    │ • position: VECTOR  │
    │ • velocity: VECTOR  │
    │ • mass: REAL_64     │
    │ • radius: REAL_64   │
    └────────────┬────────┘
                 │
      ┌──────────┼──────────┐
      ▼          ▼          ▼
   VECTOR   QUATERNION  ENERGY
   (3D ops) (rotation) (KE+PE)
      │          │
      │    ┌─────┘
      │    │ ANGULAR_VELOCITY
      │    │ (rotation rate)
      │    ▼
   PHYSICS_INTEGRATOR (RK4)
      │
      ▼
COLLISION_DETECTOR ──┐
                     │
                     ▼
              COLLISION_RESOLVER
                (impulse response)
```

## Domain Rules

| Rule | Description | Enforcement |
|------|-------------|-------------|
| DR-001 | Mass must be positive | PHYSICS_BODY invariant: mass > 0 |
| DR-002 | Quaternion must be normalized | QUATERNION invariant: x²+y²+z²+w² ≈ 1.0 |
| DR-003 | Radius must be positive | PHYSICS_BODY invariant: radius > 0 |
| DR-004 | Collision impulse conserves momentum | COLLISION_RESOLVER postcondition |
| DR-005 | Elastic collision conserves energy | COLLISION_RESOLVER postcondition |
| DR-006 | Gravity acceleration applied equally to all bodies | PHYSICS_WORLD invariant |
| DR-007 | RK4 step size determines accuracy | PHYSICS_INTEGRATOR contract bounds error |
| DR-008 | Total energy decreases only via friction (deferred) | ENERGY_MONITOR contract |

## Glossary

| Term | Definition |
|------|-----------|
| RK4 | Runge-Kutta 4th-order integration method |
| Quaternion | Unit 4-vector representing 3D rotation (w,x,y,z) |
| Impulse | Instantaneous force applied to reverse collision |
| Elastic collision | Collision preserving kinetic energy |
| Narrow phase | Exact collision detection between two bodies |
| Broad phase | Quick check eliminating impossible collisions |
| Angular velocity | Rotation rate as axis-angle (rad/s) |
| Torque | Rotational force (N·m) |
| Moment of inertia | Resistance to rotation (kg·m²) |

## Phase 1 Scope (MVP)

**Included:**
- VECTOR_3D with full arithmetic
- QUATERNION rotation representation
- PHYSICS_BODY (linear only, no rotation in Phase 1)
- PHYSICS_WORLD with gravity
- COLLISION_DETECTOR for spheres
- COLLISION_RESOLVER for impulse
- PHYSICS_INTEGRATOR with RK4
- Simple free-fall and collision scenarios

**Deferred to Phase 2:**
- Angular velocity and torque
- Plane and box collisions
- Spatial hashing for broad phase
- Advanced integration methods (RK8, symplectic)
- Constraints (joints)
- Soft bodies
