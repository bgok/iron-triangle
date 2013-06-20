ModelList = (solver) ->
    @solver = solver
    @list = []
    return @

ModelList.prototype =
    add: (name, range) ->
        # Rearrange the parameters if the value isn't specified
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

        return @

#    getVariable: (name) ->
#        @get(name)?.variable
#
    get: (name) ->
        @list[name]

window.ModelList = ModelList