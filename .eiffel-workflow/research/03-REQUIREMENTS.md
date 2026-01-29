# REQUIREMENTS: simple_physics

## Functional Requirements
| ID | Requirement | Priority | Acceptance Criteria |
|----|-------------|----------|---------------------|
| FR-001 | Compute force from mass and acceleration | MUST | F = m * a returns correct force for given inputs |
| FR-002 | Compute acceleration from force and mass | MUST | a = F / m works correctly |
| FR-003 | Integrate velocity and position over time | MUST | RK4 integration advances state with error < 1e-6 over 100 steps |
| FR-004 | Manage 3D vectors (position, velocity, force) | MUST | Vector arithmetic (add, subtract, dot product, cross product) works |
| FR-005 | Manage 3D rotations and angular velocity | MUST | Quaternion or rotation matrix integration works |
| FR-006 | Compute kinetic energy | MUST | KE = 0.5 * m * v² computed correctly |
| FR-007 | Compute potential energy | MUST | PE = m * g * h (gravity) works |
| FR-008 | Detect sphere-sphere collisions | MUST | Distance check identifies collision when distance < r1 + r2 |
| FR-009 | Resolve collision with impulse | MUST | Velocity reversed after elastic collision |
| FR-010 | Create and manage physics world | MUST | World holds bodies, applies forces, integrates time steps |
| FR-011 | Apply gravity to all bodies | MUST | Acceleration applied as g * mass |
| FR-012 | Apply spring forces (Hooke's law) | SHOULD | F = -k * x force computed correctly |
| FR-013 | Detect plane collisions | SHOULD | Sphere-plane and box-plane collision detection |
| FR-014 | Rigid body rotation physics | SHOULD | Angular velocity, torque, angular acceleration |

## Non-Functional Requirements
| ID | Requirement | Category | Measure | Target |
|----|-------------|----------|---------|--------|
| NFR-001 | Numerical stability | PERFORMANCE | Integration error growth | < 1e-4 per 1000 steps |
| NFR-002 | Handle 100+ bodies | PERFORMANCE | Simulation time per frame | < 16ms (60 FPS) |
| NFR-003 | Type-safe API | QUALITY | All contracts verified | 100% compile-time verification |
| NFR-004 | SCOOP compatibility | CONCURRENCY | Concurrent physics updates | No race conditions |
| NFR-005 | No external dependencies | MAINTAINABILITY | External libs used | simple_math only |
| NFR-006 | Void-safe implementation | QUALITY | void_safety setting | void_safety="all" enforced |
| NFR-007 | Contract coverage | QUALITY | require/ensure/invariant | Every public feature fully contracted |
| NFR-008 | Test coverage | QUALITY | Test pass rate | 100% pass rate, 50+ tests |

## Constraints
| ID | Constraint | Type | Immutable? |
|----|------------|------|------------|
| C-001 | Must be void-safe | TECHNICAL | YES |
| C-002 | Must be SCOOP-compatible | TECHNICAL | YES |
| C-003 | Must use simple_math for sqrt, trig | ECOSYSTEM | YES |
| C-004 | Only simple_* for external libs | ECOSYSTEM | YES |
| C-005 | All features must have contracts | QUALITY | YES |
| C-006 | Must compile with zero warnings | TECHNICAL | YES |
| C-007 | REAL_64 precision only (no extended) | TECHNICAL | YES |
