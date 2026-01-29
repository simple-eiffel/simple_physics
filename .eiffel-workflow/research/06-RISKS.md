# RISKS: simple_physics

## Risk Register

| ID | Risk | Likelihood | Impact | Mitigation |
|----|------|------------|--------|------------|
| RISK-001 | Quaternion math is complex | MEDIUM | MEDIUM | Thorough testing, reference implementations |
| RISK-002 | Collision detection bottleneck | MEDIUM | HIGH | Spatial hashing, broad phase optimization |
| RISK-003 | Numerical stability (integration) | LOW | HIGH | RK4 stable, extensive adversarial testing |
| RISK-004 | Community may want more features (soft bodies) | HIGH | MEDIUM | Clear MVP scope, defer to Phase 2 |
| RISK-005 | FFI integration (if needed) | LOW | HIGH | Keep pure Eiffel, plan migration |

## Technical Risks

### RISK-001: Quaternion Implementation Complexity
**Description:** Quaternion algebra is non-intuitive; implementation errors can be subtle
**Likelihood:** MEDIUM
**Impact:** MEDIUM (silent errors in rotation)
**Indicators:** Test failures, unexpected rotations in simulations
**Mitigation:** Implement carefully with reference to multiple sources; extensive unit tests
**Contingency:** Fallback to rotation matrices if quaternions prove problematic

### RISK-002: Collision Detection Performance
**Description:** O(n²) broad phase collision detection may be slow for 100+ bodies
**Likelihood:** MEDIUM
**Impact:** HIGH (unusable for large systems)
**Indicators:** Frame time > 16ms for 100 bodies
**Mitigation:** Spatial hashing grid to reduce comparisons; deferred broad phase
**Contingency:** Phase 2 adds spatial octree or BVH acceleration

### RISK-003: Numerical Stability Over Long Simulations
**Description:** RK4 error accumulation may grow unboundedly in very long simulations
**Likelihood:** LOW
**Impact:** HIGH (physics diverges)
**Indicators:** Energy conservation violation > 1% after 1000 steps
**Mitigation:** RK4 is standard choice; extensive testing; monitor energy
**Contingency:** Add symplectic integrators in Phase 2

## Ecosystem Risks

### RISK-004: Dependency on simple_math
**Description:** If simple_math √ doesn't provide needed functions, blocked
**Likelihood:** LOW (simple_math has sqrt, sin, cos)
**Impact:** MEDIUM (need fallback implementation)
**Mitigation:** Verify simple_math provides needed functions early
**Contingency:** Implement trig functions locally if needed

### RISK-005: SCOOP Complexity
**Description:** Concurrent physics updates may introduce subtle race conditions
**Likelihood:** MEDIUM
**Impact:** HIGH (non-deterministic bugs)
**Mitigation:** Immutable result objects; careful region design; concurrency testing
**Contingency:** Phase 1 is single-threaded, add SCOOP in Phase 2

## Resource Risks

### RISK-006: Scope Creep
**Description:** User requests (soft bodies, particles) expand MVP beyond capacity
**Likelihood:** HIGH
**Impact:** MEDIUM (schedule slip)
**Mitigation:** Clear MVP definition; defer to Phase 2
**Contingency:** Strict scope enforcement, documented roadmap
