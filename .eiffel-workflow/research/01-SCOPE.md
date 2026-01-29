# SCOPE: simple_physics

## Problem Statement
In one sentence: Provide a type-safe, contract-based physics simulation library for mechanics, electromagnetism, and thermodynamics calculations in Eiffel.

What's wrong today: Physics calculations in Eiffel require custom implementations; no standard library exists for common physics operations. Scientists and engineers must either reinvent the wheel or use external C/Fortran libraries via FFI, losing type safety and contract guarantees.

Who experiences this: Scientific software developers, engineers, educators, computational physicists, simulation framework builders in Eiffel.

Impact of not solving: Eiffel loses territory in scientific computing; physics-intensive applications must choose other languages; educational institutions can't teach physics with type-safe contracts.

## Target Users
| User Type | Needs | Pain Level |
|-----------|-------|------------|
| Computational physicist | Simulate particle systems, forces, energy | HIGH |
| Engineer | Structural analysis, thermodynamics, fluid dynamics | HIGH |
| Educator | Teach physics with verifiable contracts | MEDIUM |
| Researcher | Scientific computing with formal verification | HIGH |
| Game developer | Physics engine for simulations | MEDIUM |

## Success Criteria
| Level | Criterion | Measure |
|-------|-----------|---------|
| MVP | Basic mechanics (forces, motion, energy) | F=ma, kinematics working correctly |
| MVP | Numerical integration methods | RK4, Euler, Verlet stable on 100+ body systems |
| Full | Electromagnetism basics | Coulomb force, magnetic fields |
| Full | Thermodynamics | Temperature, heat transfer, entropy |
| Full | Collision detection | Basic sphere-sphere, point-plane collisions |

## Scope Boundaries
### In Scope (MUST)
- Newtonian mechanics (forces, acceleration, velocity, position)
- Energy calculations (kinetic, potential, total mechanical energy)
- Numerical integration (Euler, RK2, RK4)
- Vector and matrix operations for 3D physics
- Basic collision detection (sphere, plane, AABB)
- Rigid body dynamics (rotation, angular momentum)
- Design by Contract on all operations
- SCOOP compatibility for concurrent simulations

### In Scope (SHOULD)
- Electromagnetism (Coulomb force, magnetic fields)
- Thermodynamics (temperature, heat transfer, ideal gas law)
- Constraint solvers (rope, spring constraints)
- Particle systems (emitters, collision groups)
- Performance-optimized spatial hashing

### Out of Scope
- Fluid dynamics (Navier-Stokes solvers) → future simple_fluid
- Quantum mechanics → fundamentally different paradigm
- GPU acceleration → belongs in separate library
- Advanced FEM/CFD → too specialized
- Graphics rendering → out of scope (use simple_graphics)

### Deferred to Future
- Soft body dynamics → Phase 2 when core is stable
- Cloth simulation → Phase 3 after soft bodies
- Fluid dynamics → separate simple_fluid library
- Distributed physics (network multiplayer) → Phase 3

## Constraints
| Type | Constraint |
|------|------------|
| Technical | Must be void-safe (void_safety="all") |
| Technical | Must be SCOOP-compatible for concurrent physics updates |
| Technical | Must use simple_math for sqrt, trigonometry |
| Technical | Numerical stability required (error < 1e-6 over 1000 steps) |
| Ecosystem | Must prefer simple_* over ISE libraries |
| Performance | O(n) collision detection for 1000+ bodies |
| API | Contract-based with full require/ensure/invariant |

## Assumptions to Validate
| ID | Assumption | Risk if False |
|----|------------|---------------|
| A-1 | Eiffel community needs physics simulation | Medium - could pivot to graphics-heavy applications instead |
| A-2 | Type-safe contracts are valued over raw speed | Medium - but DBC is Eiffel's selling point |
| A-3 | Numerical integration (RK4) sufficient for most uses | Low - can add higher-order methods later |
| A-4 | simple_math provides sqrt and trig functions | Low - can implement if needed |
| A-5 | REAL_64 precision adequate for physics | Low - can use simple_decimal if needed |

## Research Questions
- What physics libraries exist in other languages and how are they structured?
- What does Eiffel's ISE library offer for mathematics?
- Are there existing Eiffel physics implementations or partial solutions?
- What numerical integration methods are standard in production physics engines?
- How do successful physics libraries handle concurrency?
- What are the performance expectations for physics simulations?
- How do production physics engines structure collision detection?
