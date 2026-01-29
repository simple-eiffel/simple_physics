# Implementation Tasks: simple_physics

## Task 1: VECTOR_3D - 3D Vector Data Class
**Files:** src/vector_3d.e
**Features:** make, zero, x/y/z, magnitude, add, subtract, scale, dot_product, cross_product, normalize

### Acceptance Criteria
- [ ] Creation contracts: make, zero factory
- [ ] All arithmetic operations implemented (add, subtract, scale, dot, cross)
- [ ] Magnitude and normalize compute correctly
- [ ] Postconditions verified: immutability, correctness formulas
- [ ] Test coverage: vector addition, dot product, cross product, magnitude
- [ ] Compiles with zero warnings
- [ ] void_safety="all" enforced

### Implementation Notes
- **Immutable by design:** All operations return new vectors
- **Magnitude:** sqrt(x² + y² + z²) using simple_math.sqrt
- **Dot product:** x₁x₂ + y₁y₂ + z₁z₂
- **Cross product:** (y₁z₂ - z₁y₂, z₁x₂ - x₁z₂, x₁y₂ - y₁x₂)
- **Normalize:** Divide by magnitude if magnitude > 0.0001
- **Contract verification:** All postconditions computable from inputs

### Why Task 1
Foundation class; required by PHYSICS_BODY and all force calculations. No dependencies.

---

## Task 2: BODY_TYPE - Enumeration for Static/Dynamic Bodies
**Files:** src/body_type.e
**Features:** STATIC, DYNAMIC, is_static, is_dynamic

### Acceptance Criteria
- [ ] Enumeration pattern implemented (two instances)
- [ ] Queries is_static, is_dynamic work correctly
- [ ] Contracts simple (no pre/postconditions needed)
- [ ] Test: Can distinguish STATIC from DYNAMIC
- [ ] Compiles clean

### Implementation Notes
- Simple enumeration pattern (two singletons or flags)
- Used by PHYSICS_BODY to distinguish immovable from movable bodies
- Minimal complexity

### Dependencies
None (standalone)

---

## Task 3: PHYSICS_BODY - Rigid Body Data Class
**Files:** src/physics_body.e
**Features:** make, make_static, id, mass, position, velocity, radius, body_type, set_position, set_velocity, kinetic_energy, potential_energy

### Acceptance Criteria
- [ ] Creation: make (dynamic) and make_static
- [ ] Properties: mass, position, velocity, radius, body_type, id
- [ ] Modifiers: set_position, set_velocity
- [ ] Computed: kinetic_energy (0.5*m*v²), potential_energy (m*g*h)
- [ ] Preconditions: mass > 0, radius > 0
- [ ] Postconditions: State changes verified, invariants hold
- [ ] Invariants: mass > 0, radius > 0, no NaN values
- [ ] Test coverage: Creation, property access, energy computation

### Implementation Notes
- **Mutable during integration** (unlike VECTOR_3D)
- **ID generation:** Static counter (thread-unsafe, OK for Phase 1)
- **Kinetic energy:** 0.5 * mass * velocity.magnitude²
- **Potential energy:** mass * gravity * position.y (assumes gravity in -y direction)
- **Contracts:** Frame conditions on mass, radius (unchanged by position/velocity updates)

### Dependencies
- Depends on: VECTOR_3D (composition for position, velocity)
- Depends on: BODY_TYPE (enumeration)

---

## Task 4: SIMPLE_PHYSICS - Facade Entry Point
**Files:** src/simple_physics.e
**Features:** make, set_gravity, create_world, world

### Acceptance Criteria
- [ ] Creation: make initializes with zero gravity
- [ ] set_gravity: Validates non-negative, returns Current for chaining
- [ ] create_world: Creates PHYSICS_WORLD with configured gravity
- [ ] world: Query returns active world (detachable)
- [ ] Contracts: Preconditions validate gravity, postconditions set state
- [ ] Fluent chaining: set_gravity.create_world works
- [ ] Test: Creation, configuration, world creation

### Implementation Notes
- **Facade pattern:** Single entry point
- **Gravity storage:** REAL_64 (magnitude); convert to VECTOR_3D (0, -gravity, 0) in create_world
- **Builder pattern:** set_gravity returns Current for chaining
- **world attribute:** detachable (may be Void if not created yet)

### Dependencies
- Depends on: PHYSICS_WORLD (creates worlds)
- Depends on: VECTOR_3D (for gravity vector)

