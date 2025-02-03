import Belmont from "@dashkite/belmont"


class Resource

  @make: ( locator ) ->
    Object.assign ( new @ ), { locator }

  @resolve: ( locator ) ->
    self = Object.assign ( new @ ), { locator }
    await self.resolve()
    self

  resolve: ->  @resource = await Belmont.resolve @locator

  observe: -> @observer = @resource.observe()

  cancel: -> 
    @resource.cancel @observer
    delete @observer

  get: -> @resource.get()

  put: ( mutator ) -> @resource.put mutator

  delete: -> @resource.delete()

  post: ( generator ) -> @resource.post generator

export default Resource