import Generic from "@dashkite/generic"
import * as Obj from "@dashkite/joy/object"
import Scout from "@dashkite/scout"

# TODO extend Scout to support encoding based on template?
import * as URLCodex from "@dashkite/url-codex"

Montrose =

  resolve: do ->

    ( Generic.make "Montrose._encode" )

      .define [ Object ], ( locator ) ->
        Scout.encode locator,
          await Scout.discover locator.origin

      .define [ Obj.has "template" ], ( locator ) ->
        URLCodex.encode locator.template, locator.bindings

export default Montrose