---

## Task 5: PHYSICS_WORLD - Simulation Orchestrator
**Files:** src/physics_world.e
**Features:** make, add_body, remove_body, body_count, integrate_step, apply_force_to_body, set_gravity, gravity, bodies, last_collisions

### Acceptance Criteria
- [ ] Creation: make initializes empty bodies list, sets gravity
- [ ] Body management: add_body, remove_body, body_count
- [ ] Preconditions: body not void, not already added
- [ ] Postconditions: Body count changes, body added/removed verified
- [ ] Forces: apply_force_to_body accumulates forces
- [ ] Gravity: set_gravity updates, applied to all bodies in integrate_step
- [ ] integrate_step: Orchestrates RK4 integration (stub: returns PHYSICS_RESULT)
- [ ] Invariants: gravity not void, bodies not void, all bodies valid
- [ ] Test: Body management, force application, gravity setting

### Implementation Notes
- **Body container:** ARRAYED_LIST [PHYSICS_BODY]
- **Force accumulation:** Store per-body (implement in Task 6 or defer to Phase 4)
- **integrate_step:** Orchestrate calls to:
  1. Gravity force application
  2. RK4 integration for each body
  3. Collision detection
  4. Collision resolution
  5. Return PHYSICS_RESULT with updated bodies
- **Stub implementation:** Phase 4 fills in actual RK4 and collision logic

### Dependencies
- Depends on: PHYSICS_BODY (contains many)
- Depends on: VECTOR_3D (gravity vector)
- Depends on: PHYSICS_INTEGRATOR (calls rk4_step)
- Depends on: COLLISION_DETECTOR (calls detect_collision)
- Depends on: COLLISION_RESOLVER (calls resolve_collision)
- Depends on: PHYSICS_RESULT (creates result)

---

## Task 6: PHYSICS_INTEGRATOR - RK4 Integration Engine
**Files:** src/physics_integrator.e
**Features:** rk4_step, estimate_error

### Acceptance Criteria
- [ ] RK4 implementation: 4 stages (k1, k2, k3, k4)
- [ ] rk4_step: Takes PHYSICS_BODY, forces (LIST [VECTOR_3D]), dt; returns new body state
- [ ] Stages computed via:
  - k1 = f(t, y)
  - k2 = f(t + dt/2, y + dt*k1/2)
  - k3 = f(t + dt/2, y + dt*k2/2)
  - k4 = f(t + dt, y + dt*k3)
  - y_new = y + dt*(k1 + 2*k2 + 2*k3 + k4)/6
- [ ] Error estimation: Local truncation error < 1e-4 * dt (contract)
- [ ] Acceleration computation: a = (total_force - gravity) / mass
- [ ] Preconditions: body not void, dt > 0, dt <= 0.1
- [ ] Postconditions: Position advanced, velocity updated, dimension preserved
- [ ] Test: RK4 convergence on free-fall problem

### Implementation Notes
- **Derivative function:** f(t, y) returns acceleration from current state
- **State vector:** y = [position.x, position.y, position.z, velocity.x, velocity.y, velocity.z]
- **Gravity force:** Always applied (a = g + other_forces/m)
- **Contraction note:** Position and velocity as separate y components
- **Error bound:** Based on RK4 O(h⁵) local error

### Dependencies
- Depends on: VECTOR_3D (for state representation)
- Depends on: PHYSICS_BODY (state to integrate)
- Depends on: simple_math (sqrt for acceleration magnitude if needed)

---

## Task 7: COLLISION_DETECTOR - Sphere-Sphere Collision Detection
**Files:** src/collision_detector.e
**Features:** detect_collision, detect_all_collisions

### Acceptance Criteria
- [ ] detect_collision: Takes PHYSICS_BODY pairs, returns COLLISION_INFO or Void
- [ ] Sphere-sphere distance check: ||pos1 - pos2|| vs radius1 + radius2
- [ ] Collision when: distance < r1 + r2 (with small tolerance ~0.0001)
- [ ] No collision when: distance >= r1 + r2
- [ ] COLLISION_INFO populated: contact point (midpoint), normal, penetration depth
- [ ] detect_all_collisions: Broad-phase O(n²) iteration, calls detect_collision for each pair
- [ ] Preconditions: Bodies not void, different bodies
- [ ] Postconditions: Collision info semantically correct if collision detected
- [ ] Test: Overlapping spheres detected, separated spheres not detected

