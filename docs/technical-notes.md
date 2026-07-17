# Technical Notes

This document provides architectural context and implementation details for Montrose.

### Reactive Resource Model

Montrose embraces the Reactive Resource Model to handle distributed state. 
Instead of relying on imperative, synchronous RPC-style HTTP requests that mask network complexities, the Reactive Resource Model treats network resources as distinct entities communicating via message passing. 
This approach isolates high-level code from the underlying transport mechanics. 
Montrose surfaces this model by providing a class-based interface that leverages event streams.
This allows developers to handle dynamic state updates gracefully without writing defensive, spot-check logic for network failures.

### Belmont Integration

Montrose acts as a wrapper around Belmont, the core reactive resource manager for the DashKite ecosystem. 
Belmont provides the foundational wiring by mapping abstract resource locators to concrete, event-driven providers. 
Belmont manages a registry of instantiated providers and delegates operations to the appropriate protocol, whether that is Broadway for live HTTP endpoints, Halstead for local storage, or Lakeshore for mock testing.

### Resource Delegation

Rather than reimplementing the complexities of resource resolution and event multiplexing, Montrose delegates operations directly to the underlying Belmont instance. 
When developers invoke methods like `observe`, `get`, or `put` on a Montrose `Resource`, they interact with the Belmont engine under the hood. 
This design delivers a convenient, focused API for UI component state management while inheriting Belmont's robust provider ecosystem and Sky API integration.
