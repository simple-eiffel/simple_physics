# RECOMMENDATION: simple_physics

## Executive Summary
simple_physics should be built as a lightweight, contract-verified 3D rigid body physics library optimized for scientific computing and education. It fills a critical gap in the Eiffel ecosystem between game-focused Box2D and research-focused Chrono, providing type-safe physics simulation with SCOOP support and zero external C dependencies.

## Recommendation
**Action:** BUILD
**Confidence:** HIGH

## Rationale
1. **Gap in ecosystem:** Eiffel has no physics library; scientists choose Python/C++ instead
2. **Well-defined scope:** Physics is solved problem; established algorithms for MVP
3. **Type-safe advantage:** Contracts allow formal verification of physical laws
4. **SCOOP opportunity:** Can support concurrent physics updating (unique)
5. **Reasonable effort:** MVP is manageable for established team

## Proposed Approach

### Phase 1 (MVP) - 3-4 months
- **Mechanics foundation:**
  - Vector (3D) operations and 3x3 matrices
  - Force, velocity, position integration (RK4)
  - Kinetic and potential energy
- **Dynamics:**
  - Mass and inertia
  - Gravity application
  - Physics world with body management
- **Collisions:**
  - Sphere-sphere detection and resolution
  - Plane collision detection
  - Impulse-based collision response
- **Quality:**
  - 50+ tests (100% pass)
  - Full contract coverage
  - SCOOP design (activation in Phase 2)

### Phase 2 (Full) - Future
- Stiff body rotation physics
- Constraints (springs, ropes)
- Soft body simulation
- Particle systems
- Event callbacks
- Advanced collision shapes

## Key Features
1. **Contract-Verified Physics** - Every operation guarantees physical correctness
2. **Type-Safe 3D Vectors** - No manual float arrays; compiler checks
3. **SCOOP-Ready Architecture** - Concurrent physics updates (future)
4. **Zero External Dependencies** - Pure Eiffel except simple_math
5. **Educational Focus** - Clear API for learning physics simulation

## Success Criteria
- MVP achieves stable 100-body simulation
- Integration error stays < 1e-4 over 1000 steps
- 43+ tests passing (100% pass rate)
- Zero compilation warnings
- Documented algorithms in architecture guide

## Dependencies
| Library | Purpose | simple_* Preferred |
|---------|---------|-------------------|
| simple_math | sqrt, sin, cos for trigonometry | YES |
| simple_mml | Future: model queries for contract verification | YES (Phase 2) |

## Next Steps
1. Run `/eiffel.spec` to transform this research into Eiffel specification
2. Run `/eiffel.intent` to capture refined intent from specification
3. Continue with Eiffel Spec Kit workflow (Phases 1-7)
4. Target completion: end of Q2 2026

## Open Questions
- Should MVP include 2D/3D options or 3D only? → Recommend 3D only for clarity
- How to handle quaternion conventions (WXYZ vs XYZW)? → Use XYZW (industry standard)
- Should collision normals be computed or only distances? → Compute normals for Phase 1