### Implementation Notes
- **Distance calculation:** Use VECTOR_3D.subtract to get delta, compute magnitude
- **Contact point:** Midpoint between centers (simplified)
- **Collision normal:** Unit vector from body1 to body2: (pos2 - pos1) / ||pos2 - pos1||
- **Penetration depth:** max(0, r1 + r2 - distance)
- **Broad phase:** Loop all pairs (i, j) with i < j to avoid duplicates

### Dependencies
- Depends on: VECTOR_3D (distance, normal computation)
- Depends on: PHYSICS_BODY (collision radii and positions)
- Depends on: COLLISION_INFO (to create)

---

## Task 8: COLLISION_INFO - Collision Data Class
**Files:** src/collision_info.e
**Features:** body1, body2, collision_point, collision_normal, penetration_depth

### Acceptance Criteria
- [ ] Creation: Stores bodies, contact point, normal, depth
- [ ] body1, body2: References to colliding bodies
- [ ] collision_point: VECTOR_3D (contact location)
- [ ] collision_normal: VECTOR_3D (unit vector, from body1 to body2)
- [ ] penetration_depth: REAL_64 (how far spheres overlap)
- [ ] Immutable: No modification after creation
- [ ] Contracts: Preconditions validate bodies, postconditions verify magnitudes

### Implementation Notes
- **Immutable data class:** Like PHYSICS_RESULT
- **Normal magnitude:** Should be ≈ 1.0 (unit vector)
- **Penetration:** Should be ≥ 0.0

### Dependencies
- Depends on: VECTOR_3D (contact point, normal)
- Depends on: PHYSICS_BODY (references only)

---

## Task 9: COLLISION_RESOLVER - Impulse-Based Collision Response
**Files:** src/collision_resolver.e
**Features:** resolve_collision

### Acceptance Criteria
- [ ] resolve_collision: Takes COLLISION_INFO, returns COLLISION_RESULT
- [ ] Impulse computation: j = -(1 + e) * (v_rel · n) / (1/m1 + 1/m2)
  - e = 1.0 (elastic collision)
  - v_rel = velocity2 - velocity1
  - n = collision normal
- [ ] Velocity updates: v1' = v1 + j*n/m1, v2' = v2 - j*n/m2
- [ ] Momentum conservation: m1*v1' + m2*v2' = m1*v1 + m2*v2 (contract)
- [ ] Energy conservation (elastic): KE after ≈ KE before (contract)
- [ ] Special case: Static bodies (mass → ∞) don't move
- [ ] Preconditions: Collision info not void, bodies valid
- [ ] Postconditions: Velocities updated, momentum + energy conserved (elastic)
- [ ] Test: Ball bouncing off wall, two-ball collision

