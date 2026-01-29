# Intent: simple_physics

## What
A production-grade physics simulation engine for Eiffel applications supporting rigid body dynamics with collision detection and response, using 4th-order Runge-Kutta numerical integration.

## Why
Eiffel lacks a native physics library. Applications requiring physics simulation currently depend on external bindings or custom implementations. simple_physics provides a pure-Eiffel, Design-by-Contract verified solution suitable for educational, engineering, and game development contexts.

## Users
- Eiffel educators teaching physics simulation
- Researchers modeling rigid body systems
- Game/simulation developers using Eiffel
- Scientific computing applications

## Acceptance Criteria
- [ ] RK4 integration with O(h⁵) local error control
- [ ] Sphere-sphere collision detection and response
- [ ] Up to 50 bodies simulated in real-time
- [ ] Immutable result objects safe for SCOOP
- [ ] 100% Design by Contract coverage
- [ ] Zero compilation warnings
- [ ] All tests passing (100% pass rate)

## Out of Scope
- Rotation/quaternions (Phase 2+)
- Particle systems
- Deformable bodies
- Soft-body dynamics
- Non-sphere collision shapes (Phase 2+)
- Parallel integration across bodies (single-threaded Phase 1)

## Dependencies

| Need | Library | Justification |
|------|---------|---------------|
| Square root, basic math | simple_math | Standard Eiffel utility |
| Data structures | ISE base | Fundamental types only |
| Testing framework | ISE testing | EQA_TEST_SET for unit tests |

**MML Decision:** YES-Required

Rationale: PHYSICS_BODY contains ARRAYED_LIST of bodies and force vectors. COLLISION_INFO contains position/velocity vectors. Frame conditions requiring MML model queries are essential for verifying collision physics properties (momentum/energy conservation).

## Technical Constraints
- **void_safety="all"**: All potential null pointers handled
- **SCOOP compatible**: PHYSICS_RESULT immutable for concurrent access
- **No external C bindings**: Pure Eiffel implementation
- **Linear motion only**: No rotation in Phase 1

## Gaps Identified (Potential simple_* Libraries)

| Gap | Current Workaround | Proposed simple_* |
|-----|-------------------|-------------------|
| Quaternion math | Not implemented (Phase 2+) | simple_quaternion |
| Matrix operations | Manual vector math | simple_matrix |
| Parametric curves | Not needed Phase 1 | simple_curves |

**Recommendation:** After shipping Phase 1, consider simple_quaternion to enable rotational physics in Phase 2.

## Phase Scope
**Phase 1 MVP:** 12 classes, linear motion, sphere collisions, RK4 integration
**Phase 2:** Quaternions, additional collision shapes, optimization
**Phase 3+:** Deformable bodies, particle systems, GPU optimization

## Success Metrics
- Implementation passes all 12 task acceptance criteria
- Contract violations caught by design (preconditions/postconditions)
- No external library dependencies beyond simple_math and ISE base
- Demonstrates RK4 convergence on free-fall and collision test cases
