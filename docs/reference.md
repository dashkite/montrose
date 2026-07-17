# Montrose API Reference

This document provides the complete API reference for Montrose.

## Reactive Resource Integration

Before interacting with the class API, it is helpful to understand how Montrose relates to the underlying system. Montrose acts as a streamlined, object-oriented layer atop Belmont, the core reactive resource manager.

The primary interaction developers have with Montrose involves passing a locator (e.g., `local:/components/greeting` or `https://api.example.com/users`) to the `Resource` class. Belmont translates this locator and connects to the correct provider—whether that is a live network endpoint, local storage, or a testing mock. From that point forward, the `Resource` instance delegates all observations and mutations directly to Belmont's event-driven architecture, enabling developers to build highly reactive components without managing network mechanics.

## Resource

The `Resource` class provides the primary interface for resolving locators and engaging with the resulting event streams.

### make

$make: locator \to resource$

Instantiates a new, unresolved `Resource` instance bound to the provided locator object. 
Unlike the asynchronous `resolve` methods, this factory method operates synchronously. 
The developer relies on `make` when they need to define the resource binding early in a component's lifecycle but wish to defer the actual Belmont provider resolution until the component mounts.

```coffeescript
resource = Resource.make template: "local:/components/greeting"
assert.deepEqual resource.locator, template: "local:/components/greeting"
```

### resolve

$resolve: locator \dashrightarrow resource$

Instantiates a new `Resource` and immediately asks Belmont to resolve the provided locator asynchronously against its registry of providers. 
The method returns a fully connected resource that is ready to observe state changes or issue HTTP requests.

```coffeescript
resource = await Resource.resolve template: "local:/components/greeting"
assert.ok resource.resource
```

### resolve

$resolve: \dashrightarrow resource$

Triggers the asynchronous Belmont resolution phase for an already instantiated `Resource`. 
Developers invoke this instance method when the resource was previously created via `make`. 
This connects the resource to the underlying provider dynamically.

```coffeescript
resource = Resource.make template: "local:/components/greeting"
await resource.resolve()
assert.ok resource.resource
```

### observe

$observe: \to observer$

Starts an event multiplexing stream for the underlying Belmont resource. 
This method returns an observer instance that developers configure using the `.when()` chain to handle incoming state updates reactively. 
This perfectly aligns with the message-passing philosophy of the Reactive Resource Model, decoupling the state logic from the network transport.

```coffeescript
resource = await Resource.resolve template: "local:/components/greeting"
observer = resource.observe()
assert.ok observer
```

### cancel

$cancel: \to \emptyset$

Terminates the active observer, tearing down the event stream for this resource instance. 
Developers ALWAYS call this method during a component's teardown phase to free up resources, clear network listeners, and prevent memory leaks.

```coffeescript
resource = await Resource.resolve template: "local:/components/greeting"
resource.observe()
resource.cancel()
assert.equal resource.observer, undefined
```

### get

$get: \dashrightarrow request$

Delegates an HTTP GET operation to the Belmont provider. 
This retrieves the current state of the resolved resource. 
Because the provider handles the transport layer, this method reliably returns a request chain regardless of whether the backend is a live API or a local simulation.

```coffeescript
resource = await Resource.resolve template: "local:/components/greeting"
request = resource.get()
assert.ok request
```

### put

$put: mutator \dashrightarrow request$

Delegates an HTTP PUT operation to the Belmont provider, passing the provided mutator payload to update the underlying state. 
Applying this mutation automatically triggers `update` events across the reactive model, immediately notifying any other active observers bound to the same locator.

```coffeescript
resource = await Resource.resolve template: "local:/components/greeting"
request = resource.put "new value"
assert.ok request
```

### delete

$delete: \dashrightarrow request$

Delegates an HTTP DELETE operation to the Belmont provider. 
This method instructs the underlying transport mechanism to permanently remove the resource, resulting in appropriate cascading events for the reactive system.

```coffeescript
resource = await Resource.resolve template: "local:/components/greeting"
request = resource.delete()
assert.ok request
```

### post

$post: generator \dashrightarrow request$

Delegates an HTTP POST operation to the Belmont provider. 
Developers pass a generator payload to instruct the backend to construct a new sub-resource or to trigger a state-mutating side effect.

```coffeescript
resource = await Resource.resolve template: "local:/components/greeting"
request = resource.post data: "value"
assert.ok request
```
