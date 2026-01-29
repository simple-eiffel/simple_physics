# LANDSCAPE: simple_physics

## Existing Solutions

### Project Chrono (C++/Python)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (open-source physics engine) |
| Platform | C++ with Python bindings (PyChrono) |
| URL | https://projectchrono.org/ |
| Maturity | MATURE (production use) |
| License | BSD-3-Clause |
| GitHub | https://github.com/projectchrono/chrono |

**Strengths:**
- Cross-platform (Windows, Linux, macOS)
- Simulates vehicles, robots, mechatronic systems
- Rigid and flexible parts with constraints, motors, contacts
- Large ecosystem and community
- Professional/academic use

**Weaknesses:**
- Large codebase (not lightweight)
- Primarily for complex mechanical systems
- No native type-safe contract system
- Heavy C++ dependency

**Relevance:** 75% - Good reference for scope and API design, but over-engineered for basic physics

---

### Box2D (C++ with language bindings)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (2D physics engine) |
| Platform | C++ with C#, Java, Python, Action Script bindings |
| URL | https://github.com/erincatto/box2d |
| Maturity | MATURE |
| License | MIT |

**Strengths:**
- Lightweight and focused (2D only)
- Very popular in game development
- Simple, clean API
- Excellent documentation
- Used in thousands of games

**Weaknesses:**
- 2D only (no 3D support)
- No explicit contract system
- Oriented toward games, not scientific computing

**Relevance:** 60% - Good for understanding 2D API design, but simple_physics should support 3D

---

### LiquidFun (C++)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (2D physics + particle fluids) |
| Platform | C++ (Google-created, extends Box2D) |
| URL | https://google.github.io/liquidfun/ |
| Maturity | STABLE (limited updates) |
| License | Apache 2.0 |

**Strengths:**
- Particle-based fluid simulation
- Soft body simulation capabilities
- Extends proven Box2D architecture
- Well-documented

**Weaknesses:**
- Unmaintained since ~2015
- 2D only
- Not scientific computing focused

**Relevance:** 40% - Particle systems could inspire future phases

---

### ReactPhysics3D (C++)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (3D physics engine) |
| Platform | C++ |
| URL | https://www.reactphysics3d.com/ |
| GitHub | https://github.com/DanielChappuis/react3d |
| Maturity | GROWING |
| License | ZLib |

**Strengths:**
- Modern 3D physics engine
- Lightweight and focused
- Good for 3D rigid body simulation
- Type-safe C++ design

**Weaknesses:**
- Relatively new (not as battle-tested as Chrono)
- Limited to rigid bodies (no soft bodies)
- Not aimed at scientific computing

**Relevance:** 70% - Best model for 3D scope and modern design patterns

---

### Pymunk (Python)
| Aspect | Assessment |
|--------|------------|
| Type | LIBRARY (2D physics) |
| Platform | Python binding to Chipmunk physics |
| URL | http://www.pymunk.org/ |
| Maturity | MATURE |
| License | MIT |

**Strengths:**
- Easy Python API
- Good documentation
- Active maintenance

**Weaknesses:**
- 2D only
- Not strongly typed
- Educational rather than industrial

**Relevance:** 50% - Good for understanding Python/high-level binding patterns

---

## Eiffel Ecosystem Check

### ISE Libraries
- `base`: Provides ARRAY, LIST, REAL_64, no physics utilities
- `math`: Provides sqrt, sin, cos (basic math only)
- No native physics simulation library

### simple_* Libraries
- `simple_math`: Will provide sqrt, trigonometry - WILL DEPEND ON THIS
- `simple_linalg`: Future - for matrix/vector operations
- **GAP:** No physics library exists in Eiffel ecosystem

### Gobo Libraries
- No physics library in Gobo

### Gap Analysis
**Critical Gap:** No type-safe, contract-based physics library exists for Eiffel. All competitors are either:
1. Heavyweight general-purpose engines (Chrono, ODE)
2. Game-oriented 2D engines (Box2D, Pymunk)
3. Not available for Eiffel at all

**Opportunity:** simple_physics could fill a unique niche: lightweight, scientifically-focused, contract-verified physics for Eiffel.

---

## Comparison Matrix
| Feature | Project Chrono | Box2D | ReactPhysics3D | Our Need |
|---------|---|---|---|---|
| 2D physics | ✓ | ✓ | ✓ | SHOULD |
| 3D physics | ✓ | ✗ | ✓ | MUST |
| Type-safe contracts | ✗ | ✗ | ✗ | MUST |
| Lightweight | ✗ | ✓ | ✓ | MUST |
| Scientific focus | ✓ | ✗ | Partial | MUST |
| Rigid bodies | ✓ | ✓ | ✓ | MUST |
| Soft bodies | ✓ | ✗ | ✗ | SHOULD (Phase 2) |
| Particles | ✓ | ✗ | ✗ | SHOULD (Phase 2) |
| SCOOP compatible | ✗ | ✗ | ✗ | MUST |

---

## Patterns Identified
| Pattern | Seen In | Adopt? |
|---------|---------|--------|
| Rigid body simulation | All | YES |
| Numerical integration (RK4) | All | YES |
| Constraint systems | Chrono, ReactPhysics3D | YES |
| Spatial hashing for collisions | Box2D, Chrono | YES |
| Physics world/scene object | All | YES |
| Entity-component architecture | Modern engines | MAYBE (Phase 2) |

---

## Build vs Buy vs Adapt
| Option | Effort | Risk | Fit |
|--------|--------|------|-----|
| BUILD | MEDIUM | LOW | 95% - Scope manageable, well-understood domain |
| ADAPT | MEDIUM | MEDIUM | 60% - Would need to wrap C++ physics engine via FFI |
| ABANDON | NONE | N/A | 0% - Leaves gap in ecosystem |

**Initial Recommendation:** BUILD

**Rationale:** Physics simulation is a well-studied domain with established algorithms. The scope is manageable for an MVP (RK4 integration, rigid bodies, basic collisions). Adapting existing C++ libraries would lose Eiffel's type safety benefits. Building allows us to:
1. Maintain contract-based verification
2. Integrate with SCOOP
3. Create lightweight library optimized for Eiffel
4. Fill ecosystem gap

---

## References
- Project Chrono: https://projectchrono.org/
- Box2D: https://github.com/erincatto/box2d
- ReactPhysics3D: https://www.reactphysics3d.com/
- Pymunk: http://www.pymunk.org/
- Open-source physics engines: https://medevel.com/os-physics-engine/
- Physics simulation comparison: https://daily.dev/blog/top-9-open-source-2d-physics-engines-compared
- Mechanics textbooks: standard references for F=ma, energy, collisions
