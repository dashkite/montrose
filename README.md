# Montrose

*HTTP-based state-management*

[![Hippocratic License HL3-CORE](https://img.shields.io/static/v1?label=Hippocratic%20License&message=HL3-CORE&labelColor=5e2751&color=bc8c3d)](https://firstdonoharm.dev/version/3/0/core.html)

Montrose is a wrapper around the Belmont reactive resource manager that provides a class-based interface for managing HTTP-based state. It manages the process of resolving, observing, and mutating resources, making it a good fit for backing UI components or other stateful elements.

## Features

- Provides a class-based wrapper for Belmont resources.
- Supports resolving resources from locators asynchronously.
- Enables reactive observation of resource updates.
- Wraps standard HTTP operations including GET, PUT, POST, and DELETE.

## Installation

To install Montrose, use the following command:

```bash
pnpm install @dashkite/montrose
```

## Usage

Developers can use Montrose to resolve a resource and observe its changes.

```coffeescript
import Resource from "@dashkite/montrose"

# Resolve a resource
resource = await Resource.resolve template: "local:/components/greeting"

# Observe changes
resource
  .observe()
  .when "update", ({ value }) -> console.log "Updated:", value
  .run()

# Mutate state
await resource
  .put "hello, world!"
  .run()
```

## Other Resources

- [Reference Documentation](docs/reference.md)
- [Usage Guides](docs/recipes.md)
- [Technical Notes](docs/technical-notes.md)
- [Testing](docs/testing.md)
