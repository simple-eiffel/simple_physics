# PARSED REQUIREMENTS: simple_physics

## Problem Summary
Type-safe 3D rigid body physics engine for scientific computing and education, with Design by Contract verification of physical correctness. Provides RK4 integration, collision detection, and energy conservation guarantees.

## Scope

### In Scope
- 3D rigid body dynamics (F = ma, torque, angular acceleration)
- RK4 integration for state evolution
- Vector and quaternion mathematics (3D rotations)
- Sphere-sphere collision detection and impulse resolution
- Kinetic and potential energy computation
- Physics world managing 100+ bodies
- Gravity application
- SCOOP-compatible concurrent updates

### Out of Scope
- Soft body dynamics (Phase 2)
- Particle systems
- Plane collision detection (Phase 2)
- Box/mesh collisions
- Graphics rendering
- Animation playback
- Constraints (joints, hinges)

## Functional Requirements
| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|---------------------|
| FR-001 | Compute force from mass and acceleration | MUST | F = m * a returns correct force |
| FR-002 | Compute acceleration from force and mass | MUST | a = F / m works correctly |
| FR-003 | Integrate velocity and position with RK4 | MUST | RK4 advances state with error < 1e-6 over 100 steps |
| FR-004 | Manage 3D vectors | MUST | Vector add, subtract, dot, cross product work |
| FR-005 | Manage 3D rotations with quaternions | MUST | Quaternion integration preserves rotation |
| FR-006 | Compute kinetic energy | MUST | KE = 0.5 * m * v² correct |
| FR-007 | Compute potential energy | MUST | PE = m * g * h (gravity) correct |
| FR-008 | Detect sphere-sphere collisions | MUST | Collision identified when distance < r1 + r2 |
| FR-009 | Resolve collision with impulse | MUST | Velocity reversed after elastic collision |
| FR-010 | Create and manage physics world | MUST | World holds bodies, applies forces, integrates steps |
| FR-011 | Apply gravity to all bodies | MUST | Acceleration applied as g * mass |
| FR-012 | Apply spring forces (Hooke's law) | SHOULD | F = -k * x computed correctly |
| FR-013 | Detect plane collisions | SHOULD | Sphere-plane collision (Phase 2) |
| FR-014 | Rigid body rotation physics | SHOULD | Angular velocity, torque, angular acceleration |

## Non-Functional Requirements
| ID | Requirement | Category | Measure | Target |
|----|-------------|----------|---------|--------|
| NFR-001 | Numerical stability | PERFORMANCE | Integration error growth | < 1e-4 per 1000 steps |
| NFR-002 | Handle 100+ bodies | PERFORMANCE | Simulation time per frame | < 16ms (60 FPS) |
| NFR-003 | Type-safe API | QUALITY | Contracts | 100% compile-time verification |
| NFR-004 | SCOOP compatible | CONCURRENCY | Race conditions | Zero unsafe concurrent access |
| NFR-005 | No external dependencies | MAINTAINABILITY | External libs | simple_math only |
| NFR-006 | Void-safe implementation | QUALITY | void_safety | void_safety="all" enforced |
| NFR-007 | Contract coverage | QUALITY | Contracts | Every public feature fully contracted |
| NFR-008 | Test coverage | QUALITY | Pass rate | 100% pass, 50+ tests |

## Constraints
| ID | Constraint | Type |
|----|------------|------|
| C-001 | Must be void-safe | TECHNICAL |
| C-002 | Must be SCOOP-compatible | TECHNICAL |
| C-003 | Must use simple_math for sqrt, trig | ECOSYSTEM |
| C-004 | Only simple_* for external libs | ECOSYSTEM |
| C-005 | All features must have contracts | QUALITY |
| C-006 | Must compile with zero warnings | TECHNICAL |
| C-007 | REAL_64 precision only (no extended) | TECHNICAL |

## Decisions Already Made
| ID | Decision | Rationale | From |
|----|----------|-----------|------|
| D-001 | 3D support | Scientists need 3D; single vector class handles both 2D/3D | research/04 |
| D-002 | RK4 primary method | Industry standard, good accuracy/complexity balance | research/04 |
| D-003 | Sphere+plane collisions | 90% of simulations use spheres; planes for environments | research/04 |
| D-004 | Quaternions for rotation | Physics integration requires stable rotation representation | research/04 |
| D-005 | 3x3 matrices local | Only need small matrices; can't wait for simple_linalg | research/04 |

## Innovations to Implement
| ID | Innovation | Design Impact |
|----|------------|---------------|
| I-001 | Contract-verified physics | Every physics method verifies physical correctness (F=ma, energy) |
| I-002 | Lightweight + scientific | Optimized for research/education, not games |
| I-003 | SCOOP-compatible world | Physics world designed for concurrent updates via SCOOP |
| I-004 | Pure Eiffel implementation | No FFI/C dependencies; maintainable by Eiffel community |

## Risks to Address in Design
| ID | Risk | Mitigation in Design |
|----|------|---------------------|
| RISK-001 | Quaternion math complexity | Thorough unit tests, reference implementations |
| RISK-002 | Collision detection bottleneck | Spatial hashing planned for Phase 2 |
| RISK-003 | Numerical stability | RK4 proven stable; extensive adversarial testing |
| RISK-004 | Scope creep (soft bodies) | Clear MVP definition; defer to Phase 2 |
| RISK-005 | SCOOP complexity | Immutable result objects; careful region design |
| RISK-006 | simple_math dependency | Verify sqrt, sin, cos available early |

## Use Cases

### UC-001: Simple Free Fall
**Actor:** Physics educator demonstrating gravity
**Precondition:** Physics world created, one sphere at height h
**Main Flow:**
1. Set sphere initial position and velocity
2. Apply gravity force
3. Integrate 100 time steps with dt=0.01s
4. Query final position and velocity
**Postcondition:** Height decreased; velocity increased downward

### UC-002: Elastic Collision
**Actor:** Researcher simulating particle collision
**Precondition:** Two spheres moving toward each other
**Main Flow:**
1. Detect collision (distance < r1 + r2)
2. Compute collision normal
3. Apply impulse to reverse velocities
4. Integrate forward
**Postcondition:** Spheres separate; total kinetic energy conserved (elastic)

### UC-003: Concurrent Physics Updates (SCOOP)
**Actor:** Parallel simulation engine
**Precondition:** Physics world with 100 bodies, concurrent region
**Main Flow:**
1. Multiple processors apply forces to different bodies in parallel
2. Each processor integrates its subset of bodies
3. Sync to next time step
**Postcondition:** No race conditions; physics correct

## Requirements Traceability
Every FR/NFR maps to design class(es):
- FR-001,002 → PHYSICS_BODY feature `compute_acceleration`
- FR-003 → PHYSICS_INTEGRATOR feature `rk4_step`
- FR-004 → VECTOR_3D class (add, subtract, dot, cross)
- FR-005 → QUATERNION class (integration, normalization)
- FR-006,007 → PHYSICS_BODY feature `kinetic_energy`, `potential_energy`
- FR-008,009 → COLLISION_DETECTOR, COLLISION_RESOLVER
- FR-010,011 → SIMPLE_PHYSICS facade, PHYSICS_WORLD
