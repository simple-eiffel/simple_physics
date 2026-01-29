# simple_physics

[Documentation](https://simple-eiffel.github.io/simple_physics/) •
[GitHub](https://github.com/simple-eiffel/simple_physics) •
[Issues](https://github.com/simple-eiffel/simple_physics/issues)

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Eiffel 25.02](https://img.shields.io/badge/Eiffel-25.02-purple.svg)
![DBC: Contracts](https://img.shields.io/badge/DBC-Contracts-green.svg)

Production-ready physics simulation engine for Eiffel with rigid body dynamics, RK4 integration, and sphere collision detection.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

✅ **Production Ready** — v1.0.0
- 70 tests passing (52 unit + 18 adversarial), 100% pass rate
- RK4 integration, sphere collision, impulse resolution
- Design by Contract throughout, void-safe, SCOOP-compatible

## Quick Start

```eiffel
local
    l_physics: SIMPLE_PHYSICS
    l_world: PHYSICS_WORLD
    l_body: PHYSICS_BODY
    l_pos, l_vel: VECTOR_3D
do
    create l_physics.make
    l_physics.set_gravity (9.8).do_nothing
    l_world := l_physics.create_world

    create l_pos.make (0.0, 100.0, 0.0)
    create l_vel.zero
    create l_body.make (10.0, 0.5, l_pos, l_vel)

    l_world.add_body (l_body)

    -- Simulate 1 second
    from i := 1 until i > 60 loop
        l_world.integrate_step (0.016)
        i := i + 1
    end
end
```

For complete documentation, see [our docs site](https://simple-eiffel.github.io/simple_physics/).

## Features

- **3D Vectors:** Immutable vectors with arithmetic, dot/cross products, normalization
- **Rigid Body Dynamics:** Static and dynamic bodies with mass, position, velocity, energy
- **RK4 Integration:** Fourth-order Runge-Kutta for accurate time stepping
- **Collision Detection:** Sphere-sphere with contact geometry
- **Collision Resolution:** Impulse-based response with post-collision velocities
- **Design by Contract:** Complete specifications for safety-critical use
- **SCOOP Compatible:** Concurrent programming support with immutable results
- **Void-Safe:** Full void_safety=all with no null pointer errors

## Installation

Add to your ECF configuration file:

```xml
<library name="simple_physics" location="$SIMPLE_EIFFEL/simple_physics/simple_physics.ecf"/>
```

## Documentation

- **[Quick API](https://simple-eiffel.github.io/simple_physics/quick.html)** — 5-minute reference
- **[User Guide](https://simple-eiffel.github.io/simple_physics/user-guide.html)** — Tutorials and patterns
- **[API Reference](https://simple-eiffel.github.io/simple_physics/api-reference.html)** — Complete API
- **[Architecture](https://simple-eiffel.github.io/simple_physics/architecture.html)** — Design decisions
- **[Cookbook](https://simple-eiffel.github.io/simple_physics/cookbook.html)** — Real-world examples

## License

MIT License - See LICENSE file

## Support

- **Docs:** https://simple-eiffel.github.io/simple_physics/
- **GitHub:** https://github.com/simple-eiffel/simple_physics
- **Issues:** https://github.com/simple-eiffel/simple_physics/issues
