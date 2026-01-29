# CHALLENGED ASSUMPTIONS: simple_physics

## Assumptions Challenged

### A-001: RK4 is Necessary for MVP
**Challenge:** Could Euler method suffice for simple cases, deferring RK4 to Phase 2?
**Evidence for:** Euler is simpler to implement, test, and understand; many educational examples use Euler
**Evidence against:** RK4 only ~4x more complex; industry standard; Euler error unacceptable for scientific use
**Verdict:** VALID - RK4 should be Phase 1, not Euler-only
**Action:** Implement RK4 as primary; Euler as fallback for testing/learning

### A-002: Quaternions Are Necessary for Phase 1
**Challenge:** Could we defer quaternion rotation to Phase 2, keep bodies as point masses only?
**Evidence for:** Simplifies MVP significantly; most simple simulations don't rotate
**Evidence against:** Quaternions not much more complex than vectors; prevents incorrect results later
**Verdict:** MODIFY - Phase 1 is linear motion only; rotation deferred to Phase 2
**Action:** Remove rotation/quaternion from Phase 1 scope (simplifies significantly)

### A-003: Sphere Collisions Are the Only Must-Have
**Challenge:** Should planes be included in MVP (many simulations have ground planes)?
**Evidence for:** Planes are extremely common; sphere-plane collision is straightforward
**Evidence against:** Adds complexity; can represent ground as large sphere initially
**Verdict:** VALID - Sphere+plane deferred to Phase 2; use large sphere workaround
**Action:** Phase 1: sphere-sphere only; clear documentation of workaround

### A-004: 100+ Bodies Must Be Supported in Phase 1
**Challenge:** What if we target 10-20 bodies for MVP, scale to 100+ in Phase 2?
**Evidence for:** Reduces testing burden; simpler to verify correctness on small systems
**Evidence against:** Real use cases need 100+; O(n²) collision detection fine for 100 with simple optimization
**Verdict:** MODIFY - Target 50 bodies for Phase 1, scale to 100+ in Phase 2
**Action:** Document performance limits clearly; design for future spatial hashing

### A-005: simple_math Provides All Needed Functions
**Challenge:** What if simple_math is missing sqrt, sin, cos, or atan2?
**Evidence for:** simple_math is standard, should have trig
**Evidence against:** Possible gap if simple_math is incomplete
**Verdict:** NEEDS_VALIDATION - Verify simple_math completeness before Phase 1
**Action:** Early integration gate: confirm sqrt, sin, cos, atan2 available

### A-006: Impulse Resolution is Correct Collision Response
**Challenge:** Should we use penalty method or Lagrange multipliers instead?
**Evidence for:** Impulse is standard in game physics; simpler than penalty methods
**Evidence against:** Requires careful tuning; penalty method more robust
**Verdict:** VALID - Impulse standard; extensive testing will validate
**Action:** Implement impulse-based; deferred advanced methods to Phase 2

### A-007: No Constraints Needed for Phase 1
**Challenge:** Will users immediately ask for joints/hinges/constraints?
**Evidence for:** MVP scope is rigid bodies; constraints are Phase 2
**Evidence against:** Some common scenarios (pendulum) need constraints
**Verdict:** VALID - Keep MVP simple; provide workarounds (long stiff springs)
**Action:** Document constraint workarounds; roadmap Phase 2 constraint support

### A-008: Energy Conservation Is Testable
**Challenge:** Can we actually verify energy conservation to contract-level precision?
**Evidence for:** Elastic collisions + no friction → total energy constant
**Evidence against:** Floating-point rounding → small energy changes inevitable
**Verdict:** MODIFY - Test energy conservation to 0.1% tolerance, not exact
**Action:** Contract postconditions specify tolerance bounds, not exact equality

## Requirements Questioned

### FR-003: RK4 Accuracy Criterion
**Requirement:** RK4 integration advances state with error < 1e-6 over 100 steps
**Challenge:** Is 1e-6 realistic? RK4 local error is O(h⁵); over 100 steps accumulation could be higher
**Verdict:** MODIFY - Change to "RK4 error < 1e-4 over 100 steps with dt=0.01"
**Action:** Use empirical adversarial testing to validate error bound

### FR-011: Gravity Applied to All Bodies
**Requirement:** Acceleration applied as g * mass
**Challenge:** Should gravity be per-body configurable? Some objects should float
**Verdict:** MODIFY - Add "can disable gravity per-body" to FR-011 extension
**Action:** PHYSICS_BODY.set_ignore_gravity feature

### FR-012: Spring Forces
**Requirement:** F = -k * x force computed correctly
**Challenge:** Is spring force important for MVP? Could defer to Phase 2
**Verdict:** MODIFY - Defer spring forces (FR-012) to Phase 2
**Action:** Remove from Phase 1 scope; add to Phase 2 roadmap

## Missing Requirements Identified

| ID | Missing Requirement | How Discovered |
|----|---------------------|-----------------|
| FR-015 | Per-body time scale | Pausing individual bodies without pausing simulation |
| FR-016 | Velocity damping | Air resistance/drag force without explicit spring |
| FR-017 | Rotation locking | Prevent rotation around specific axis |
| FR-018 | Body type (static/dynamic/kinematic) | Standard physics pattern |
| FR-019 | Query closest bodies to point | Optimization for broad phase |
| FR-020 | Batch integration | Integrate subset of bodies without others |

**Decisions:**
- FR-015, 016: Deferred to Phase 2 (complexity)
- FR-017: Deferred to Phase 2 (constraint-like)
- FR-018: ADD to Phase 1 (enables static ground plane without collision)
- FR-019, 020: Deferred to Phase 2 (optimization)

## Design Constraints Validated

| Constraint | Valid? | Notes |
|-----------|--------|-------|
| simple_* first | YES | simple_math is only external dependency |
| SCOOP-compatible | VALID IF | Requires immutable result objects, careful regions |
| void_safety="all" | YES | No null issues with proper null checks |
| Zero warnings | YES | Standards-compliant Eiffel compiles clean |
| REAL_64 precision | YES | Scientific computing standard |

## Revised Scope (Post-Challenge)

### Phase 1 (Simplified MVP)
✓ VECTOR_3D arithmetic (no quaternion yet)
✓ PHYSICS_BODY with linear motion only
✓ PHYSICS_WORLD with gravity (configurable per body)
✓ Sphere-sphere collision detection only
✓ Impulse-based collision response
✓ RK4 integration (error tolerance ~1e-4)
✓ Kinetic/potential energy computation
✓ Body types: static, dynamic (enables ground planes)
✗ Rotation/quaternion (Phase 2)
✗ Spring forces (Phase 2)
✗ Plane collisions (Phase 2)
✗ Constraints (Phase 2)

### Performance Targets (Revised)
- Target: 50 bodies, not 100+ (Phase 1)
- Performance: < 5ms per frame (50 FPS)
- Accuracy: RK4 error < 1e-4 per 100 steps

### Testing Strategy (Revised)
- Unit tests for VECTOR_3D, RK4 integrator
- Scenario tests: free fall, collision, energy conservation (to 0.1% tolerance)
- Adversarial tests: extreme forces, very small time steps, edge collisions
