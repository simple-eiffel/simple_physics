# DECISIONS: simple_physics

## Decision Log

### D-001: 2D vs 3D Physics
**Question:** Should MVP support 2D only or full 3D?
**Options:**
1. 2D only: Simpler MVP, less code, follows Box2D pattern
2. 3D support: More complex, aligns with modern physics engines, better for scientific work

**Decision:** 3D support
**Rationale:** Scientists and engineers need 3D; 2D is subset; single vector class can handle both
**Implications:** Vector/matrix code is slightly more complex, but worth it for scope
**Reversible:** YES - can simplify later if needed

---

### D-002: RK4 vs Higher-Order Methods
**Question:** What integration method should be primary?
**Options:**
1. Euler only: Simplest, lowest accuracy
2. RK4: Good balance of accuracy and complexity, standard in physics
3. RK8 or higher: More accurate, more complex

**Decision:** RK4 as default, Euler/RK2 for testing
**Rationale:** RK4 is industry standard, good accuracy without excess complexity
**Implications:** 4 substeps per integration step
**Reversible:** YES - can add RK8 in Phase 2

---

### D-003: Collision Detection Scope
**Question:** What collision shapes should MVP support?
**Options:**
1. Spheres only: Simplest, 1 distance check
2. Spheres + planes: Covers most use cases
3. Full mesh collisions: Complex, deferred

**Decision:** Spheres + planes (+ AABBs if time permits)
**Rationale:** 90% of simulations use spheres; planes for environments
**Implications:** O(n²) broad phase needed
**Reversible:** YES - can add complex shapes in Phase 2

---

### D-004: Rotation Representation
**Question:** How to represent 3D rotations?
**Options:**
1. Euler angles: Intuitive, gimbal lock issues
2. Quaternions: Complex math, stable, better for integration
3. Rotation matrices: Straightforward, 9 values, more storage

**Decision:** Quaternions for core, Euler angles as convenience API
**Rationale:** Physics integration requires stable rotation representation
**Implications:** Quaternion implementation needed
**Reversible:** YES - can refactor to matrices later

---

### D-005: Dependency on simple_linalg
**Question:** Should we wait for simple_linalg or implement matrix ops locally?
**Options:**
1. Wait for simple_linalg: Deferred dependency
2. Implement 3x3 matrices ourselves: Self-contained MVP

**Decision:** Implement 3x3 matrices locally for now
**Rationale:** Only need small matrices; can't wait for simple_linalg
**Implications:** Matrix code in this library, migration path when simple_linalg ready
**Reversible:** YES - can extract to simple_linalg later
