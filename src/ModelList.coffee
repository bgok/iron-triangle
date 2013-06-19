ModelList = (solver) ->
    @solver = solver
    @list = []
    return @

ModelList.prototype =
    add: (name, value, range) ->
        # Rearrange the parameters if the value isn't specified
        if _.isArray(value)
            range = value
            value = undefined

        if _.isUndefined(range)
            @solver.decl(name)
            @list.push(@list[name] =
                name: name
            )
        else
            @solver.decl(name, [range])
            @list.push(@list[name] =
                name: name
                min: range[0]
                max: range[1]
            )

        @solver.eq(name, @solver.const(value)) if !_.isUndefined(value)

        return @

#    getVariable: (name) ->
#        @get(name)?.variable
#
    get: (name) ->
        @list[name]

window.ModelList = ModelList