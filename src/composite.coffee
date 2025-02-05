import { Queue } from "@dashkite/joy/iterable"
import Observer from "@dashkite/belmont/observer"
import Resource from "./index"

zip = ( resources ) ->
  observer = Observer.make()
  current = {}
  for name, resource in resources
    do ( name, resource ) ->
      resource
        .observe()
        .when "update", ({ value }) ->
          current[ name ] = value
          observer.dispatch name: "update", value: current
        .run() 
  observer

class CompositeResource

  @make: ( locators ) ->
    Object.assign ( new @ ), { locators }

  @resolve: ( locators ) ->
    self = Object.assign ( new @ ), { locators }
    await self.resolve()
    self

  resolve: ->  
    @resources = {}
    for name, locator of @locators
      @resources[ name ] = await Resource.resolve locator 
    @

  observe: -> 
    @observer ?= zip @resources

  cancel: -> 
    for name, resource of @resources
      @resource.cancel()
    @observer.dispatch name: "cancel"

  get: ->
    result = {}
    resources = @resources
    await Promise.all do ->
      for name, resource of resources
        result[ name ] = await resource
          .get()
          .when "failure", ( error ) -> # TODO
          .resolve "value"
    result

  put: ( mutator ) ->
    value = await mutator await @get()
    result = {}
    resources = @resources
    await Promise.all do ->
      for name, resource of resources
        result[ name ] = await resource
          .put value[ name ]
          .when "failure", ( error ) -> # TODO
          .resolve "value"
    result

  delete: ->
    resources = @resources
    await Promise.all do ->
      for name, resource of resources
        await resource
          .delete()
          .when "failure", ( error ) -> # TODO
          .resolve "success"

  post: ( generator ) ->

export default CompositeResource