### Implementation Notes
- **Elastic collision:** e = 1.0 (energy preserved)
- **Static body:** Treat as infinite mass (don't update velocity)
- **Impulse scalar:** j = -(1+e)*(v_rel · n) / (1/m1 + 1/m2)
- **Frame condition:** No position changes (impulse is instantaneous)
- **Contracts:** Verify momentum and energy bounds

### Dependencies
- Depends on: VECTOR_3D (velocity, normal arithmetic)
- Depends on: COLLISION_INFO (collision data)
- Depends on: COLLISION_RESULT (to create)

---

## Task 10: COLLISION_RESULT - Collision Resolution Data Class
**Files:** src/collision_result.e
**Features:** body1_velocity_after, body2_velocity_after

### Acceptance Criteria
- [ ] Creation: Stores new velocities after impulse
- [ ] body1_velocity_after: VECTOR_3D (new velocity for body1)
- [ ] body2_velocity_after: VECTOR_3D (new velocity for body2)
- [ ] Immutable: No modification after creation
- [ ] Contracts: Preconditions validate, postconditions verify non-void

### Implementation Notes
- **Immutable data class**
- **Both velocities required:** Not void

### Dependencies
- Depends on: VECTOR_3D (velocities)

---

## Task 11: PHYSICS_RESULT - Simulation Step Results (Immutable)
**Files:** src/physics_result.e
**Features:** bodies, collisions, total_kinetic_energy, total_potential_energy, step_time

### Acceptance Criteria
- [ ] Creation: Stores final bodies, collisions, energies, step time
- [ ] bodies: LIST [PHYSICS_BODY] (all bodies after step)
- [ ] collisions: LIST [COLLISION_INFO] (collisions detected)
- [ ] total_kinetic_energy: REAL_64 (sum of all KE)
- [ ] total_potential_energy: REAL_64 (sum of all PE)
- [ ] step_time: REAL_64 (time step integrated)
- [ ] Immutable: No modification after creation
- [ ] Invariants: Bodies not void, collisions not void, energies non-negative
- [ ] SCOOP-safe: Immutable for shared access across regions

### Implementation Notes
- **Immutable data class:** Safe for SCOOP sharing
- **Energy computation:** Sum of body.kinetic_energy and body.potential_energy
- **Collections:** Non-empty (at least 1 body)

### Dependencies
- Depends on: PHYSICS_BODY (references in list)
- Depends on: COLLISION_INFO (references in list)

---

## Task 12: ECF Configuration and Test Framework
**Files:** simple_physics.ecf, test/test_app.e, test/test_vector_3d.e

### Acceptance Criteria
- [ ] ECF file: Proper configuration with void_safety="all", concurrency=scoop
- [ ] Dependencies: simple_math, ISE base, ISE testing
- [ ] Test application: Compiles, runs test suite
- [ ] Skeletal tests created: test_vector_3d.e (from Phase 1)
- [ ] Test runner: test_app.e orchestrates all tests
- [ ] Compilation: Zero warnings
- [ ] Test execution: All skeletal tests pass (100% pass rate)

### Implementation Notes
- **ECF targets:** main target for library, test target for tests
- **Clauses:** src/ for implementation, test/ for tests
- **simple_math:** Required for sqrt, sin, cos (verify availability)
- **Skeletal tests:** From Phase 1, now ready for Phase 5 expansion

### Dependencies
- Depends on: All other classes (integration point)

---

## Task Dependency Graph

```
VECTOR_3D (Task 1)
    ↓
BODY_TYPE (Task 2)
    ↓
PHYSICS_BODY (Task 3) ← depends on VECTOR_3D, BODY_TYPE
    ↓
SIMPLE_PHYSICS (Task 4) ← depends on VECTOR_3D
    ↓
PHYSICS_WORLD (Task 5) ← depends on PHYSICS_BODY, VECTOR_3D, SIMPLE_PHYSICS
    ↓ ↓ ↓ ↓
PHYSICS_INTEGRATOR (Task 6) ← depends on VECTOR_3D, PHYSICS_BODY
COLLISION_DETECTOR (Task 7) ← depends on VECTOR_3D, PHYSICS_BODY
    ↓
COLLISION_INFO (Task 8) ← depends on VECTOR_3D
    ↓
COLLISION_RESOLVER (Task 9) ← depends on VECTOR_3D, COLLISION_INFO
    ↓
COLLISION_RESULT (Task 10) ← depends on VECTOR_3D
    ↓
PHYSICS_RESULT (Task 11) ← depends on PHYSICS_BODY, COLLISION_INFO
    ↓
ECF & Tests (Task 12) ← depends on all classes
```

## Task Execution Order (Recommended)

1. **Foundation (no dependencies):**
   - Task 1: VECTOR_3D
   - Task 2: BODY_TYPE

2. **Body representation:**
   - Task 3: PHYSICS_BODY

3. **Top-level entry:**
   - Task 4: SIMPLE_PHYSICS

4. **World orchestrator:**
   - Task 5: PHYSICS_WORLD

5. **Core simulation (parallel after Task 5):**
   - Task 6: PHYSICS_INTEGRATOR
   - Task 7: COLLISION_DETECTOR

6. **Collision response:**
   - Task 8: COLLISION_INFO
   - Task 9: COLLISION_RESOLVER
   - Task 10: COLLISION_RESULT

7. **Results container:**
   - Task 11: PHYSICS_RESULT

8. **Integration & testing:**
   - Task 12: ECF & Tests

## Phase 4 Gate Conditions

**Before implementation starts, verify:**
- [ ] simple_math provides sqrt, sin, cos functions
- [ ] ISE base ≥ version 25.02
- [ ] void_safety="all" configuration available
- [ ] SCOOP concurrency supported
- [ ] EiffelStudio compiler ready

---

## Total Task Count: 12
- Foundation classes: 4
- Engine classes: 3
- Data classes: 4
- Integration: 1

**Estimated complexity:** High (numerical algorithms)
**Risk areas:** RK4 integration, collision physics
**Success factors:** Contract-driven development, extensive testing
