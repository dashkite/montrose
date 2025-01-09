import Generic from "@dashkite/generic"

Montrose =

  resource: do ->

    ( Generic.make "Montrose.resource" )

      .define [ String, Object ], ( locator ) ->

      .define [ String, String ], ( string, url ) ->
        ( target ) ->
          target.resources ?= {}
          target.resources[ name ] =
            url: url
            state: await Registry.get url

  resources: ( dictionary ) ->
    Fn.pipe do ->    
      for key, value of dictionary
        Montrose.resource key, value

  observe: do ->

    ( Generic.make "Montrose.observe" )

      .define [ String, Array ], ( name, fx ) ->
        Montrose.observe name, Fn.flow fx

      .define [ String, Function ], ( name, handler ) ->
        ( target ) ->
          resolve = Montrose.resolve name
          observable = await resolve target
          observable.observe handler

  update: do -> 

    ( Generic.make "Montrose.update" )

      .define [ String, Array ], ( name, fx ) ->
        Montrose.update name, Fn.flow fx

      .define [ String, Function ], ( name, mutator ) ->
        ( target ) ->
          resolve = Montrose.resolve name
          observable = await resolve target
          observable.update mutator


export default Montrose