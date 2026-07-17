# Usage Guides

This document provides task-based scenarios for using Montrose.

## Managing Component State

Developers often need to synchronize a UI component's state with a remote or local backend resource.
Montrose enables this by wrapping Belmont resources in a class that integrates into component lifecycles, exposing methods to resolve, observe, and mutate state.

```coffeescript
import Resource from "@dashkite/montrose"

class Greeting
  @make: ->
    # Resolve the resource locator asynchronously
    state = await Resource.resolve template: "local:/components/greeting"
    Object.assign ( new @ ), { state }

  activate: ->
    # Observe the resource for changes
    @state
      .observe()
      .when "update", ({ value }) => @render value
      .run()

  deactivate: ->
    # Cancel observation when the component is deactivated
    @state.cancel()

  set: ( greeting ) ->
    # Mutate the resource state
    @state.put(greeting).run()

  render: ( value ) ->
    # implementation of UI rendering goes here
```

1. The developer resolves the resource locator using `Resource.resolve`.
2. The developer activates the component, calling `observe()` on the resource state.
3. The developer configures an event handler for the `update` event to render the new value.
4. The developer mutates the state by calling `put()` on the resource when the user interacts.
5. The developer deactivates the component and calls `cancel()` to clean up the observer.

## Triggering Backend Actions

Developers occasionally need to trigger side-effects or generate new sub-resources without relying on continuous state observation.
Montrose provides HTTP-aligned methods like `get` and `post` to interact with resources transactionally.

```coffeescript
import Resource from "@dashkite/montrose"

triggerWorkflow = ( data ) ->
  # Resolve the workflow endpoint
  resource = await Resource.resolve template: "https://api.example.com/workflows"
  
  # Trigger the side-effect using POST
  await resource.post(data).run()

  # Retrieve the updated status using GET
  status = await resource.get().resolve "status"
  
  # implementation of status evaluation goes here
```

1. The developer resolves the resource locator using `Resource.resolve`.
2. The developer initiates the workflow by calling `post()` with the required generator data.
3. The developer retrieves the current state of the resource transactionally using `get()`.

## Deferring Resource Resolution

In complex component architectures, developers may need to construct resource bindings synchronously during initialization, but defer the actual network resolution until the component mounts.
Montrose enables this by separating the synchronous `make` factory from the asynchronous instance `resolve` method.

```coffeescript
import Resource from "@dashkite/montrose"

class Profile

  constructor: ( locator ) ->
    # Bind the locator synchronously without connecting
    @state = Resource.make { locator }

  mount: ->
    # Defer the asynchronous resolution until mount
    await @state.resolve()
    
    @state
      .observe()
      .when "update", ({ value }) => @render value
      .run()

  render: ( value ) ->
    # implementation of UI rendering goes here
```

1. The developer constructs the resource synchronously using `Resource.make`, binding the locator.
2. The developer defers network connection until the `mount` lifecycle phase.
3. The developer calls the instance `resolve()` method to connect to the underlying Belmont provider.
4. The developer begins observing the resource.

## Removing Active Resources

Developers sometimes need to permanently delete a resource that is actively being observed by other parts of the application.
Montrose enables this by providing a `delete` method that interacts with Belmont's reactive routing, ensuring all subscribers are appropriately notified.

```coffeescript
import Resource from "@dashkite/montrose"

removeDocument = ( id ) ->
  # Resolve the document resource
  document = await Resource.resolve template: "https://api.example.com/documents/#{id}"
  
  # Instruct the provider to remove the resource
  await document.delete().run()
  
  # implementation of navigation or cleanup goes here
```

1. The developer resolves the target document resource using `Resource.resolve`.
2. The developer issues a deletion request by calling `delete()`.
3. The underlying provider processes the request and automatically cascades teardown events to any active observers in the reactive system.
