import assert from "@dashkite/assert"
import {test, success} from "@dashkite/amen"
import print from "@dashkite/amen-console"

import Providers from "@dashkite/belmont/providers"
import Halstead from "@dashkite/halstead"
Providers.add "local", Halstead

import Resource from "../src"
import CompositeResource from "../src/composite"

import configuration from "./configuration"
{ origin } = configuration

actual =
  update: []
  put: []

expected = 
  update: [ "hello, world!" ]
  put: [ "hello, world!", "goodbye!" ]

do ->

  print await test "Montrose", [

    await test "observe and cancel", ->

      greeting = await Resource.resolve template: "local:/components/greeting"

      greeting
        .observe()
        .when "update", ({ value }) -> actual.update.push value
        .run()

      await greeting
        .put "hello, world!"
        .when "value", ({ value }) -> actual.put.push value
        .run()

      greeting.cancel()

      await greeting
        .put "goodbye!"
        .when "value", ({ value }) -> actual.put.push value
        .run()

      assert.deepEqual expected, actual

    await test "component model", ->

      renders = []

      class Greeting

        @make: ->
          state = await Resource.resolve template: "local:/components/greeting"
          Object.assign ( new @ ), { state }

        render: ( value ) ->
          renders.push value

        activate: -> 
          @state
            .observe()
            .when "update", ({ value }) => @render value
            .run()

        deactivate: ->
          @state.cancel()

        set: ( greeting ) ->
          @state
            .put greeting
            .resolve "value"

      greeting = await Greeting.make()

      # PROBLEM
      # Why isn't this generating an initial update event?
      greeting.activate()

      # CURRENT VALUE IS "goodbye!" (from the first test)
      # console.log get: await do ->
      #   greeting
      #     .state
      #     .get()
      #     .resolve "value"

      await greeting.set "good day!"

      greeting.deactivate()
      await greeting.set "hola!"

      console.log renders

    await test "composite resources", ->

      resources = await CompositeResource.resolve
        greeting: template: "local:/components/greeting"
        profile: template: "local:/components/profile"

      resources
        .observe()
        .when "update", ({ value }) -> actual.update.push value
        .run()

      await resources
        .put ({ profile }) -> 
          { greeting: "bonjour!", profile }
        .when "value", ({ value }) -> actual.put.push value
        .run()

      resources.cancel()

      await greeting
        .put ({ profile }) -> 
          { greeting: "mahalo!", profile }
        .when "value", ({ value }) -> actual.put.push value
        .run()

      console.log actual

  ]

  process.exit if success then 0 else 1
